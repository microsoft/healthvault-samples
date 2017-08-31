//
//  MHVAsyncTaskOperation.m
//  MHVLib
//
//  Copyright (c) 2017 Microsoft Corporation. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "MHVAsyncTaskOperation.h"
#import "MHVAsyncTaskCompletionSource.h"

typedef NS_ENUM(NSUInteger, MHVAsyncTaskMode)
{
    MHVAsyncTaskModeDefault,
    MHVAsyncTaskModeIndeterminate
};

typedef NS_ENUM(NSUInteger, MHVAsyncTaskWaitMode)
{
    MHVAsyncTaskWaitModeSingle,
    MHVAsyncTaskWaitModeMultiple
};

@interface MHVAsyncTaskOperation ()

@property(nonatomic, strong)                MHVAsyncTaskBlock                   workBlock;
@property(nonatomic, strong)                MHVAsyncTaskIndeterminateBlock      indeterminateWorkBlock;
@property(nonatomic, assign)                MHVAsyncTaskMode                    mode;
@property(nonatomic, assign)                MHVAsyncTaskWaitMode                waitMode;
@property(nonatomic, strong)                MHVAsyncTaskOperation               *dependentResultOperation;
@property(nonatomic, strong)                NSMutableArray                      *dependentResultOperations;
@property(nonatomic, strong)                id                                  result;
@property(nonatomic, assign, readwrite)     MHVAsyncTaskOperationState          state;

@end

@implementation MHVAsyncTaskOperation

- (instancetype)initWithBlock:(MHVResultOperationBlock)workBlock
{
    NSParameterAssert(workBlock);
    
    self = [super init];
    if(self)
    {
        _workBlock = workBlock;
        _mode = MHVAsyncTaskModeDefault;
        _waitMode = MHVAsyncTaskWaitModeSingle;
        _state = MHVAsyncTaskOperationStateWaiting;
    }
    
    return self;
}

- (instancetype)initWithIndeterminateBlock:(MHVAsyncTaskIndeterminateBlock)workBlock
{
    NSParameterAssert(workBlock);
    
    self = [super init];
    if(self)
    {
        _completionSource = [[MHVAsyncTaskCompletionSource alloc] init];
        _indeterminateWorkBlock = workBlock;
        _mode = MHVAsyncTaskModeIndeterminate;
        _waitMode = MHVAsyncTaskWaitModeSingle;
        _state = MHVAsyncTaskOperationStateWaiting;
    }
    
    return self;
}

#pragma mark - MHVAsyncOperation overrides

- (void)startOperation
{
    @synchronized(self)
    {
        // Ignore if someone explicitly calls start while we are already running
        if(self.state != MHVAsyncTaskOperationStateWaiting)
        {
            return;
        }
        
        self.state = MHVAsyncTaskOperationStateRunning;
    }
    
    // Cancel the operation if we have no work to do.
    // TODO: There may be cases when it would be usefull to allow tasks with no work blocks.
    // In that case we could finish the task here as opposed to canceling it?
    if((self.mode == MHVAsyncTaskModeDefault && !self.workBlock) || (self.mode == MHVAsyncTaskModeIndeterminate && !self.indeterminateWorkBlock))
    {
        [self cancelOperation];
        return;
    }
    
    id input = nil;
    MHVAsyncTaskOperationState dependentState = MHVAsyncTaskOperationStateRanToCompletion;
    
    // If this task is waiting on multiple tasks (waitForAll) then we iterate through them to build
    // an array of result objects and an aggregate state. The aggregate state will be canceled
    // if any of the dependent tasks were canceled and ranToCompletion otherwise.
    if(self.waitMode == MHVAsyncTaskWaitModeMultiple)
    {
        if(self.dependentResultOperations.count > 0)
        {
            // build the results array from the dependent operations
            NSMutableArray *results = [NSMutableArray new];
            for (MHVAsyncTaskOperation *task in self.dependentResultOperations)
            {
                if(task.result)
                {
                    [results addObject:task.result];
                }
                
                if(task.state == MHVAsyncTaskOperationStateCanceled)
                {
                    dependentState = MHVAsyncTaskOperationStateCanceled;
                }
            }
            input = [NSArray arrayWithArray:results];
        }
    }
    else
    {
        input = self.dependentResultOperation.result;
        dependentState = self.dependentResultOperation.state;
    }

    // Take a look at the continuationOptions and determine if we should run
    // this task or not.
    switch (self.continuationOptions)
    {
        case MHVTaskContinueIfPreviousTaskWasNotCanceled:
            
            if(dependentState == MHVAsyncTaskOperationStateCanceled)
            {
                self.result = input;
                [self cancelOperation];
                return;
            }
            
            break;
            
        case MHVTaskContinueIfPreviousTaskWasCanceled:
            
            if(dependentState != MHVAsyncTaskOperationStateCanceled)
            {
                self.result = input;
                [self cancelOperation];
                return;
            }
            
            break;
        default:
            break;
    }
    
    // Run the task
    if(self.mode == MHVAsyncTaskModeIndeterminate)
    {
        __weak typeof(self) weakSelf = self;
        MHVAsyncTaskFinishBlock finish = ^void(id output)
        {
            _result = output;
            [weakSelf finishOperation];
        };
        MHVAsyncTaskCancelBlock cancel = ^void(id output)
        {
            _result = output;
            [weakSelf cancelOperation];
        };
        
        self.completionSource.finish = finish;
        self.completionSource.cancel = cancel;
        
        self.indeterminateWorkBlock(input, finish, cancel);
    }
    else
    {
        self.result = self.workBlock(input);
        [self finishOperation];
    }
}


- (void)cancelOperation
{
    self.state = MHVAsyncTaskOperationStateCanceled;
    [self finishOperation];
}


- (void)finishOperation
{
    @synchronized(self)
    {
        if(self.state != MHVAsyncTaskOperationStateCanceled)
        {
            self.state = MHVAsyncTaskOperationStateRanToCompletion;
        }
        
        if (!self.isFinished)
        {
            [super finishOperation];
        }
    }
}


- (void)setState:(MHVAsyncTaskOperationState)state
{
    @synchronized(self)
    {
        _state = state;
    }
}


#pragma mark - Continuation stuff


- (MHVAsyncTaskOperation *)continueWithTaskOperation:(MHVAsyncTaskOperation *)operation
{
    operation.dependentResultOperation = self;
    [operation addDependency:self];
    return operation;
}


- (MHVAsyncTaskOperation *)continueWithBlock:(MHVAsyncTaskBlock)workBlock
{
    MHVAsyncTaskOperation *resultOperation = [[MHVAsyncTaskOperation alloc] initWithBlock:workBlock];
    resultOperation.dependentResultOperation = self;
    [resultOperation addDependency:self];
    return resultOperation;
}


+ (MHVAsyncTaskOperation *)waitForAll:(NSArray *)operations beforeBlock:(MHVAsyncTaskMultipleInputBlock)workBlock
{
    MHVAsyncTaskOperation *resultOperation = [[MHVAsyncTaskOperation alloc] initWithBlock:workBlock];
    [resultOperation.dependentResultOperations addObjectsFromArray:operations];
    resultOperation.waitMode = MHVAsyncTaskWaitModeMultiple;
    
    for (MHVAsyncTaskOperation *dependency in operations)
    {
        [resultOperation addDependency:dependency];
    }
    
    return resultOperation;
}


- (MHVAsyncTaskOperation *)continueWithIndeterminateBlock:(MHVAsyncTaskIndeterminateBlock)workBlock
{
    MHVAsyncTaskOperation *resultOperation = [[MHVAsyncTaskOperation alloc] initWithIndeterminateBlock:workBlock];
    resultOperation.dependentResultOperation = self;
    [resultOperation addDependency:self];
    return resultOperation;
}


+ (MHVAsyncTaskOperation *)waitForAll:(NSArray *)operations beforeIndeterminateBlock:(MHVAsyncTaskIndeterminateMultipleInputBlock)workBlock
{
    MHVAsyncTaskOperation *resultOperation = [[MHVAsyncTaskOperation alloc] initWithIndeterminateBlock:workBlock];
    [resultOperation.dependentResultOperations addObjectsFromArray:operations];
    resultOperation.waitMode = MHVAsyncTaskWaitModeMultiple;
    
    for (MHVAsyncTaskOperation *dependency in operations)
    {
        [resultOperation addDependency:dependency];
    }
    
    return resultOperation;
}



#pragma mark - Getters / Setters


- (NSMutableArray *)dependentResultOperations
{
    if(!_dependentResultOperations)
    {
        _dependentResultOperations = [NSMutableArray new];
    }
    
    return _dependentResultOperations;
}


@end

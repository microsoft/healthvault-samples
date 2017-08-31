//
//  MHVAsyncTask.m
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

#import "MHVAsyncTask.h"

@interface MHVAsyncTask ()

@property(nonatomic, strong)        MHVAsyncTaskOperation               *underlyingOperation;
@property(nonatomic, assign)        BOOL                                hasStarted;

@end

@implementation MHVAsyncTask

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        
    }
    
    return self;
}

- (instancetype)initWithBlock:(MHVResultOperationBlock)workBlock
{
    NSParameterAssert(workBlock);
    
    self = [self init];
    if(self)
    {
        _underlyingOperation = [[MHVAsyncTaskOperation alloc] initWithBlock:workBlock];
    }
    
    return self;
}

- (instancetype)initWithIndeterminateBlock:(MHVAsyncTaskIndeterminateBlock)workBlock
{
    NSParameterAssert(workBlock);
    
    self = [self init];
    if(self)
    {
        _underlyingOperation = [[MHVAsyncTaskOperation alloc] initWithIndeterminateBlock:workBlock];
    }
    
    return self;
}

- (MHVAsyncTask *)start
{
    @synchronized(self)
    {
        NSAssert(!self.hasStarted, @"Should not try to start task twice");
        
        if(!self.hasStarted)
        {
            self.hasStarted = YES;
            [self.underlyingQueue addOperation:self.underlyingOperation];
        }
        
        return self;
    }
}

- (MHVAsyncTask *)startInQueue:(NSOperationQueue *)queue
{
    @synchronized(self)
    {
        NSAssert(!self.hasStarted, @"Should not try to start task twice");
        
        if(!self.hasStarted)
        {
            self.underlyingQueue = queue;
            return [self start];
        }
        
        return self;
    }
}

- (void)cancel
{
    [self.underlyingOperation cancelOperation];
}

#pragma mark - Continuation stuff


- (MHVAsyncTask *)continueWithTask:(MHVAsyncTask *)task
{
    return [self continueWithOptions:MHVAsyncTaskContinueAlways task:task];
}

- (MHVAsyncTask *)continueWithOptions:(MHVAsyncTaskContinuationOptions)continuationOptions task:(MHVAsyncTask *)task
{
    [self.underlyingOperation continueWithTaskOperation:task.underlyingOperation];
    task.underlyingOperation.continuationOptions = continuationOptions;
    [task startInQueue:self.underlyingQueue];
    return task;
}

- (MHVAsyncTask *)continueWithBlock:(MHVAsyncTaskBlock)resultBlock
{
    return [self continueWithOptions:MHVAsyncTaskContinueAlways block:resultBlock];
}

- (MHVAsyncTask *)continueWithOptions:(MHVAsyncTaskContinuationOptions)continuationOptions block:(MHVAsyncTaskBlock)resultBlock
{
    MHVAsyncTask *resultOperation = [MHVAsyncTask new];
    resultOperation.underlyingOperation = [self.underlyingOperation continueWithBlock:resultBlock];
    resultOperation.underlyingOperation.continuationOptions = continuationOptions;
    [resultOperation startInQueue:self.underlyingQueue];
    return resultOperation;
}

- (MHVAsyncTask *)continueWithIndeterminateBlock:(MHVAsyncTaskIndeterminateBlock)resultBlock
{
    return [self continueWithOptions:MHVAsyncTaskContinueAlways indeterminateBlock:resultBlock];
}

- (MHVAsyncTask *)continueWithOptions:(MHVAsyncTaskContinuationOptions)continuationOptions indeterminateBlock:(MHVAsyncTaskIndeterminateBlock)resultBlock
{
    MHVAsyncTask *resultOperation = [MHVAsyncTask new];
    resultOperation.underlyingOperation = [self.underlyingOperation continueWithIndeterminateBlock:resultBlock];
    resultOperation.underlyingOperation.continuationOptions = continuationOptions;
    [resultOperation startInQueue:self.underlyingQueue];
    return resultOperation;
}

+ (MHVAsyncTask *)waitForAll:(NSArray *)tasks beforeBlock:(MHVAsyncTaskMultipleInputBlock)resultBlock
{
    MHVAsyncTask *resultOperation = [MHVAsyncTask new];
    
    // build an array of the underlying operations
    NSMutableArray *operations = [NSMutableArray new];
    for (MHVAsyncTask *task in tasks)
    {
        [operations addObject:task.underlyingOperation];
    }
    
    resultOperation.underlyingOperation = [MHVAsyncTaskOperation waitForAll:operations beforeBlock:resultBlock];
    [resultOperation start];
    return resultOperation;
}

+ (MHVAsyncTask *)waitForAll:(NSArray *)tasks beforeIndeterminateBlock:(MHVAsyncTaskIndeterminateMultipleInputBlock)resultBlock
{
    MHVAsyncTask *resultOperation = [MHVAsyncTask new];
    
    // build an array of the underlying operations
    NSMutableArray *operations = [NSMutableArray new];
    for (MHVAsyncTask *task in tasks)
    {
        [operations addObject:task.underlyingOperation];
    }
    
    resultOperation.underlyingOperation = [MHVAsyncTaskOperation waitForAll:operations beforeIndeterminateBlock:resultBlock];
    [resultOperation start];
    return resultOperation;
}

+ (MHVAsyncTask *)whenAll:(NSArray *)tasks
{
    void (^taskBlock)(NSArray*, void (^)(id), void (^)(id)) = ^void(NSArray *inputs, MHVAsyncTaskFinishBlock finish, MHVAsyncTaskCancelBlock cancel)
    {
        for (MHVAsyncTask *performedTask in tasks)
        {
            if(performedTask.underlyingOperation.state == MHVAsyncTaskOperationStateCanceled)
            {
                cancel(inputs);
                return;
            }
        }
        
        finish(inputs);
    };
    
    MHVAsyncTask *task = [self waitForAll:tasks beforeIndeterminateBlock:taskBlock];
    return task;
}

+ (void)startSequenceOfTasks:(NSArray<MHVAsyncTask*>*)taskSequence
{
    [self startSequenceOfTasks:taskSequence withContinuationOption:MHVAsyncTaskContinueAlways];
}

+ (void)startSequenceOfTasks:(NSArray<MHVAsyncTask*>*)taskSequence withContinuationOption:(MHVAsyncTaskContinuationOptions)option
{
    MHVAsyncTask *prevTask = nil;
    for (MHVAsyncTask *task in taskSequence)
    {
        //Start first one, the rest continue from their previous task
        if (!prevTask)
        {
            [task start];
        }
        else
        {
            [prevTask continueWithOptions:option task:task];
        }
        
        prevTask = task;
    }
}

- (id)waitForResult
{
    return self.result;
}

- (MHVAsyncTaskOperationState)endingState
{
    [self.underlyingOperation waitUntilFinished];
    return self.state;
}

#pragma mark - Internal

- (NSOperationQueue *)underlyingQueue
{
    if(!_underlyingQueue)
    {
        _underlyingQueue = [NSOperationQueue new];
    }
    
    return _underlyingQueue;
}

- (id)result
{
    [self.underlyingOperation waitUntilFinished];
    return self.underlyingOperation.result;
}

- (MHVAsyncTaskOperationState)state
{
    return self.underlyingOperation.state;
}

- (MHVAsyncTaskCompletionSource *)completionSource
{
    return self.underlyingOperation.completionSource;
}

@end

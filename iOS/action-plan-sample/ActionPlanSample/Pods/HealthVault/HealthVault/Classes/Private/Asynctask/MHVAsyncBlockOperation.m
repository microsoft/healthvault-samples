//
//  MHVAsyncBlockOperation.m
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


#import "MHVAsyncBlockOperation.h"


@interface MHVAsyncBlockOperation ()

@property(nonatomic, strong)    MHVAsyncOperationFinishBlock        operationBlock;
@property(nonatomic, strong)    NSTimer                             *timeoutTimer;

@end




@implementation MHVAsyncBlockOperation


+(MHVAsyncBlockOperation *)asyncBlockOperationWithBlock:(MHVAsyncOperationBlock)operationBlock
{
    MHVAsyncBlockOperation *operation = [[MHVAsyncBlockOperation alloc] initWithOperation:operationBlock];
    return operation;
}


+(MHVAsyncBlockOperation *)asyncBlockOperationWithTimeout:(NSTimeInterval)timeoutSeconds block:(MHVAsyncOperationBlock)operationBlock
{
    MHVAsyncBlockOperation *operation = [[MHVAsyncBlockOperation alloc] initWithOperation:operationBlock];
    operation.timeoutTimer = [NSTimer timerWithTimeInterval:timeoutSeconds target:operation selector:@selector(timeout:) userInfo:nil repeats:NO];
    return operation;
}


-(id)initWithOperation:(MHVAsyncOperationBlock)operationBlock
{
    NSParameterAssert(operationBlock);
    self = [super init];
    if(self)
    {
        _operationBlock = operationBlock;
    }
    
    return self;
}


-(void)startOperation
{
    if(!self.operationBlock)
    {
        [self cancelOperation];
    }
    
    if(self.timeoutTimer)
    {
        [[NSRunLoop currentRunLoop] addTimer:self.timeoutTimer forMode:NSDefaultRunLoopMode];
    }
    
    __weak typeof(self) weakSelf = self;
    MHVAsyncOperationFinishBlock finish = ^void()
    {
        [weakSelf finishOperation];
    };
    
    self.operationBlock(finish);
}


-(void)cancelOperation
{
    [self finishOperation];
}


-(void)finishOperation
{
    if(self.timeoutTimer)
    {
        [self.timeoutTimer invalidate];
    }
    
    // call to super is required
    [super finishOperation];
}


-(void)timeout:(NSTimer *)timer
{
    [self cancel];
}


@end

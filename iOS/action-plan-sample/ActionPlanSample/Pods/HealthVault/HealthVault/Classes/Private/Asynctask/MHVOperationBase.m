//
//  MHVOperationBase.m
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

#import "MHVOperationBase.h"


@interface MHVOperationBase ()

@property (nonatomic, assign) BOOL isExecuting;
@property (nonatomic, assign) BOOL isConcurrent;
@property (nonatomic, assign) BOOL isFinished;

@end


@implementation MHVOperationBase


- (void)start
{
    self.isConcurrent = YES;
    self.isExecuting = YES;
    self.isFinished = NO;
    
    if (!self.isCancelled)
    {
        [self startOperation];
    }
    else
    {
        [self cancelOperation];
    }
}


/*
 *  Should be implemented by child classes
 */
-(void)startOperation
{
    
}


/*
 *  Should be implemented by child classes
 */
-(void)cancelOperation
{
    
}


-(void)finishOperation
{
    self.isExecuting = NO;
    self.isFinished = YES;
}


- (void)setIsExecuting:(BOOL)isExecuting
{
    [self willChangeValueForKey:@"isExecuting"];
    _isExecuting = isExecuting;
    [self didChangeValueForKey:@"isExecuting"];
}


- (void)setIsFinished:(BOOL)isFinished
{
    [self willChangeValueForKey:@"isFinished"];
    _isFinished = isFinished;
    [self didChangeValueForKey:@"isFinished"];
}


@end

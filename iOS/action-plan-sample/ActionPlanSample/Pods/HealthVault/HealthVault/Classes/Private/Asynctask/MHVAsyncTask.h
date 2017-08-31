//
//  MHVAsyncTask.h
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

#import <Foundation/Foundation.h>
#import "MHVAsyncTaskOperation.h"

@class MHVAsyncTaskCompletionSource;

@interface MHVAsyncTask<__covariant InputType, __covariant OutputType> : NSObject

/*
 * @brief the operation queue that the task will run in. Calling startInQueue can change this.
 */
@property(nonatomic, strong)                                NSOperationQueue                    *underlyingQueue;

/*
 * @brief the result of the task. Accessing this property will block until the task is finished.
 */
@property(nonatomic, strong, readonly)                      OutputType                          result;

/*
 *  @brief the current state of the task. This property is not currently KVO compliant!
 */
@property(nonatomic, assign, readonly)                      MHVAsyncTaskOperationState          state;

/*
 * @brief The ending state of the task. Accessing this property will block until the task is finished.
 */
@property(nonatomic, assign, readonly)                      MHVAsyncTaskOperationState          endingState;

/*
 * @brief the completion source for the operation. This object can be used to finish or cancel the operation from
 * outside of the operation block.
 */
@property(nonatomic, strong, readonly)                      MHVAsyncTaskCompletionSource        *completionSource;

- (instancetype)initWithBlock:(MHVResultOperationBlock)workBlock;
- (instancetype)initWithIndeterminateBlock:(void (^)(InputType input, void (^finish)(OutputType), void (^cancel)(OutputType)))workBlock;

- (MHVAsyncTask<OutputType, id> *)continueWithTask:(MHVAsyncTask *)task;
- (MHVAsyncTask<OutputType, id> *)continueWithBlock:(id (^)(OutputType))resultBlock;
- (MHVAsyncTask<OutputType, id> *)continueWithIndeterminateBlock:(void (^)(OutputType, void (^)(id), void (^)(id)))resultBlock;

- (MHVAsyncTask<OutputType, id> *)continueWithOptions:(MHVAsyncTaskContinuationOptions)continuationOptions task:(MHVAsyncTask<OutputType, id> *)task;
- (MHVAsyncTask<OutputType, id> *)continueWithOptions:(MHVAsyncTaskContinuationOptions)continuationOptions block:(id (^)(OutputType))resultBlock;
- (MHVAsyncTask<OutputType, id> *)continueWithOptions:(MHVAsyncTaskContinuationOptions)continuationOptions indeterminateBlock:(void (^)(OutputType, void (^)(id), void (^)(id)))resultBlock;

+ (MHVAsyncTask *)whenAll:(NSArray *)tasks;

+ (void)startSequenceOfTasks:(NSArray<MHVAsyncTask*>*)taskSequence;
+ (void)startSequenceOfTasks:(NSArray<MHVAsyncTask*>*)taskSequence withContinuationOption:(MHVAsyncTaskContinuationOptions)option;

+ (MHVAsyncTask *)waitForAll:(NSArray *)tasks beforeBlock:(id (^)(NSArray*))workBlock;
+ (MHVAsyncTask *)waitForAll:(NSArray *)tasks beforeIndeterminateBlock:(void (^)(NSArray*, void (^)(id), void (^)(id)))workBlock;

- (MHVAsyncTask *)start;
- (MHVAsyncTask *)startInQueue:(NSOperationQueue *)queue;

- (void)cancel;
- (OutputType)waitForResult;

@end

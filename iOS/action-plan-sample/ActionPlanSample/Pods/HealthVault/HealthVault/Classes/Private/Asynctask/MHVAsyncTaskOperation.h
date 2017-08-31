//
//  MHVAsyncTaskOperation.h
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
#import "MHVOperationEnums.h"

typedef void(^MHVAsyncTaskFinishBlock)(id output);
typedef void(^MHVAsyncTaskCancelBlock)(id output);
typedef id(^MHVAsyncTaskBlock)(id input);
typedef id(^MHVAsyncTaskMultipleInputBlock)(NSArray *inputs);
typedef void(^MHVAsyncTaskIndeterminateBlock)(id input, MHVAsyncTaskFinishBlock finish, MHVAsyncTaskCancelBlock cancel);
typedef void(^MHVAsyncTaskIndeterminateMultipleInputBlock)(NSArray *inputs, MHVAsyncTaskFinishBlock finish, MHVAsyncTaskCancelBlock cancel);

@class MHVAsyncTaskCompletionSource;

@interface MHVAsyncTaskOperation<InputType, OutputType> : MHVOperationBase

/*
 * @brief the result of the task. If the operation is still running, the result may not be set yet.
 */
@property(nonatomic, strong, readonly)          id                                  result;

/*
 *  @brief the continuation options associated with this operation. This only applies if the operation has at
 *  least 1 dependent operation.
 */
@property(nonatomic, assign)                    MHVAsyncTaskContinuationOptions     continuationOptions;

/*
 *  @brief the current state of the operation
 */
@property(nonatomic, assign, readonly)          MHVAsyncTaskOperationState          state;

/*
 * @brief the completion source for the operation. This object can be used to finish or cancel the operation from
 * outside of the operation block.
 */
@property(nonatomic, strong, readonly)          MHVAsyncTaskCompletionSource        *completionSource;

- (instancetype)initWithBlock:(OutputType (^)(InputType))workBlock;
- (instancetype)initWithIndeterminateBlock:(void (^)(InputType, void (^)(OutputType), void (^)(OutputType)))workBlock;

- (MHVAsyncTaskOperation<OutputType, id> *)continueWithTaskOperation:(MHVAsyncTaskOperation *)operation;
- (MHVAsyncTaskOperation<OutputType, id> *)continueWithBlock:(OutputType (^)(InputType))workBlock;
- (MHVAsyncTaskOperation<OutputType, id> *)continueWithIndeterminateBlock:(void (^)(InputType, void (^)(OutputType), void (^)(OutputType)))workBlock;
+ (MHVAsyncTaskOperation *)waitForAll:(NSArray *)operations beforeBlock:(OutputType (^)(NSArray*))workBlock;
+ (MHVAsyncTaskOperation *)waitForAll:(NSArray *)operations beforeIndeterminateBlock:(void (^)(NSArray*, void (^)(OutputType), void (^)(OutputType)))workBlock;


@end

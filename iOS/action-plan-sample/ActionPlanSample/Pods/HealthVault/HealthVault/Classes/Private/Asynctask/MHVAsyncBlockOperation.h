//
//  MHVAsyncBlockOperation.h
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

typedef void(^MHVAsyncOperationFinishBlock)();
typedef void(^MHVAsyncOperationBlock)(MHVAsyncOperationFinishBlock finishBlock);

@interface MHVAsyncBlockOperation : MHVOperationBase

+(MHVAsyncBlockOperation *)asyncBlockOperationWithBlock:(MHVAsyncOperationBlock)operationBlock;

/*
 *  Creates a MHVAsyncBlockOperation instance that once started will remain in the "executing" state until either finishBLock() is called or the timer expires.
 *  If the timer expires before the finishBlock is called, the operation will be canceled.
 */
+(MHVAsyncBlockOperation *)asyncBlockOperationWithTimeout:(NSTimeInterval)timeoutSeconds block:(MHVAsyncOperationBlock)operationBlock;

@end

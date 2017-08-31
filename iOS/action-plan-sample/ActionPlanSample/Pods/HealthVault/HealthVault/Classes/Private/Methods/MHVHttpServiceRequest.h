//
//  MHVMethodRequest.h
//  MHVLib
//
// Copyright (c) 2017 Microsoft Corporation. All rights reserved.
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

#import <Foundation/Foundation.h>

@class MHVMethod, MHVServiceResponse, MHVHttpServiceRequest;
@protocol MHVHttpServiceOperationProtocol;

typedef void (^MHVRequestCompletion)(MHVServiceResponse *_Nullable response, NSError *_Nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface MHVHttpServiceRequest : NSObject

@property (nonatomic, strong, readonly) id<MHVHttpServiceOperationProtocol> serviceOperation;
@property (nonatomic, strong, readonly, nullable) MHVRequestCompletion completion;
@property (nonatomic, assign) NSInteger retryAttempts;
@property (nonatomic, assign) BOOL hasRefreshedToken;

- (instancetype)initWithServiceOperation:(id<MHVHttpServiceOperationProtocol>)serviceOperation
                              completion:(MHVRequestCompletion _Nullable)completion;

@end

NS_ASSUME_NONNULL_END


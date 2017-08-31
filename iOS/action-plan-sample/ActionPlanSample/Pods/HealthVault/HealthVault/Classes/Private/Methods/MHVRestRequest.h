//
//  MHVRestRequest.h
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
#import "MHVHttpServiceOperationProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MHVRestRequest : NSObject <MHVHttpServiceOperationProtocol>

@property (nonatomic, strong, readonly)           NSString      *path;
@property (nonatomic, strong, readonly)           NSString      *httpMethod;
@property (nonatomic, strong, readonly, nullable) NSDictionary  *pathParams;
@property (nonatomic, strong, readonly, nullable) NSDictionary  *queryParams;
@property (nonatomic, strong, readonly, nullable) id            body;
@property (nonatomic, assign, readonly)           BOOL          isAnonymous;

@property (nonatomic, strong, readonly)           NSURL         *url;

- (instancetype)initWithPath:(NSString *)path
                  httpMethod:(NSString *)httpMethod
                  pathParams:(NSDictionary<NSString *, NSString *> *_Nullable)pathParams
                 queryParams:(NSDictionary<NSString *, NSString *> *_Nullable)queryParams
                        body:(NSData *_Nullable)body
                 isAnonymous:(BOOL)isAnonymous;

- (void)updateUrlWithServiceUrl:(NSURL *)serviceUrl;

@end

NS_ASSUME_NONNULL_END

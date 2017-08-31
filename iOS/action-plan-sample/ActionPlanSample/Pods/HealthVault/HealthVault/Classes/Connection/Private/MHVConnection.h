//
//  MHVConnection.h
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
#import "MHVConnectionProtocol.h"

@class MHVConfiguration, MHVThingCacheConfiguration, MHVClientFactory, MHVServiceInstance, MHVApplicationCreationInfo;

@protocol MHVHttpServiceProtocol, MHVThingCacheConfigurationProtocol, MHVThingCacheSynchronizerProtocol;

NS_ASSUME_NONNULL_BEGIN

@interface MHVConnection : NSObject<MHVConnectionProtocol>

@property (nonatomic, strong, nullable) MHVServiceInstance *serviceInstance;
@property (nonatomic, strong, readonly, nullable) MHVPersonInfo *personInfo;
@property (nonatomic, strong, readonly) MHVConfiguration *configuration;

- (instancetype)initWithConfiguration:(MHVConfiguration *)configuration
                    cacheSynchronizer:(id<MHVThingCacheSynchronizerProtocol>_Nullable)cacheSynchronizer
                   cacheConfiguration:(id<MHVThingCacheConfigurationProtocol>_Nullable)cacheConfiguration
                        clientFactory:(MHVClientFactory *)clientFactory
                          httpService:(id<MHVHttpServiceProtocol>)httpService;

@end

NS_ASSUME_NONNULL_END

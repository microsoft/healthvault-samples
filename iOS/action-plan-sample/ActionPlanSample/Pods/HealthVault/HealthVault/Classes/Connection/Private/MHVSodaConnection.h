//
//  MHVSodaConnection.h
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
#import "MHVConnection.h"
#import "MHVSodaConnectionProtocol.h"

@class MHVConfiguration, MHVThingCacheConfiguration, MHVClientFactory;

@protocol MHVSessionCredentialClientProtocol, MHVHttpServiceProtocol, MHVKeychainServiceProtocol, MHVShellAuthServiceProtocol, MHVThingCacheSyncronizer;

NS_ASSUME_NONNULL_BEGIN

@interface MHVSodaConnection : MHVConnection<MHVSodaConnectionProtocol>

- (instancetype)initWithConfiguration:(MHVConfiguration *)configuration
                    cacheSynchronizer:(id<MHVThingCacheSynchronizerProtocol>_Nullable)cacheSynchronizer
                   cacheConfiguration:(id<MHVThingCacheConfigurationProtocol>_Nullable)cacheConfiguration
                        clientFactory:(MHVClientFactory *)clientFactory
                          httpService:(id<MHVHttpServiceProtocol>)httpService
                      keychainService:(id<MHVKeychainServiceProtocol>)keychainService
                     shellAuthService:(id<MHVShellAuthServiceProtocol>)shellAuthService;

@end

NS_ASSUME_NONNULL_END

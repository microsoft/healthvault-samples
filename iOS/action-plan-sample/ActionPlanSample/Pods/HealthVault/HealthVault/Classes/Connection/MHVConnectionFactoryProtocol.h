//
//  MHVConnectionFactoryProtocol.h
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

@class MHVConfiguration;
@protocol MHVSodaConnectionProtocol, MHVThingCacheConfigurationProtocol;

NS_ASSUME_NONNULL_BEGIN

@protocol MHVConnectionFactoryProtocol <NSObject>

/**
 Gets an instance of MHVSodaConnectionProtocol used to connect to HealthVault.

 @note If Thing caching is enabled, calling this method will return a connection using the default cache configuration. To change the configuration of the Thing cache use getOrCreateSodaConnectionWithAppConfiguration:thingCacheConfiguration:.
 @param configuration configuration Configuration required for authenticating the connection.
 @return An instance of MHVSodaConnectionProtocol.
 */
- (id<MHVSodaConnectionProtocol> _Nullable)getOrCreateSodaConnectionWithConfiguration:(MHVConfiguration *)configuration;

#if THING_CACHE
/**
 Gets an instance of MHVSodaConnectionProtocol used to connect to HealthVault using a custom cache configuration.
 
 @note If Thing caching is enabled, calling this method will return a connection using the default cache configuration. To change the configuration of the Thing cache use getOrCreateSodaConnectionWithAppConfiguration:thingCacheConfiguration:.
 @param appConfiguration configuration MHVConfiguration Configuration required for authenticating the connection.
 @param thingCacheConfiguration id<MHVThingCacheConfigurationProtocol> The configuration object for the Thing cache.
 @return An instance of MHVSodaConnectionProtocol.
 */
- (id<MHVSodaConnectionProtocol> _Nullable)getOrCreateSodaConnectionWithAppConfiguration:(MHVConfiguration *)appConfiguration
                                                                 thingCacheConfiguration:(id<MHVThingCacheConfigurationProtocol>)thingCacheConfiguration;
#endif

@end

NS_ASSUME_NONNULL_END

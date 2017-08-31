//
//  MHVConfiguration.h
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
@class MHVThingCacheConfiguration;

@interface MHVConfiguration : NSObject

/**
 Gets or sets the root URL for the default instance of the HealthVault web-service. ( ex: https://platform.healthvault.com/platform/ )

 @note This may be overwritten if an environment instance bounce happens. This property corresponds to the "HV_HealthServiceUrl" configuration value when reading from web.config.
 */
@property (nonatomic, strong) NSURL *defaultHealthVaultUrl;

/**
 Gets the HealthVault Shell URL for the configured default instance of the HealthVault web-service. ( ex: https://account.healthvault.com )

 @note This may be overwritten if an environment instance bounce happens. This property corresponds to the "HV_ShellUrl" configuration value when reading from web.config.
 */
@property (nonatomic, strong) NSURL *defaultShellUrl;

/**
 Gets the root URL for a default instance of the Rest HealthVault service

 @note This property corresponds to the "HV_RestHealthServiceUrl" configuration value when reading from web.config.
 */
@property (nonatomic, strong) NSURL *restHealthVaultUrl;

/**
 Gets the version string to send with requests to the Rest HealthVault service
 */
@property (nonatomic, strong) NSString *restVersion;

/**
 Gets the application's unique identifier.
 
 @note This property corresponds to the "HV_ApplicationId" configuration value when reading from web.config.
 */
@property (nonatomic, strong) NSUUID *masterApplicationId;

/**
 Gets the request timeout
 
 @note This value is used to set the timeout property when making the request to HealthVault. The timeout is the number of seconds that a request will wait for a response from HealtVault. If the method response is not returned within the time-out period the an error object will be provided with details. This property corresponds to the "HV_DefaultRequestTimeoutSeconds" configuration value when reading from web.config. The value defaults to 30 seconds.
 */
@property (nonatomic, assign) NSTimeInterval requestTimeoutDuration;

/**
 Gets the request time to live.
 @note This property defines the "msg-ttl" in the HealthVault request header XML. It determines how long the same XML can be used before HealthVault determines the request invalid. This property corresponds to the "HV_DefaultRequestTimeToLiveSeconds" configuration value when reading from web.config. The value defaults to 1800 seconds.
 */
@property (nonatomic, assign) NSTimeInterval requestTimeToLiveDuration;

/**
 Gets the number of retries the SDK will make when getting an internal error response (error 500) from HealthVault.
 
 @note This property corresponds to the "HV_RequestRetryOnInternal500Count" configuration value when reading from web.config. The value defaults to 2.
 */
@property (nonatomic, assign) NSInteger retryOnInternal500Count;

/**
 Gets the sleep duration between retries due to HealthVault returning an internal error (error 500).
 
 @note This property corresponds to the "HV_RequestRetryOnInternal500SleepSeconds" configuration value when reading from web.config. The value defaults to 1 second.
 */
@property (nonatomic, assign) NSTimeInterval retryOnInternal500SleepDuration;

/**
 Gets the size in bytes of the block used to hash inlined BLOB data.
 
 @note This property corresponds to the "HV_DefaultInlineBlobHashBlockSize" configuration value when reading from web.config. The value defaults to 2MB.
 */
@property (nonatomic, assign) NSInteger inlineBlobHashBlockSize;

/**
 Gets a value indicating whether or not legacy type versioning support should be used.
 
 @note Type versions support was initially determined by an applications base authorizations and/or the HealthRecordView TypeVersionFormat. Some of these behaviorswere unexpected which led to changes to automatically put the ThingQuery TypeIds" and HealthVaultConfiguration SupportedTypeVersions" into the HealthRecordView TypeVersionFormat automatically for developers. This exhibits the expected behavior for most applications. However, in some rare cases applications may need to revert back to the original behavior. When this property returns true the original behavior will be observed. If false, the new behavior will be observed. This property corresponds to the "HV_SupportedTypeVersions" configuration value when reading from web.config. This property defaults to false
 */
@property (nonatomic, assign) BOOL useLegacyTypeVersionSupport;

/**
 Gets the value which indicates whether the application is able to handle connecting to multiple instances of the HealthVault web-service.
 
 @note This property corresponds to the "HV_MultiInstanceAware" configuration value when reading from web.config. This property defaults to true Applications in HealthVault can be configured to support more than one instance of the HealthVault web-service. In such a case, and when the MultiInstanceAware configuration is set to true, all redirects generated through the HealthVault .NET API will have a flag set indicating that the application is able to deal with HealthVault accounts that may reside in other HealthVault instances.  In such a case, HealthVault Shell can redirect back with an account associated with any one of the instances of the HealthVault web-service which the application has chosen to support.  The application may then need to be able to handle connecting to the appropriate instance of the HealthVault web-service for each account. For more information see the http://go.microsoft.com/?linkid=9830913 Global HealthVault Architecture article
 */
@property (nonatomic, assign) BOOL isMultiInstanceAware;

/**
 Gets the value which indicates whether the application marked as multi record
 
 @note This property corresponds to the "HV_IsMRA" configuration value when reading from web.config.
 */
@property (nonatomic, assign) BOOL isMultiRecordApp;

@end

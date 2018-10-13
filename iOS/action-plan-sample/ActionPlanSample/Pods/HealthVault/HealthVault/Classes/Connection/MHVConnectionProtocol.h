//
//  MHVConnectionProtocol.h
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
#import <UIKit/UIKit.h>

@class MHVSessionCredential, MHVConfiguration, MHVPersonInfo, MHVServiceResponse, MHVMethod, MHVRemoteMonitoringClient, MHVConnectionTaskResult;

@protocol MHVHttpServiceOperationProtocol, MHVPersonClientProtocol, MHVPlatformClientProtocol, MHVThingClientProtocol, MHVVocabularyClientProtocol, MHVRemoteMonitoringClient, MHVThingCacheConfigurationProtocol;

NS_ASSUME_NONNULL_BEGIN

/**
 Represents a connection for an application to the HealthVault service for operations.
 */
@protocol MHVConnectionProtocol <NSObject>

/**
 The application identifier.
 */
@property (nonatomic, strong, readonly, nullable) NSUUID *applicationId;

/**
 The credential object for the current session.
 */
@property (nonatomic, strong, readonly, nullable) MHVSessionCredential *sessionCredential;

/**
 The cache configuration object.
 It must be set before calling authenticateWithViewController.
 */
@property (nonatomic, strong, nullable) id<MHVThingCacheConfigurationProtocol> cacheConfiguration;

/**
 The person info for the current session.
 */
@property (nonatomic, strong, readonly, nullable) MHVPersonInfo *personInfo;

/**
 The authentication state for the current session. YES if the session is authenticated.
 */
@property (nonatomic, assign, readonly) BOOL isAuthenticated;

/**
 Makes Web request call to HealthVault service.

 @param operation The operation to execute.  Either MHVMethod or MHVRestRequest.
        MHVMethod class has properties representing the method name, version, parameters, recordId and correlationId.
        MHVRestRequest class has properties for url, query parameters, etc.
 */
- (void)executeHttpServiceOperation:(id<MHVHttpServiceOperationProtocol>)operation
                         completion:(void (^_Nullable)(MHVServiceResponse *_Nullable response, NSError *_Nullable error))completion;

/**
 Authenticates the connection. Calling authenticate will immediately present an authentication user interface if the connection is not authenticated.

 @param viewController Optional A view controller used to present a user authentication user interface. If the viewController parameter is nil the authentication flow will be presented from the current window's root view controller.
 @param completion Envoked when the operation completes. NSError object will be nil if there is no error when performing the operation.
 */
- (void)authenticateWithViewController:(UIViewController *_Nullable)viewController
                            completion:(void(^_Nullable)(NSError *_Nullable error))completion;

/**
 A client that can be used to access information and records associated with the currently athenticated user.

 @return An instance conforming to MHVPersonClientProtocol.
 */
- (id<MHVPersonClientProtocol> _Nullable)personClient;

/**
 A client that can be used to interact with the HealthVault platform.

 @return An instance conforming to MHVPlatformClientProtocol.
 */
- (id<MHVPlatformClientProtocol> _Nullable)platformClient;

/**
 A client that can be used to access things associated with a particular record.

 @return An instance conforming to MHVThingClientProtocol.
 */
- (id<MHVThingClientProtocol> _Nullable)thingClient;


/**
 A client that can be used to access remote monitoring items.
 
 @return An instance conforming to MHVRemoteMonitoringClientProtocol.
 */
- (MHVRemoteMonitoringClient *_Nullable)remoteMonitoringClient;

/**
 A client that can be used to access vocabularies.

 @return An instance conforming to MHVVocabularyClientProtocol.
 */
- (id<MHVVocabularyClientProtocol> _Nullable)vocabularyClient;

/**
 Perform background tasks.  
 This should be called in application:performFetchWithCompletionHandler:
 You will also need to add "Background fetch" to your app's "Background modes" capabilities
 if you wish to have HealthVault data updated in the background

 @param completion Envoked when the tasks are complete
 */
- (void)performBackgroundTasks:(void(^_Nullable)(MHVConnectionTaskResult *taskResult))completion;

/**
 Perform foreground tasks.
 This should be called in applicationDidBecomeActive:
 
 @param completion Envoked when the tasks are complete
 */
- (void)performForegroundTasks:(void(^_Nullable)(MHVConnectionTaskResult *taskResult))completion;

@end

NS_ASSUME_NONNULL_END

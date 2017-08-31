//
//  MHVSodaConnectionProtocol.h
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

@class UIViewController;

/**
 A client connection to HealthVault
 */
@protocol MHVSodaConnectionProtocol <MHVConnectionProtocol>

/**
 Prompt the user to authorize additional records for use in this app.

 @param viewController Optional A view controller used to present a user authentication user interface. If the viewController parameter is nil the authentication flow will be presented from the current window's root view controller.
 @param completion Envoked when the operation completes. NSError object will be nil if there is no error when performing the operation.
 */
- (void)authorizeAdditionalRecordsWithViewController:(UIViewController *_Nullable)viewController
                                          completion:(void(^_Nullable)(NSError *_Nullable error))completion;

/**
 Deletes connection information, forcing new application provisioning and authentication on the next call.

 @param completion Envoked when the operation completes. NSError object will be nil if there is no error when performing the operation.
 */
- (void)deauthorizeApplicationWithCompletion:(void(^_Nullable)(NSError *_Nullable error))completion;

@end

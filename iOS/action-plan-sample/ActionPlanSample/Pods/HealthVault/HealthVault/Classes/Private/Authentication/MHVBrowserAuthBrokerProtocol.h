//
//  MHVBrowserAuthBrokerProtocol.h
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

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
@class UIViewController;

typedef void (^MHVSignInCompletion)(NSURL *_Nullable successUrl, NSError *_Nullable error);

NS_ASSUME_NONNULL_BEGIN

@protocol MHVBrowserAuthBrokerProtocol <NSObject, WKNavigationDelegate>

@property (nonatomic, strong, readonly) NSURL *startUrl;

/**
 * Authenticates with the view controller as the parent view controller
 *
 * @param viewController the view controller to use as the parent when presenting the authentication browser, 
 *        if nil the current key window's root view controller is used
 * @param startUrl Starting URL for the authentication
 * @param endUrl End URL that indicates the authentication succeeded
 * @param completion Envoked when the operation completes. NSURL if success, or NSError if the authentication failed.
 */
- (void)authenticateWithViewController:(UIViewController *_Nullable)viewController
                              startUrl:(NSURL *)startUrl
                                endUrl:(NSURL *)endUrl
                            completion:(MHVSignInCompletion)completion;

/**
 * Cancel the authentication.  The completion passed to authenticateWithViewController:... will be called with an error
 */
- (void)userCancelled;

@end

NS_ASSUME_NONNULL_END

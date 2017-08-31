//
// MHVHttpService.h
// MHVLib
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
#import "MHVHttpServiceProtocol.h"
@class MHVConfiguration;

NS_ASSUME_NONNULL_BEGIN

@interface MHVHttpService : NSObject <MHVHttpServiceProtocol>

/**
 Create MHV HTTP Service

 @param urlSession NSURLSession to use
 @return the MHVHttpService
 */
- (instancetype)initWithURLSession:(NSURLSession *)urlSession;

/**
 Create MHV HTTP Service using default NSURLSession

 @param configuration MHVConfiguration to use, with properties for creating the NSURLSession
 @return the MHVHttpService
 */
- (instancetype)initWithConfiguration:(MHVConfiguration *)configuration;

- (instancetype)init __unavailable;
+ (instancetype)new __unavailable;

@end

NS_ASSUME_NONNULL_END

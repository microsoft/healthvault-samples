//
// MHVRequestMessageCreator.h
// MHVLib
//
// Copyright 2017 Microsoft Corp.
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
#import "MHVRequestMessageCreatorProtocol.h"

@class MHVMethod, MHVAuthSession, MHVConfiguration, MHVCryptographer;

NS_ASSUME_NONNULL_BEGIN

/**
 This class encapsulates the data that is contained in a request.
 */
@interface MHVRequestMessageCreator : NSObject<MHVRequestMessageCreatorProtocol>

- (instancetype)initWithMethod:(MHVMethod *)method
                  sharedSecret:(NSString *_Nullable)sharedSecret
                   authSession:(MHVAuthSession *)authSession
                 configuration:(MHVConfiguration *)configuration
                         appId:(NSUUID *)appId
                   messageTime:(NSDate *)messageTime
                 cryptographer:(MHVCryptographer *)cryptographer;

@end

NS_ASSUME_NONNULL_END

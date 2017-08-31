//
// MHVPendingMethod.h
// healthvault-ios-sdk
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
//

#import "MHVMethod.h"

@interface MHVPendingMethod : MHVMethod

@property (nonatomic, strong, readonly) NSString *identifier;
@property (nonatomic, strong, readonly) NSDate *originalRequestDate;

- (instancetype)initWithOriginalRequestDate:(NSDate *)originalRequestDate
                                     method:(MHVMethod *)method;

- (instancetype)initWithOriginalRequestDate:(NSDate *)originalRequestDate
                                 identifier:(NSString *)identifier
                                 methodName:(NSString *)methodName;

@end

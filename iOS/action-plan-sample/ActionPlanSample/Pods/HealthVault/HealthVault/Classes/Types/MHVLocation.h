//
//  MHVLocation.h
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

#import "MHVType.h"

NS_ASSUME_NONNULL_BEGIN

@interface MHVLocation : MHVType


/**
 An ISO 3166-1 two letter country code (defaults to US)
 */
@property (nonatomic, strong) NSString *country;

/**
 An ISO 3166-2 state/province code without the country prefix.
 */
@property (nonatomic, strong, nullable) NSString *stateProvince;

/**
 Initializes a new instance of MHVLocation

 @param country An ISO 3166-1 two letter country code
 @param stateProvince An ISO 3166-2 state/province code without the country prefix.
 @return A new MHVLocation populated with the specified country and state or province
 */
- (instancetype)initWithCountry:(NSString *)country stateProvince:(NSString *_Nullable)stateProvince;

@end

NS_ASSUME_NONNULL_END

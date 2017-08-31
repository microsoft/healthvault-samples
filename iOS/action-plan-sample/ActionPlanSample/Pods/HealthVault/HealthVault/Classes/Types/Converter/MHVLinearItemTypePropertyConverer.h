//
//  MHVLinearItemTypePropertyConverer.h
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
#import "MHVItemTypePropertyConverterProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MHVLinearItemTypePropertyConverer : MHVType<MHVItemTypePropertyConverterProtocol>

/**
 The value by which to multiply the original value - The 'm' in the equation x' = mx + b.
 */
@property (nonatomic, assign, readonly) double multiplier;

/**
 The offset to add in the linear conversion - The 'b' in the equation x' = mx + b.
 */
@property (nonatomic, assign, readonly) double offset;

/**
 Creates a new instance of the MHVLinearItemTypePropertyConverer class.

 @param multiplier The multiplier to use in the linear conversion.
 @param offset The offset to use in the linear conversion.
 @return A new instance of MHVLinearItemTypePropertyConverer
 */
- (instancetype)initWithMultiplier:(double)multiplier offset:(double)offset;

+ (instancetype)new __unavailable;
- (instancetype)init __unavailable;

@end

NS_ASSUME_NONNULL_END

//
//  MHVThingTypeOrderByProperty.h
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

@protocol MHVItemTypePropertyConverterProtocol;

/**
 The property that the thing-type can be ordered by in the result.
 */
@interface MHVThingTypeOrderByProperty : MHVType

/**
 The name of the property.
 */
@property (nonatomic, strong, readonly, nullable) NSString *name;

/**
 The data type for the property.
 */
@property (nonatomic, strong, readonly, nullable) NSString *type;

/**
 The XPath fot the property
 */
@property (nonatomic, strong, readonly, nullable) NSString *xpath;

/**
 A units conversion to apply to the value of a property of numeric type. When a thing type has multiple versions that store the same data with different units, a conversion between units may be required to ensure that values are ordered correctly across versions.
 */
@property (nonatomic, strong, readonly, nullable) id<MHVItemTypePropertyConverterProtocol> converter;

@end


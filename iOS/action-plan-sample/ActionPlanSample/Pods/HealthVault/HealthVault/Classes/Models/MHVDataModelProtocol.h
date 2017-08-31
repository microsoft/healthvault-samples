//
// MHVDataModelDynamicClass.m
// MHVLib
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

#ifndef MHVCommon_MHVDataModelProtocol_h
#define MHVCommon_MHVDataModelProtocol_h

#import <Foundation/Foundation.h>

@protocol MHVDataModelProtocol <NSObject>

@required

/*!
 * @brief Returns a dictionary of property names to either formatter for NSDate properties, or item class for NSArray properties
 *        Child classes should add their parent's parameter map.
 */
+ (NSDictionary *)objectParametersMap;

/*!
 * @brief Returns a dictionary of property names to JSON names, ie "workoutStatus" : "Status"
 *        Simple first-letter casing ("name" : "Name") is handled automatically
 *        Child classes should add their parent's name map.
 */
+ (NSDictionary *)propertyNameMap;

/*!
 * @brief Creates a DataModel or type given an object.
 *        MHVDataModel expects a NSDictionary, +DataModel categories implement to init different types, ie NSString, NSNumber, etc.
 * @param object NSObject the object to be converted
 * @param parameters NSObject Optional parameter used for the conversion, used for NSDate for the formatter, and for NSArray for the item class
 * @return a data model
 */
- (instancetype)initWithObject:(id)object objectParameters:(NSObject *)parameters;

/*!
 * @brief Returns an object encoded as JSON.
 *        +DataModel categories implement to encode different types, ie NSString, NSNumber, etc.
 * @param parameters NSObject Optional parameter used for the conversion, currently only used for the formatter to use for NSDates
 * @return NSString encoded as JSON
 */
- (NSString *)jsonRepresentationWithObjectParameters:(NSObject *)parameters;

/*!
 * @brief Indicate whether the class should validate properties match the values in the dictionary when created
 *        Defaults to NO since many classes don't include old band properties from cloud
 */
+ (BOOL)shouldValidateProperties;

/*!
 * @brief Validates that there is a property for all keys in the dictionary.  Asserts for those not found.
 *        NOTE: Only validates in Debug builts
 */
- (void)validatePropertiesForDictionary:(NSDictionary *)dictionary;

/*!
 * @brief Validates that property name map keys and values are NSStrings (to avoid mixup with objectParametersMap)
 *        NOTE: Only validates in Debug builts
 */
- (void)validatePropertyNameMap:(NSDictionary<NSString *, NSString *> *)nameMap;

@end

#endif

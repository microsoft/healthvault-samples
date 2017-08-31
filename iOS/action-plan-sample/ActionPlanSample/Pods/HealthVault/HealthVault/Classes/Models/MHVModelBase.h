//
// MHVModelBase.h
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

#ifndef MHVCommon_MHVModelBase_h
#define MHVCommon_MHVModelBase_h

#import <Foundation/Foundation.h>
#import "MHVDataModelProtocol.h"

@interface MHVModelBase : NSObject<MHVDataModelProtocol, NSCoding, NSCopying>

/*!
 * @brief Helper to initialize an object from json.
 * @param json NSString
 * @return a data model
 */
- (instancetype)initWithJson:(NSString *)json;

/*!
 * @brief Creates a MHVModelBase or type given an object.
 *        MHVModelBase expects a NSDictionary, +DataModel categories implement to init different types, ie NSString, NSNumber, etc.
 * @param object NSObject the object to be converted
 * @param parameters NSObject Optional parameter used for the conversion, used for NSDate for the formatter, and for NSArray for the item class
 * @return a data model
 */
- (instancetype)initWithObject:(id)object objectParameters:(NSObject *)parameters;

/*!
 * @brief Initialize all properties from dictionary
 * @param object NSObject the object to fill
 * @param dictionary NSDictionary dictionary with values to use
 */
+ (void)setProperties:(id<MHVDataModelProtocol>)object fromDictionary:(NSDictionary *)dictionary;

/*!
 * @brief Merge properties from one object to another *Without overwriting values in self with nil values in dataModel*
 *        ie: "if (dataModel.value) { self.value = dataModel.value; }"
 *        Arrays and Dictionary objects are *merged*
 * @param dataModel MHVModelBase the object to copy values from
 */
- (void)mergeWithDataModel:(MHVModelBase*)dataModel;

/*!
 * @brief Get an array of settable property names on the data model. 
 */
- (NSArray<NSString *> *)settableProperties;

/*!
 * @brief Returns an object encoded as JSON.
 *        +DataModel categories implement to encode different types, ie NSString, NSNumber, etc.
 * @param parameters NSObject Optional parameter used for the conversion, currently only used for the formatter to use for NSDates
 * @return NSString encoded as JSON
 */
- (NSString *)jsonRepresentationWithObjectParameters:(NSObject *)parameters;

/*!
 * @brief Returns an object encoded as JSON.  Shortcut when no parameters
 *        +DataModel categories implement to encode different types, ie NSString, NSNumber, etc.
 * @return NSString encoded as JSON
 */
- (NSString *)jsonRepresentation;

@end

#endif

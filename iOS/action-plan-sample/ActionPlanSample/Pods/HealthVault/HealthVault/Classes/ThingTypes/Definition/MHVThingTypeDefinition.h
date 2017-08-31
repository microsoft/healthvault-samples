//
//  MHVThingTypeDefinition.h
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

@class MHVThingTypeVersionInfo, MHVBool;


/**
 Describes the schema and structure of a thing type.
 */
@interface MHVThingTypeDefinition : MHVType

/**
 A string representing the type name.
 */
@property (nonatomic, strong, readonly) NSString *name;

/**
 A GUID representing the type identifier.
 */
@property (nonatomic, strong, readonly) NSUUID *typeId;

/**
 An XML string representing the definition. *The object will be nil if MHVThingTypeSectionsXsd is not requested.
 */
@property (nonatomic, strong, readonly) NSString *xmlSchemaDefinition;

/**
 A Bool indicating whether or not the thing type can be created. YES if it can be created, NO otherwise. *The object will be nil if MHVThingTypeSectionsCore is not requested.
 */
@property (nonatomic, strong, readonly) MHVBool *isCreatable;

/**
 A Bool indicating whether or not the thing type is immutable. YES if it can be mutated, NO otherwise. *The object will be nil if MHVThingTypeSectionsCore is not requested.
 */
@property (nonatomic, strong, readonly) MHVBool *isImmutable;

/**
 A Bool indicating if only a single instance of the thing type can exist for each health record. YES if it is a singleton, NO otherwise. *The object will be nil if MHVThingTypeSectionsCore is not requested.
 */
@property (nonatomic, strong, readonly) MHVBool *isSingletonType;

/**
 A Bool indicating if the thing type instance can be set to read-only. YES if instances can be set to read-only, NO otherwise. *The object will be nil if MHVThingTypeSectionsCore is not requested.
 */
@property (nonatomic, strong, readonly) MHVBool *allowReadOnly;

/**
 A collection of version information for the thing type. *The object will be nil if MHVThingTypeSectionsVersions is not requested.
 */
@property (nonatomic, strong, readonly) NSArray<MHVThingTypeVersionInfo *> *versions;

/**
 A string repersentation of the XPath. *The object will be nil if MHVThingTypeSectionsEffectiveDateXPath is not requested.
 */
@property (nonatomic, strong, readonly) NSString *effectiveDateXPath;

/**
 A string repersentation of the XPath.
 */
@property (nonatomic, strong, readonly) NSString *updatedEndDateXPath;

@end

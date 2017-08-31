//
//  MHVThingConstants.h
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

#ifndef MHVThingConstants_h
#define MHVThingConstants_h

/**
 Enumeration used to specify the sections of thing type definition that should be returned.
 */
typedef NS_ENUM(NSUInteger, MHVThingTypeSections)
{
    // Indicates no information about the thing type definition should be returned.
    MHVThingTypeSectionsNone = 0x0,
    
    // Indicates the core information about the thing type definition should be returned.
    MHVThingTypeSectionsCore = 0x1,
    
    // Indicates the schema of the thing type definition should be returned.
    MHVThingTypeSectionsXsd = 0x2,
    
    // Indicates the columns used by the thing type definition should be returned. (Not currently supported in the iOS SDK)
    //MHVThingTypeSectionsColumns = 0x4,
    
    // Indicates the transforms supported by the thing type definition should be returned. (Not currently supported in the iOS SDK)
    //MHVThingTypeSectionsTransforms = 0x8,
    
    // Indicates the transforms and their XSL source supported by the health record item type definition should be returned. (Not currently supported in the iOS SDK)
    //MHVThingTypeSectionsTransformSource = 0x10,
    
    // Indicates the versions of the thing type definition should be returned.
    MHVThingTypeSectionsVersions = 0x20,
    
    // Indicates the effective date XPath of the thing type definition should be returned.
    MHVThingTypeSectionsEffectiveDateXPath = 0x40,
    
    // Indicates all information for the thing type definition should be returned.
    MHVThingTypeSectionsAll = MHVThingTypeSectionsCore | MHVThingTypeSectionsXsd | MHVThingTypeSectionsVersions | MHVThingTypeSectionsEffectiveDateXPath
};

#endif /* MHVThingConstants_h */

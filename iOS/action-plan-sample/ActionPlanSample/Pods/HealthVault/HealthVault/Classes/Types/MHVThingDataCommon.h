//
// MHVThingDataStandard.h
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

#import <Foundation/Foundation.h>
#import "MHVType.h"
#import "MHVString255.h"
#import "MHVStringZ512.h"
#import "MHVRelatedThing.h"

// -------------------------
//
// Common Xml data in a MHVThing
// [Notes, tags, extensions...]
//
// -------------------------
@interface MHVThingDataCommon : MHVType

// -------------------------
//
// Data
//
// -------------------------
//
// (Optional) The source of the MHVThing
//
@property (readwrite, nonatomic, strong) NSString *source;
//
// (Optional) Arbitrary notes associated with the MHVThing
//
@property (readwrite, nonatomic, strong) NSString *note;
//
// (Optional) One or more string tags
//
@property (readwrite, nonatomic, strong) MHVStringZ512 *tags;
//
// (Optional) Additional application specific "Extension" data injected
// into the MHVThing. Can be ANY well-formed Xml node
//
@property (readwrite, nonatomic, strong) NSMutableArray *extensions;
//
// (Optional) Things related to the MHVThing
//
@property (readwrite, nonatomic, strong) NSArray<MHVRelatedThing *> *relatedThings;
//
// (Optional) Application injected ID
//
@property (readwrite, nonatomic, strong) MHVString255 *clientID;
//
// Convenience properties
//
@property (readwrite, nonatomic, strong) NSString *clientIDValue;

// ----------------------
//
// Methods
//
// ----------------------
- (MHVRelatedThing *)addRelation:(NSString *)name toThing:(MHVThing *)thing;

@end

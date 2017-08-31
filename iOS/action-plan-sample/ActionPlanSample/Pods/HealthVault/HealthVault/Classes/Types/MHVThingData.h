//
// MHVThingData.h
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
#import "MHVThingDataCommon.h"
#import "MHVThingDataTyped.h"

// -------------------------
//
// Xml data associated with an MHVThing
// - Typed data [e.g. Medication, Allergy, Exercise etc.] with associated MHV Schemas
// - Common data [Notes, tags, extensions...]
//
// -------------------------
@interface MHVThingData : MHVType

// -------------------------
//
// Data
//
// -------------------------
@property (readwrite, nonatomic, strong) MHVThingDataCommon *common;
@property (readwrite, nonatomic, strong) MHVThingDataTyped *typed;

@property (readonly, nonatomic) BOOL hasCommon;
@property (readonly, nonatomic) BOOL hasTyped;


@end

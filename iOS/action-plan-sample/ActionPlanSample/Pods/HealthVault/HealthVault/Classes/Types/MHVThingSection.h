//
// MHVThingSection.h
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

typedef NS_ENUM (NSInteger, MHVThingSection)
{
    MHVThingSection_None = 0,
    MHVThingSection_Data = 0x01,
    MHVThingSection_Core = 0x02,
    MHVThingSection_Audits = 0x04,
    MHVThingSection_Tags = 0x08,          // Not supported by MHVThing parsing
    MHVThingSection_Blobs = 0x10,
    MHVThingSection_Permissions = 0x20,   // Not supported by MHVThing parsing
    MHVThingSection_Signatures = 0x40,    // Not supported by MHVThing parsing
    //
    // Composite
    //
    MHVThingSection_Standard = (MHVThingSection_Data | MHVThingSection_Core)
};

NSString *MHVThingSectionToString(MHVThingSection section);
MHVThingSection MHVThingSectionFromString(NSString *string);

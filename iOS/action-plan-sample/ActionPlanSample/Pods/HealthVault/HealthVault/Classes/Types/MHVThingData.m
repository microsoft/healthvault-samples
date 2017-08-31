//
// MHVThingData.m
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

#import "MHVValidator.h"
#import "MHVThingData.h"
#import "MHVThingType.h"
#import "MHVThingRaw.h"

static NSString *const c_element_common = @"common";

@implementation MHVThingData

- (BOOL)hasTyped
{
    return self.typed != nil;
}

- (MHVThingDataTyped *)typed
{
    if (!_typed)
    {
        _typed = [[MHVThingDataTyped alloc] init];
    }
    
    return _typed;
}

- (BOOL)hasCommon
{
    return self.common != nil;
}

- (MHVThingDataCommon *)common
{
    if (!_common)
    {
        _common = [[MHVThingDataCommon alloc] init];
    }
    
    return _common;
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN
    
    MHVVALIDATE_OPTIONAL(self.common);
    MHVVALIDATE_OPTIONAL(self.typed);
    
    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    if (self.typed)
    {
        [writer writeElement:self.typed.rootElement content:self.typed];
    }
    
    [writer writeElement:c_element_common content:self.common];
}

- (void)deserialize:(XReader *)reader
{
    if (![reader isStartElementWithName:c_element_common])
    {
        //
        // Typed Thing Data!
        //
        self.typed = [self deserializeTyped:reader];
        if (!self.typed)
        {
            self.typed = [self deserializeRaw:reader];
        }
        
        if (!self.typed)
        {
            return;
        }
    }
    
    if ([reader isStartElementWithName:c_element_common])
    {
        self.common = [reader readElement:c_element_common asClass:[MHVThingDataCommon class]];
    }
}

#pragma mark - Internal methods

- (MHVThingDataTyped *)deserializeTyped:(XReader *)reader
{
    MHVThingType *thingType = (MHVThingType *)reader.context;
    NSString *typeID = (thingType != nil) ? thingType.typeID : nil;
    
    MHVThingDataTyped *typedThing = [[MHVTypeSystem current] newFromTypeID:typeID];
    
    if (typedThing)
    {
        if (typedThing.hasRawData)
        {
            [typedThing deserialize:reader];
        }
        else
        {
            [reader readElementRequired:reader.localName intoObject:typedThing];
        }
    }
    
    return typedThing;
}

- (MHVThingRaw *)deserializeRaw:(XReader *)reader
{
    MHVThingRaw *raw = [[MHVThingRaw alloc] init];
    
    if (raw)
    {
        [raw deserialize:reader];
    }
    
    return raw;
}

@end

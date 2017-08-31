//
// MHVThingDataCommon.m
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
#import "MHVThingDataCommon.h"

static NSString *const c_element_source = @"source";
static NSString *const c_element_note = @"note";
static NSString *const c_element_tags = @"tags";
static NSString *const c_element_extension = @"extension";
static NSString *const c_element_related = @"related-thing";
static NSString *const c_element_clientID = @"client-thing-id";

@implementation MHVThingDataCommon

- (NSString *)clientIDValue
{
    return _clientID ? _clientID.value : nil;
}

- (void)setClientIDValue:(NSString *)clientIDValue
{
    _clientID = nil;
    if (clientIDValue && ![clientIDValue isEqualToString:@""])
    {
        MHVString255 *clientID = [[MHVString255 alloc] initWith:clientIDValue];
        _clientID = clientID;
    }
}

- (MHVRelatedThing *)addRelation:(NSString *)name toThing:(MHVThing *)thing
{
    if (!self.relatedThings)
    {
        self.relatedThings = @[];
    }
    
    MHVRelatedThing *relation = [MHVRelatedThing relationNamed:name toThing:thing];
    
    MHVCHECK_NOTNULL(relation);
    self.relatedThings = [self.relatedThings arrayByAddingObject:relation];
    
    return relation;
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN;
    
    MHVVALIDATE_OPTIONAL(self.tags);
    MHVVALIDATE_ARRAYOPTIONAL(self.relatedThings, MHVClientError_InvalidRelatedThing);
    MHVVALIDATE_OPTIONAL(self.clientID);
    
    MHVVALIDATE_SUCCESS;
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_source value:self.source];
    [writer writeElement:c_element_note value:self.note];
    [writer writeElement:c_element_tags content:self.tags];
    [writer writeRawElementArray:c_element_extension elements:self.extensions];
    [writer writeElementArray:c_element_related elements:self.relatedThings];
    [writer writeElement:c_element_clientID content:self.clientID];
}

- (void)deserialize:(XReader *)reader
{
    self.source = [reader readStringElement:c_element_source];
    self.note = [reader readStringElement:c_element_note];
    self.tags = [reader readElement:c_element_tags asClass:[MHVStringZ512 class]];
    self.extensions = [reader readRawElementArray:c_element_extension];
    self.relatedThings = [reader readElementArray:c_element_related asClass:[MHVRelatedThing class] andArrayClass:[NSMutableArray class]];
    self.clientID = [reader readElement:c_element_clientID asClass:[MHVString255 class]];
}

@end

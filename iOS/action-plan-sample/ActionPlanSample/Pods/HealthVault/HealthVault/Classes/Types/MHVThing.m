//
// MHVThing.m
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
#import "MHVThing.h"

static NSString* const c_element_state = @"thing-state";

static const xmlChar  *x_element_key = XMLSTRINGCONST("thing-id");
static const xmlChar  *x_element_type = XMLSTRINGCONST("type-id");
static const xmlChar  *x_element_flags = XMLSTRINGCONST("flags");
static const xmlChar  *x_element_effectiveDate = XMLSTRINGCONST("eff-date");
static const xmlChar  *x_element_created = XMLSTRINGCONST("created");
static const xmlChar  *x_element_updated = XMLSTRINGCONST("updated");
static const xmlChar  *x_element_data = XMLSTRINGCONST("data-xml");
static const xmlChar  *x_element_blobs = XMLSTRINGCONST("blob-payload");
static const xmlChar  *x_element_permissions = XMLSTRINGCONST("eff-permissions");
static const xmlChar  *x_element_tags = XMLSTRINGCONST("tags");
static const xmlChar  *x_element_signatures = XMLSTRINGCONST("signature-info");
static const xmlChar  *x_element_updatedEndDate = XMLSTRINGCONST("updated-end-date");

@implementation MHVThing

- (BOOL)hasKey
{
    return self.key != nil;
}

- (BOOL)hasTypeInfo
{
    return self.type != nil;
}

- (BOOL)hasData
{
    return self.data != nil;
}

- (BOOL)hasTypedData
{
    return self.hasData && self.data.hasTyped;
}

- (BOOL)hasCommonData
{
    return self.hasData && self.data.hasCommon;
}

- (BOOL)hasBlobData
{
    return self.blobs.hasThings;
}

- (BOOL)isReadOnly
{
    return (self.flags & MHVThingFlagImmutable) != 0;
}

- (BOOL)hasUpdatedEndDate
{
    return self.updatedEndDate && !self.updatedEndDate.isNull;
}

- (NSString *)note
{
    return self.hasCommonData ? self.data.common.note : nil;
}

- (void)setNote:(NSString *)note
{
    self.data.common.note = note;
}

- (MHVBlobPayload *)blobs
{
    if (!_blobs)
    {
    	_blobs = [[MHVBlobPayload alloc] init];
    }
    
    return _blobs;
}

- (NSString *)thingID
{
    if (!self.key)
    {
        return @"";
    }
    
    return self.key.thingID;
}

- (NSString *)typeID
{
    return self.type != nil ? self.type.typeID : @"";
}

- (instancetype)initWithType:(NSString *)typeID
{
    MHVThingDataTyped *data = [[MHVTypeSystem current] newFromTypeID:typeID];
    
    if (data)
    {
        self = [self initWithTypedData:data];
        
        return self;
    }
    
    return nil;
}

- (instancetype)initWithTypedData:(MHVThingDataTyped *)data
{
    if (!data)
    {
        MHVASSERT_PARAMETER(data);
        return nil;
    }
    
    self = [super init];
    
    if (self)
    {
        _type = [[MHVThingType alloc] initWithTypeID:data.type];
        _data = [[MHVThingData alloc] init];
        _data.typed = data;
    }
    
    return self;
}

- (instancetype)initWithTypedDataClassName:(NSString *)name
{
    NSString *typeID = [[MHVTypeSystem current] getTypeIDForClassName:name];
    
    if (typeID)
    {
        return [self initWithType:typeID];
    }
    
    return nil;
}

- (instancetype)initWithTypedDataClass:(Class)cls
{
    return [self initWithTypedDataClassName:NSStringFromClass(cls)];
}

- (BOOL)setKeyToNew
{
    MHVThingKey *newKey = [MHVThingKey newLocal];
    
    if (newKey)
    {
        self.key = newKey;
        
        return YES;
    }
    
    return NO;
}

- (BOOL)ensureKey
{
    if (!self.key)
    {
        return [self setKeyToNew];
    }
    
    return YES;
}

- (BOOL)ensureEffectiveDate
{
    if (!self.effectiveDate)
    {
        NSDate *newDate = [self.data.typed getDate];
        
        if (!newDate)
        {
            newDate = [NSDate date];
        }
        
        self.effectiveDate = newDate;
    }
    
    return self.effectiveDate != nil;
}

- (BOOL)removeEndDate
{
    self.updatedEndDate = [MHVConstrainedXmlDate nullDate];
    
    return self.updatedEndDate != nil;
}

- (BOOL)updateEndDate:(NSDate *)date
{
    if (!date)
    {
        MHVASSERT_PARAMETER(date);
        return NO;
    }
    
    self.updatedEndDate = [MHVConstrainedXmlDate fromDate:date];
    
    return self.updatedEndDate != nil;
}

- (BOOL)updateEndDateWithApproxDate:(MHVApproxDateTime *)date
{
    if (!date)
    {
        MHVASSERT_PARAMETER(date);
        return NO;
    }
    
    if (date.isStructured)
    {
        self.updatedEndDate = [MHVConstrainedXmlDate fromDate:[date toDate]];
        
        return self.updatedEndDate != nil;
    }
    
    return [self removeEndDate];
}

- (NSDate *)getDate
{
    if (self.hasTypedData)
    {
        NSDate *date = [self.data.typed getDate];
        if (date)
        {
            return date;
        }
    }
    
    if (self.effectiveDate)
    {
        return self.effectiveDate;
    }
    
    return nil;
}

- (BOOL)isVersion:(NSString *)version
{
    if (self.hasKey && self.key.hasVersion)
    {
        return [self.key.version isEqualToString:version];
    }
    
    return NO;
}

- (BOOL)isType:(NSString *)typeID
{
    if (self.hasTypeInfo)
    {
        return [self.type isType:typeID];
    }
    
    return NO;
}

- (MHVThing *)shallowClone
{
    MHVThing *thing = [[MHVThing alloc] init];
    
    thing.key = self.key;
    thing.type = self.type;
    thing.state = self.state;
    thing.flags = self.flags;
    thing.effectiveDate = self.effectiveDate;
    thing.created = self.created;
    thing.updated = self.updated;
    if (self.hasData)
    {
        thing.data = self.data;
    }
    
    if (self.hasBlobData)
    {
        thing.blobs = self.blobs;
    }
    
    thing.updatedEndDate = self.updatedEndDate;
    
    return thing;
}

- (void)prepareForUpdate
{
    self.effectiveDate = nil;
    self.updated = nil;
    if (self.isReadOnly)
    {
        self.data = nil; // Can't update read only dataXml
    }
}

- (void)prepareForNew
{
    self.effectiveDate = nil;
    self.updated = nil;
    self.created = nil;
    self.key = nil;
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN;
    
    MHVVALIDATE_OPTIONAL(self.key);
    MHVVALIDATE_OPTIONAL(self.type);
    MHVVALIDATE_OPTIONAL(self.data);
    MHVVALIDATE_OPTIONAL(self.blobs);
    
    MHVVALIDATE_SUCCESS;
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementXmlName:x_element_key content:self.key];
    [writer writeElementXmlName:x_element_type content:self.type];
    [writer writeElement:c_element_state value:MHVThingStateToString(self.state)];
    [writer writeElementXmlName:x_element_flags intValue:self.flags];
    [writer writeElementXmlName:x_element_effectiveDate dateValue:self.effectiveDate];
    [writer writeElementXmlName:x_element_created content:self.created];
    [writer writeElementXmlName:x_element_updated content:self.updated];
    [writer writeElementXmlName:x_element_data content:self.data];
    if ([self hasBlobData])
    {
        [writer writeElementXmlName:x_element_blobs content:self.blobs];
    }
    [writer writeElementXmlName:x_element_updatedEndDate content:self.updatedEndDate];
}

- (void)deserialize:(XReader *)reader
{
    self.key = [reader readElementWithXmlName:x_element_key asClass:[MHVThingKey class]];
    self.type = [reader readElementWithXmlName:x_element_type asClass:[MHVThingType class]];
    
    NSString *state = [reader readStringElement:c_element_state];
    if (state)
    {
        self.state = MHVThingStateFromString(state);
    }
    
    self.flags = [reader readIntElementXmlName:x_element_flags];
    self.effectiveDate = [reader readDateElementXmlName:x_element_effectiveDate];
    self.created = [reader readElementWithXmlName:x_element_created asClass:[MHVAudit class]];
    self.updated = [reader readElementWithXmlName:x_element_updated asClass:[MHVAudit class]];
    self.data = [reader readElementWithXmlName:x_element_data asClass:[MHVThingData class]];
    self.blobs = [reader readElementWithXmlName:x_element_blobs asClass:[MHVBlobPayload class]];
    [reader skipElementWithXmlName:x_element_permissions];
    [reader skipElementWithXmlName:x_element_tags];
    [reader skipElementWithXmlName:x_element_signatures];
    self.updatedEndDate = [reader readElementWithXmlName:x_element_updatedEndDate asClass:[MHVConstrainedXmlDate class]];
    
    if (self.updatedEndDate && self.updatedEndDate.isNull)
    {
        self.updatedEndDate = nil;
    }
}

- (NSString *)toXmlString
{
    return [self toXmlStringWithRoot:@"info"];
}

+ (MHVThing *)newFromXmlString:(NSString *)xml
{
    return (MHVThing *)[NSObject newFromString:xml withRoot:@"info" asClass:[MHVThing class]];
}

@end

//
// MHVRelatedThing.m
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
#import "MHVRelatedThing.h"
#import "MHVThing.h"

static NSString *const c_element_thingID = @"thing-id";
static NSString *const c_element_version = @"version-stamp";
static NSString *const c_element_clientID = @"client-thing-id";
static NSString *const c_element_relationship = @"relationship-type";

@implementation MHVRelatedThing

- (instancetype)initRelationship:(NSString *)relationship toThingWithKey:(MHVThingKey *)key
{
    MHVCHECK_STRING(relationship);
    MHVCHECK_NOTNULL(key);

    self = [super init];
    if (self)
    {
        _thingID = key.thingID;
        _version = key.version;
        _relationship = relationship;
    }

    return self;
}

- (instancetype)initRelationship:(NSString *)relationship toThingWithClientID:(NSString *)clientID
{
    MHVCHECK_STRING(relationship);
    MHVCHECK_STRING(clientID);

    self = [super init];
    if (self)
    {
        _relationship = relationship;

        _clientID = [[MHVString255 alloc] initWith:clientID];
        MHVCHECK_NOTNULL(_clientID);
    }

    return self;
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN

    MHVVALIDATE_STRINGOPTIONAL(self.thingID, MHVClientError_InvalidRelatedThing);
    MHVVALIDATE_OPTIONAL(self.clientID);
    MHVVALIDATE_STRINGOPTIONAL(self.relationship, MHVClientError_InvalidRelatedThing);

    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_thingID value:self.thingID];
    [writer writeElement:c_element_version value:self.version];
    [writer writeElement:c_element_clientID content:self.clientID];
    [writer writeElement:c_element_relationship value:self.relationship];
}

- (void)deserialize:(XReader *)reader
{
    self.thingID = [reader readStringElement:c_element_thingID];
    self.version = [reader readStringElement:c_element_version];
    self.clientID = [reader readElement:c_element_clientID asClass:[MHVString255 class]];
    self.relationship = [reader readStringElement:c_element_relationship];
}

+ (MHVRelatedThing *)relationNamed:(NSString *)name toThing:(MHVThing *)thing
{
    return [MHVRelatedThing relationNamed:name toThingKey:thing.key];
}

+ (MHVRelatedThing *)relationNamed:(NSString *)name toThingKey:(MHVThingKey *)key
{
    return [[MHVRelatedThing alloc] initRelationship:name toThingWithKey:key];
}

@end

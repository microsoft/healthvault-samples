//
// MHVThingType.m
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
#import "MHVThingType.h"

static NSString *const c_attribute_name = @"name";

@implementation MHVThingType

- (instancetype)initWithTypeID:(NSString *)typeID
{
    MHVCHECK_STRING(typeID);

    self = [super init];
    if (self)
    {
        _typeID = typeID;
    }

    return self;
}

- (BOOL)isType:(NSString *)typeID
{
    return [self.typeID caseInsensitiveCompare:typeID] == NSOrderedSame;
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN;

    MHVVALIDATE_STRING(self.typeID, MHVClientError_InvalidThingType);

    MHVVALIDATE_SUCCESS;
}

- (void)serializeAttributes:(XWriter *)writer
{
    [writer writeAttribute:c_attribute_name value:self.name];
}

- (void)serialize:(XWriter *)writer
{
    [writer writeText:self.typeID];
}

- (void)deserializeAttributes:(XReader *)reader
{
    self.name = [reader readAttribute:c_attribute_name];
}

- (void)deserialize:(XReader *)reader
{
    self.typeID = [reader readValue];
    reader.context = self;
}

@end

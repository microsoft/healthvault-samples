//
// MHVPersonalContactInfo.m
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
#import "MHVPersonalContactInfo.h"

static NSString *const c_typeid = @"162dd12d-9859-4a66-b75f-96760d67072b";
static NSString *const c_typename = @"contact";

static NSString *const c_element_contact = @"contact";

@implementation MHVPersonalContactInfo

- (instancetype)initWithContact:(MHVContact *)contact
{
    MHVCHECK_NOTNULL(contact);

    self = [super init];
    if (self)
    {
        _contact = contact;
    }

    return self;
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN

        MHVVALIDATE(self.contact, MHVClientError_InvalidPersonalContactInfo);

    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_contact content:self.contact];
}

- (void)deserialize:(XReader *)reader
{
    self.contact = [reader readElement:c_element_contact asClass:[MHVContact class]];
}

+ (NSString *)typeID
{
    return c_typeid;
}

+ (NSString *)XRootElement
{
    return c_typename;
}

+ (MHVThing *)newThing
{
    return [[MHVThing alloc] initWithType:[MHVPersonalContactInfo typeID]];
}

@end

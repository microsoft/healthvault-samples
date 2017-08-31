//
// MHVPendingThing.m
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
#import "MHVPendingThing.h"
#import "MHVThing.h"

static const xmlChar *x_element_id = XMLSTRINGCONST("thing-id");
static const xmlChar *x_element_type = XMLSTRINGCONST("type-id");
static const xmlChar *x_element_edate = XMLSTRINGCONST("eff-date");

@implementation MHVPendingThing

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN;

    MHVVALIDATE(self.key, MHVClientError_InvalidPendingThing);
    MHVVALIDATE_OPTIONAL(self.type);

    MHVVALIDATE_SUCCESS;
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementXmlName:x_element_id content:self.key];
    [writer writeElementXmlName:x_element_type content:self.type];
    [writer writeElementXmlName:x_element_edate dateValue:self.effectiveDate];
}

- (void)deserialize:(XReader *)reader
{
    self.key = [reader readElementWithXmlName:x_element_id asClass:[MHVThingKey class]];
    self.type = [reader readElementWithXmlName:x_element_type asClass:[MHVThingType class]];
    self.effectiveDate = [reader readDateElementXmlName:x_element_edate];
}

@end

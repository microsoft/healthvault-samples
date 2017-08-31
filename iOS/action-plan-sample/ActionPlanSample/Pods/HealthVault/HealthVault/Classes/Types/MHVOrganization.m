//
// MHVOrganization.m
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
#import "MHVOrganization.h"

static NSString *const c_element_name = @"name";
static NSString *const c_element_contact = @"contact";
static NSString *const c_element_type = @"type";
static NSString *const c_element_site = @"website";

@implementation MHVOrganization

- (NSString *)toString
{
    return self.name;
}

- (NSString *)description
{
    return [self toString];
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN

    MHVVALIDATE_STRING(self.name, MHVClientError_InvalidOrganization);
    MHVVALIDATE_OPTIONAL(self.contact);
    MHVVALIDATE_OPTIONAL(self.type);
    MHVVALIDATE_STRINGOPTIONAL(self.website, MHVClientError_InvalidOrganization);

    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_name value:self.name];
    [writer writeElement:c_element_contact content:self.contact];
    [writer writeElement:c_element_type content:self.type];
    [writer writeElement:c_element_site value:self.website];
}

- (void)deserialize:(XReader *)reader
{
    self.name = [reader readStringElement:c_element_name];
    self.contact = [reader readElement:c_element_contact asClass:[MHVContact class]];
    self.type = [reader readElement:c_element_type asClass:[MHVCodableValue class]];
    self.website = [reader readStringElement:c_element_site];
}

@end

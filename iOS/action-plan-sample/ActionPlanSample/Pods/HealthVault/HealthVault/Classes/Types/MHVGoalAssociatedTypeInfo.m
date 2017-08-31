//
//  MHVGoalAssociatedTypeInfo.m
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

#import "MHVGoalAssociatedTypeInfo.h"

static NSString *const c_element_thing_type_version_id = @"thing-type-version-id";
static NSString *const c_element_thing_type_value_xpath = @"thing-type-value-xpath";
static NSString *const c_element_thing_type_display_xpath = @"thing-type_display-xpath";

@implementation MHVGoalAssociatedTypeInfo

- (void) serialize:(XWriter *)writer
{
    [writer writeElement:c_element_thing_type_version_id value:self.thingTypeVersionId.UUIDString];
    [writer writeElement:c_element_thing_type_value_xpath value:self.thingTypeValueXPath];
    [writer writeElement:c_element_thing_type_display_xpath value:self.thingTypeDisplayXPath];
}

- (void) deserialize:(XReader *)reader
{
    self.thingTypeVersionId = [[NSUUID alloc] initWithUUIDString:[reader readStringElement:c_element_thing_type_version_id]];
    self.thingTypeValueXPath = [reader readElement:c_element_thing_type_value_xpath asClass:[NSString class]];
    self.thingTypeDisplayXPath = [reader readElement:c_element_thing_type_value_xpath asClass:[NSString class]];
}

@end

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

#import "MHVPlan.h"

static NSString *const c_typeid = @"504d6c08-68f9-4e07-8699-5fb55678f13d";
static NSString *const c_typename = @"plan";

static NSString *const c_element_name = @"name";
static NSString *const c_element_description = @"description";
static NSString *const c_element_status = @"status";
static NSString *const c_element_category = @"category";
static NSString *const c_element_objectives = @"objectives";

@implementation MHVPlan

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_name content:self.name];
    [writer writeElement:c_element_description content:self.descriptionText];
    [writer writeElement:c_element_status value:self.status.stringValue];
    [writer writeElement:c_element_category value:self.category.stringValue];
    [writer writeElement:c_element_objectives content:self.objectives];
}

- (void)deserialize:(XReader *)reader
{
    self.name = [reader readElement:c_element_name asClass:[MHVStringNZNW class]];
    self.descriptionText = [reader readElement:c_element_description asClass:[MHVStringNZNW class]];
    self.status = [[MHVActionPlanInstanceStatusEnum alloc] initWithString:[reader readStringElement:c_element_status]];
    self.category = [[MHVActionPlanCategoryEnum alloc] initWithString:[reader readStringElement:c_element_category]];
    self.objectives = [reader readElement:c_element_objectives asClass:[MHVPlanObjectiveList class]];
}

+ (NSString *)typeID
{
    return c_typeid;
}

+ (NSString *)XRootElement
{
    return c_typename;
}

@end

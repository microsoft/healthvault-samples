//
//  MHVHealthGoal.m
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

#import "MHVHealthGoal.h"

static NSString *const c_typeid = @"dad8bb47-9ad0-4f09-a020-0ff051d1d0f7";
static NSString *const c_typename = @"health-goal";

static NSString *const c_element_name = @"name";
static NSString *const c_element_description = @"description";
static NSString *const c_element_start_date = @"start-date";
static NSString *const c_element_end_date = @"end-date";
static NSString *const c_element_associated_type_info = @"associated-type-info";
static NSString *const c_element_target_range = @"target-range";
static NSString *const c_element_goal_additional_ranges = @"goal-additional-ranges";
static NSString *const c_element_recurrence = @"recurrence";

@implementation MHVHealthGoal

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_name content:self.name];
    [writer writeElement:c_element_description value:self.descriptionText];
    [writer writeElement:c_element_start_date content:self.startDate];
    [writer writeElement:c_element_end_date content:self.endDate];
    [writer writeElement:c_element_associated_type_info content:self.associatedTypeInfo];
    [writer writeElement:c_element_target_range content:self.targetRange];
    [writer writeElementArray:c_element_goal_additional_ranges elements:self.goalAdditionalRanges];
    [writer writeElement:c_element_recurrence content:self.recurrence];
}

- (void)deserialize:(XReader *)reader
{
    self.name = [reader readElement:c_element_name asClass:[MHVCodableValue class]];
    self.descriptionText = [reader readStringElement:c_element_description];
    self.startDate = [reader readElement:c_element_start_date asClass:[MHVApproxDateTime class]];
    self.endDate = [reader readElement:c_element_end_date asClass:[MHVApproxDateTime class]];
    self.associatedTypeInfo = [reader readElement:c_element_associated_type_info asClass:[MHVGoalAssociatedTypeInfo class]];
    self.targetRange = [reader readElement:c_element_target_range asClass:[MHVGoalRangeType class]];
    self.goalAdditionalRanges = [reader readElementArray:c_element_goal_additional_ranges asClass:[MHVGoalRangeType class] andArrayClass:[NSMutableArray class]];
    self.recurrence = [reader readElement:c_element_recurrence asClass:[MHVGoalRecurrence class]];
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

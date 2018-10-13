//
//  MHVPlanObjective.m
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

#import "MHVPlanObjective.h"

static NSString *const c_element_id = @"id";
static NSString *const c_element_name = @"name";
static NSString *const c_element_description = @"description";
static NSString *const c_element_state = @"state";
static NSString *const c_element_outcomes = @"outcomes";

@implementation MHVPlanObjective

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_id value:self.identifier.UUIDString];
    [writer writeElement:c_element_name content:self.name];
    [writer writeElement:c_element_description content:self.descriptionText];
    [writer writeElement:c_element_state value:self.state.stringValue];
    [writer writeElement:c_element_outcomes content:self.outcomes];
}

- (void)deserialize:(XReader *)reader
{
    self.identifier = [[NSUUID alloc] initWithUUIDString:[reader readStringElement:c_element_id]];
    self.name = [reader readElement:c_element_name asClass:[MHVStringNZNW class]];
    self.descriptionText = [reader readElement:c_element_description asClass:[MHVStringNZNW class]];
    self.state = [[MHVObjectiveStateEnum alloc] initWithString:[reader readStringElement:c_element_state]];
    self.outcomes = [reader readElement:c_element_outcomes asClass:[MHVPlanOutcomeList class]];
}

@end

static NSString *const c_element_objective = @"objective";

@implementation MHVPlanObjectiveList

- (void)serialize:(XWriter *)writer
{
    [writer writeElementArray:c_element_objective elements:self.objective];
}

- (void)deserialize:(XReader *)reader
{
    self.objective = [reader readElementArray:c_element_objective asClass:[MHVPlanObjective class] andArrayClass:[NSMutableArray class]];
}

@end

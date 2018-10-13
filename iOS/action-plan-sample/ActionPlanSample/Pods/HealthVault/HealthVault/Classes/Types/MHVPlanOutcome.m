//
//  MHVPlanOutcome.m
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

#import "MHVPlanOutcome.h"

static NSString *const c_element_name = @"name";
static NSString *const c_element_type = @"type";

@implementation MHVPlanOutcome

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_name content:self.name];
    [writer writeElement:c_element_type value:self.type.stringValue];
}

- (void)deserialize:(XReader *)reader
{
    self.name = [reader readElement:c_element_name asClass:[MHVStringNZNW class]];
    self.type = [[MHVObjectiveOutcomeTypeEnum alloc] initWithString:[reader readStringElement:c_element_type]];
}

@end

static NSString *const c_element_outcome = @"outcome";

@implementation MHVPlanOutcomeList

- (void)serialize:(XWriter *)writer
{
    [writer writeElementArray:c_element_outcome elements:self.outcome];
}

- (void)deserialize:(XReader *)reader
{
    self.outcome = [reader readElementArray:c_element_outcome asClass:[MHVPlanOutcome class] andArrayClass:[NSMutableArray class]];
}

@end

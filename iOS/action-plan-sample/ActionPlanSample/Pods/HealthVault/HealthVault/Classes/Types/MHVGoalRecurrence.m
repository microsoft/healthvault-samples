//
//  MHVGoalRecurrence.m
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

#import "MHVGoalRecurrence.h"

static NSString *const c_element_interval = @"interval";
static NSString *const c_element_times_in_interval = @"times-in-interval";

@implementation MHVGoalRecurrence

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_interval content:self.interval];
    [writer writeElement:c_element_times_in_interval content:self.timesInInterval];
}

- (void) deserialize:(XReader *)reader
{
    self.interval = [reader readElement:c_element_interval asClass:[MHVCodableValue class]];
    self.timesInInterval = [reader readElement:c_element_times_in_interval asClass:[MHVPositiveInt class]];
}
@end

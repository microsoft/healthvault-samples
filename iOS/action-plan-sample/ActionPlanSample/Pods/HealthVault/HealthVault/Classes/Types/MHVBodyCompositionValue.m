//
//  MHVBodyCompositionValue.m
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

#import "MHVBodyCompositionValue.h"

static NSString *const c_element_mass_value = @"mass-value";
static NSString *const c_element_percent_value = @"percent-value";

@implementation MHVBodyCompositionValue

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_mass_value content:self.massValue];
    [writer writeElement:c_element_percent_value content:self.percentValue];
}

- (void)deserialize:(XReader *)reader
{
    self.massValue = [reader readElement:c_element_mass_value asClass:[MHVWeightMeasurement class]];
    self.percentValue = [reader readElement:c_element_percent_value asClass:[MHVPercentage class]];
}

@end

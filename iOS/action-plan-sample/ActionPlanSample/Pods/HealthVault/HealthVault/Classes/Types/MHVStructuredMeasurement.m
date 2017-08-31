//
//  MHVStructuredMeasurement.m
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


#import "MHVStructuredMeasurement.h"

static NSString *const c_element_value = @"value";
static NSString *const c_element_units = @"units";

@implementation MHVStructuredMeasurement

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_value content:self.value];
    [writer writeElement:c_element_units content:self.units];
}

- (void)deserialize:(XReader *)reader
{
    self.value = [reader readElement:c_element_value asClass:[MHVDouble class]];
    self.units = [reader readElement:c_element_units asClass:[MHVCodableValue class]];
}

@end

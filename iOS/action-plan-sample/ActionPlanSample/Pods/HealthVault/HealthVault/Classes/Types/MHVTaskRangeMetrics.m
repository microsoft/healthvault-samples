//
//  MHVTaskRangeMetrics.m
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

#import "MHVTaskRangeMetrics.h"

static NSString *const c_element_property_xpath = @"property-xpath";
static NSString *const c_element_min_target = @"min-target";
static NSString *const c_element_max_target = @"max-target";

@implementation MHVTaskRangeMetrics

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_property_xpath content:self.propertyXPath];
    [writer writeElement:c_element_min_target content:self.minTarget];
    [writer writeElement:c_element_max_target content:self.maxTarget];
}

- (void)deserialize:(XReader *)reader
{
    self.propertyXPath = [reader readElement:c_element_property_xpath asClass:[MHVStringNZNW class]];
    self.minTarget = [reader readElement:c_element_min_target asClass:[MHVDouble class]];
    self.maxTarget = [reader readElement:c_element_max_target asClass:[MHVDouble class]];
}

@end

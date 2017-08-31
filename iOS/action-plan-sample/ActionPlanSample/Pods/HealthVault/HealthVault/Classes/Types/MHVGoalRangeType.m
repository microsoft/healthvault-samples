//
//  MHVGoalRangeType.m
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

#import "MHVGoalRangeType.h"

static NSString *const c_element_name = @"name";
static NSString *const c_element_description = @"description";
static NSString *const c_element_minimum = @"minimum";
static NSString *const c_element_maximum = @"maximum";

@implementation MHVGoalRangeType

- (void) serialize:(XWriter *)writer
{
    [writer writeElement:c_element_name content:self.name];
    [writer writeElement:c_element_description value:self.descriptionText];
    [writer writeElement:c_element_minimum content:self.minimum];
    [writer writeElement:c_element_maximum content:self.maximum];
}

- (void) deserialize:(XReader *)reader
{
    self.name = [reader readElement:c_element_name asClass:[MHVCodableValue class]];
    self.descriptionText = [reader readStringElement:c_element_description];
    self.minimum = [reader readElement:c_element_minimum asClass:[MHVGeneralMeasurement class]];
    self.maximum = [reader readElement:c_element_maximum asClass:[MHVGeneralMeasurement class]];
}
@end


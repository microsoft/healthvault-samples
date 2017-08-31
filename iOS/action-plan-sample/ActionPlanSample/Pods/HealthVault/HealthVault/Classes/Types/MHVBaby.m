//
//  MHVDelivery.h
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

#import "MHVBaby.h"

static NSString *const c_element_name = @"name";
static NSString *const c_element_gender = @"gender";
static NSString *const c_element_weight = @"weight";
static NSString *const c_element_length = @"length";
static NSString *const c_element_head_circumference = @"head-circumference";
static NSString *const c_element_note = @"note";

@implementation MHVBaby

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_name content:self.name];
    [writer writeElement:c_element_gender content:self.gender];
    [writer writeElement:c_element_weight content:self.weight];
    [writer writeElement:c_element_length content:self.length];
    [writer writeElement:c_element_head_circumference content:self.headCircumference];
    [writer writeElement:c_element_note value:self.note];
}

- (void)deserialize:(XReader *)reader
{
    self.name = [reader readElement:c_element_name asClass:[MHVName class]];
    self.gender = [reader readElement:c_element_gender asClass:[MHVCodableValue class]];
    self.weight = [reader readElement:c_element_weight asClass:[MHVWeightMeasurement class]];
    self.length = [reader readElement:c_element_length asClass:[MHVLengthMeasurement class]];
    self.headCircumference = [reader readElement:c_element_head_circumference asClass:[MHVLengthMeasurement class]];
    self.note = [reader readStringElement:c_element_note];
}

@end

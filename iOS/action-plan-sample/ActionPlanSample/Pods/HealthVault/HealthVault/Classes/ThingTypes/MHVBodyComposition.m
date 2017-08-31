//
//  MHVBodyComposition.m
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

#import "MHVBodyComposition.h"

static NSString *const c_typeid = @"18adc276-5144-4e7e-bf6c-e56d8250adf8";
static NSString *const c_typename = @"body-composition";

static NSString *const c_element_when = @"when";
static NSString *const c_element_measurement_name = @"measurement-name";
static NSString *const c_element_value = @"value";
static NSString *const c_element_measurement_method = @"measurement-method";
static NSString *const c_element_site = @"site";

@implementation MHVBodyComposition

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_when content:self.when];
    [writer writeElement:c_element_measurement_name content:self.measurementName];
    [writer writeElement:c_element_value content:self.value];
    [writer writeElement:c_element_measurement_method content:self.measurementMethod];
    [writer writeElement:c_element_site content:self.site];
}

- (void)deserialize:(XReader *)reader
{
    self.when = [reader readElement:c_element_when asClass:[MHVApproxDateTime class]];
    self.measurementName = [reader readElement:c_element_measurement_name asClass:[MHVCodableValue class]];
    self.value = [reader readElement:c_element_value asClass:[MHVBodyCompositionValue class]];
    self.measurementMethod = [reader readElement:c_element_measurement_method asClass:[MHVCodableValue class]];
    self.site = [reader readElement:c_element_site asClass:[MHVCodableValue class]];
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

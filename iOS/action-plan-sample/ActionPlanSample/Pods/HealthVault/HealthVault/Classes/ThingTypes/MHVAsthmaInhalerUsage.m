//
//  MHVAsthmaInhalerUsage.m
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

#import "MHVAsthmaInhalerUsage.h"

static NSString *const c_typeid = @"03efe378-976a-42f8-ae1e-507c497a8c6d";
static NSString *const c_typename = @"asthma-inhaler-use";

static NSString *const c_element_when = @"when";
static NSString *const c_element_drug = @"drug";
static NSString *const c_element_strength = @"strength";
static NSString *const c_element_dose_count = @"dose-count";
static NSString *const c_element_device_id = @"device-id";
static NSString *const c_element_dose_purpose = @"dose-purpose";

@implementation MHVAsthmaInhalerUsage

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_when content:self.when];
    [writer writeElement:c_element_drug content:self.drug];
    [writer writeElement:c_element_strength content:self.strength];
    [writer writeElement:c_element_dose_count intValue:self.doseCount];
    [writer writeElement:c_element_device_id value:self.deviceId];
    [writer writeElement:c_element_dose_purpose content:self.dosePurpose];
}

-(void)deserialize:(XReader *)reader
{
    self.when = [reader readElement:c_element_when asClass:[MHVDateTime class]];
    self.drug = [reader readElement:c_element_drug asClass:[MHVCodableValue class]];
    self.strength = [reader readElement:c_element_strength asClass:[MHVCodableValue class]];
    self.doseCount = [reader readIntElement:c_element_dose_count];
    self.deviceId = [reader readStringElement:c_element_device_id];
    self.dosePurpose = [reader readElement:c_element_dose_purpose asClass:[MHVCodableValue class]];
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

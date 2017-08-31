//
//  MHVAsthmaInhaler.m
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

#import "MHVAsthmaInhaler.h"

static NSString *const c_typeid = @"ff9ce191-2096-47d8-9300-5469a9883746";
static NSString *const c_typename = @"asthma-inhaler";

static NSString *const c_element_drug = @"drug";
static NSString *const c_element_strength = @"strength";
static NSString *const c_element_purpose = @"purpose";
static NSString *const c_element_start_date = @"start-date";
static NSString *const c_element_stop_date = @"stop-date";
static NSString *const c_element_expiration_date = @"expiration-date";
static NSString *const c_element_device_id = @"device-id";
static NSString *const c_element_initial_dose = @"initial-doses";
static NSString *const c_element_min_daily_dose = @"min-daily-doses";
static NSString *const c_element_max_daily_dose = @"max-daily-doses";
static NSString *const c_element_can_alert = @"can-alert";
static NSString *const c_element_alert = @"alert";

@implementation MHVAsthmaInhaler

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_drug content:self.drug];
    [writer writeElement:c_element_strength content:self.strength];
    [writer writeElement:c_element_purpose value:self.purpose];
    [writer writeElement:c_element_start_date content:self.startDate];
    [writer writeElement:c_element_stop_date content:self.stopDate];
    [writer writeElement:c_element_expiration_date content:self.expirationDate];
    [writer writeElement:c_element_device_id value:self.deviceId];
    [writer writeElement:c_element_initial_dose intValue:self.initialDose];
    [writer writeElement:c_element_min_daily_dose intValue:self.minDailyDoses];
    [writer writeElement:c_element_max_daily_dose intValue:self.maxDailyDoses];
    [writer writeElement:c_element_can_alert content:self.canAlert];
    [writer writeElementArray:c_element_alert elements:self.alert];
}

-(void)deserialize:(XReader *)reader
{
    self.drug = [reader readElement:c_element_drug asClass:[MHVCodableValue class]];
    self.strength = [reader readElement:c_element_strength asClass:[MHVCodableValue class]];
    self.purpose = [reader readStringElement:c_element_purpose];
    self.startDate = [reader readElement:c_element_start_date asClass:[MHVApproxDateTime class]];
    self.stopDate = [reader readElement:c_element_stop_date asClass:[MHVApproxDateTime class]];
    self.expirationDate = [reader readElement:c_element_expiration_date asClass:[MHVApproxDateTime class]];
    self.deviceId = [reader readStringElement:c_element_device_id];
    self.initialDose = [reader readIntElement:c_element_initial_dose];
    self.minDailyDoses = [reader readIntElement:c_element_min_daily_dose];
    self.maxDailyDoses = [reader readIntElement:c_element_max_daily_dose];
    self.canAlert = [reader readElement:c_element_can_alert asClass:[MHVBool class]];
    self.alert = [reader readElementArray:c_element_alert
                                  asClass:[MHVAlert class]
                            andArrayClass:[NSMutableArray class]];
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

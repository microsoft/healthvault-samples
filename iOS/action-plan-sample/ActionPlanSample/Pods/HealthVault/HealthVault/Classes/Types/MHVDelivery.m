//
//  MHVDelivery.m
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

#import "MHVDelivery.h"

static NSString *const c_element_location = @"location";
static NSString *const c_element_time_of_delivery = @"time-of-delivery";
static NSString *const c_element_labor_duration = @"labor-duration";
static NSString *const c_element_complications = @"complications";
static NSString *const c_element_anesthesia = @"anesthesia";
static NSString *const c_element_delivery_method = @"delivery-method";
static NSString *const c_element_outcome = @"outcome";
static NSString *const c_element_baby = @"baby";
static NSString *const c_element_note = @"note";

@implementation MHVDelivery

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_location content:self.location];
    [writer writeElement:c_element_time_of_delivery content:self.timeOfDelivery];
    [writer writeElement:c_element_labor_duration content:self.laborDuration];
    [writer writeElementArray:c_element_complications elements:self.complications];
    [writer writeElementArray:c_element_anesthesia elements:self.anesthesia];
    [writer writeElement:c_element_delivery_method content:self.deliveryMethod];
    [writer writeElement:c_element_outcome content:self.outcome];
    [writer writeElement:c_element_baby content:self.baby];
    [writer writeElement:c_element_note value:self.note];
}

- (void)deserialize:(XReader *)reader
{
    self.location = [reader readElement:c_element_location asClass:[MHVOrganization class]];
    self.timeOfDelivery = [reader readElement:c_element_time_of_delivery asClass:[MHVApproxDateTime class]];
    self.laborDuration = [reader readElement:c_element_labor_duration asClass:[MHVPositiveDouble class]];
    self.complications = [reader readElementArray:c_element_complications asClass:[MHVCodableValue class] andArrayClass:[NSMutableArray class]];
    self.anesthesia = [reader readElementArray:c_element_anesthesia asClass:[MHVCodableValue class] andArrayClass:[NSMutableArray class]];
    self.deliveryMethod = [reader readElement:c_element_delivery_method asClass:[MHVCodableValue class]];
    self.outcome = [reader readElement:c_element_outcome asClass:[MHVCodableValue class]];
    self.baby = [reader readElement:c_element_baby asClass:[MHVBaby class]];
    self.note = [reader readStringElement:c_element_note];
}

@end


//
//  MHVPregnancy.m
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

#import "MHVPregnancy.h"

static NSString *const c_typeid = @"46d485cf-2b84-429d-9159-83152ba801f4";
static NSString *const c_typename = @"pregnancy";

static NSString *const c_element_due_date = @"due-date";
static NSString *const c_element_last_menstrual_peroid = @"last-menstrual-period";
static NSString *const c_element_conception_method = @"conception-method";
static NSString *const c_element_fetus_count = @"fetus-count";
static NSString *const c_element_gestational_age = @"gestational-age";
static NSString *const c_element_delivery = @"delivery";

@implementation MHVPregnancy

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_due_date content:self.dueDate];
    [writer writeElement:c_element_last_menstrual_peroid content:self.lastMenstrualPeriod];
    [writer writeElement:c_element_conception_method content:self.conceptionMethod];
    [writer writeElement:c_element_fetus_count content:self.feteusCount];
    [writer writeElement:c_element_gestational_age content:self.gestationalAge];
    [writer writeElementArray:c_element_delivery elements:self.delivery];
}

- (void)deserialize:(XReader *)reader
{
    self.dueDate = [reader readElement:c_element_due_date asClass:[MHVApproxDate class]];
    self.lastMenstrualPeriod = [reader readElement:c_element_last_menstrual_peroid asClass:[MHVDate class]];
    self.conceptionMethod = [reader readElement:c_element_conception_method asClass:[MHVCodableValue class]];
    self.feteusCount = [reader readElement:c_element_fetus_count asClass:[MHVNonNegativeInt class]];
    self.gestationalAge = [reader readElement:c_element_gestational_age asClass:[MHVPositiveInt class]];
    self.delivery = [reader readElementArray:c_element_delivery asClass:[MHVDelivery class] andArrayClass:[NSMutableArray class]];
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

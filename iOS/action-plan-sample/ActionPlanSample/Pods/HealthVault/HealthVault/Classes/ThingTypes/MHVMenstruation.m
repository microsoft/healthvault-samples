//
//  MHVMenstruation.m
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

#import "MHVMenstruation.h"

static NSString *const c_typeid = @"caff3ff3-812f-44b1-9c9f-c1af13167705";
static NSString *const c_typename = @"menstruation";

static NSString *const c_element_when = @"when";
static NSString *const c_element_is_new_cycle = @"is-new-cycle";
static NSString *const c_element_amount = @"amount";

@implementation MHVMenstruation

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_when content:self.when];
    [writer writeElement:c_element_is_new_cycle content:self.isNewCycle];
    [writer writeElement:c_element_amount content:self.amount];
}

- (void)deserialize:(XReader *)reader
{
    self.when = [reader readElement:c_element_when asClass:[MHVDateTime class]];
    self.isNewCycle = [reader readElement:c_element_is_new_cycle asClass:[MHVBool class]];
    self.amount = [reader readElement:c_element_amount asClass:[MHVCodableValue class]];
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

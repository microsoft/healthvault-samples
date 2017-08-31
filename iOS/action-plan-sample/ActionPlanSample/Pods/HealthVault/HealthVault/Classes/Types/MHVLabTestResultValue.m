//
// MHVLabTestResultValue.m
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
//
//
#import "MHVValidator.h"
#import "MHVLabTestResultValue.h"
#import "NSArray+Utils.h"

static const xmlChar *x_element_measurement = XMLSTRINGCONST("measurement");
static NSString *const c_element_ranges = @"ranges";
static const xmlChar *x_element_ranges = XMLSTRINGCONST("ranges");
static const xmlChar *x_element_flag = XMLSTRINGCONST("flag");

@implementation MHVLabTestResultValue

- (BOOL)hasRanges
{
    return ![NSArray isNilOrEmpty:self.ranges];
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN;

    MHVVALIDATE(self.measurement, MHVClientError_InvalidLabTestResultValue);
    MHVVALIDATE_ARRAYOPTIONAL(self.ranges, MHVClientError_InvalidLabTestResultValue);
    MHVVALIDATE_OPTIONAL(self.flag);

    MHVVALIDATE_SUCCESS;
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementXmlName:x_element_measurement content:self.measurement];
    [writer writeElementArray:c_element_ranges elements:self.ranges];
    [writer writeElementXmlName:x_element_flag content:self.flag];
}

- (void)deserialize:(XReader *)reader
{
    self.measurement = [reader readElementWithXmlName:x_element_measurement asClass:[MHVApproxMeasurement class]];
    self.ranges = [reader readElementArrayWithXmlName:x_element_ranges
                                              asClass:[MHVTestResultRange class]
                                        andArrayClass:[NSMutableArray class]];
    self.flag = [reader readElementWithXmlName:x_element_flag asClass:[MHVCodableValue class]];
}

@end

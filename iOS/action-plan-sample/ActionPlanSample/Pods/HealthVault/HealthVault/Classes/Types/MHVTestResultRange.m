//
// MHVTestResultRange.m
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
#import "MHVTestResultRange.h"

static const xmlChar *x_element_type = XMLSTRINGCONST("type");
static const xmlChar *x_element_text = XMLSTRINGCONST("text");
static const xmlChar *x_element_value = XMLSTRINGCONST("value");

@implementation MHVTestResultRange

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN;

    MHVVALIDATE(self.type, MHVClientError_InvalidTestResultRange);
    MHVVALIDATE(self.text, MHVClientError_InvalidTestResultRange);
    MHVVALIDATE_OPTIONAL(self.value);

    MHVVALIDATE_SUCCESS;
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementXmlName:x_element_type content:self.type];
    [writer writeElementXmlName:x_element_text content:self.text];
    [writer writeElementXmlName:x_element_value content:self.value];
}

- (void)deserialize:(XReader *)reader
{
    self.type = [reader readElementWithXmlName:x_element_type asClass:[MHVCodableValue class]];
    self.text = [reader readElementWithXmlName:x_element_text asClass:[MHVCodableValue class]];
    self.value = [reader readElementWithXmlName:x_element_value asClass:[MHVTestResultRangeValue class]];
}

@end


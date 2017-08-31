//
// MHVLabTestResultsDetails.m
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
#import "MHVValidator.h"
#import "MHVLabTestResultsDetails.h"

static const xmlChar *x_element_when = XMLSTRINGCONST("when");
static const xmlChar *x_element_name = XMLSTRINGCONST("name");
static const xmlChar *x_element_substance = XMLSTRINGCONST("substance");
static const xmlChar *x_element_method = XMLSTRINGCONST("collection-method");
static const xmlChar *x_element_clinicalCode = XMLSTRINGCONST("clinical-code");
static const xmlChar *x_element_value = XMLSTRINGCONST("value");
static const xmlChar *x_element_status = XMLSTRINGCONST("status");
static const xmlChar *x_element_note = XMLSTRINGCONST("note");

@implementation MHVLabTestResultsDetails

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN;

    MHVVALIDATE_OPTIONAL(self.when);
    MHVVALIDATE_OPTIONAL(self.substance);
    MHVVALIDATE_OPTIONAL(self.collectionMethod);
    MHVVALIDATE_OPTIONAL(self.clinicalCode);
    MHVVALIDATE_OPTIONAL(self.value);
    MHVVALIDATE_OPTIONAL(self.status);

    MHVVALIDATE_SUCCESS;
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementXmlName:x_element_when content:self.when];
    [writer writeElementXmlName:x_element_name value:self.name];
    [writer writeElementXmlName:x_element_substance content:self.substance];
    [writer writeElementXmlName:x_element_method content:self.collectionMethod];
    [writer writeElementXmlName:x_element_clinicalCode content:self.clinicalCode];
    [writer writeElementXmlName:x_element_value content:self.value];
    [writer writeElementXmlName:x_element_status content:self.status];
    [writer writeElementXmlName:x_element_note value:self.note];
}

- (void)deserialize:(XReader *)reader
{
    self.when = [reader readElementWithXmlName:x_element_when asClass:[MHVApproxDateTime class]];
    self.name = [reader readStringElementWithXmlName:x_element_name];
    self.substance = [reader readElementWithXmlName:x_element_substance asClass:[MHVCodableValue class]];
    self.collectionMethod = [reader readElementWithXmlName:x_element_method asClass:[MHVCodableValue class]];
    self.clinicalCode = [reader readElementWithXmlName:x_element_clinicalCode asClass:[MHVCodableValue class]];
    self.value = [reader readElementWithXmlName:x_element_value asClass:[MHVLabTestResultValue class]];
    self.status = [reader readElementWithXmlName:x_element_status asClass:[MHVCodableValue class]];
    self.note = [reader readStringElementWithXmlName:x_element_note];
}

@end


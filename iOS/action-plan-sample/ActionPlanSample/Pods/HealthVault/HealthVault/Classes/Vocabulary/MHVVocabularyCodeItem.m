//
// MHVVocabularyCodeItem.m
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

#import "MHVValidator.h"
#import "MHVVocabularyCodeItem.h"

static const xmlChar *x_element_code = XMLSTRINGCONST("code-value");
static const xmlChar *x_element_displaytext = XMLSTRINGCONST("display-text");
static const xmlChar *x_element_abbrv = XMLSTRINGCONST("abbreviation-text");
static NSString *const c_element_data = @"info-xml";

@implementation MHVVocabularyCodeItem

- (NSString *)toString
{
    return self.displayText;
}

- (NSString *)description
{
    return [self toString];
}

- (BOOL)matchesDisplayText:(NSString *)text
{
    return [self.displayText caseInsensitiveCompare:[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] == NSOrderedSame;
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN;

    MHVVALIDATE_STRING(self.codeValue, MHVClientError_InvalidVocabIdentifier);

    MHVVALIDATE_SUCCESS;
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementXmlName:x_element_code value:self.codeValue];
    [writer writeElementXmlName:x_element_displaytext value:self.displayText];
    [writer writeElementXmlName:x_element_abbrv value:self.abbreviationText];
    [writer writeRaw:self.infoXml];
}

- (void)deserialize:(XReader *)reader
{
    self.codeValue = [reader readStringElementWithXmlName:x_element_code];
    self.displayText = [reader readStringElementWithXmlName:x_element_displaytext];
    self.abbreviationText = [reader readStringElementWithXmlName:x_element_abbrv];
    self.infoXml = [reader readElementRaw:c_element_data];
}

@end


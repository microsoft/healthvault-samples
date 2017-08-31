//
// MHVCodedValue.m
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

#import "MHVCodedValue.h"
#import "MHVValidator.h"

static const xmlChar *x_element_value = XMLSTRINGCONST("value");
static const xmlChar *x_element_family = XMLSTRINGCONST("family");
static const xmlChar *x_element_type = XMLSTRINGCONST("type");
static const xmlChar *x_element_version = XMLSTRINGCONST("version");

@implementation MHVCodedValue

- (instancetype)initWithCode:(NSString *)code andVocab:(NSString *)vocab
{
    return [self initWithCode:code vocab:vocab vocabFamily:nil vocabVersion:nil];
}

- (instancetype)initWithCode:(NSString *)code vocab:(NSString *)vocab vocabFamily:(NSString *)family vocabVersion:(NSString *)version
{
    MHVCHECK_STRING(code);
    MHVCHECK_STRING(vocab);
    
    self = [super init];
    if (self)
    {
        _code = code;
        _vocabularyName = vocab;
        
        if (family)
        {
            _vocabularyFamily = family;
        }
        
        if (version)
        {
            _vocabularyVersion = version;
        }
    }
    return self;
}

+ (MHVCodedValue *)fromCode:(NSString *)code andVocab:(NSString *)vocab
{
    return [[MHVCodedValue alloc] initWithCode:code andVocab:vocab];
}

+ (MHVCodedValue *)fromCode:(NSString *)code vocab:(NSString *)vocab vocabFamily:(NSString *)family vocabVersion:(NSString *)version
{
    return [[MHVCodedValue alloc] initWithCode:code vocab:vocab vocabFamily:family vocabVersion:version];
}

- (BOOL)isEqualToCodedValue:(MHVCodedValue *)value
{
    if (value == nil)
    {
        return FALSE;
    }
    
    return (((self.vocabularyName == nil && value.vocabularyName == nil) || [self.vocabularyName isEqualToString:value.vocabularyName]) &&
            ((self.code == nil && value.code == nil) || [self.code isEqualToString:value.code]) &&
            ((self.vocabularyFamily == nil && value.vocabularyFamily == nil) || [self.vocabularyFamily isEqualToString:value.vocabularyFamily]) &&
            ((self.vocabularyVersion == nil && value.vocabularyVersion == nil) || [self.vocabularyVersion isEqualToString:value.vocabularyVersion]));
}

- (BOOL)isEqualToCode:(NSString *)code fromVocab:(NSString *)vocabName
{
    return [self.code isEqualToString:code] && [self.vocabularyName isEqualToString:vocabName];
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[MHVCodedValue class]])
    {
        return FALSE;
    }

    return [self isEqualToCodedValue:(MHVCodedValue *)object];
}

- (MHVCodedValue *)clone
{
    MHVCodedValue *cloned = [[MHVCodedValue alloc] init];

    MHVCHECK_NOTNULL(cloned);

    cloned.code = self.code;
    cloned.vocabularyName = self.vocabularyName;
    cloned.vocabularyFamily = self.vocabularyFamily;
    cloned.vocabularyVersion = self.vocabularyVersion;

    return cloned;
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN;

    MHVVALIDATE_STRING(self.code, MHVClientError_InvalidCodedValue);
    MHVVALIDATE_STRING(self.vocabularyName, MHVClientError_InvalidCodedValue);
    MHVVALIDATE_STRINGOPTIONAL(self.vocabularyFamily, MHVClientError_InvalidCodedValue);
    MHVVALIDATE_STRINGOPTIONAL(self.vocabularyVersion, MHVClientError_InvalidCodedValue);

    MHVVALIDATE_SUCCESS;
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementXmlName:x_element_value value:self.code];
    [writer writeElementXmlName:x_element_family value:self.vocabularyFamily];
    [writer writeElementXmlName:x_element_type value:self.vocabularyName];
    [writer writeElementXmlName:x_element_version value:self.vocabularyVersion];
}

- (void)deserialize:(XReader *)reader
{
    self.code = [reader readStringElementWithXmlName:x_element_value];
    self.vocabularyFamily = [reader readStringElementWithXmlName:x_element_family];
    self.vocabularyName = [reader readStringElementWithXmlName:x_element_type];
    self.vocabularyVersion = [reader readStringElementWithXmlName:x_element_version];
}

@end


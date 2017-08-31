//
// MHVName.m
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
#import "MHVName.h"

static NSString *const c_element_fullName = @"full";
static NSString *const c_element_title = @"title";
static NSString *const c_element_first = @"first";
static NSString *const c_element_middle = @"middle";
static NSString *const c_element_last = @"last";
static NSString *const c_element_suffix = @"suffix";

@implementation MHVName

- (instancetype)initWithFirst:(NSString *)first andLastName:(NSString *)last
{
    return [self initWithFirst:first middle:nil andLastName:last];
}

- (instancetype)initWithFirst:(NSString *)first middle:(NSString *)middle andLastName:(NSString *)last
{
    MHVCHECK_NOTNULL(first);
    MHVCHECK_NOTNULL(last);

    self = [super init];
    if (self)
    {
        _first = first;
        _middle = middle;
        _last = last;

        [self buildFullName];
        MHVCHECK_NOTNULL(_fullName);
    }

    return self;
}

- (instancetype)initWithFullName:(NSString *)name
{
    MHVCHECK_STRING(name);

    self = [super init];
    if (self)
    {
        _fullName = name;
    }

    return self;
}

- (NSString *)fullName
{
    if (!_fullName)
    {
        [self buildFullName];
    }
    return _fullName;
}

- (BOOL)buildFullName
{
    NSMutableString *fullName = [[NSMutableString alloc] init];

    MHVCHECK_NOTNULL(fullName);

    if (self.title)
    {
        [self appendString:self.title.text toString:fullName];
    }

    [self appendString:self.first toString:fullName];
    
    if (!self.middle || [self.middle isEqualToString:@""])
    {
        NSString *middleInitial = [[self.middle substringWithRange:[self.middle rangeOfComposedCharacterSequenceAtIndex:0]] uppercaseString];
        [self appendString:middleInitial toString:fullName];
    }

    [self appendString:self.last toString:fullName];
    
    if (self.suffix)
    {
        [self appendString:self.suffix.text toString:fullName];
    }

    self.fullName = fullName;

    return TRUE;
}

- (void)appendString:(NSString *)string toString:(NSMutableString *)toString
{
    if (string && ![string isEqualToString:@""])
    {
        if (toString.length > 0)
        {
            [toString appendString:@" "];
        }
        
        [toString appendString:string];
    }
}

- (NSString *)description
{
    return [self toString];
}

- (NSString *)toString
{
    return (self.fullName) ? self.fullName : @"";
}

+ (MHVVocabularyIdentifier *)vocabForTitle
{
    return [[MHVVocabularyIdentifier alloc] initWithFamily:c_hvFamily andName:@"name-prefixes"];
}

+ (MHVVocabularyIdentifier *)vocabForSuffix
{
    return [[MHVVocabularyIdentifier alloc] initWithFamily:c_hvFamily andName:@"name-suffixes"];
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN

    MHVVALIDATE_STRING(self.fullName, MHVClientError_InvalidName);

    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_fullName value:self.fullName];
    [writer writeElement:c_element_title content:self.title];
    [writer writeElement:c_element_first value:self.first];
    [writer writeElement:c_element_middle value:self.middle];
    [writer writeElement:c_element_last value:self.last];
    [writer writeElement:c_element_suffix content:self.suffix];
}

- (void)deserialize:(XReader *)reader
{
    self.fullName = [reader readStringElement:c_element_fullName];
    self.title = [reader readElement:c_element_title asClass:[MHVCodableValue class]];
    self.first = [reader readStringElement:c_element_first];
    self.middle = [reader readStringElement:c_element_middle];
    self.last = [reader readStringElement:c_element_last];
    self.suffix = [reader readElement:c_element_suffix asClass:[MHVCodableValue class]];
}

@end

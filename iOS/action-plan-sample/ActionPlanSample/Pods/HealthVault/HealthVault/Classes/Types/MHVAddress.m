//
// MHVAddress.m
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

#import "MHVAddress.h"
#import "MHVValidator.h"
#import "NSArray+Utils.h"
#import "NSArray+MHVThing.h"

static NSString *const c_element_description = @"description";
static NSString *const c_element_isPrimary = @"is-primary";
static NSString *const c_element_street = @"street";
static NSString *const c_element_city = @"city";
static NSString *const c_element_state = @"state";
static NSString *const c_element_postalCode = @"postcode";
static NSString *const c_element_country = @"country";
static NSString *const c_element_county = @"county";

@implementation MHVAddress

-(BOOL)hasStreet
{
    return ![NSArray isNilOrEmpty:self.street];
}

- (NSArray<NSString *> *)street
{
    if (!_street)
    {
        _street = [[NSArray alloc] init];
    }
    
    return _street;
}

- (NSString *)toString
{
    NSMutableString *text = [[NSMutableString alloc] init];
    
    [self appendWords:[self.street toString] toString:text];
    
    [self appendStringOnNewLine:self.city toString:text];
    [self appendStringOnNewLine:self.county toString:text];
    
    [self appendStringOnNewLine:self.state toString:text];
    [self appendWords:self.postalCode toString:text];
    [self appendStringOnNewLine:self.country toString:text];
    
    return text;
}

- (void)appendWords:(NSString *)words toString:(NSMutableString *)toString
{
    if (words && ![words isEqualToString:@""])
    {
        if (toString.length > 0)
        {
            [toString appendString:@" "];
        }
        
        [toString appendString:words];
    }
}

- (void)appendStringOnNewLine:(NSString *)string toString:(NSMutableString *)toString
{
    if (string && ![string isEqualToString:@""])
    {
        if (toString.length > 0)
        {
            [toString appendString:@"\r\n"];
        }
        
        [toString appendString:string];
    }
}


- (NSString *)description
{
    return [self toString];
}

+ (MHVVocabularyIdentifier *)vocabForCountries
{
    return [[MHVVocabularyIdentifier alloc] initWithFamily:c_isoFamily andName:@"iso3166"];
}

+ (MHVVocabularyIdentifier *)vocabForUSStates
{
    return [[MHVVocabularyIdentifier alloc] initWithFamily:c_hvFamily andName:@"states"];
}

+ (MHVVocabularyIdentifier *)vocabForCanadianProvinces
{
    return [[MHVVocabularyIdentifier alloc] initWithFamily:c_hvFamily andName:@"provinces"];
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN
    
    MHVVALIDATE_ARRAY(self.street, MHVClientError_InvalidAddress);
    
    MHVVALIDATE_STRING(self.city, MHVClientError_InvalidAddress);
    MHVVALIDATE_STRING(self.postalCode, MHVClientError_InvalidAddress);
    MHVVALIDATE_STRING(self.country, MHVClientError_InvalidAddress);
    
    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_description value:self.type];
    [writer writeElement:c_element_isPrimary content:self.isPrimary];
    [writer writeElementArray:c_element_street elements:self.street];
    [writer writeElement:c_element_city value:self.city];
    [writer writeElement:c_element_state value:self.state];
    [writer writeElement:c_element_postalCode value:self.postalCode];
    [writer writeElement:c_element_country value:self.country];
    [writer writeElement:c_element_county value:self.county];
}

- (void)deserialize:(XReader *)reader
{
    self.type = [reader readStringElement:c_element_description];
    self.isPrimary = [reader readElement:c_element_isPrimary asClass:[MHVBool class]];
    self.street = [reader readStringElementArray:c_element_street];
    self.city = [reader readStringElement:c_element_city];
    self.state = [reader readStringElement:c_element_state];
    self.postalCode = [reader readStringElement:c_element_postalCode];
    self.country = [reader readStringElement:c_element_country];
    self.county = [reader readStringElement:c_element_county];
}

@end


//
// MHVVitalSignResult.m
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
#import "MHVVitalSignResult.h"

static NSString *const c_element_title = @"title";
static NSString *const c_element_value = @"value";
static NSString *const c_element_unit = @"unit";
static NSString *const c_element_refMin = @"reference-minimum";
static NSString *const c_element_refMax = @"reference-maximum";
static NSString *const c_element_textValue = @"text-value";
static NSString *const c_element_flag = @"flag";

@implementation MHVVitalSignResult

- (instancetype)initWithTitle:(MHVCodableValue *)title value:(double)value andUnit:(NSString *)unit
{
    MHVCHECK_NOTNULL(title);

    self = [super init];
    if (self)
    {
        _title = title;

        _value = [[MHVDouble alloc] initWith:value];
        MHVCHECK_NOTNULL(_value);

        if (unit)
        {
            _unit = [[MHVCodableValue alloc] initWithText:unit];
            MHVCHECK_NOTNULL(_unit);
        }
    }

    return self;
}

- (instancetype)initWithTemperature:(double)value inCelsius:(BOOL)celsius
{
    MHVCodableValue *title = [MHVCodableValue fromText:@"Temperature" code:@"Tmp" andVocab:@"vital-statistics"];

    return [self initWithTitle:title value:value andUnit:(celsius) ? @"celsius" : @"fahrenheit"];
}

- (NSString *)description
{
    return [self toString];
}

- (NSString *)toString
{
    return [NSString stringWithFormat:@"%@, %@ %@",
            (self.title) ? [self.title toString] : @"",
            (self.value) ? [self.value toStringWithFormat:@"%.2f"] : @"",
            (self.unit) ? [self.unit toString] : @""];
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN;

    MHVVALIDATE(self.title, MHVClientError_InvalidVitalSignResult);
    MHVVALIDATE_OPTIONAL(self.value);
    MHVVALIDATE_OPTIONAL(self.unit);
    MHVVALIDATE_OPTIONAL(self.referenceMin);
    MHVVALIDATE_OPTIONAL(self.referenceMax);
    MHVVALIDATE_STRINGOPTIONAL(self.textValue, MHVClientError_InvalidVitalSignResult);
    MHVVALIDATE_OPTIONAL(self.flag);

    MHVVALIDATE_SUCCESS;
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_title content:self.title];
    [writer writeElement:c_element_value content:self.value];
    [writer writeElement:c_element_unit content:self.unit];
    [writer writeElement:c_element_refMin content:self.referenceMin];
    [writer writeElement:c_element_refMax content:self.referenceMax];
    [writer writeElement:c_element_textValue value:self.textValue];
    [writer writeElement:c_element_flag content:self.flag];
}

- (void)deserialize:(XReader *)reader
{
    self.title = [reader readElement:c_element_title asClass:[MHVCodableValue class]];
    self.value = [reader readElement:c_element_value asClass:[MHVDouble class]];
    self.unit = [reader readElement:c_element_unit asClass:[MHVCodableValue class]];
    self.referenceMin = [reader readElement:c_element_refMin asClass:[MHVDouble class]];
    self.referenceMax = [reader readElement:c_element_refMax asClass:[MHVDouble class]];
    self.textValue = [reader readStringElement:c_element_textValue];
    self.flag = [reader readElement:c_element_flag asClass:[MHVCodableValue class]];
}

@end

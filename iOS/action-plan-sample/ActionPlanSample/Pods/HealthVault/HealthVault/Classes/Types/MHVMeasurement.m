//
// MHVMeasurement.m
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
#import "MHVMeasurement.h"

static const xmlChar *x_element_value = XMLSTRINGCONST("value");
static const xmlChar *x_element_units = XMLSTRINGCONST("units");

@implementation MHVMeasurement

- (instancetype)initWithValue:(double)value andUnits:(MHVCodableValue *)units
{
    MHVCHECK_NOTNULL(units);

    self = [super init];
    if (self)
    {
        _value = value;
        _units = units;
    }

    return self;
}

- (instancetype)initWithValue:(double)value andUnitsString:(NSString *)units
{
    MHVCodableValue *unitsValue = [[MHVCodableValue alloc] initWithText:units];

    MHVCHECK_NOTNULL(unitsValue);

    return [self initWithValue:value andUnits:unitsValue];
}

+ (MHVMeasurement *)fromValue:(double)value andUnits:(MHVCodableValue *)units
{
    return [[MHVMeasurement alloc] initWithValue:value andUnits:units];
}

+ (MHVMeasurement *)fromValue:(double)value andUnitsString:(NSString *)units
{
    return [[MHVMeasurement alloc] initWithValue:value andUnitsString:units];
}

+ (MHVMeasurement *)fromValue:(double)value unitsDisplayText:(NSString *)unitsText unitsCode:(NSString *)code unitsVocab:(NSString *)vocab
{
    MHVCodableValue *unitCode = [[MHVCodableValue alloc] initWithText:unitsText code:code andVocab:vocab];

    MHVCHECK_NOTNULL(unitCode);

    MHVMeasurement *measurement = [[MHVMeasurement alloc] initWithValue:value andUnits:unitCode];

    return measurement;
}

- (NSString *)description
{
    return [self toString];
}

- (NSString *)toString
{
    if (!self.units)
    {
        return [NSString localizedStringWithFormat:@"%g", self.value];
    }

    return [self toStringWithFormat:@"%g %@"];
}

- (NSString *)toStringWithFormat:(NSString *)format
{
    return [NSString localizedStringWithFormat:format, self.value, self.units.text];
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN

    MHVVALIDATE(self.units, MHVClientError_InvalidMeasurement);

    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementXmlName:x_element_value doubleValue:self.value];
    [writer writeElementXmlName:x_element_units content:self.units];
}

- (void)deserialize:(XReader *)reader
{
    self.value = [reader readDoubleElementXmlName:x_element_value];
    self.units = [reader readElementWithXmlName:x_element_units asClass:[MHVCodableValue class]];
}

@end

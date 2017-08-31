//
// MHVWeightMeasurement.m
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
#import "MHVWeightMeasurement.h"

static double const c_PoundsPerKg = 2.20462262185;
static double const c_KgPerPound = 0.45359237;

static const xmlChar *x_element_kg = XMLSTRINGCONST("kg");
static const xmlChar *x_element_display = XMLSTRINGCONST("display");

@implementation MHVWeightMeasurement

- (double)inKg
{
    return (self.value) ? self.value.value : NAN;
}

- (void)setInKg:(double)valueInKg
{
    if (!self.value)
    {
        self.value = [[MHVPositiveDouble alloc] init];
    }
    
    self.value.value = valueInKg;
    
    [self updateDisplayValue:valueInKg units:@"kilogram" andUnitsCode:@"kg"];
}

- (double)inGrams
{
    return self.inKg * 1000;
}

- (void)setInGrams:(double)grams
{
    if (!self.value)
    {
        self.value = [[MHVPositiveDouble alloc] init];
    }
    
    self.value.value = grams / 1000;
    
    [self updateDisplayValue:grams units:@"gram" andUnitsCode:@"g"];
}

- (double)inMilligrams
{
    return self.inGrams * 1000;
}

- (void)setInMilligrams:(double)milligrams
{
    if (!self.value)
    {
        self.value = [[MHVPositiveDouble alloc] init];
    }
    
    self.value.value = milligrams / (1000 * 1000);
    
    [self updateDisplayValue:milligrams units:@"milligram" andUnitsCode:@"mg"];
}

- (double)inPounds
{
    return [MHVWeightMeasurement kgToPounds:self.inKg];
}

- (void)setInPounds:(double)valueInPounds
{
    if (!self.value)
    {
        self.value = [[MHVPositiveDouble alloc] init];
    }
    
    self.value.value = [MHVWeightMeasurement poundsToKg:valueInPounds];
    
    [self updateDisplayValue:valueInPounds units:@"pound" andUnitsCode:@"lb"];
}

- (double)inOunces
{
    return self.inPounds * 16;
}

- (void)setInOunces:(double)ounces
{
    if (!self.value)
    {
        self.value = [[MHVPositiveDouble alloc] init];
    }
    
    self.value.value = [MHVWeightMeasurement poundsToKg:(ounces / 16)];
    
    [self updateDisplayValue:ounces units:@"ounce" andUnitsCode:@"oz"];
}

- (instancetype)initWithKg:(double)value
{
    self = [super init];
    if (self)
    {
        self.inKg = value;
        
        MHVCHECK_NOTNULL(self.value);
        MHVCHECK_NOTNULL(self.display);
    }
    
    return self;
}

- (instancetype)initWithPounds:(double)value
{
    self = [super init];
    if (self)
    {
        self.inPounds = value;
        
        MHVCHECK_NOTNULL(self.value);
        MHVCHECK_NOTNULL(self.display);
    }
    
    return self;
}

- (BOOL)updateDisplayValue:(double)displayValue units:(NSString *)unitValue andUnitsCode:(NSString *)code
{
    MHVDisplayValue *newValue = [[MHVDisplayValue alloc] initWithValue:displayValue andUnits:unitValue];
    
    MHVCHECK_NOTNULL(newValue);
    if (code)
    {
        newValue.unitsCode = code;
    }
    
    self.display = newValue;
    
    return TRUE;
}

- (NSString *)description
{
    return [self toString];
}

- (NSString *)toString
{
    return [self toStringWithFormat:@"%.2f kilogram"];
}

- (NSString *)toStringWithFormat:(NSString *)format
{
    return [NSString localizedStringWithFormat:format, self.inKg];
}

- (NSString *)stringInPounds:(NSString *)format
{
    return [NSString localizedStringWithFormat:format, self.inPounds];
}

- (NSString *)stringInOunces:(NSString *)format
{
    return [NSString localizedStringWithFormat:format, self.inOunces];
}

- (NSString *)stringInKg:(NSString *)format
{
    return [NSString localizedStringWithFormat:format, self.inKg];
}

- (NSString *)stringInGrams:(NSString *)format
{
    return [NSString localizedStringWithFormat:format, self.inGrams];
}

- (NSString *)stringInMilligrams:(NSString *)format
{
    return [NSString localizedStringWithFormat:format, self.inMilligrams];
}

+ (MHVWeightMeasurement *)fromKg:(double)kg
{
    return [[MHVWeightMeasurement alloc] initWithKg:kg];
}

+ (MHVWeightMeasurement *)fromPounds:(double)pounds
{
    return [[MHVWeightMeasurement alloc] initWithPounds:pounds];
}

+ (MHVWeightMeasurement *)fromGrams:(double)grams
{
    MHVWeightMeasurement *weight = [[MHVWeightMeasurement alloc] init];
    
    weight.inGrams = grams;
    return weight;
}

+ (MHVWeightMeasurement *)fromMillgrams:(double)mg
{
    MHVWeightMeasurement *weight = [[MHVWeightMeasurement alloc] init];
    
    weight.inMilligrams = mg;
    return weight;
}

+ (MHVWeightMeasurement *)fromOunces:(double)ounces
{
    MHVWeightMeasurement *weight = [[MHVWeightMeasurement alloc] init];
    
    weight.inOunces = ounces;
    return weight;
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN;
    
    MHVVALIDATE(self.value, MHVClientError_InvalidWeightMeasurement);
    MHVVALIDATE_OPTIONAL(self.display);
    
    MHVVALIDATE_SUCCESS;
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementXmlName:x_element_kg content:self.value];
    [writer writeElementXmlName:x_element_display content:self.display];
}

- (void)deserialize:(XReader *)reader
{
    self.value = [reader readElementWithXmlName:x_element_kg asClass:[MHVPositiveDouble class]];
    self.display = [reader readElementWithXmlName:x_element_display asClass:[MHVDisplayValue class]];
}

+ (double)kgToPounds:(double)kg
{
    return kg * c_PoundsPerKg;
}

+ (double)poundsToKg:(double)pounds
{
    return pounds * c_KgPerPound;
}

@end

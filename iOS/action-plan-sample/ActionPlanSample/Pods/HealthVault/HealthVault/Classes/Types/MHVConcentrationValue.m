//
// MHVConcentrationValue.m
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

#import "MHVConcentrationValue.h"
#import "MHVValidator.h"

NSString *const c_element_mmolPL = @"mmolPerL";
NSString *const c_element_display = @"display";

const xmlChar *x_element_mmolPL = XMLSTRINGCONST("mmolPerL");
const xmlChar *x_element_display = XMLSTRINGCONST("display");

NSString *const c_mmolPlUnits = @"mmol/L";
NSString *const c_mmolUnitsCode = @"mmol-per-l";
NSString *const c_mgDLUnits = @"mg/dL";
NSString *const c_mgDLUnitsCode = @"mg-per-dl";

double mgDLToMmolPerL(double mgDLValue, double molarWeight)
{
    //
    // DL = 0.1 Liters
    // (10 * mgDL)/1000 = g/L
    // Molar weight = grams/mole
    //
    // ((10 * mgDL)/1000 / molarWeight) * 1000)
    
    return (10 * mgDLValue) / molarWeight;
}

double mmolPerLToMgDL(double mmolPerL, double molarWeight)
{
    return (mmolPerL * molarWeight) / 10;
}


@interface MHVConcentrationValue ()

@property (readwrite, nonatomic, strong) MHVNonNegativeDouble *value;

@end

@implementation MHVConcentrationValue

- (double)mmolPerLiter
{
    return self.value ? self.value.value : NAN;
}

- (void)setMmolPerLiter:(double)mmolPerLiter
{
    if (!_value)
    {
        _value = [[MHVNonNegativeDouble alloc] init];
    }
    
    _value.value = mmolPerLiter;
    [self updateDisplayValue:mmolPerLiter units:c_mmolPlUnits andUnitsCode:c_mmolUnitsCode];
}

- (instancetype)initWithMmolPerLiter:(double)value
{
    self = [super init];
    if (self)
    {
        [self setMmolPerLiter:value];
    }
    return self;
}

- (instancetype)initWithMgPerDL:(double)value gramsPerMole:(double)gramsPerMole
{
    self = [super init];
    if (self)
    {
        [self setMgPerDL:value gramsPerMole:gramsPerMole];
    }
    
    return self;
}

- (double)mgPerDL:(double)gramsPerMole
{
    if (_value)
    {
        return mmolPerLToMgDL(_value.value, gramsPerMole);
    }
    
    return NAN;
}

- (void)setMgPerDL:(double)value gramsPerMole:(double)gramsPerMole
{
    double mmolPerl = mgDLToMmolPerL(value, gramsPerMole);
    
    if (!_value)
    {
        _value = [[MHVNonNegativeDouble alloc] init];
    }
    
    _value.value = mmolPerl;
    [self updateDisplayValue:value units:c_mgDLUnits andUnitsCode:c_mgDLUnitsCode];
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
    return [self toStringWithFormat:@"%.3f mmol/l"];
}

- (NSString *)toStringWithFormat:(NSString *)format
{
    return [NSString localizedStringWithFormat:format, self.mmolPerLiter];
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN;
    
    MHVVALIDATE(self.value, MHVClientError_InvalidConcentrationValue);
    MHVVALIDATE_OPTIONAL(self.display);
    
    MHVVALIDATE_SUCCESS;
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementXmlName:x_element_mmolPL content:self.value];
    [writer writeElementXmlName:x_element_display content:self.display];
}

- (void)deserialize:(XReader *)reader
{
    self.value = [reader readElementWithXmlName:x_element_mmolPL asClass:[MHVNonNegativeDouble class]];
    self.display = [reader readElementWithXmlName:x_element_display asClass:[MHVDisplayValue class]];
}

@end

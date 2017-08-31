//
// MHVBloodGlucoseMeasurement.m
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

#import "MHVBloodGlucoseMeasurement.h"
#import "MHVValidator.h"
#import "MHVMeasurement.h"

@implementation MHVBloodGlucoseMeasurement

- (double)mmolPerLiter
{
    return (self.value) ? self.value.value : NAN;
}

- (void)setMmolPerLiter:(double)mmolPerLiter
{
    if (!self.value)
    {
        self.value = [[MHVPositiveDouble alloc] init];
    }
    
    self.value.value = mmolPerLiter;
    [self updateDisplayValue:mmolPerLiter units:c_mmolPlUnits andUnitsCode:c_mmolUnitsCode];
}

- (double)mgPerDL
{
    if (self.value)
    {
        return [MHVBloodGlucoseMeasurement mMolPerLiterToMgPerDL:self.value.value];
    }
    
    return NAN;
}

- (void)setMgPerDL:(double)mgPerDL
{
    if (!self.value)
    {
        self.value = [[MHVPositiveDouble alloc] init];
    }
    
    self.value.value = [MHVBloodGlucoseMeasurement mgPerDLToMmolPerLiter:mgPerDL];
    [self updateDisplayValue:mgPerDL units:c_mgDLUnits andUnitsCode:c_mgDLUnitsCode];
}

- (instancetype)initWithMmolPerLiter:(double)value
{
    self = [super init];
    if (self)
    {
        [self setMmolPerLiter:value];
        MHVCHECK_NOTNULL(_value);
    }
    
    return self;
}

- (instancetype)initWithMgPerDL:(double)value
{
    self = [super init];
    if (self)
    {
        [self setMgPerDL:value];
        MHVCHECK_NOTNULL(_value);
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
    return [self toStringWithFormat:@"%.3f mmol/l"];
}

- (NSString *)toStringWithFormat:(NSString *)format
{
    return [NSString localizedStringWithFormat:format, self.mmolPerLiter];
}

+ (double)mMolPerLiterToMgPerDL:(double)value
{
    return value * 18;
}

+ (double)mgPerDLToMmolPerLiter:(double)value
{
    return value / 18;
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN;
    
    MHVVALIDATE(self.value, MHVClientError_InvalidBloodGlucoseMeasurement);
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
    self.value = [reader readElementWithXmlName:x_element_mmolPL asClass:[MHVPositiveDouble class]];
    self.display = [reader readElementWithXmlName:x_element_display asClass:[MHVDisplayValue class]];
}

@end

//
// MHVLengthMeasurement.m
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
#import "MHVLengthMeasurement.h"

static const xmlChar *x_element_meters = XMLSTRINGCONST("m");
static const xmlChar *x_element_display = XMLSTRINGCONST("display");

@interface MHVLengthMeasurement ()

@property (nonatomic, strong) MHVPositiveDouble *meters;

@end

@implementation MHVLengthMeasurement

- (double)inMeters
{
    return (self.meters) ? self.meters.value : NAN;
}

- (void)setInMeters:(double)meters
{
    if (!self.meters)
    {
        self.meters = [[MHVPositiveDouble alloc] init];
    }
    
    self.meters.value = meters;
    [self updateDisplayValue:meters units:@"meters" andUnitsCode:@"m"];
}

- (double)inCentimeters
{
    return self.inMeters * 100.0;
}

- (void)setInCentimeters:(double)inCentimeters
{
    if (!self.meters)
    {
        self.meters = [[MHVPositiveDouble alloc] init];
    }
    
    self.meters.value = inCentimeters / 100.0;
    [self updateDisplayValue:inCentimeters units:@"centimeters" andUnitsCode:@"cm"];
}

- (double)inKilometers
{
    return self.inMeters / 1000.0;
}

- (void)setInKilometers:(double)inKilometers
{
    if (!self.meters)
    {
        self.meters = [[MHVPositiveDouble alloc] init];
    }
    
    self.meters.value = inKilometers * 1000.0;
    [self updateDisplayValue:inKilometers units:@"kilometers" andUnitsCode:@"km"];
}

- (double)inInches
{
    return (self.meters) ? [MHVLengthMeasurement metersToInches:self.meters.value] : NAN;
}

- (void)setInInches:(double)inches
{
    if (!self.meters)
    {
        self.meters = [[MHVPositiveDouble alloc] init];
    }
    
    self.meters.value = [MHVLengthMeasurement inchesToMeters:inches];
    [self updateDisplayValue:inches units:@"inches" andUnitsCode:@"in"];
}

- (double)inFeet
{
    return self.inInches / 12.0;
}

- (void)setInFeet:(double)inFeet
{
    if (!self.meters)
    {
        self.meters = [[MHVPositiveDouble alloc] init];
    }
    
    self.meters.value = [MHVLengthMeasurement inchesToMeters:inFeet * 12.0];
    [self updateDisplayValue:inFeet units:@"feet" andUnitsCode:@"ft"];
}

- (double)inMiles
{
    return self.inFeet / 5280.0;
}

- (void)setInMiles:(double)inMiles
{
    if (!self.meters)
    {
        self.meters = [[MHVPositiveDouble alloc] init];
    }
    
    self.meters.value = [MHVLengthMeasurement inchesToMeters:inMiles * 5280.0 * 12.0];
    [self updateDisplayValue:inMiles units:@"miles" andUnitsCode:@"mi"];
}

- (instancetype)initWithInches:(double)inches
{
    self = [super init];
    if (self)
    {
        [self setInInches:inches];
        MHVCHECK_NOTNULL(self.meters);
        MHVCHECK_NOTNULL(self.display);
    }
    
    return self;
}

- (instancetype)initWithMeters:(double)meters
{
    self = [super init];
    if (self)
    {
        self.inMeters = meters;
        MHVCHECK_NOTNULL(self.meters);
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

- (NSString *)toString
{
    return [self stringInMeters:@"%.2f m"];
}

- (NSString *)toStringWithFormat:(NSString *)format
{
    return [NSString localizedStringWithFormat:format, self.inMeters];
}

- (NSString *)stringInCentimeters:(NSString *)format
{
    return [NSString localizedStringWithFormat:format, self.inCentimeters];
}

- (NSString *)stringInMeters:(NSString *)format
{
    return [NSString localizedStringWithFormat:format, self.inMeters];
}

- (NSString *)stringInKilometers:(NSString *)format
{
    return [NSString localizedStringWithFormat:format, self.inKilometers];
}

- (NSString *)stringInInches:(NSString *)format
{
    return [NSString localizedStringWithFormat:format, self.inInches];
}

- (NSString *)stringInFeetAndInches:(NSString *)format
{
    long totalInches = (long)round(self.inInches);
    long feet = totalInches / 12;
    long inches = totalInches % 12;
    
    return [NSString localizedStringWithFormat:format, feet, inches];
}

- (NSString *)stringInMiles:(NSString *)format
{
    return [NSString localizedStringWithFormat:format, self.inMiles];
}

+ (MHVLengthMeasurement *)fromMiles:(double)value
{
    MHVLengthMeasurement *length = [[MHVLengthMeasurement alloc] init];
    
    length.inMiles = value;
    return length;
}

+ (MHVLengthMeasurement *)fromInches:(double)value
{
    MHVLengthMeasurement *length = [[MHVLengthMeasurement alloc] init];
    
    length.inInches = value;
    return length;
}

+ (MHVLengthMeasurement *)fromKilometers:(double)value
{
    MHVLengthMeasurement *length = [[MHVLengthMeasurement alloc] init];
    
    length.inKilometers = value;
    return length;
}

+ (MHVLengthMeasurement *)fromMeters:(double)value
{
    MHVLengthMeasurement *length = [[MHVLengthMeasurement alloc] init];
    
    length.inMeters = value;
    return length;
}

+ (MHVLengthMeasurement *)fromCentimeters:(double)value
{
    MHVLengthMeasurement *length = [[MHVLengthMeasurement alloc] init];
    
    length.inCentimeters = value;
    return length;
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN;
    
    MHVVALIDATE(self.meters, MHVClientError_InvalidLengthMeasurement);
    MHVVALIDATE_OPTIONAL(self.display);
    
    MHVVALIDATE_SUCCESS;
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementXmlName:x_element_meters content:self.meters];
    [writer writeElementXmlName:x_element_display content:self.display];
}

- (void)deserialize:(XReader *)reader
{
    self.meters = [reader readElementWithXmlName:x_element_meters asClass:[MHVPositiveDouble class]];
    self.display = [reader readElementWithXmlName:x_element_display asClass:[MHVDisplayValue class]];
}

+ (double)centimetersToInches:(double)cm
{
    return cm * 0.3937;
}

+ (double)inchesToCentimeters:(double)cm
{
    return cm * 2.54;
}

+ (double)metersToInches:(double)meters
{
    return [MHVLengthMeasurement centimetersToInches:meters * 100.0];
}

+ (double)inchesToMeters:(double)inches
{
    return [MHVLengthMeasurement inchesToCentimeters:inches] / 100.0;
}

@end

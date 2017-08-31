//
// MHVBloodGlucose.m
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

#import "MHVBloodGlucose.h"
#import "MHVValidator.h"

static NSString *const c_typeid = @"879e7c04-4e8a-4707-9ad3-b054df467ce4";
static NSString *const c_typename = @"blood-glucose";

static const xmlChar *x_element_when = XMLSTRINGCONST("when");
static const xmlChar *x_element_value = XMLSTRINGCONST("value");
static const xmlChar *x_element_type = XMLSTRINGCONST("glucose-measurement-type");
static const xmlChar *x_element_operatingTemp = XMLSTRINGCONST("outside-operating-temp");
static const xmlChar *x_element_controlTest = XMLSTRINGCONST("is-control-test");
static const xmlChar *x_element_normalcy = XMLSTRINGCONST("normalcy");
static const xmlChar *x_element_context = XMLSTRINGCONST("measurement-context");

static NSString *const c_vocab_measurement = @"glucose-measurement-type";

@interface MHVBloodGlucose ()

@property (nonatomic, strong) MHVOneToFive *normalcyValue;

@end

@implementation MHVBloodGlucose

- (NSDate *)getDate
{
    return [self.when toDate];
}

- (NSDate *)getDateForCalendar:(NSCalendar *)calendar
{
    return [self.when toDateForCalendar:calendar];
}

- (double)inMgPerDL
{
    return (self.value) ? self.value.mgPerDL : NAN;
}

- (void)setInMgPerDL:(double)inMgPerDL
{
    if (!self.value)
    {
        self.value = [[MHVBloodGlucoseMeasurement alloc] init];
    }
    
    self.value.mgPerDL = inMgPerDL;
}

- (double)inMmolPerLiter
{
    return (self.value) ? self.value.mmolPerLiter : NAN;
}

- (void)setInMmolPerLiter:(double)inMmolPerLiter
{
    if (!self.value)
    {
        self.value = [[MHVBloodGlucoseMeasurement alloc] init];
    }
    
    self.value.mmolPerLiter = inMmolPerLiter;
}

- (MHVRelativeRating)normalcy
{
    return (self.normalcyValue) ? (MHVRelativeRating)self.normalcyValue.value : MHVRelativeRating_None;
}

- (void)setNormalcy:(MHVRelativeRating)normalcy
{
    if (normalcy == MHVRelativeRating_None)
    {
        self.normalcyValue = nil;
    }
    else
    {
        if (!self.normalcyValue)
        {
            self.normalcyValue = [[MHVOneToFive alloc] init];
        }
        
        self.normalcyValue.value = normalcy;
    }
}

- (instancetype)initWithMmolPerLiter:(double)value andDate:(NSDate *)date
{
    MHVCHECK_NOTNULL(date);
    
    self = [super init];
    if (self)
    {
        [self setInMmolPerLiter:value];
        MHVCHECK_NOTNULL(_value);
        
        _when = [[MHVDateTime alloc] initWithDate:date];
        MHVCHECK_NOTNULL(_when);
    }
    
    return self;
}

- (NSString *)stringInMgPerDL:(NSString *)format
{
    return [NSString localizedStringWithFormat:format, self.inMgPerDL];
}

- (NSString *)stringInMmolPerLiter:(NSString *)format
{
    return [NSString localizedStringWithFormat:format, self.inMmolPerLiter];
}

- (NSString *)toString
{
    return [self stringInMmolPerLiter:@"%.3f mmol/L"];
}

- (NSString *)normalcyText
{
    return stringFromRating(self.normalcy);
}

+ (MHVCodableValue *)createPlasmaMeasurementType
{
    return [MHVBloodGlucose newMeasurementText:@"Plasma" andCode:@"p"];
}

+ (MHVCodableValue *)createWholeBloodMeasurementType
{
    return [MHVBloodGlucose newMeasurementText:@"Whole blood" andCode:@"wb"];
}

+ (MHVVocabularyIdentifier *)vocabForContext
{
    return [[MHVVocabularyIdentifier alloc] initWithFamily:c_hvFamily andName:@"glucose-measurement-context"];
}

+ (MHVVocabularyIdentifier *)vocabForMeasurementType
{
    return [[MHVVocabularyIdentifier alloc] initWithFamily:c_hvFamily andName:@"glucose-measurement-type"];
}

+ (MHVVocabularyIdentifier *)vocabForNormalcy
{
    return [[MHVVocabularyIdentifier alloc] initWithFamily:c_hvFamily andName:@"normalcy-one-to-five"];
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN
    
    MHVVALIDATE(self.when, MHVClientError_InvalidBloodGlucose);
    MHVVALIDATE(self.value, MHVClientError_InvalidBloodGlucose);
    MHVVALIDATE(self.measurementType, MHVClientError_InvalidBloodGlucose);
    MHVVALIDATE_OPTIONAL(self.isOutsideOperatingTemp);
    MHVVALIDATE_OPTIONAL(self.isControlTest);
    MHVVALIDATE_OPTIONAL(self.normalcyValue);
    MHVVALIDATE_OPTIONAL(self.context);
    
    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementXmlName:x_element_when content:self.when];
    [writer writeElementXmlName:x_element_value content:self.value];
    [writer writeElementXmlName:x_element_type content:self.measurementType];
    [writer writeElementXmlName:x_element_operatingTemp content:self.isOutsideOperatingTemp];
    [writer writeElementXmlName:x_element_controlTest content:self.isControlTest];
    [writer writeElementXmlName:x_element_normalcy content:self.normalcyValue];
    [writer writeElementXmlName:x_element_context content:self.context];
}

- (void)deserialize:(XReader *)reader
{
    self.when = [reader readElementWithXmlName:x_element_when asClass:[MHVDateTime class]];
    self.value = [reader readElementWithXmlName:x_element_value asClass:[MHVBloodGlucoseMeasurement class]];
    self.measurementType = [reader readElementWithXmlName:x_element_type asClass:[MHVCodableValue class]];
    self.isOutsideOperatingTemp = [reader readElementWithXmlName:x_element_operatingTemp asClass:[MHVBool class]];
    self.isControlTest = [reader readElementWithXmlName:x_element_controlTest asClass:[MHVBool class]];
    self.normalcyValue = [reader readElementWithXmlName:x_element_normalcy asClass:[MHVOneToFive class]];
    self.context = [reader readElementWithXmlName:x_element_context asClass:[MHVCodableValue class]];
}

+ (NSString *)typeID
{
    return c_typeid;
}

+ (NSString *)XRootElement
{
    return c_typename;
}

+ (MHVThing *)newThing
{
    return [[MHVThing alloc] initWithType:[MHVBloodGlucose typeID]];
}

- (NSString *)typeName
{
    return NSLocalizedString(@"Blood Glucose", @"Blood Glucose Type Name");
}

#pragma mark - Internal methods

+ (MHVCodableValue *)newMeasurementText:(NSString *)text andCode:(NSString *)code
{
    MHVCodedValue *codedValue = [MHVBloodGlucose newMeasurementCode:code];
    MHVCodableValue *codableValue = [[MHVCodableValue alloc] initWithText:text andCode:codedValue];
    
    return codableValue;
}

+ (MHVCodedValue *)newMeasurementCode:(NSString *)code
{
    return [[MHVCodedValue alloc] initWithCode:code andVocab:c_vocab_measurement];
}

@end

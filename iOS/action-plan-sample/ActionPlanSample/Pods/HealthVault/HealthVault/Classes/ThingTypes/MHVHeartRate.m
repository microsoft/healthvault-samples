//
// MHVHeartRate.m
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

#import "MHVHeartRate.h"
#import "MHVValidator.h"

static NSString *const c_typeID = @"b81eb4a6-6eac-4292-ae93-3872d6870994";
static NSString *const c_typeName = @"heart-rate";

static const xmlChar *x_element_when = XMLSTRINGCONST("when");
static const xmlChar *x_element_value = XMLSTRINGCONST("value");
static const xmlChar *x_element_method = XMLSTRINGCONST("measurement-method");
static const xmlChar *x_element_conditions = XMLSTRINGCONST("measurement-conditions");
static const xmlChar *x_element_flags = XMLSTRINGCONST("measurement-flags");

@implementation MHVHeartRate

- (int)bpmValue
{
    return (self.bpm != nil) ? self.bpm.value : -1;
}

- (void)setBpmValue:(int)bpmValue
{
    if (!self.bpm)
    {
        self.bpm = [[MHVNonNegativeInt alloc] init];
    }
    
    self.bpm.value = bpmValue;
}

- (instancetype)initWithBpm:(int)bpm andDate:(NSDate *)date
{
    self = [super init];
    if (self)
    {
        _bpm = [[MHVNonNegativeInt alloc] initWith:bpm];
        MHVCHECK_NOTNULL(_bpm);
        
        _when = [[MHVDateTime alloc] initWithDate:date];
        MHVCHECK_NOTNULL(_when);
    }
    
    return self;
}

- (NSDate *)getDate
{
    return [self.when toDate];
}

- (NSDate *)getDateForCalendar:(NSCalendar *)calendar
{
    return [self.when toDateForCalendar:calendar];
}

+ (MHVVocabularyIdentifier *)vocabForMeasurementMethod
{
    return [[MHVVocabularyIdentifier alloc] initWithFamily:c_hvFamily andName:@"heart-rate-measurement-method"];
}

+ (MHVVocabularyIdentifier *)vocabForMeasurementConditions
{
    return [[MHVVocabularyIdentifier alloc] initWithFamily:c_hvFamily andName:@"heart-rate-measurement-conditions"];
}

- (NSString *)toString
{
    return [self toStringWithFormat:@"%d bpm"];
}

- (NSString *)toStringWithFormat:(NSString *)format
{
    return [NSString localizedStringWithFormat:format, self.bpmValue];
}

- (NSString *)description
{
    return [self toString];
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN;
    
    MHVVALIDATE(self.when, MHVClientError_InvalidHeartRate);
    MHVVALIDATE(self.bpm, MHVClientError_InvalidHeartRate);
    MHVVALIDATE_OPTIONAL(self.measurementMethod);
    MHVVALIDATE_OPTIONAL(self.measurementConditions);
    MHVVALIDATE_OPTIONAL(self.measurementFlags);
    
    MHVVALIDATE_SUCCESS;
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementXmlName:x_element_when content:self.when];
    [writer writeElementXmlName:x_element_value content:self.bpm];
    [writer writeElementXmlName:x_element_method content:self.measurementMethod];
    [writer writeElementXmlName:x_element_conditions content:self.measurementConditions];
    [writer writeElementXmlName:x_element_flags content:self.measurementFlags];
}

- (void)deserialize:(XReader *)reader
{
    self.when = [reader readElementWithXmlName:x_element_when asClass:[MHVDateTime class]];
    self.bpm = [reader readElementWithXmlName:x_element_value asClass:[MHVNonNegativeInt class]];
    self.measurementMethod = [reader readElementWithXmlName:x_element_method asClass:[MHVCodableValue class]];
    self.measurementConditions = [reader readElementWithXmlName:x_element_conditions asClass:[MHVCodableValue class]];
    self.measurementFlags = [reader readElementWithXmlName:x_element_flags asClass:[MHVCodableValue class]];
}

+ (NSString *)typeID
{
    return c_typeID;
}

+ (NSString *)XRootElement
{
    return c_typeName;
}

+ (MHVThing *)newThing
{
    return [[MHVThing alloc] initWithType:[MHVHeartRate typeID]];
}

- (NSString *)typeName
{
    return NSLocalizedString(@"Heart Rate", @"Heart Rate Type Name");
}

@end

//
// MHVBloodPressure.m
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

#import "MHVBloodPressure.h"
#import "MHVValidator.h"

static NSString *const c_typeID = @"ca3c57f4-f4c1-4e15-be67-0a3caf5414ed";
static NSString *const c_typeName = @"blood-pressure";

static const xmlChar *x_element_when = XMLSTRINGCONST("when");
static const xmlChar *x_element_systolic = XMLSTRINGCONST("systolic");
static const xmlChar *x_element_diastolic = XMLSTRINGCONST("diastolic");
static const xmlChar *x_element_pulse = XMLSTRINGCONST("pulse");
static const xmlChar *x_element_heartbeat = XMLSTRINGCONST("irregular-heartbeat");

@implementation MHVBloodPressure

- (int)systolicValue
{
    return (self.systolic) ? self.systolic.value : -1;
}

- (void)setSystolicValue:(int)systolicValue
{
    if (!self.systolic)
    {
        self.systolic = [[MHVNonNegativeInt alloc] init];
    }
    
    self.systolic.value = systolicValue;
}

- (int)diastolicValue
{
    return (self.diastolic) ? self.diastolic.value : -1;
}

- (void)setDiastolicValue:(int)diastolicValue
{
    if (!self.diastolic)
    {
        self.diastolic = [[MHVNonNegativeInt alloc] init];
    }
    
    self.diastolic.value = diastolicValue;
}

- (int)pulseValue
{
    return (self.pulse) ? self.pulse.value : -1;
}

- (void)setPulseValue:(int)pulseValue
{
    if (!self.pulse)
    {
        self.pulse = [[MHVNonNegativeInt alloc] init];
    }
    
    self.pulse.value = pulseValue;
}

- (instancetype)initWithSystolic:(int)sVal diastolic:(int)dVal
{
    return [self initWithSystolic:sVal diastolic:dVal pulse:-1];
}

- (instancetype)initWithSystolic:(int)sVal diastolic:(int)dVal andDate:(NSDate *)date
{
    MHVCHECK_NOTNULL(date);
    
    self = [self initWithSystolic:sVal diastolic:dVal];
    if (self)
    {
        _when = [[MHVDateTime alloc] initWithDate:date];
        MHVCHECK_NOTNULL(_when);
    }
    
    return self;
}

- (instancetype)initWithSystolic:(int)sVal diastolic:(int)dVal pulse:(int)pVal
{
    self = [super init];
    if (self)
    {
        _systolic = [[MHVNonNegativeInt alloc] initWith:sVal];
        MHVCHECK_NOTNULL(_systolic);
        
        _diastolic = [[MHVNonNegativeInt alloc] initWith:dVal];
        MHVCHECK_NOTNULL(_diastolic);
        
        if (pVal >= 0)
        {
            _pulse = [[MHVNonNegativeInt alloc] initWith:pVal];
            MHVCHECK_NOTNULL(_pulse);
        }
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

- (NSString *)toString
{
    return [self toStringWithFormat:@"%d/%d"];
}

- (NSString *)toStringWithFormat:(NSString *)format
{
    return [NSString localizedStringWithFormat:format, self.systolicValue, self.diastolicValue];
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN;
    
    MHVVALIDATE(self.when, MHVClientError_InvalidBloodPressure);
    MHVVALIDATE(self.systolic, MHVClientError_InvalidBloodPressure);
    MHVVALIDATE(self.diastolic, MHVClientError_InvalidBloodPressure);
    MHVVALIDATE_OPTIONAL(self.pulse);
    MHVVALIDATE_OPTIONAL(self.irregularHeartbeat);
    
    MHVVALIDATE_SUCCESS;
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementXmlName:x_element_when content:self.when];
    [writer writeElementXmlName:x_element_systolic content:self.systolic];
    [writer writeElementXmlName:x_element_diastolic content:self.diastolic];
    [writer writeElementXmlName:x_element_pulse content:self.pulse];
    [writer writeElementXmlName:x_element_heartbeat content:self.irregularHeartbeat];
}

- (void)deserialize:(XReader *)reader
{
    self.when = [reader readElementWithXmlName:x_element_when asClass:[MHVDateTime class]];
    self.systolic = [reader readElementWithXmlName:x_element_systolic asClass:[MHVNonNegativeInt class]];
    self.diastolic = [reader readElementWithXmlName:x_element_diastolic asClass:[MHVNonNegativeInt class]];
    self.pulse = [reader readElementWithXmlName:x_element_pulse asClass:[MHVNonNegativeInt class]];
    self.irregularHeartbeat = [reader readElementWithXmlName:x_element_heartbeat asClass:[MHVBool class]];
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
    return [[MHVThing alloc] initWithType:[MHVBloodPressure typeID]];
}

- (NSString *)typeName
{
    return NSLocalizedString(@"Blood Pressure", @"Blood Pressure Type Name");
}

@end

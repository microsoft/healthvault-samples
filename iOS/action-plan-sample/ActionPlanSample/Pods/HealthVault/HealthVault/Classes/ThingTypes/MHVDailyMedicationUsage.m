//
// MHVDailyMedicationUsage.m
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
//

#import "MHVDailyMedicationUsage.h"
#import "MHVValidator.h"

static NSString *const c_typeid = @"a9a76456-0357-493e-b840-598bbb9483fd";
static NSString *const c_typename = @"daily-medication-usage";

static const xmlChar *x_element_when = XMLSTRINGCONST("when");
static const xmlChar *x_element_drugName = XMLSTRINGCONST("drug-name");
static const xmlChar *x_element_dosesConsumed = XMLSTRINGCONST("number-doses-consumed-in-day");
static const xmlChar *x_element_purpose = XMLSTRINGCONST("purpose-of-use");
static const xmlChar *x_element_dosesIntended = XMLSTRINGCONST("number-doses-intended-in-day");
static const xmlChar *x_element_usageSchedule = XMLSTRINGCONST("medication-usage-schedule");
static const xmlChar *x_element_drugForm = XMLSTRINGCONST("drug-form");
static const xmlChar *x_element_prescriptionType = XMLSTRINGCONST("prescription-type");
static const xmlChar *x_element_singleDoseDescr = XMLSTRINGCONST("single-dose-description");

@implementation MHVDailyMedicationUsage

- (int)dosesConsumedValue
{
    return (self.dosesConsumed) ? self.dosesConsumed.value : -1;
}

- (void)setDosesConsumedValue:(int)dosesConsumedValue
{
    if (!self.dosesConsumed)
    {
        self.dosesConsumed = [[MHVInt alloc] init];
    }
    
    self.dosesConsumed.value = dosesConsumedValue;
}

- (int)dosesIntendedValue
{
    return (self.dosesIntended) ? self.dosesIntended.value : -1;
}

- (void)setDosesIntendedValue:(int)dosesIntendedValue
{
    if (!self.dosesIntended)
    {
        self.dosesIntended = [[MHVInt alloc] init];
    }
    
    self.dosesIntended.value = dosesIntendedValue;
}

- (instancetype)initWithDoses:(int)doses forDrug:(MHVCodableValue *)drug onDay:(NSDate *)day
{
    MHVCHECK_NOTNULL(day);
    
    MHVDate *date =  [[MHVDate alloc] initWithDate:day];
    return [self initWithDoses:doses forDrug:drug onDate:date];
}

- (instancetype)initWithDoses:(int)doses forDrug:(MHVCodableValue *)drug onDate:(MHVDate *)date
{
    MHVCHECK_NOTNULL(drug);
    MHVCHECK_NOTNULL(date);
    
    self = [super init];
    if (self)
    {
        _when = date;
        
        _drugName = drug;
        
        [self setDosesConsumedValue:doses];
        MHVCHECK_NOTNULL(_dosesConsumed);
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

- (NSString *)description
{
    return [self toString];
}

- (NSString *)toString
{
    return (self.drugName) ? [self.drugName toString] : @"";
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN
    
    MHVVALIDATE(self.when, MHVClientError_InvalidDailyMedicationUsage);
    MHVVALIDATE(self.drugName, MHVClientError_InvalidDailyMedicationUsage);
    MHVVALIDATE(self.dosesConsumed, MHVClientError_InvalidDailyMedicationUsage);
    MHVVALIDATE_OPTIONAL(self.purpose);
    MHVVALIDATE_OPTIONAL(self.dosesIntended);
    MHVVALIDATE_OPTIONAL(self.usageSchedule);
    MHVVALIDATE_OPTIONAL(self.drugForm);
    MHVVALIDATE_OPTIONAL(self.prescriptionType);
    MHVVALIDATE_OPTIONAL(self.singleDoseDescription);
    
    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementXmlName:x_element_when content:self.when];
    [writer writeElementXmlName:x_element_drugName content:self.drugName];
    [writer writeElementXmlName:x_element_dosesConsumed content:self.dosesConsumed];
    [writer writeElementXmlName:x_element_purpose content:self.purpose];
    [writer writeElementXmlName:x_element_dosesIntended content:self.dosesIntended];
    [writer writeElementXmlName:x_element_usageSchedule content:self.usageSchedule];
    [writer writeElementXmlName:x_element_drugForm content:self.drugForm];
    [writer writeElementXmlName:x_element_prescriptionType content:self.prescriptionType];
    [writer writeElementXmlName:x_element_singleDoseDescr content:self.singleDoseDescription];
}

- (void)deserialize:(XReader *)reader
{
    self.when = [reader readElementWithXmlName:x_element_when asClass:[MHVDate class]];
    self.drugName = [reader readElementWithXmlName:x_element_drugName asClass:[MHVCodableValue class]];
    self.dosesConsumed = [reader readElementWithXmlName:x_element_dosesConsumed asClass:[MHVInt class]];
    self.purpose = [reader readElementWithXmlName:x_element_purpose asClass:[MHVCodableValue class]];
    self.dosesIntended = [reader readElementWithXmlName:x_element_dosesIntended asClass:[MHVInt class]];
    self.usageSchedule = [reader readElementWithXmlName:x_element_usageSchedule asClass:[MHVCodableValue class]];
    self.drugForm = [reader readElementWithXmlName:x_element_drugForm asClass:[MHVCodableValue class]];
    self.prescriptionType = [reader readElementWithXmlName:x_element_prescriptionType asClass:[MHVCodableValue class]];
    self.singleDoseDescription = [reader readElementWithXmlName:x_element_singleDoseDescr asClass:[MHVCodableValue class]];
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
    return [[MHVThing alloc] initWithType:[MHVDailyMedicationUsage typeID]];
}

- (NSString *)typeName
{
    return NSLocalizedString(@"Medication usage", @"Daily medication usage Type Name");
}

@end

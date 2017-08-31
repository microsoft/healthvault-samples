//
// MHVMorningSleepJournal.m
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
#import "MHVSleepJournalAM.h"
#import "NSArray+Utils.h"

static NSString *const c_typeid = @"11c52484-7f1a-11db-aeac-87d355d89593";
static NSString *const c_typename = @"sleep-am";

static const xmlChar *x_element_when = XMLSTRINGCONST("when");
static const xmlChar *x_element_bedtime = XMLSTRINGCONST("bed-time");
static const xmlChar *x_element_waketime = XMLSTRINGCONST("wake-time");
static const xmlChar *x_element_sleepMins = XMLSTRINGCONST("sleep-minutes");
static const xmlChar *x_element_settlingMins = XMLSTRINGCONST("settling-minutes");
static NSString *const c_element_awakening = @"awakening";
static const xmlChar *x_element_medications = XMLSTRINGCONST("medications");
static const xmlChar *x_element_state = XMLSTRINGCONST("wake-state");

@interface MHVSleepJournalAM ()

@property (nonatomic, strong) MHVPositiveInt *wakeStateValue;

@end

@implementation MHVSleepJournalAM

- (MHVWakeState)wakeState
{
    return (self.wakeStateValue) ? (MHVWakeState)(self.wakeStateValue.value) : MHVWakeState_Unknown;
}

- (void)setWakeState:(MHVWakeState)wakeState
{
    if (wakeState == MHVWakeState_Unknown)
    {
        self.wakeStateValue = nil;
    }
    else
    {
        if (!self.wakeStateValue)
        {
            self.wakeStateValue = [[MHVPositiveInt alloc] init];
        }
        
        self.wakeStateValue.value = (int)wakeState;
    }
}

- (NSArray<MHVOccurence *> *)awakenings
{
    if (!_awakenings)
    {
        _awakenings = @[];
    }
    
    return _awakenings;
}

- (BOOL)hasAwakenings
{
    return ![NSArray isNilOrEmpty:self.awakenings];
}

- (int)sleepMinutesValue
{
    return (self.sleepMinutes) ? self.sleepMinutes.value : -1;
}

- (void)setSleepMinutesValue:(int)sleepMinutesValue
{
    if (!self.sleepMinutes)
    {
        self.sleepMinutes = [[MHVNonNegativeInt alloc] init];
    }
    
    self.sleepMinutes.value = sleepMinutesValue;
}

- (int)settlingMinutesValue
{
    return self.settlingMinutes ? self.settlingMinutes.value : -1;
}

- (void)setSettlingMinutesValue:(int)settlingMinutesValue
{
    if (!self.settlingMinutes)
    {
        self.settlingMinutes = [[MHVNonNegativeInt alloc] init];
    }
    
    self.settlingMinutes.value = settlingMinutesValue;
}

- (instancetype)initWithBedtime:(NSDate *)bedtime onDate:(NSDate *)date settlingMinutes:(int)settlingMinutes sleepingMinutes:(int)sleepingMinutes wokeupAt:(NSDate *)wakeTime
{
    MHVCHECK_NOTNULL(date);
    
    self = [super init];
    if (self)
    {
        _when = [[MHVDateTime alloc] initWithDate:date];
        MHVCHECK_NOTNULL(_when);
        
        _bedTime = [[MHVTime alloc] initWithDate:bedtime];
        MHVCHECK_NOTNULL(_bedTime);
        
        _settlingMinutes = [[MHVNonNegativeInt alloc] initWith:settlingMinutes];
        MHVCHECK_NOTNULL(_settlingMinutes);
        
        _sleepMinutes = [[MHVNonNegativeInt alloc] initWith:sleepingMinutes];
        MHVCHECK_NOTNULL(_sleepMinutes);
        
        _wakeTime = [[MHVTime alloc] initWithDate:wakeTime];
        MHVCHECK_NOTNULL(_wakeTime);
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

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN
    
    MHVVALIDATE(self.when, MHVClientError_InvalidSleepJournal);
    MHVVALIDATE(self.bedTime, MHVClientError_InvalidSleepJournal);
    MHVVALIDATE(self.settlingMinutes, MHVClientError_InvalidSleepJournal);
    MHVVALIDATE(self.sleepMinutes, MHVClientError_InvalidSleepJournal);
    MHVVALIDATE(self.wakeTime, MHVClientError_InvalidSleepJournal);
    MHVVALIDATE(self.wakeStateValue, MHVClientError_InvalidSleepJournal);
    MHVVALIDATE_ARRAYOPTIONAL(self.awakenings, MHVClientError_InvalidSleepJournal);
    MHVVALIDATE_OPTIONAL(self.medicationsBeforeBed);
    
    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementXmlName:x_element_when content:self.when];
    [writer writeElementXmlName:x_element_bedtime content:self.bedTime];
    [writer writeElementXmlName:x_element_waketime content:self.wakeTime];
    [writer writeElementXmlName:x_element_sleepMins content:self.sleepMinutes];
    [writer writeElementXmlName:x_element_settlingMins content:self.settlingMinutes];
    [writer writeElementArray:c_element_awakening elements:self.awakenings];
    [writer writeElementXmlName:x_element_medications content:self.medicationsBeforeBed];
    [writer writeElementXmlName:x_element_state content:self.wakeStateValue];
}

- (void)deserialize:(XReader *)reader
{
    self.when = [reader readElementWithXmlName:x_element_when asClass:[MHVDateTime class]];
    self.bedTime = [reader readElementWithXmlName:x_element_bedtime asClass:[MHVTime class]];
    self.wakeTime = [reader readElementWithXmlName:x_element_waketime asClass:[MHVTime class]];
    self.sleepMinutes = [reader readElementWithXmlName:x_element_sleepMins asClass:[MHVNonNegativeInt class]];
    self.settlingMinutes = [reader readElementWithXmlName:x_element_settlingMins asClass:[MHVNonNegativeInt class]];
    self.awakenings = [reader readElementArray:c_element_awakening asClass:[MHVOccurence class] andArrayClass:[NSMutableArray class]];
    self.medicationsBeforeBed = [reader readElementWithXmlName:x_element_medications asClass:[MHVCodableValue class]];
    self.wakeStateValue = [reader readElementWithXmlName:x_element_state asClass:[MHVPositiveInt class]];
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
    return [[MHVThing alloc] initWithType:[MHVSleepJournalAM typeID]];
}

- (NSString *)typeName
{
    return NSLocalizedString(@"Sleep Journal", @"Daily sleep journal");
}

@end

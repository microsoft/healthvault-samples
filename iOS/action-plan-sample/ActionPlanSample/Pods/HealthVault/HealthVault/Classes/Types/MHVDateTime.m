//
// DateTime.m
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

#import "MHVDateTime.h"
#import "MHVValidator.h"

static const xmlChar *x_element_date = XMLSTRINGCONST("date");
static const xmlChar *x_element_time = XMLSTRINGCONST("time");
static const xmlChar *x_element_timeZone = XMLSTRINGCONST("tz");

@implementation MHVDateTime

- (BOOL)hasTime
{
    return self.time != nil;
}

- (BOOL)hasTimeZone
{
    return self.timeZone != nil;
}

- (instancetype)initNow
{
    return [self initWithDate:[NSDate date]];
}

- (instancetype)initWithDate:(NSDate *)dateValue
{
    MHVCHECK_NOTNULL(dateValue);
    
    NSDateComponents *components = [self componentsFromDate:dateValue];
    MHVCHECK_NOTNULL(components);
    
    return [self initWithComponents:components];
}

- (instancetype)initWithComponents:(NSDateComponents *)components
{
    MHVCHECK_NOTNULL(components);
    
    self = [super init];
    if (self)
    {
        _date = [[MHVDate alloc] initWithComponents:components];
        _time = [[MHVTime alloc] initWithComponents:components];
        
        MHVCHECK_TRUE(_date && _time);
    }
    return self;
}

+ (MHVDateTime *)now
{
    return [[MHVDateTime alloc] initNow];
}

+ (MHVDateTime *)fromDate:(NSDate *)date
{
    return [[MHVDateTime alloc] initWithDate:date];
}

- (BOOL)setWithDate:(NSDate *)dateValue
{
    MHVCHECK_NOTNULL(dateValue);
    
    NSDateComponents *components = [self componentsFromDate:dateValue];
    MHVCHECK_NOTNULL(components);
    
    return [self setWithComponents:components];
}

- (BOOL)setWithComponents:(NSDateComponents *)components
{
    MHVCHECK_NOTNULL(components);
    
    self.date = [[MHVDate alloc] initWithComponents:components];
    self.time = [[MHVTime alloc] initWithComponents:components];
    
    MHVCHECK_TRUE(self.date && self.time);
    
    return TRUE;
}

- (NSString *)description
{
    return [self toString];
}

- (NSString *)toString
{
    return [self toStringWithFormat:@"MM/dd/yy hh:mm aaa"];
}

- (NSString *)toStringWithFormat:(NSString *)format
{
    NSDate *date = [self toDate];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:format];
    
    return [formatter stringFromDate:date];
}

- (NSDateComponents *)componentsFromDate:(NSDate *)date
{
    if (!date)
    {
        return nil;
    }
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    return [calendar components:NSCalendarUnitDay       |
            NSCalendarUnitMonth     |
            NSCalendarUnitYear      |
            NSCalendarUnitHour      |
            NSCalendarUnitMinute    |
            NSCalendarUnitSecond
                       fromDate:date];
}

- (NSDateComponents *)toComponents
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [NSDateComponents new];
    [components setCalendar:calendar];
    
    MHVCHECK_SUCCESS([self getComponents:components]);
    
    return components;
}

- (BOOL)getComponents:(NSDateComponents *)components
{
    MHVCHECK_NOTNULL(components);
    MHVCHECK_NOTNULL(self.date);
    
    [self.date getComponents:components];
    if (self.time)
    {
        [self.time getComponents:components];
    }
    
    return TRUE;
}

- (NSDate *)toDate
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    MHVCHECK_NOTNULL(calendar);
    
    NSDate *date = [self toDateForCalendar:calendar];
    
    return date;
}

- (NSDate *)toDateForCalendar:(NSCalendar *)calendar
{
    if (calendar)
    {
        NSDateComponents *components = [[NSDateComponents alloc] init];
        MHVCHECK_NOTNULL(components);
        
        MHVCHECK_SUCCESS([self getComponents:components]);
        
        NSDate *date = [calendar dateFromComponents:components];
        
        return date;
    }
    
    return nil;
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN;
    
    MHVVALIDATE(self.date, MHVClientError_InvalidDateTime);
    MHVVALIDATE_OPTIONAL(self.time);
    
    MHVVALIDATE_SUCCESS;
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementXmlName:x_element_date content:self.date];
    [writer writeElementXmlName:x_element_time content:self.time];
    [writer writeElementXmlName:x_element_timeZone content:self.timeZone];
}

- (void)deserialize:(XReader *)reader
{
    self.date = [reader readElementWithXmlName:x_element_date asClass:[MHVDate class]];
    self.time = [reader readElementWithXmlName:x_element_time asClass:[MHVTime class]];
    self.timeZone = [reader readElementWithXmlName:x_element_timeZone asClass:[MHVCodableValue class]];
}

@end

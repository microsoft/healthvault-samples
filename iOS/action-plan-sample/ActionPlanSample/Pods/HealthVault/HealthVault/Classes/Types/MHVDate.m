//
// MHVDate.m
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

#import "MHVDate.h"
#import "MHVValidator.h"

static const xmlChar *x_element_year  = XMLSTRINGCONST("y");
static const xmlChar *x_element_month = XMLSTRINGCONST("m");
static const xmlChar *x_element_day   = XMLSTRINGCONST("d");

@interface MHVDate ()

@property (nonatomic, strong) MHVYear  *yearObject;
@property (nonatomic, strong) MHVMonth *monthObject;
@property (nonatomic, strong) MHVDay   *dayObject;

@end

@implementation MHVDate

- (int)year
{
    return (_yearObject) ? _yearObject.value : -1;
}

- (void)setYear:(int)year
{
    if (year >= 0)
    {
        if (!_yearObject)
        {
            _yearObject = [[MHVYear alloc] init];
        }
        
        _yearObject.value = year;
    }
    else
    {
        _yearObject = nil;
    }
}

- (int)month
{
    return (_monthObject) ? _monthObject.value : -1;
}

- (void)setMonth:(int)month
{
    if (month >= 0)
    {
        if (!_monthObject)
        {
            _monthObject = [[MHVMonth alloc] init];
        }
        
        _monthObject.value = month;
    }
    else
    {
        _monthObject = nil;
    }
}

- (int)day
{
    return (_dayObject) ? _dayObject.value : -1;
}

- (void)setDay:(int)day
{
    if (day >= 0)
    {
        if (!_dayObject)
        {
            _dayObject = [[MHVDay alloc] init];
        }
        
        _dayObject.value = day;
    }
    else
    {
        _dayObject = nil;
    }
}

- (instancetype)initNow
{
    return [self initWithDate:[NSDate date]];
}

- (instancetype)initWithDate:(NSDate *)date
{
    MHVCHECK_NOTNULL(date);
    
    return [self initWithComponents:[self componentsFromDate:date]];
}

- (instancetype)initWithComponents:(NSDateComponents *)components
{
    MHVCHECK_NOTNULL(components);
    
    return [self initWithYear:[components year] month:[components month] day:[components day]];
}

- (instancetype)initWithYear:(NSInteger)yearValue month:(NSInteger)monthValue day:(NSInteger)dayValue
{
    self = [super init];
    if (self)
    {
        
        if (yearValue != NSDateComponentUndefined)
        {
            _yearObject = [[MHVYear alloc] initWith:(int)yearValue];
        }
        
        if (monthValue != NSDateComponentUndefined)
        {
            _monthObject = [[MHVMonth alloc] initWith:(int)monthValue];
        }
        
        if (dayValue != NSDateComponentUndefined)
        {
            _dayObject = [[MHVDay alloc] initWith:(int)dayValue];
        }
        
        MHVCHECK_TRUE(_yearObject && _monthObject && _dayObject);
    }
    return self;
}

- (BOOL)setWithDate:(NSDate *)date
{
    return [self setWithComponents:[self componentsFromDate:date]];
}

- (BOOL)setWithComponents:(NSDateComponents *)components
{
    MHVCHECK_NOTNULL(components);
    
    self.yearObject = [[MHVYear alloc] initWith:(int)components.year];
    self.monthObject = [[MHVMonth alloc] initWith:(int)components.month];
    self.dayObject = [[MHVDay alloc] initWith:(int)components.day];
    
    MHVCHECK_TRUE(_yearObject && _monthObject && _dayObject);
    
    return TRUE;
}

+ (MHVDate *)fromDate:(NSDate *)date
{
    return [[MHVDate alloc] initWithDate:date];
}

+ (MHVDate *)fromYear:(int)year month:(int)month day:(int)day
{
    return [[MHVDate alloc] initWithYear:year month:month day:day];
}

+ (MHVDate *)now
{
    return [[MHVDate alloc] initNow];
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
    
    return components;
}

- (NSDateComponents *)toComponentsForCalendar:(NSCalendar *)calendar
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    [components setCalendar:calendar];
    
    MHVCHECK_SUCCESS([self getComponents:components]);
    
    return components;
}

- (BOOL)getComponents:(NSDateComponents *)components
{
    MHVCHECK_NOTNULL(components);
    
    if (self.yearObject)
    {
        [components setYear:self.year];
    }
    
    if (self.monthObject)
    {
        [components setMonth:self.month];
    }
    
    if (self.dayObject)
    {
        [components setDay:self.day];
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
        NSDateComponents *components = [NSDateComponents new];
        MHVCHECK_NOTNULL(components);
        
        MHVCHECK_SUCCESS([self getComponents:components]);
        
        NSDate *date = [calendar dateFromComponents:components];
        
        return date;
    }
    
    return nil;
}

- (NSString *)description
{
    return [self toString];
}

- (NSString *)toString
{
    return [self toStringWithFormat:@"MM/dd/yy"];
}

- (NSString *)toStringWithFormat:(NSString *)format
{
    NSDate *date = [self toDate];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:format];
    
    return [formatter stringFromDate:date];
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN;
    
    MHVVALIDATE(self.yearObject, MHVClientError_InvalidDate);
    MHVVALIDATE(self.monthObject, MHVClientError_InvalidDate);
    MHVVALIDATE(self.dayObject, MHVClientError_InvalidDate);
    
    MHVVALIDATE_SUCCESS;
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementXmlName:x_element_year content:self.yearObject];
    [writer writeElementXmlName:x_element_month content:self.monthObject];
    [writer writeElementXmlName:x_element_day content:self.dayObject];
}

- (void)deserialize:(XReader *)reader
{
    self.yearObject = [reader readElementWithXmlName:x_element_year asClass:[MHVYear class]];
    self.monthObject = [reader readElementWithXmlName:x_element_month asClass:[MHVMonth class]];
    self.dayObject = [reader readElementWithXmlName:x_element_day asClass:[MHVDay class]];
}

@end

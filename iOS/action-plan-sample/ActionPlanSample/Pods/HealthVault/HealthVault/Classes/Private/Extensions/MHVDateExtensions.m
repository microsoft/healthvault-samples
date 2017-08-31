//
// MHVDateExtensions.m
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

#import "MHVDateExtensions.h"
#import "MHVValidator.h"

static NSString *kHealthVaultDateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";

@implementation NSDate (MHVExtensions)

- (NSString *)toString
{
    return self.description;
}

- (NSString *)toStringWithFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    MHVCHECK_NOTNULL(formatter);

    NSString *string = [formatter dateToString:self withFormat:format];

    return string;
}

- (NSString *)toStringWithStyle:(NSDateFormatterStyle)style
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    MHVCHECK_NOTNULL(formatter);

    NSString *string = [formatter dateToString:self withStyle:style];

    return string;
}

- (NSComparisonResult)compareDescending:(NSDate *)other
{
    return -([self compare:other]);
}

- (NSTimeInterval)offsetFromNow
{
    return [[NSDate date] timeIntervalSinceDate:self];
}

+ (NSDate *)fromHour:(int)hour
{
    return [NSDate fromHour:hour andMinute:0];
}

+ (NSDate *)fromHour:(int)hour andMinute:(int)minute
{
    NSDateComponents *components = [self newComponents];

    components.hour = hour;
    components.minute = minute;

    NSDate *newDate = [components date];

    return newDate;
}

+ (NSDate *)fromYear:(int)year month:(int)month andDay:(int)day
{
    NSDateComponents *components = [self newComponents];

    components.year = year;
    components.month = month;
    components.day = day;

    NSDate *newDate = [components date];

    return newDate;
}

+ (NSDateComponents *)newComponents
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [NSDateComponents new];
    [components setCalendar:calendar];
    
    return components;
}

- (NSDate *)toStartOfDay
{
    NSCalendar *calendar = [NSCalendar newGregorian];

    MHVCHECK_NOTNULL(calendar);

    NSDate *day = [[calendar yearMonthDayFrom:self] date];


    return day;
}

- (NSDate *)toEndOfDay
{
    NSCalendar *calendar = [NSCalendar newGregorian];

    MHVCHECK_NOTNULL(calendar);

    NSDateComponents *dateComponents = [calendar getComponentsFor:self];
    dateComponents.hour = 23;
    dateComponents.minute = 59;
    dateComponents.second = 59;

    NSDate *day = [calendar dateFromComponents:dateComponents];

    return day;
}

- (NSString *)dateToUtcString
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    NSLocale *locale = [NSDateFormatter newCultureNeutralLocale];

    [formatter setLocale:locale];

    [formatter setDateFormat:kHealthVaultDateFormat];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSString *utcDateString = [formatter stringFromDate:self];

    return utcDateString;
}

@end


const NSUInteger NSAllCalendarUnits = (NSCalendarUnitDay       |
                                       NSCalendarUnitMonth     |
                                       NSCalendarUnitYear      |
                                       NSCalendarUnitHour      |
                                       NSCalendarUnitMinute    |
                                       NSCalendarUnitSecond);

@implementation NSCalendar (MHVExtensions)

- (NSDateComponents *)componentsForCalendar
{
    NSDateComponents *components = [[NSDateComponents alloc] init];

    [components setCalendar:self];

    return components;
}

- (NSDateComponents *)getComponentsFor:(NSDate *)date
{
    return [self components:NSAllCalendarUnits fromDate:date];
}

- (NSDateComponents *)yearMonthDayFrom:(NSDate *)date
{
    NSDateComponents *components =  [self components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];

    [components setCalendar:self];

    return components;
}

+ (NSDateComponents *)componentsFromDate:(NSDate *)date
{
    MHVCHECK_NOTNULL(date);

    NSCalendar *calendar = [NSCalendar newGregorian];
    MHVCHECK_NOTNULL(calendar);

    NSDateComponents *components = [calendar getComponentsFor:date];

    return components;
}

+ (NSDateComponents *)newComponents
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [NSDateComponents new];
    [components setCalendar:calendar];

    return components;
}

+ (NSDateComponents *)newUtcComponents
{
    NSCalendar *calendar = [NSCalendar newGregorianUtc];

    MHVCHECK_NOTNULL(calendar);

    NSDateComponents *components = [[NSDateComponents alloc] init];
    MHVCHECK_NOTNULL(components);

    [components setCalendar:calendar];

    return components;
}

+ (NSDateComponents *)utcComponentsFromDate:(NSDate *)date
{
    MHVCHECK_NOTNULL(date);

    NSCalendar *calendar = [NSCalendar newGregorianUtc];
    MHVCHECK_NOTNULL(calendar);

    NSDateComponents *components = [calendar getComponentsFor:date];

    return components;
}

+ (NSCalendar *)newGregorian
{
    return [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
}

+ (NSCalendar *)newGregorianUtc
{
    NSCalendar *calendar = [NSCalendar newGregorian];

    if (calendar)
    {
        [calendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    }

    return calendar;
}

@end

@implementation NSDateFormatter (MHVExtensions)

+ (NSDateFormatter *)newUtcFormatter
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    if (formatter)
    {
        [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    }

    return formatter;
}

+ (NSDateFormatter *)newZuluFormatter
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    if (formatter)
    {
        [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH:mm:ss.SSS'Z'"]; // Zulu time format
    }

    return formatter;
}

- (NSString *)dateToString:(NSDate *)date withFormat:(NSString *)format
{
    NSString *currentFormat = [self dateFormat];

    [self setDateFormat:format];
    NSString *dateString = [self stringFromDate:date];

    [self setDateFormat:currentFormat];

    return dateString;
}

- (NSString *)dateToString:(NSDate *)date withStyle:(NSDateFormatterStyle)style
{
    NSDateFormatterStyle currentDateStyle = [self dateStyle];

    [self setDateStyle:style];
    NSString *dateString = [self stringFromDate:date];

    [self setDateStyle:currentDateStyle];

    return dateString;
}

- (NSString *)dateTimeToString:(NSDate *)date withStyle:(NSDateFormatterStyle)style
{
    NSDateFormatterStyle currentDateStyle = [self dateStyle];
    NSDateFormatterStyle currentTimeStyle = [self timeStyle];

    [self setDateStyle:style];
    [self setTimeStyle:style];

    NSString *dateString = [self stringFromDate:date];

    [self setDateStyle:currentDateStyle];
    [self setTimeStyle:currentTimeStyle];

    return dateString;
}

- (NSString *)dateTimeToString:(NSDate *)date
{
    return [self dateToString:date withFormat:@"MM/dd/yy hh:mm aaa"];
}

+ (NSLocale *)newCultureNeutralLocale
{
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];

    return locale;
}

@end

@implementation NSDateComponents (MHVExtensions)

+ (BOOL)isEqualYearMonthDay:(NSDateComponents *)d1 and:(NSDateComponents *)d2
{
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
}

+ (NSComparisonResult)compareYearMonthDay:(NSDateComponents *)d1 and:(NSDateComponents *)d2
{
    NSInteger cmp = d1.year - d2.year;

    if (cmp != 0)
    {
        return (cmp > 0) ? NSOrderedDescending : NSOrderedAscending;
    }

    //
    // Year is equal
    //
    cmp = d1.month - d2.month;
    if (cmp != 0)
    {
        return (cmp > 0) ? NSOrderedDescending : NSOrderedAscending;
    }

    //
    // Month is equal
    //
    cmp = d1.day - d2.day;
    if (cmp != 0)
    {
        return (cmp > 0) ? NSOrderedDescending : NSOrderedAscending;
    }

    return NSOrderedSame;
}

@end

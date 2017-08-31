//
// XConvert.m
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
#import "XConverter.h"
#import "MHVLogger.h"

static int const c_xDateFormatCount = 6;
static NSString *s_xDateFormats[c_xDateFormatCount] =
{
    @"yyyy'-'MM'-'dd'T'HHmmss'Z'",          // Zulu form
    @"yyyy'-'MM'-'dd'T'HHmmss.SSS'Z'",      // Zulu form
    @"yyyy'-'MM'-'dd'T'HHmmss.SSSZZZZ",     // Time zone form
    @"yyyy'-'MM'-'dd'T'HHmmssZZZZ",          // Time zone form,
    @"yyyy'-'MM'-'dd",
    @"yy'-'MM'-'dd"
};

static NSString *const c_POSITIVEINF = @"INF";
static NSString *const c_NEGATIVEINF = @"-INF";
static NSString *const c_TRUE = @"true";
static NSString *const c_FALSE = @"false";

@interface XConverter ()

@property (nonatomic, strong) NSDateFormatter *parser;
@property (nonatomic, strong) NSDateFormatter *utcParser;
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSLocale *dateLocale;
@property (nonatomic, strong) NSMutableString *stringBuffer;

@end

@implementation XConverter

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _stringBuffer = [[NSMutableString alloc] init];
        MHVCHECK_NOTNULL(_stringBuffer);
    }

    return self;
}

- (BOOL)tryString:(NSString *)source toInt:(int *)result
{
    MHVCHECK_STRING(source);
    MHVCHECK_NOTNULL(result);
    
    NSScanner *scanner = [[NSScanner alloc] initWithString:source];

    return [scanner scanInt:result];
}

- (int)stringToInt:(NSString *)source
{
    int value = 0;

    if (![self tryString:source toInt:&value])
    {
        MHVLOG(@"Failed to parse stringToInt: %@", source);
        return -1;
    }

    return value;
}

- (BOOL)tryInt:(int)source toString:(NSString **)result
{
    MHVCHECK_NOTNULL(result);

    *result = [NSString stringWithFormat:@"%d", source];
    MHVCHECK_STRING(*result);

    return TRUE;
}

- (NSString *)intToString:(int)source
{
    NSString *result;

    if (![self tryInt:source toString:&result])
    {
        MHVLOG(@"Failed to parse intToString: %i", source);
        return nil;
    }

    return result;
}

- (BOOL)tryString:(NSString *)source toFloat:(float *)result
{
    MHVCHECK_STRING(source);
    MHVCHECK_NOTNULL(result);
    
    NSScanner *scanner = [[NSScanner alloc] initWithString:source];

    if ([scanner scanFloat:result])
    {
        return TRUE;
    }

    if ([source isEqualToString:c_NEGATIVEINF])
    {
        *result = -INFINITY;
        return TRUE;
    }

    if ([source isEqualToString:c_POSITIVEINF])
    {
        *result = INFINITY;
        return TRUE;
    }

    return FALSE;
}

- (float)stringToFloat:(NSString *)source
{
    float value = 0;

    if (![self tryString:source toFloat:&value])
    {
        MHVLOG(@"Failed to parse stringToFloat: %@", source);
        return -1;
    }

    return value;
}

- (BOOL)tryFloat:(float)source toString:(NSString **)result
{
    MHVCHECK_NOTNULL(result);

    if (source == -INFINITY)
    {
        *result = c_NEGATIVEINF;
        return TRUE;
    }

    if (source == INFINITY)
    {
        *result = c_POSITIVEINF;
        return TRUE;
    }

    *result = [NSString stringWithFormat:@"%f", source];
    MHVCHECK_STRING(*result);

    return TRUE;
}

- (NSString *)floatToString:(float)source
{
    NSString *string = nil;

    if (![self tryFloat:source toString:&string])
    {
        MHVLOG(@"Failed to parse floatToString: %f", source);
        return nil;
    }

    return string;
}

- (BOOL)tryString:(NSString *)source toDouble:(double *)result
{
    MHVCHECK_STRING(source);
    MHVCHECK_NOTNULL(result);
    
    NSScanner *scanner = [[NSScanner alloc] initWithString:source];

    if ([scanner scanDouble:result])
    {
        return TRUE;
    }

    if ([source isEqualToString:c_NEGATIVEINF])
    {
        *result = -INFINITY;
        return TRUE;
    }

    if ([source isEqualToString:c_POSITIVEINF])
    {
        *result = INFINITY;
        return TRUE;
    }

    return FALSE;
}

- (double)stringToDouble:(NSString *)source
{
    double value = 0;

    if (![self tryString:source toDouble:&value])
    {
        MHVLOG(@"Failed to parse stringToDouble: %@", source);
        return -1;
    }

    return value;
}

- (BOOL)tryDouble:(double)source toString:(NSString **)result
{
    MHVCHECK_NOTNULL(result);

    if (source == -INFINITY)
    {
        *result = c_NEGATIVEINF;
        return TRUE;
    }

    if (source == INFINITY)
    {
        *result = c_POSITIVEINF;
        return TRUE;
    }

    [self tryDoubleRoundtrip:source toString:result];
    MHVCHECK_STRING(*result);

    return TRUE;
}

//
// We have to do this to prevent loss of precision in doubles during serialization
// http://msdn.microsoft.com/en-us/library/dwhawy9k.aspx#RFormatString
//
- (BOOL)tryDoubleRoundtrip:(double)source toString:(NSString **)result
{
    NSString *asString = [NSString stringWithFormat:@"%.15g", source];

    MHVCHECK_NOTNULL(asString);

    double parsedBack = [self stringToDouble:asString];
    if (parsedBack == source)
    {
        *result = asString;
    }
    else
    {
        *result = [NSString stringWithFormat:@"%.17g", source];
    }

    return *result != nil;
}

- (NSString *)doubleToString:(double)source
{
    NSString *string = nil;

    if (![self tryDouble:source toString:&string])
    {
        MHVLOG(@"Failed to parse doubleToString: %f", source);
        return nil;
    }

    return string;
}

- (BOOL)tryString:(NSString *)source toBool:(BOOL *)result
{
    MHVCHECK_STRING(source);
    MHVCHECK_NOTNULL(result);
    
    [self.stringBuffer setString:source];

    MHVCHECK_TRUE((self.stringBuffer.length == source.length));

    if ([self.stringBuffer isEqualToString:c_TRUE])
    {
        *result = TRUE;
    }
    else if ([self.stringBuffer isEqualToString:c_FALSE])
    {
        *result =  FALSE;
    }
    else if ([self.stringBuffer isEqualToString:@"1"])
    {
        *result =  TRUE;
    }
    else if ([self.stringBuffer isEqualToString:@"0"])
    {
        *result =  FALSE;
    }
    else
    {
        return NO;
    }

    return TRUE;
}

- (BOOL)stringToBool:(NSString *)source
{
    BOOL value = FALSE;

    if (![self tryString:source toBool:&value])
    {
        MHVLOG(@"Failed to parse stringToBool: %@", source);
        return NO;
    }

    return value;
}

- (NSString *)boolToString:(BOOL)source
{
    return source ? c_TRUE : c_FALSE;
}

- (BOOL)tryString:(NSString *)source toDate:(NSDate **)result
{
    MHVCHECK_STRING(source);
    MHVCHECK_NOTNULL(result);

    //
    // Since NSDateFormatter is otherwise incapable of parsing xsd:datetime
    // ISO 8601 expresses UTC/GMT offsets as "2001-10-26T21:32:52+02:00"
    // DateFormatter does not like the : in the +02:00
    // So, we simply whack all : in the string, and change our dateformat strings accordingly
    //
    // Use a mutable string, so we don't have to keep allocating new strings
    //
    [self.stringBuffer setString:source];
    
    MHVCHECK_TRUE((self.stringBuffer.length == source.length));
    
    [self.stringBuffer replaceOccurrencesOfString:@":"
     withString:@""
     options:0
     range:NSMakeRange(0, self.stringBuffer.length)];

    NSDateFormatter *parser = [self ensureDateParser];
    for (int i = 0; i < c_xDateFormatCount; ++i)
    {
        NSString *format = s_xDateFormats[i];

        [parser setDateFormat:format];
        *result = [parser dateFromString:self.stringBuffer];
        if (*result)
        {
            return TRUE;
        }
    }

    NSTimeZone *tz = parser.timeZone;
    if (tz.isDaylightSavingTime)
    {
        *result = [self stringToDateWithWithDaylightSavings:self.stringBuffer inTimeZone:tz];
        if (*result)
        {
            return TRUE;
        }
    }

    return FALSE;
}

- (NSDate *)stringToDate:(NSString *)source
{
    NSDate *date = nil;

    if (![self tryString:source toDate:&date])
    {
        MHVLOG(@"Failed to parse stringToDate: %@", source);
        return nil;
    }

    return date;
}

- (BOOL)tryDate:(NSDate *)source toString:(NSString **)result
{
    MHVCHECK_NOTNULL(source);
    MHVCHECK_NOTNULL(result);

    NSDateFormatter *formatter = [self ensureDateFormatter];
    *result = [formatter stringFromDate:source];
    MHVCHECK_STRING(*result);

    return TRUE;
}

- (NSString *)dateToString:(NSDate *)source
{
    NSString *string = nil;

    if (![self tryDate:source toString:&string])
    {
        MHVLOG(@"Failed to parse dateToString: %@", source.description);
        return nil;
    }

    return string;
}

- (NSUUID *)stringToUuid:(NSString *)source
{
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:source];

    if (!uuid)
    {
        MHVLOG(@"Failed to parse stringToUdid: %@", source);
        return nil;
    }

    return uuid;
}

- (NSString *)uuidToString:(NSUUID *)uuid
{
    return [uuid UUIDString];
}

#pragma mark - Internal methods

- (NSDateFormatter *)ensureDateFormatter
{
    if (!self.formatter)
    {
        NSDateFormatter *formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH:mm:ss.SSS'Z'"]; // Zulu time format
        
        self.formatter = formatter;
        MHVCHECK_OOM(self.formatter);
        [self.formatter setLocale:[self ensureLocale]];
    }

    return self.formatter;
}

- (NSDateFormatter *)ensureDateParser
{
    if (!self.parser)
    {
        self.parser = [NSDateFormatter new];
        MHVCHECK_OOM(self.parser);
        [self.parser setLocale:[self ensureLocale]];
    }

    return self.parser;
}

- (NSDateFormatter *)ensureUtcDateParser
{
    if (!self.utcParser)
    {
        NSDateFormatter *formatter = [NSDateFormatter new];
        [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        
        self.utcParser = formatter;
        MHVCHECK_OOM(self.utcParser);
        [self.utcParser setLocale:[self ensureLocale]];
    }

    return self.utcParser;
}

- (NSCalendar *)ensureGregorianCalendar
{
    if (!self.calendar)
    {
        self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        MHVCHECK_OOM(self.calendar);
    }

    return self.calendar;
}

- (NSLocale *)ensureLocale
{
    if (!self.dateLocale)
    {
        self.dateLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        MHVCHECK_OOM(self.dateLocale);
    }

    return self.dateLocale;
}

//
// HealthVault dates can be time zone agnostic. This is because historical data from 3rd parties may never have captured the original time zone.
// Dates are always interpreted as 'local' - in whatever time zone the user is currently in.
//
// This means that you can end up with dates that never "existed" in some time zones because of Daylight
// Savings Time
// E.g. the local time 2014:03-09'T'02:30:00 is legal in India.
// But that particular time never existed in USA local time.
// Daylight savings went from 1.00 AM to 3.00 AM, skipping 2.00 am entirely.
//
// DateTimeFormatter, when running with local time zone, helpfully decides that since such dates do not exist, it must not return them.
// So we have to do this workaround
//
- (NSDate *)stringToDateWithWithDaylightSavings:(NSString *)source inTimeZone:(NSTimeZone *)tz
{
    NSDateFormatter *parser = [self ensureUtcDateParser];
    NSCalendar *calendar = [self ensureGregorianCalendar];

    for (int i = 0; i < c_xDateFormatCount; ++i)
    {
        NSString *format = s_xDateFormats[i];
        [parser setDateFormat:format];

        NSDate *utcDate = [parser dateFromString:source];
        if (utcDate)
        {
            NSTimeInterval daylightSavingsOffset = [tz daylightSavingTimeOffset];
            utcDate = [utcDate dateByAddingTimeInterval:daylightSavingsOffset];
            
            [calendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
            
            NSDateComponents *components = [calendar components:NSCalendarUnitDay       |
                                                                NSCalendarUnitMonth     |
                                                                NSCalendarUnitYear      |
                                                                NSCalendarUnitHour      |
                                                                NSCalendarUnitMinute    |
                                                                NSCalendarUnitSecond
                                                       fromDate:utcDate];
            [components setCalendar:calendar];
            [components setTimeZone:tz];

            NSDate *localDate = [components date];
            return localDate;
        }
    }

    return nil;
}

@end

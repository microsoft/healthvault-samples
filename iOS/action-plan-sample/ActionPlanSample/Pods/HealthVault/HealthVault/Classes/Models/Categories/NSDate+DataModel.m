//
// NSDate+DataModel.m
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

#import "NSDate+DataModel.h"
#import "MHVValidator.h"

@implementation NSDate (DataModel)

+ (NSArray*)dataModelDateFormatters
{
    static dispatch_once_t once;
    static NSArray *formatters = nil;
    
    dispatch_once(&once, ^{
        NSDateFormatter *genericFormatter = [NSDateFormatter new];
        [genericFormatter setDateFormat:kISOGenericDateFormatterString];
        [genericFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];

        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:kISODateFormatterString];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];

        NSDateFormatter *timeZoneFormatter = [NSDateFormatter new];
        [timeZoneFormatter setDateFormat:kISODateWithTimeZoneFormatterString];
        [timeZoneFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];

        NSDateFormatter *activityFormatter = [NSDateFormatter new];
        [activityFormatter setDateFormat:kISOActivityHistoryDateFormatterString];
        [activityFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];

        NSDateFormatter *defaultFormatter = [NSDateFormatter new];
        [defaultFormatter setDateFormat:kISOBirthDateFormatterString];
        [defaultFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        formatters = @[genericFormatter, dateFormatter, timeZoneFormatter, activityFormatter, defaultFormatter];
    });
    return formatters;
}

- (instancetype)initWithObject:(id)object objectParameters:(NSDateFormatter*)formatter
{
    if (!object || [object isKindOfClass:[NSNull class]])
    {
        return nil;
    }
    else if ([object isKindOfClass:[NSDate class]])
    {
        self = [object copy];
    }
    else if ([object isKindOfClass:[NSString class]])
    {
        NSString *string = (NSString*)object;
        NSDate *date = [formatter dateFromString:string];
        if (!date)
        {
            //Try and parse the date using all the possible formatters
            for (NSInteger i = 0; i < [NSDate dataModelDateFormatters].count && !date; i++)
            {
                date = [[NSDate dataModelDateFormatters][i] dateFromString:string];
                
                //TODO: Could persist the successful formatter as associatedObject, for re-serializing later...
            }
        }
        
        if (date)
        {
            //Compiler warning if there isn't an init call in this method, do this initWithTimeInterval:0 to avoid
            self = [self initWithTimeInterval:0 sinceDate:date];
        }
        else
        {
            return nil;
        }
    }
    else
    {
        MHVASSERT_TRUE(NO, [NSString stringWithFormat:@"Unsupported class: %@", NSStringFromClass([object class])]);
    }
    return self;
}

- (NSString*)jsonRepresentationWithObjectParameters:(NSDateFormatter*)formatter
{
    //Allow nil formatter, for HealthVault
    if (!formatter)
    {
        formatter = [NSDateFormatter new];
        [formatter setDateFormat:kISOGenericDateFormatterString];
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }
    
    NSString *string = [formatter stringFromDate:self];
    if (string)
    {
        return [NSString stringWithFormat:@"\"%@\"", [formatter stringFromDate:self]];
    }
    return @"null";
}

@end

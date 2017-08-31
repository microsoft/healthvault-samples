//
// MHVDateTimeBase.m
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

#import <Foundation/Foundation.h>
#import "MHVDateTimeBase.h"

@implementation MHVDateTimeBase

- (instancetype)init
{
    return [self initWithDate:[NSDate date]];
}

- (instancetype)initWithDate:(NSDate *)date
{
    self = [super init];

    if (self)
    {
        self.date = date;
    }

    return self;
}

- (instancetype)initWithObject:(id)object objectParameters:(NSObject *)parameters
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:[self dateFormatString]];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    self = [super init];
    if (self)
    {
        if ([object isKindOfClass:[NSString class]])
        {
            self.date = [dateFormatter dateFromString:object];
        }
    }
    return self;
}

- (NSString*)dateFormatString
{
    return @"yyyy-MM-dd'T'HH:mm";
}

- (NSString*)description
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat: self.dateFormatString];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    return [formatter stringFromDate:self.date];
}

- (NSString *)jsonRepresentationWithObjectParameters:(NSObject *)ignored
{
    return [NSString stringWithFormat:@"\"%@\"", [self description]];
}

@end

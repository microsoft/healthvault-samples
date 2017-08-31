//
// MHVLocalDateTime.m
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
#import "MHVZonedDateTime.h"

@interface MHVZonedDateTime()

@property (nonatomic, strong) NSTimeZone* timeZone;

@end

@implementation MHVZonedDateTime

- (NSString*)dateFormatString
{
    return @"yyyy-MM-dd'T'HH:mm:ssX VV";
}

- (instancetype)initWithObject:(id)object objectParameters:(NSObject *)parameters
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:[self dateFormatString]];
    
    self = [super init];
    if (self)
    {
        if ([object isKindOfClass:[NSString class]])
        {
            self.date = [dateFormatter dateFromString:object];

            if (self.date != nil)
            {
                NSArray* parts = [object componentsSeparatedByString:@" "];

                if (parts.count > 1)
                {
                    NSTimeZone* zone = [NSTimeZone timeZoneWithName:[parts objectAtIndex:1]];

                    if (zone != nil)
                    {
                        self.timeZone = zone;
                    }
                }
            }
        }
    }
    
    return self;
}

- (NSString*)description
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat: self.dateFormatString];

    if (self.timeZone != nil)
    {
        [formatter setTimeZone:self.timeZone];
    }

    return [formatter stringFromDate:self.date];
}

@end

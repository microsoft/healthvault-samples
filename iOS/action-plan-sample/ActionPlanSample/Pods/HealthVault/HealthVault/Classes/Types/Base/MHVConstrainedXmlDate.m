//
// MHVConstrainedXmlDate.m
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

#import "MHVConstrainedXmlDate.h"
#import "MHVValidator.h"

static NSString *const c_maxDate = @"9999-12-31T00:00:00";
static NSString *const c_maxDatePrefix = @"9999";

@implementation MHVConstrainedXmlDate

- (BOOL)isNull
{
    return !self.value;
}

- (instancetype)init
{
    return [self initWith:nil];
}

- (instancetype)initWith:(NSDate *)value
{
    self = [super init];
    MHVCHECK_SELF;

    if (value)
    {
        _value = value;
    }

    return self;
}

- (NSString *)description
{
    return [self toString];
}

- (NSString *)toString
{
    return [self toStringWithFormat:@"%d"];
}

- (NSString *)toStringWithFormat:(NSString *)format
{
    if (!self.value)
    {
        return nil;
    }
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:format];

    return [formatter stringFromDate:self.value];
}

- (void)serialize:(XWriter *)writer
{
    if (self.value)
    {
        [writer writeDate:self.value];
    }
    else
    {
        // Special magic value MHV uses to Remove this entry
        [writer writeText:c_maxDate];
    }
}

- (void)deserialize:(XReader *)reader
{
    NSString *text = [reader readString];

    if ((!text || [text isEqualToString:@""])|| [text hasPrefix:c_maxDatePrefix])
    {
        self.value = nil;
        return;
    }

    NSDate *date = nil;
    if ([reader.converter tryString:text toDate:&date] && date)
    {
        self.value = date;
    }
}

+ (MHVConstrainedXmlDate *)fromDate:(NSDate *)date
{
    return [[MHVConstrainedXmlDate alloc] initWith:date];
}

+ (MHVConstrainedXmlDate *)nullDate
{
    return [[MHVConstrainedXmlDate alloc] init];
}

@end

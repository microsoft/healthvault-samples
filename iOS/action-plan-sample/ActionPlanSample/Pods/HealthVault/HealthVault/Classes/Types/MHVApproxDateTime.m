//
// MHVApproxDateTime.m
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

#import "MHVApproxDateTime.h"
#import "MHVValidator.h"

static NSString *const c_element_descriptive = @"descriptive";
static NSString *const c_element_structured = @"structured";

@implementation MHVApproxDateTime

- (void)setDescriptive:(NSString *)descriptive
{
    if (!descriptive || [descriptive isEqualToString:@""])
    {
        _dateTime = nil;
    }
    
    _descriptive = descriptive;
}

- (void)setDateTime:(MHVDateTime *)dateTime
{
    if (dateTime)
    {
        _descriptive = nil;
    }
    
    _dateTime = dateTime;
}

- (BOOL)isStructured
{
    return self.dateTime != nil;
}

- (instancetype)initWithDescription:(NSString *)descr
{
    MHVCHECK_NOTNULL(descr);
    
    self = [super init];
    if (self)
    {
        _descriptive = descr;
    }
    return self;
}

- (instancetype)initWithDate:(NSDate *)date
{
    MHVDateTime *dateTime = [[MHVDateTime alloc] initWithDate:date];
    
    MHVCHECK_NOTNULL(dateTime);
    
    self = [self initWithDateTime:dateTime];
    
    return self;
}

- (instancetype)initWithDateTime:(MHVDateTime *)dateTime
{
    MHVCHECK_NOTNULL(dateTime);
    
    self = [super init];
    if (self)
    {
        _dateTime = dateTime;
    }
    
    return self;
}

- (instancetype)initNow
{
    return [self initWithDate:[NSDate date]];
}

+ (MHVApproxDateTime *)fromDate:(NSDate *)date
{
    return [[MHVApproxDateTime alloc] initWithDate:date];
}

+ (MHVApproxDateTime *)fromDescription:(NSString *)descr
{
    return [[MHVApproxDateTime alloc] initWithDescription:descr];
}

+ (MHVApproxDateTime *)now
{
    return [[MHVApproxDateTime alloc] initNow];
}

- (NSString *)description
{
    return [self toString];
}

- (NSString *)toString
{
    if (self.dateTime)
    {
        return [self.dateTime toString];
    }
    
    return (self.descriptive) ? self.descriptive : @"";
}

- (NSString *)toStringWithFormat:(NSString *)format
{
    if (self.dateTime)
    {
        return [self.dateTime toStringWithFormat:format];
    }
    
    return (self.descriptive) ? self.descriptive : @"";
}

- (NSDate *)toDate
{
    if (self.dateTime)
    {
        return [self.dateTime toDate];
    }
    
    return nil;
}

- (NSDate *)toDateForCalendar:(NSCalendar *)calendar
{
    if (self.dateTime)
    {
        return [self.dateTime toDateForCalendar:calendar];
    }
    
    return nil;
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN
    //
    // The data type is a choice. You can do one or the other
    //
    MHVVALIDATE_TRUE((self.dateTime || self.descriptive), MHVClientError_InvalidApproxDateTime);
    
    MHVVALIDATE_TRUE((!(self.dateTime && self.descriptive)), MHVClientError_InvalidApproxDateTime);
    
    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_descriptive value:self.descriptive];
    [writer writeElement:c_element_structured content:self.dateTime];
}

- (void)deserialize:(XReader *)reader
{
    self.descriptive = [reader readStringElement:c_element_descriptive];
    self.dateTime = [reader readElement:c_element_structured asClass:[MHVDateTime class]];
}

@end

//
// MHVHeight.m
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

#import "MHVHeight.h"
#import "MHVValidator.h"

static NSString *const c_typeid = @"40750a6a-89b2-455c-bd8d-b420a4cb500b";
static NSString *const c_typename = @"height";

static const xmlChar *x_element_when = XMLSTRINGCONST("when");
static const xmlChar *x_element_value = XMLSTRINGCONST("value");

@implementation MHVHeight

- (NSDate *)getDate
{
    return [self.when toDate];
}

- (NSDate *)getDateForCalendar:(NSCalendar *)calendar
{
    return [self.when toDateForCalendar:calendar];
}

- (double)inMeters
{
    return (self.value) ? self.value.inMeters : NAN;
}

- (void)setInMeters:(double)inMeters
{
    if (!self.value)
    {
        self.value = [[MHVLengthMeasurement alloc] init];
    }
    
    self.value.inMeters = inMeters;
}

- (double)inInches
{
    return (self.value) ? self.value.inInches : NAN;
}

- (void)setInInches:(double)inInches
{
    if (!self.value)
    {
        self.value = [[MHVLengthMeasurement alloc] init];
    }
    
    self.value.inInches = inInches;
}

- (instancetype)initWithMeters:(double)meters andDate:(NSDate *)date
{
    self = [super init];
    if (self)
    {
        [self setInMeters:meters];
        MHVCHECK_NOTNULL(_value);
        
        _when = [[MHVDateTime alloc] initWithDate:date];
        MHVCHECK_NOTNULL(_when);
    }
    
    return self;
}

- (instancetype)initWithInches:(double)inches andDate:(NSDate *)date
{
    self = [super init];
    if (self)
    {
        [self setInInches:inches];
        MHVCHECK_NOTNULL(_value);
        
        _when = [[MHVDateTime alloc] initWithDate:date];
        MHVCHECK_NOTNULL(_when);
    }
    
    return self;
}

- (NSString *)stringInMeters:(NSString *)format
{
    return (self.value) ? [self.value stringInMeters:format] : @"";
}

- (NSString *)stringInInches:(NSString *)format
{
    return (self.value) ? [self.value stringInInches:format] : @"";
}

- (NSString *)stringInFeetAndInches:(NSString *)format
{
    return (self.value) ? [self.value stringInFeetAndInches:format] : @"";
}

- (NSString *)toString
{
    return (self.value) ? [self.value toString] : @"";
}

- (NSString *)description
{
    return [self toString];
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN;
    
    MHVVALIDATE(self.when, MHVClientError_InvalidWeight);
    MHVVALIDATE(self.value, MHVClientError_InvalidWeight);
    
    MHVVALIDATE_SUCCESS;
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementXmlName:x_element_when content:self.when];
    [writer writeElementXmlName:x_element_value content:self.value];
}

- (void)deserialize:(XReader *)reader
{
    self.when = [reader readElementWithXmlName:x_element_when asClass:[MHVDateTime class]];
    self.value = [reader readElementWithXmlName:x_element_value asClass:[MHVLengthMeasurement class]];
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
    return [[MHVThing alloc] initWithType:[MHVHeight typeID]];
}

- (NSString *)typeName
{
    return NSLocalizedString(@"Height", @"Height Type Name");
}

@end

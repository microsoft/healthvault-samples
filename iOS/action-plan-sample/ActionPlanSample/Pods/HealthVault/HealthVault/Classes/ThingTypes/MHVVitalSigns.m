//
// MHVVitalSigns.m
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
#import "MHVValidator.h"
#import "MHVVitalSigns.h"
#import "NSArray+Utils.h"

static NSString *const c_typeid = @"73822612-c15f-4b49-9e65-6af369e55c65";
static NSString *const c_typename = @"vital-signs";

static NSString *const c_element_when = @"when";
static NSString *const c_element_results = @"vital-signs-results";
static NSString *const c_element_site = @"site";
static NSString *const c_element_position = @"position";

@implementation MHVVitalSigns

- (BOOL)hasResults
{
    return ![NSArray isNilOrEmpty:self.results];
}

- (NSArray<MHVVitalSignResult *> *)results
{
    if (!_results)
    {
        _results = @[];
    }
    
    return _results;
}

- (MHVVitalSignResult *)firstResult
{
    return (self.hasResults) ? [self.results objectAtIndex:0] : nil;
}

- (NSDate *)getDate
{
    return [self.when toDate];
}

- (NSDate *)getDateForCalendar:(NSCalendar *)calendar
{
    return [self.when toDateForCalendar:calendar];
}

- (instancetype)initWithDate:(NSDate *)date
{
    return [self initWithResult:nil onDate:date];
}

- (instancetype)initWithResult:(MHVVitalSignResult *)result onDate:(NSDate *)date
{
    MHVCHECK_NOTNULL(date);
    
    self = [super init];
    if (self)
    {
        _when = [[MHVDateTime alloc] initWithDate:date];
        MHVCHECK_NOTNULL(_when);
        
        if (result)
        {
            _results = @[result];
            MHVCHECK_NOTNULL(_results);
        }
    }
    
    return self;
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN
    
    MHVVALIDATE(self.when, MHVClientError_InvalidVitalSigns);
    MHVVALIDATE_ARRAYOPTIONAL(self.results, MHVClientError_InvalidVitalSigns);
    MHVVALIDATE_STRINGOPTIONAL(self.site, MHVClientError_InvalidVitalSigns);
    MHVVALIDATE_STRINGOPTIONAL(self.position, MHVClientError_InvalidVitalSigns);
    
    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_when content:self.when];
    [writer writeElementArray:c_element_results elements:self.results];
    [writer writeElement:c_element_site value:self.site];
    [writer writeElement:c_element_position value:self.position];
}

- (void)deserialize:(XReader *)reader
{
    self.when = [reader readElement:c_element_when asClass:[MHVDateTime class]];
    self.results = [reader readElementArray:c_element_results asClass:[MHVVitalSignResult class] andArrayClass:[NSMutableArray class]];
    self.site = [reader readStringElement:c_element_site];
    self.position = [reader readStringElement:c_element_position];
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
    return [[MHVThing alloc] initWithType:[MHVVitalSigns typeID]];
}

@end

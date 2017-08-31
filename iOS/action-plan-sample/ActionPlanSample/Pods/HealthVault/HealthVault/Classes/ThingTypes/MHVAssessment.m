//
// MHVAssessment.m
// MHVLib
//
// Copyright (c) 2017 Microsoft Corporation. All rights reserved.

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

#import "MHVAssessment.h"
#import "MHVValidator.h"

static NSString *const c_typeid = @"58fd8ac4-6c47-41a3-94b2-478401f0e26c";
static NSString *const c_typename = @"health-assessment";

static NSString *const c_element_when = @"when";
static NSString *const c_element_name = @"name";
static NSString *const c_element_category = @"category";
static NSString *const c_element_result = @"result";

@implementation MHVAssessment

- (NSArray<MHVAssessmentField *> *)results
{
    if (!_results)
    {
        _results = @[];
    }

    return _results;
}

- (NSDate *)getDate
{
    return [self.when toDate];
}

- (NSDate *)getDateForCalendar:(NSCalendar *)calendar
{
    return [self.when toDateForCalendar:calendar];
}

- (NSString *)description
{
    return [self toString];
}

- (NSString *)toString
{
    return self.name ? self.name : @"";
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN

    MHVVALIDATE(self.when, MHVClientError_InvalidAssessment);
    MHVVALIDATE_STRING(self.name, MHVClientError_InvalidAssessment);
    MHVVALIDATE(self.category, MHVClientError_InvalidAssessment);
    MHVVALIDATE_ARRAY(self.results, MHVClientError_InvalidAssessment);

    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_when content:self.when];
    [writer writeElement:c_element_name value:self.name];
    [writer writeElement:c_element_category content:self.category];
    [writer writeElementArray:c_element_result elements:self.results];
}

- (void)deserialize:(XReader *)reader
{
    self.when = [reader readElement:c_element_when asClass:[MHVDateTime class]];
    self.name = [reader readStringElement:c_element_name];
    self.category = [reader readElement:c_element_category asClass:[MHVCodableValue class]];
    self.results = [reader readElementArray:c_element_result
                                    asClass:[MHVAssessmentField class]
                              andArrayClass:[NSMutableArray class]];
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
    return [[MHVThing alloc] initWithType:[MHVAssessment typeID]];
}

@end

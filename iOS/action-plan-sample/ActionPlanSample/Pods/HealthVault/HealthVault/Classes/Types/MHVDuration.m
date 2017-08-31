//
// MHVDuration.m
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

#import "MHVDuration.h"
#import "MHVValidator.h"

static NSString *const c_element_start = @"start-date";
static NSString *const c_element_end = @"end-date";

@implementation MHVDuration

- (instancetype)initWithStartDate:(NSDate *)start endDate:(NSDate *)end
{
    MHVCHECK_NOTNULL(start);
    MHVCHECK_NOTNULL(end);

    self = [super init];
    if (self)
    {
        _startDate = [[MHVApproxDateTime alloc] initWithDate:start];
        MHVCHECK_NOTNULL(_startDate);

        _endDate = [[MHVApproxDateTime alloc] initWithDate:end];
        MHVCHECK_NOTNULL(_endDate);
    }

    return self;
}

- (instancetype)initWithDate:(NSDate *)start andDurationInSeconds:(double)duration
{
    return [self initWithStartDate:start endDate:[start dateByAddingTimeInterval:duration]];
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN

    MHVVALIDATE(self.startDate, MHVClientError_InvalidDuration);
    MHVVALIDATE(self.endDate, MHVClientError_InvalidDuration);

    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_start content:self.startDate];
    [writer writeElement:c_element_end content:self.endDate];
}

- (void)deserialize:(XReader *)reader
{
    self.startDate = [reader readElement:c_element_start asClass:[MHVApproxDateTime class]];
    self.endDate = [reader readElement:c_element_end asClass:[MHVApproxDateTime class]];
}

@end

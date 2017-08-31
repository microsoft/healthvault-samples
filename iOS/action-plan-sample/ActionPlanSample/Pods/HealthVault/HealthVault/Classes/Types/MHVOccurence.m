//
// MHVOccurence.m
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
#import "MHVOccurence.h"

static NSString *const c_element_when = @"when";
static NSString *const c_element_minutes = @"minutes";

@implementation MHVOccurence

- (instancetype)initForDuration:(int)minutes startingAt:(MHVTime *)time
{
    MHVCHECK_NOTNULL(time);

    self = [super init];
    if (self)
    {
        _when = time;

        _durationMinutes = [[MHVNonNegativeInt alloc] initWith:minutes];
        MHVCHECK_NOTNULL(_durationMinutes);
    }

    return self;
}

- (instancetype)initForDuration:(int)minutes startingAtHour:(int)hour andMinute:(int)minute
{
    MHVTime *time = [[MHVTime alloc] initWithHour:hour minute:minute];

    MHVCHECK_NOTNULL(time);

    return [self initForDuration:minutes startingAt:time];
}

+ (MHVOccurence *)forDuration:(int)minutes atHour:(int)hour andMinute:(int)minute
{
    return [[MHVOccurence alloc] initForDuration:minutes startingAtHour:hour andMinute:minute];
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN

    MHVVALIDATE(self.when, MHVClientError_InvalidOccurrence);
    MHVVALIDATE(self.durationMinutes, MHVClientError_InvalidOccurrence);

    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_when content:self.when];
    [writer writeElement:c_element_minutes content:self.durationMinutes];
}

- (void)deserialize:(XReader *)reader
{
    self.when = [reader readElement:c_element_when asClass:[MHVTime class]];
    self.durationMinutes = [reader readElement:c_element_minutes asClass:[MHVNonNegativeInt class]];
}

@end


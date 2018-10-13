//
//  MHVTaskCompletionMetrics.m
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

#import "MHVTaskCompletionMetrics.h"

static NSString *const c_element_recurrence_type = @"recurrence-type";
static NSString *const c_element_completion_type = @"completion-type";
static NSString *const c_element_occurrence_count = @"occurrence-count";

@implementation MHVTaskCompletionMetrics

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_recurrence_type value:self.recurrenceType.stringValue];
    [writer writeElement:c_element_completion_type value:self.completionType.stringValue];
    [writer writeElement:c_element_occurrence_count content:self.occurrenceCount];
}

- (void)deserialize:(XReader *)reader
{
    self.recurrenceType = [[MHVTimelineSnapshotCompletionMetricsRecurrenceTypeEnum alloc] initWithString:[reader readStringElement:c_element_recurrence_type]];
    self.completionType =  [[MHVActionPlanTaskCompletionTypeEnum alloc] initWithString:[reader readStringElement:c_element_completion_type]];
    self.occurrenceCount = [reader readElement:c_element_occurrence_count asClass:[MHVPositiveInt class]];
}

@end

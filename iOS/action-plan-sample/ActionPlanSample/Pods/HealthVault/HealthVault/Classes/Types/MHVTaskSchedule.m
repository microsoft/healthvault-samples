//
//  MHVTaskSchedule.m
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

#import "MHVTaskSchedule.h"

static NSString *const c_element_start_date_time = @"start-date-time";
static NSString *const c_element_end_date_time = @"end-date-time";
static NSString *const c_element_schedule_type = @"schedule-type";
static NSString *const c_element_recurrence_type = @"recurrence-type";
static NSString *const c_element_group_id = @"group-id";
static NSString *const c_element_multiple = @"multiple";
static NSString *const c_element_minutes_to_remind_before = @"minutes-to-remind-before";
static NSString *const c_element_adherence_window_in_minutes = @"adherence-window-in-minutes";

@implementation MHVTaskSchedule

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_start_date_time content:self.startDateTime];
    [writer writeElement:c_element_end_date_time content:self.endDateTime];
    [writer writeElement:c_element_schedule_type value:self.scheduleType.stringValue];
    [writer writeElement:c_element_recurrence_type value:self.recurrenceType.stringValue];
    [writer writeElement:c_element_group_id content:self.groupId];
    [writer writeElement:c_element_multiple content:self.multiple];
    [writer writeElement:c_element_minutes_to_remind_before content:self.minutesToRemindBefore];
    [writer writeElement:c_element_adherence_window_in_minutes content:self.adherenceWindowInMinutes];
}

- (void)deserialize:(XReader *)reader
{
    self.startDateTime = [reader readElement:c_element_start_date_time asClass:[MHVDateTime class]];
    self.endDateTime = [reader readElement:c_element_end_date_time asClass:[MHVDateTime class]];
    self.scheduleType = [[MHVTimelineScheduleTypeEnum alloc] initWithString:[reader readStringElement:c_element_schedule_type]];
    self.recurrenceType = [[MHVTimelineSnapshotCompletionMetricsRecurrenceTypeEnum alloc] initWithString:[reader readStringElement:c_element_recurrence_type]];
    self.groupId = [reader readElement:c_element_group_id asClass:[MHVStringNZNW class]];
    self.multiple = [reader readElement:c_element_multiple asClass:[MHVStringNZNW class]];
    self.minutesToRemindBefore = [reader readElement:c_element_minutes_to_remind_before asClass:[MHVNonNegativeDouble class]];
    self.adherenceWindowInMinutes = [reader readElement:c_element_adherence_window_in_minutes asClass:[MHVNonNegativeDouble class]];
}

@end

static NSString *const c_element_schedule = @"schedule";

@implementation MHVTaskSchedules

- (void)serialize:(XWriter *)writer
{
    [writer writeElementArray:c_element_schedule elements:self.schedule];
}

- (void)deserialize:(XReader *)reader
{
    self.schedule = [reader readElementArray:c_element_schedule asClass:[MHVTaskSchedule class] andArrayClass:[NSMutableArray class]];
}

@end

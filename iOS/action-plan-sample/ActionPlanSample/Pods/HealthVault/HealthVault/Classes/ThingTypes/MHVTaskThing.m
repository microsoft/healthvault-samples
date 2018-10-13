//
//  MHVTasktThing.m
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

#import "MHVTaskThing.h"

static NSString *const c_typeid = @"6184d61f-4846-4219-b675-b61de85860d1";
static NSString *const c_typename = @"task";

static NSString *const c_element_date_started = @"date-started";
static NSString *const c_element_name = @"name";
static NSString *const c_element_short_description = @"short-description";
static NSString *const c_element_long_descrption = @"long-description";
static NSString *const c_element_is_reminder_enabled = @"is-reminder-enabled";
static NSString *const c_element_status = @"status";
static NSString *const c_element_task_key = @"task-key";
static NSString *const c_element_type = @"type";
static NSString *const c_element_schedules = @"schedules";
static NSString *const c_element_tracking_policy = @"tracking-policy";
static NSString *const c_element_associated_objective_ids = @"associated-objective-ids";

@implementation MHVTaskThing

-(void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_date_started content:self.dateStarted];
    [writer writeElement:c_element_name content:self.name];
    [writer writeElement:c_element_short_description content:self.shortDescription];
    [writer writeElement:c_element_long_descrption content:self.longDescription];
    [writer writeElement:c_element_is_reminder_enabled content:self.isReminderEnabled];
    [writer writeElement:c_element_status value:self.status.stringValue];
    [writer writeElement:c_element_task_key value:self.taskKey];
    [writer writeElement:c_element_type value:self.taskType.UUIDString];
    [writer writeElement:c_element_schedules content:self.schedules];
    [writer writeElement:c_element_tracking_policy content:self.trackingPolicy];
    [writer writeElement:c_element_associated_objective_ids content:self.associatedObjectiveIds];
}

-(void)deserialize:(XReader *)reader
{
    self.dateStarted = [reader readElement:c_element_date_started asClass:[MHVDateTime class]];
    self.name = [reader readElement:c_element_name asClass:[MHVStringNZNW class]];
    self.shortDescription = [reader readElement:c_element_short_description asClass:[MHVString128 class]];
    self.longDescription = [reader readElement:c_element_long_descrption asClass:[MHVStringNZNW class]];
    self.isReminderEnabled = [reader readElement:c_element_is_reminder_enabled asClass:[MHVBool class]];
    self.status = [[MHVActionPlanTaskInstanceStatusEnum alloc] initWithString:[reader readStringElement:c_element_status]];
    self.taskKey = [reader readStringElement:c_element_task_key];
    self.taskType = [[NSUUID alloc] initWithUUIDString:[reader readStringElement:c_element_type]];
    self.schedules = [reader readElement:c_element_schedules asClass:[MHVTaskSchedules class]];
    self.trackingPolicy = [reader readElement:c_element_tracking_policy asClass:[MHVTaskTrackingPolicy class]];
    self.associatedObjectiveIds = [reader readElement:c_element_associated_objective_ids asClass:[MHVUUID class]];
}

+ (NSString *)typeID
{
    return c_typeid;
}

+ (NSString *)XRootElement
{
    return c_typename;
}

@end


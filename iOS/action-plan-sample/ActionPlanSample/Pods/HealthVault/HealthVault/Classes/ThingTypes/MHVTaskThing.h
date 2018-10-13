//
//  MHVTaskThing.h
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

#import "MHVThing.h"
#import "MHVDateTime.h"
#import "MHVTaskSchedule.h"
#import "MHVString128.h"
#import "MHVTaskTrackingPolicy.h"
#import "MHVUUID.h"
#import "MHVActionPlanTaskInstance.h"

@interface MHVTaskThing : MHVThingDataTyped

//
// (Required) The date the user started performing this task as part of their plan.
//
@property (readwrite, nonatomic, strong) MHVDateTime *dateStarted;
//
// (Required) The task name.
//
@property (readwrite, nonatomic, strong) MHVStringNZNW *name;
//
// (Required) A brief description of the task.
//
@property (readwrite, nonatomic, strong) MHVString128 *shortDescription;
//
// (Required) A more detailed description of the task.
//
@property (readwrite, nonatomic, strong) MHVStringNZNW *longDescription;
//
// (Optional) Whether the user should receive a reminder at the task's scheduled time.
//
@property (readwrite, nonatomic, strong) MHVBool *isReminderEnabled;
//
// (Required) The task status.
//
@property (readwrite, nonatomic, strong) MHVActionPlanTaskInstanceStatusEnum *status;
//
// (Optional) The task key a provider sets and maintains for a user's created task.
//
@property (readwrite, nonatomic, strong) NSString *taskKey;
//
// (Optional) For a task whose completion is tied to recording a specific health measurement or other piece of data, this indicates the item type to be recorded.
//
@property (readwrite, nonatomic, strong) NSUUID *taskType;
//
// (Optional) The schedule of when the task is to be performed.
//
@property (readwrite, nonatomic, strong) MHVTaskSchedules *schedules;
//
// (Optional) The rules for tracking task completion.
//
@property (readwrite, nonatomic, strong) MHVTaskTrackingPolicy *trackingPolicy;
//
// (Optional) The plan objectives that completion of this task counts towards.
//
@property (readwrite, nonatomic, strong) MHVUUID *associatedObjectiveIds;

@end


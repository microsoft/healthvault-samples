//
//  MHVTaskSchedule.h
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

#import "MHVType.h"
#import "MHVDateTime.h"
#import "MHVStringNZNW.h"
#import "MHVPositiveInt.h"
#import "MHVNonNegativeDouble.h"
#import "MHVTimelineSchedule.h"
#import "MHVTimelineSnapshotCompletionMetrics.h"

@interface MHVTaskSchedule : MHVType

@property (readwrite, nonatomic, strong) MHVDateTime *startDateTime;
@property (readwrite, nonatomic, strong) MHVDateTime *endDateTime;
@property (readwrite, nonatomic, strong) MHVTimelineScheduleTypeEnum *scheduleType;
@property (readwrite, nonatomic, strong) MHVTimelineSnapshotCompletionMetricsRecurrenceTypeEnum *recurrenceType;
@property (readwrite, nonatomic, strong) MHVStringNZNW *groupId;
@property (readwrite, nonatomic, strong) MHVPositiveInt *multiple;
@property (readwrite, nonatomic, strong) MHVNonNegativeDouble *minutesToRemindBefore;
@property (readwrite, nonatomic, strong) MHVNonNegativeDouble *adherenceWindowInMinutes;

@end

@interface MHVTaskSchedules : MHVType

@property (readwrite, nonatomic, strong) NSArray<MHVTaskSchedule *> *schedule;

@end


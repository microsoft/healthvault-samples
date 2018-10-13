//
//  MHVTaskTrackingEntry.h
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
#import "MHVActionPlanTaskTracking.h"

@interface MHVTaskTrackingEntry : MHVThingDataTyped

//
// (Required) When the entry was recorded.
//
@property (readwrite, nonatomic, strong) MHVDateTime *trackingTime;
//
// (Required) The method by which the tracking entry was triggered.
//
@property (readwrite, nonatomic, strong) MHVActionPlanTaskTrackingTrackingTypeEnum *trackingType;
//
// (Required) The task adherence or completion status represented by this tracking entry.
//
@property (readwrite, nonatomic, strong) MHVActionPlanTaskTrackingTrackingStatusEnum *trackingStatus;
//
// (Optional) When the occurrence window began.
//
@property (readwrite, nonatomic, strong) MHVDateTime *occurrenceStartTime;
//
// (Optional) When the occurrence window ended.
//
@property (readwrite, nonatomic, strong) MHVDateTime *occurrenceEndTime;
//
// (Required) When the completion window began.
//
@property (readwrite, nonatomic, strong) MHVDateTime *completionStartTime;
//
// (Required) When the completion window ended.
//
@property (readwrite, nonatomic, strong) MHVDateTime *completionEndTime;

@end

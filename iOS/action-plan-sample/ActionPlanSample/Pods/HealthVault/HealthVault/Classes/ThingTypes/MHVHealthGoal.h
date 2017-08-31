//
//  MHVHealthGoal.h
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
#import "MHVGoalAssociatedTypeInfo.h"
#import "MHVGoalRangeType.h"
#import "MHVGoalRecurrence.h"

@interface MHVHealthGoal : MHVThingDataTyped

// -------------------------
//
// Data
//
// -------------------------
//
// (Required) Name of the goal.
//
@property (readwrite, nonatomic, strong) MHVCodableValue *name;
//
// (Optional) Description of the goal.
//
@property (readwrite, nonatomic, strong) NSString *descriptionText;
//
// (Optional) The start date of the goal.
//
@property (readwrite, nonatomic, strong) MHVApproxDateTime *startDate;
//
// (Optional) The end date of the goal.
//
@property (readwrite, nonatomic, strong) MHVApproxDateTime *endDate;
//
// (Optional) Specifies HealthVault type information related to this goal.
//
@property (readwrite, nonatomic, strong) MHVGoalAssociatedTypeInfo *associatedTypeInfo;
//
// (Optional) The target range for the goal.
//
@property (readwrite, nonatomic, strong) MHVGoalRangeType *targetRange;
//
// (Optional) Allows specifying additional ranges for the goal.
//
@property (readwrite, nonatomic, strong) NSArray<MHVGoalRangeType *> *goalAdditionalRanges;
//
// (Optional) This field allows defining recurrence for goals.	
//
@property (readwrite, nonatomic, strong) MHVGoalRecurrence *recurrence;

@end

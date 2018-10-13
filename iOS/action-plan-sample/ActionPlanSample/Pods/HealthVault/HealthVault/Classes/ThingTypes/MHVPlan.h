//
//  MHVPlan.h
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
#import "MHVStringNZNW.h"
#import "MHVActionPlan.h"
#import "MHVActionPlanInstance.h"
#import "MHVPlanObjective.h"

@interface MHVPlan : MHVThingDataTyped

//
// (Required) The localized plan name.
//
@property (readwrite, nonatomic, strong) MHVStringNZNW *name;
//
// (Optional) The localized plan description.
//
@property (readwrite, nonatomic, strong) MHVStringNZNW *descriptionText;
//
// (Required) The plan status.
//
@property (readwrite, nonatomic, strong) MHVActionPlanInstanceStatusEnum *status;
//
// (Required) The plan category.
//
@property (readwrite, nonatomic, strong) MHVActionPlanCategoryEnum *category;
//
// (Required) The plan objectives.
//
@property (readwrite, nonatomic, strong) MHVPlanObjectiveList *objectives;

@end

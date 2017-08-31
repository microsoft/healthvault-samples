//
//  MHVAsthmaInhaler.h
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
#import "MHVAlert.h"

@interface MHVAsthmaInhaler : MHVThingDataTyped

//
// (Required) The name of the drug in the canister.
//
@property (readwrite, nonatomic, strong) MHVCodableValue *drug;
//
// (Optional) The textual description of the drug strength.
//
@property (readwrite, nonatomic, strong) MHVCodableValue *strength;
//
// (Optional) The purpose for the inhaler.
//
@property (readwrite, nonatomic, strong) NSString *purpose;
//
// (Required) The approximate date of when the inhaler started being used.
//
@property (readwrite, nonatomic, strong) MHVApproxDateTime *startDate;
//
// (Optional) The approximate date of when the inhaler was retired.
//
@property (readwrite, nonatomic, strong) MHVApproxDateTime *stopDate;
//
// (Optional) The date the canister is clinically expired.
//
@property (readwrite, nonatomic, strong) MHVApproxDateTime *expirationDate;
//
// (Optional) The unique id or serial number for the canister.
//
@property (readwrite, nonatomic, strong) NSString *deviceId;
//
// (Optional) The number of doses in the unit at the time the thing instance was created.
//
@property (readwrite, nonatomic) int initialDose;
//
// (Optional) The minimum number of doses that should be taken per day.
//
@property (readwrite, nonatomic) int minDailyDoses;
//
// (Optional) The maximum number of doses that should be taken per day.
//
@property (readwrite, nonatomic) int maxDailyDoses;
//
// (Optional) States whether the inhaler can show alerts.
//
@property (readwrite, nonatomic, strong) MHVBool *canAlert;
//
// (Optional) A set of the alert times that the device should activate its feature.
//
@property (readwrite, nonatomic, strong) NSArray<MHVAlert *> *alert;

@end

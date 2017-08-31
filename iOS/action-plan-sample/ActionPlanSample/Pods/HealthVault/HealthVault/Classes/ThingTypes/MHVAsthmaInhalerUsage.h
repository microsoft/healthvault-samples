//
//  MHVAsthmaInhalerUsage.h
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

@interface MHVAsthmaInhalerUsage : MHVThingDataTyped

//
// (Required) The date and time when the inhaler was used.
//
@property (readwrite, nonatomic, strong) MHVDateTime *when;
//
// (Required) The name of the drug in the canister.
//
@property (readwrite, nonatomic, strong) MHVCodableValue *drug;
//
// (Optional) The textual description of the drug strength.
//
@property (readwrite, nonatomic, strong) MHVCodableValue *strength;
//
// (Optional) The number of doses used.
//
@property (readwrite, nonatomic) int doseCount;
//
// (Optional) The unique id or serial number for the canister.
//
@property (readwrite, nonatomic, strong) NSString *deviceId;
//
// (Optional) An enumeration of the possible purposes the inhaler usage is targeting.
//
@property (readwrite, nonatomic, strong) MHVCodableValue *dosePurpose;

@end

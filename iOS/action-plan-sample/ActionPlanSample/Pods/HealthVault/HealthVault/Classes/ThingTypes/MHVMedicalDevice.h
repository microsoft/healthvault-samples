//
//  MHVMedicalDevice.h
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
#import "MHVPerson.h"

@interface MHVMedicalDevice : MHVThingDataTyped

//
// (Required) The date and time of the report.
//
@property (readwrite, nonatomic, strong) MHVDateTime *when;
//
// (Optional) The name of the medical equipment.
//
@property (readwrite, nonatomic, strong) NSString *deviceName;
//
// (Optional) The vendor of the medical equipment.
//
@property (readwrite, nonatomic, strong) MHVPerson *vendor;
//
// (Optional) Free form model name of the medical equipment.
//
@property (readwrite, nonatomic, strong) NSString *model;
//
// (Optional) Free form serial number of the medical equipment.
//
@property (readwrite, nonatomic, strong) NSString *serialNumber;
//
// (Optional) The location on the body where the device takes readings.
//
@property (readwrite, nonatomic, strong) NSString *anatomicSite;
//
// (Optional) A free form description of the of the medical equipment.
//
@property (readwrite, nonatomic, strong) NSString *descriptionText;
@end

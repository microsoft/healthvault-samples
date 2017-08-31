//
// MHVAppointment.h
// MHVLib
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
#import "MHVDuration.h"
#import "MHVPerson.h"

@interface MHVAppointment : MHVThingDataTyped

// -------------------------
//
// Data
//
// -------------------------
//
// (Required) The date and time of the appointment.
//
@property (readwrite, nonatomic, strong) MHVDateTime *when;
//
// (Optional) The duration of the medical appointment.
//
@property (readwrite, nonatomic, strong) MHVDuration *duration;
//
// (Optional) The type of service provided by the medical appointment.
//
@property (readwrite, nonatomic, strong) MHVCodableValue *service;
//
// (Optional) The clinic information for the medical appointment.
//
@property (readwrite, nonatomic, strong) MHVPerson *clinic;
//
// (Optional) The specialty for the medical appointment.
//
@property (readwrite, nonatomic, strong) MHVCodableValue *specialty;
//
// (Optional) The status of the medical appointment.
//
@property (readwrite, nonatomic, strong) MHVCodableValue *status;
//
// (Optional) The care class for a medical appointment.
//
@property (readwrite, nonatomic, strong) MHVCodableValue *careClass;

@end

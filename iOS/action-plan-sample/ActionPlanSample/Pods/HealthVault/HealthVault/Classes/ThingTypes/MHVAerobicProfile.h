//
// MHVAerobicProfile.h
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

#import <Foundation/Foundation.h>
#import "MHVTypes.h"

@interface MHVAerobicProfile : MHVThingDataTyped

// -------------------------
//
// Data
//
// -------------------------
//
// (Required) The date/time when the aerobic profile measurements were taken.
//
@property (readwrite, nonatomic, strong) MHVDateTime *when;
//
// (Optional) The maximum heart rate of the person.
//
@property (readwrite, nonatomic, strong) MHVPositiveInt *maxHeartrate;
//
// (Optional) The heart rate of the person when at rest.
//
@property (readwrite, nonatomic, strong) MHVPositiveInt *restingHeartrate;
//
// (Optional) The anaerobic threshold (AT) is the exercise intensity at which lactate
//            starts to accumulate in the blood stream.
//
@property (readwrite, nonatomic, strong) MHVPositiveInt *anaerobicThreshold;
//
// (Optional) VO2 max is the maximum rate at which oxygen is absorbed into the blood
//            stream by the body.
//
@property (readwrite, nonatomic, strong) MHVMaxVO2 *vO2Max;
//
// (Optional) A grouping of heart rate zones.
//
@property (readwrite, nonatomic, strong) MHVHeartrateZoneGroup *heartrateZoneGroup;

@end

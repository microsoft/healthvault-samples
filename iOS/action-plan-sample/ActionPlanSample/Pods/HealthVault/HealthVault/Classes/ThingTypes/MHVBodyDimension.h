//
//  MHVBodyDimension.h
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
#import "MHVLengthMeasurement.h"
#import "MHVApproxDateTime.h"

@interface MHVBodyDimension : MHVThingDataTyped

//
// (Required) The date and time of the measurement.
//
@property (readwrite, nonatomic, strong) MHVApproxDateTime *when;
//
// (Required) The name of the measurement.
//
@property (readwrite, nonatomic, strong) MHVCodableValue *measurementName;
//
// (Required) The value of the measurement.
//
@property (readwrite, nonatomic, strong) MHVLengthMeasurement *value;

@end

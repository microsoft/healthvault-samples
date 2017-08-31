//
// MHVAerobicProfile.m
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

#import "MHVAerobicProfile.h"

static NSString *const c_typeid = @"7b2ea78c-4b78-4f75-a6a7-5396fe38b09a";
static NSString *const c_typename = @"aerobic-profile";

static NSString *const c_element_when = @"when";
static NSString *const c_element_max_heartrate = @"max-heartrate";
static NSString *const c_element_resting_heartrate = @"resting-heartrate";
static NSString *const c_element_anaerobic_threshold = @"anaerobic-threshold";
static NSString *const c_element_vO2_max = @"VO2-max";
static NSString *const c_element_heartrate_zone_group = @"heartrate-zone-group";

@implementation MHVAerobicProfile

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_when content:self.when];
    [writer writeElement:c_element_max_heartrate content:self.maxHeartrate];
    [writer writeElement:c_element_resting_heartrate content:self.restingHeartrate];
    [writer writeElement:c_element_anaerobic_threshold content:self.anaerobicThreshold];
    [writer writeElement:c_element_vO2_max content:self.vO2Max];
    [writer writeElement:c_element_heartrate_zone_group content:self.heartrateZoneGroup];
}

- (void)deserialize:(XReader *)reader
{
    self.when = [reader readElement:c_element_when asClass:[MHVDateTime class]];
    self.maxHeartrate = [reader readElement:c_element_max_heartrate asClass:[MHVPositiveInt class]];
    self.restingHeartrate = [reader readElement:c_element_resting_heartrate asClass:[MHVPositiveInt class]];
    self.anaerobicThreshold = [reader readElement:c_element_anaerobic_threshold asClass:[MHVPositiveInt class]];
    self.vO2Max = [reader readElement:c_element_vO2_max asClass:[MHVMaxVO2 class]];
    self.heartrateZoneGroup = [reader readElement:c_element_heartrate_zone_group asClass:[MHVHeartrateZoneGroup class]];
}

+ (NSString *)typeID
{
    return c_typeid;
}

+ (NSString *)XRootElement
{
    return c_typename;
}

@end

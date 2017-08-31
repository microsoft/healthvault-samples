//
// MHVHeartRateZoneGroup.m
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


#import "MHVHeartrateZoneGroup.h"

static NSString *const c_element_name = @"name";
static NSString *const c_element_heartrate_zone = @"heartrate-zone";

@implementation MHVHeartrateZoneGroup

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_name value:self.name];
    [writer writeElement:c_element_heartrate_zone content:self.heartrateZone];
}

- (void)deserialize:(XReader *)reader
{
    self.name = [reader readStringElement:c_element_name];
    self.heartrateZone = [reader readElement:c_element_heartrate_zone asClass:[MHVHeartrateZone class]];
}

@end

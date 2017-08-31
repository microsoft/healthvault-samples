//
// MHVZoneBoundary.m
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

#import "MHVZoneBoundary.h"

static NSString *const c_element_absolute_heartrate = @"absolute-heartrate";
static NSString *const c_element_percent_max_heartrate = @"percent-max-heartrate";

@implementation MHVZoneBoundary

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_absolute_heartrate content:self.absoluteHeartrate];
    [writer writeElement:c_element_percent_max_heartrate content:self.percentMaxHeartrate];
}

- (void)deserialize:(XReader *)reader
{
    self.absoluteHeartrate = [reader readElement:c_element_absolute_heartrate asClass:[MHVPositiveInt class]];
    self.percentMaxHeartrate = [reader readElement:c_element_percent_max_heartrate asClass:[MHVPercentage class]];
}

@end

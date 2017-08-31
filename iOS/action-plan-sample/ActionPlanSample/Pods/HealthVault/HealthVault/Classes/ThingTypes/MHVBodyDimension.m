//
//  MHVBodyDimension.m
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

#import "MHVBodyDimension.h"

static NSString *const c_typeid = @"dd710b31-2b6f-45bd-9552-253562b9a7c1";
static NSString *const c_typename = @"body-dimension";

static NSString *const c_element_when = @"when";
static NSString *const c_element_measurement_name = @"measurement-name";
static NSString *const c_element_value = @"value";

@implementation MHVBodyDimension

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_when content:self.when];
    [writer writeElement:c_element_measurement_name content:self.measurementName];
    [writer writeElement:c_element_value content:self.value];
}

- (void)deserialize:(XReader *)reader
{
    self.when = [reader readElement:c_element_when asClass:[MHVApproxDateTime class]];
    self.measurementName = [reader readElement:c_element_measurement_name asClass:[MHVCodableValue class]];
    self.value = [reader readElement:c_element_value asClass:[MHVLengthMeasurement class]];
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

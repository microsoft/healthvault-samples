//
// MHVAppointment.m
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

#import "MHVAppointment.h"

static NSString *const c_typeid = @"4b18aeb6-5f01-444c-8c70-dbf13a2f510b";
static NSString *const c_typename = @"appointment";

static NSString *const c_element_when = @"when";
static NSString *const c_element_duration = @"duration";
static NSString *const c_element_service = @"service";
static NSString *const c_element_clinic = @"clinic";
static NSString *const c_element_specialty = @"specialty";
static NSString *const c_element_status = @"status";
static NSString *const c_element_care_class = @"care-class";

@implementation MHVAppointment

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_when content:self.when];
    [writer writeElement:c_element_duration content:self.duration];
    [writer writeElement:c_element_service content:self.service];
    [writer writeElement:c_element_clinic content:self.clinic];
    [writer writeElement:c_element_specialty content:self.specialty];
    [writer writeElement:c_element_status content:self.status];
    [writer writeElement:c_element_care_class content:self.careClass];
}

- (void)deserialize:(XReader *)reader
{
    self.when = [reader readElement:c_element_when asClass:[MHVDateTime class]];
    self.duration = [reader readElement:c_element_duration asClass:[MHVDuration class]];
    self.service = [reader readElement:c_element_service asClass:[MHVCodableValue class]];
    self.clinic = [reader readElement:c_element_clinic asClass:[MHVPerson class]];
    self.specialty = [reader readElement:c_element_specialty asClass:[MHVCodableValue class]];
    self.status = [reader readElement:c_element_status asClass:[MHVCodableValue class]];
    self.careClass = [reader readElement:c_element_care_class asClass:[MHVCodableValue class]];
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

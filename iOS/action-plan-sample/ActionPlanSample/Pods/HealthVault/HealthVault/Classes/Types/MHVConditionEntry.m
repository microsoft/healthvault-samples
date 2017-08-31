//
// MHVConditionEntry.m
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

#import "MHVConditionEntry.h"
#import "MHVValidator.h"

static NSString *const c_element_name = @"name";
static NSString *const c_element_onsetDate = @"onset-date";
static NSString *const c_element_resolutionDate = @"resolution-date";
static NSString *const c_element_resolution = @"resolution";
static NSString *const c_element_occurrence = @"occurrence";
static NSString *const c_element_severity = @"severity";

@implementation MHVConditionEntry

- (instancetype)initWithName:(NSString *)name
{
    MHVCHECK_STRING(name);

    self = [super init];
    if (self)
    {
        _name = [[MHVCodableValue alloc] initWithText:name];
        MHVCHECK_NOTNULL(_name);
    }
    return self;
}

- (NSString *)toString
{
    return (self.name) ? [self.name toString] : @"";
}

- (NSString *)description
{
    return [self toString];
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN

    MHVVALIDATE(self.name, MHVClientError_InvalidCondition);

    MHVVALIDATE_OPTIONAL(self.onsetDate);
    MHVVALIDATE_STRINGOPTIONAL(self.resolution, MHVClientError_InvalidCondition);
    MHVVALIDATE_OPTIONAL(self.resolutionDate);
    MHVVALIDATE_OPTIONAL(self.occurrence);
    MHVVALIDATE_OPTIONAL(self.severity);

    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_name content:self.name];
    [writer writeElement:c_element_onsetDate content:self.onsetDate];
    [writer writeElement:c_element_resolutionDate content:self.resolutionDate];
    [writer writeElement:c_element_resolution value:self.resolution];
    [writer writeElement:c_element_occurrence content:self.occurrence];
    [writer writeElement:c_element_severity content:self.severity];
}

- (void)deserialize:(XReader *)reader
{
    self.name = [reader readElement:c_element_name asClass:[MHVCodableValue class]];
    self.onsetDate = [reader readElement:c_element_onsetDate asClass:[MHVApproxDate class]];
    self.resolutionDate = [reader readElement:c_element_resolutionDate asClass:[MHVApproxDate class]];
    self.resolution = [reader readStringElement:c_element_resolution];
    self.occurrence = [reader readElement:c_element_occurrence asClass:[MHVCodableValue class]];
    self.severity = [reader readElement:c_element_severity asClass:[MHVCodableValue class]];
}

@end

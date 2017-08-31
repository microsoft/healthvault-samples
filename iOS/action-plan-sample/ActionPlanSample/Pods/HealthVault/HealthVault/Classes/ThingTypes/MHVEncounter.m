//
// MHVEncounter.m
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
//

#import "MHVEncounter.h"
#import "MHVValidator.h"

static NSString *const c_typeid = @"464083cc-13de-4f3e-a189-da8e47d5651b";
static NSString *const c_typename = @"encounter";

static NSString *const c_element_when = @"when";
static NSString *const c_element_type = @"type";
static NSString *const c_element_reason = @"reason";
static NSString *const c_element_duration = @"duration";
static NSString *const c_element_consent = @"consent-granted";
static NSString *const c_element_facility = @"facility";

@implementation MHVEncounter

- (NSDate *)getDate
{
    return [self.when toDate];
}

- (NSDate *)getDateForCalendar:(NSCalendar *)calendar
{
    return [self.when toDateForCalendar:calendar];
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN

    MHVVALIDATE_OPTIONAL(self.when);
    MHVVALIDATE_OPTIONAL(self.encounterType);
    MHVVALIDATE_STRINGOPTIONAL(self.reason, MHVClientError_InvalidEncounter);
    MHVVALIDATE_OPTIONAL(self.duration);
    MHVVALIDATE_OPTIONAL(self.consent);
    MHVVALIDATE_OPTIONAL(self.facility);

    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_when content:self.when];
    [writer writeElement:c_element_type content:self.encounterType];
    [writer writeElement:c_element_reason value:self.reason];
    [writer writeElement:c_element_duration content:self.duration];
    [writer writeElement:c_element_consent content:self.consent];
    [writer writeElement:c_element_facility content:self.facility];
}

- (void)deserialize:(XReader *)reader
{
    self.when = [reader readElement:c_element_when asClass:[MHVDateTime class]];
    self.encounterType = [reader readElement:c_element_type asClass:[MHVCodableValue class]];
    self.reason = [reader readStringElement:c_element_reason];
    self.duration = [reader readElement:c_element_duration asClass:[MHVDuration class]];
    self.consent = [reader readElement:c_element_consent asClass:[MHVBool class]];
    self.facility = [reader readElement:c_element_facility asClass:[MHVOrganization class]];
}

+ (NSString *)typeID
{
    return c_typeid;
}

+ (NSString *)XRootElement
{
    return c_typename;
}

+ (MHVThing *)newThing
{
    return [[MHVThing alloc] initWithType:[MHVEncounter typeID]];
}

- (NSString *)typeName
{
    return NSLocalizedString(@"Encounter", @"Encounter Type Name");
}

@end

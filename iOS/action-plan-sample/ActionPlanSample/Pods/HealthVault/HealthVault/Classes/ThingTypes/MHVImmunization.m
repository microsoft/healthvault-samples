//
// MHVImmunization.m
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

#import "MHVImmunization.h"
#import "MHVValidator.h"

static NSString *const c_typeid = @"cd3587b5-b6e1-4565-ab3b-1c3ad45eb04f";
static NSString *const c_typename = @"immunization";

static NSString *const c_element_name = @"name";
static NSString *const c_element_administeredDate = @"administration-date";
static NSString *const c_element_administrator = @"administrator";
static NSString *const c_element_manufacturer = @"manufacturer";
static NSString *const c_element_lot = @"lot";
static NSString *const c_element_route = @"route";
static NSString *const c_element_expiration = @"expiration-date";
static NSString *const c_element_sequence = @"sequence";
static NSString *const c_element_surface = @"anatomic-surface";
static NSString *const c_element_adverseEvent = @"adverse-event";
static NSString *const c_element_consent = @"consent";

@implementation MHVImmunization

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

- (NSDate *)getDate
{
    return (self.administeredDate) ? [self.administeredDate toDate] : nil;
}

- (NSDate *)getDateForCalendar:(NSCalendar *)calendar
{
    return (self.administeredDate) ? [self.administeredDate toDateForCalendar:calendar] : nil;
}

- (NSString *)description
{
    return [self toString];
}

- (NSString *)toString
{
    return (self.name) ? [self.name toString] : @"";
}

+ (MHVVocabularyIdentifier *)vocabForName
{
    return [[MHVVocabularyIdentifier alloc] initWithFamily:c_hvFamily andName:@"immunizations-common"];
}

+ (MHVVocabularyIdentifier *)vocabForAdverseEvent
{
    return [[MHVVocabularyIdentifier alloc] initWithFamily:c_hvFamily andName:@"immunization-adverse-effect"];
}

+ (MHVVocabularyIdentifier *)vocabForManufacturer
{
    return [[MHVVocabularyIdentifier alloc] initWithFamily:c_hl7Family andName:@"vaccine-manufacturers-mvx"];
}

+ (MHVVocabularyIdentifier *)vocabForSurface
{
    return [[MHVVocabularyIdentifier alloc] initWithFamily:c_hvFamily andName:@"immunization-anatomic-surface"];
}

+ (MHVVocabularyIdentifier *)vocabForRoute
{
    return [[MHVVocabularyIdentifier alloc] initWithFamily:c_hvFamily andName:@"immunization-routes"];
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN

        MHVVALIDATE(self.name, MHVClientError_InvalidImmunization);

    MHVVALIDATE_OPTIONAL(self.administeredDate);
    MHVVALIDATE_OPTIONAL(self.administrator);
    MHVVALIDATE_OPTIONAL(self.manufacturer);
    MHVVALIDATE_STRINGOPTIONAL(self.lot, MHVClientError_InvalidImmunization);
    MHVVALIDATE_OPTIONAL(self.route);
    MHVVALIDATE_OPTIONAL(self.expiration);
    MHVVALIDATE_STRINGOPTIONAL(self.sequence, MHVClientError_InvalidImmunization);
    MHVVALIDATE_OPTIONAL(self.anatomicSurface);
    MHVVALIDATE_STRINGOPTIONAL(self.adverseEvent, MHVClientError_InvalidImmunization);
    MHVVALIDATE_STRINGOPTIONAL(self.consent, MHVClientError_InvalidImmunization);

    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_name content:self.name];
    [writer writeElement:c_element_administeredDate content:self.administeredDate];
    [writer writeElement:c_element_administrator content:self.administrator];
    [writer writeElement:c_element_manufacturer content:self.manufacturer];
    [writer writeElement:c_element_lot value:self.lot];
    [writer writeElement:c_element_route content:self.route];
    [writer writeElement:c_element_expiration content:self.expiration];
    [writer writeElement:c_element_sequence value:self.sequence];
    [writer writeElement:c_element_surface content:self.anatomicSurface];
    [writer writeElement:c_element_adverseEvent value:self.adverseEvent];
    [writer writeElement:c_element_consent value:self.consent];
}

- (void)deserialize:(XReader *)reader
{
    self.name = [reader readElement:c_element_name asClass:[MHVCodableValue class]];
    self.administeredDate = [reader readElement:c_element_administeredDate asClass:[MHVApproxDateTime class]];
    self.administrator = [reader readElement:c_element_administrator asClass:[MHVPerson class]];
    self.manufacturer = [reader readElement:c_element_manufacturer asClass:[MHVCodableValue class]];
    self.lot = [reader readStringElement:c_element_lot];
    self.route = [reader readElement:c_element_route asClass:[MHVCodableValue class]];
    self.expiration = [reader readElement:c_element_expiration asClass:[MHVApproxDate class]];
    self.sequence = [reader readStringElement:c_element_sequence];
    self.anatomicSurface = [reader readElement:c_element_surface asClass:[MHVCodableValue class]];
    self.adverseEvent = [reader readStringElement:c_element_adverseEvent];
    self.consent = [reader readStringElement:c_element_consent];
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
    return [[MHVThing alloc] initWithType:[MHVImmunization typeID]];
}

- (NSString *)typeName
{
    return NSLocalizedString(@"Immunization", @"Immunization Type Name");
}

@end

//
// MHVPersonalDemographics.m
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


#import "MHVValidator.h"
#import "MHVPersonalDemographics.h"

static NSString *const c_typeid = @"92ba621e-66b3-4a01-bd73-74844aed4f5b";
static NSString *const c_typename = @"personal";

static NSString *const c_element_name = @"name";
static NSString *const c_element_birthdate = @"birthdate";
static NSString *const c_element_bloodType = @"blood-type";
static NSString *const c_element_ethnicity = @"ethnicity";
static NSString *const c_element_ssn = @"ssn";
static NSString *const c_element_marital = @"marital-status";
static NSString *const c_element_employment = @"employment-status";
static NSString *const c_element_deceased = @"is-deceased";
static NSString *const c_element_dateOfDeath = @"date-of-death";
static NSString *const c_element_religion = @"religion";
static NSString *const c_element_veteran = @"is-veteran";
static NSString *const c_element_education = @"highest-education-level";
static NSString *const c_element_disabled = @"is-disabled";
static NSString *const c_element_donor = @"organ-donor";

@implementation MHVPersonalDemographics

- (NSString *)description
{
    return [self toString];
}

- (NSString *)toString
{
    return (self.name) ? [self.name toString] : @"";
}

+ (MHVVocabularyIdentifier *)vocabForBloodType
{
    return [[MHVVocabularyIdentifier alloc] initWithFamily:c_hvFamily andName:@"blood-types"];
}

+ (MHVVocabularyIdentifier *)vocabForEthnicity
{
    return [[MHVVocabularyIdentifier alloc] initWithFamily:c_hvFamily andName:@"ethnicity-types"];
}

+ (MHVVocabularyIdentifier *)vocabForMaritalStatus
{
    return [[MHVVocabularyIdentifier alloc] initWithFamily:c_hvFamily andName:@"marital-status"];
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN

    MHVVALIDATE_OPTIONAL(self.name);
    MHVVALIDATE_OPTIONAL(self.birthDate);
    MHVVALIDATE_OPTIONAL(self.bloodType);
    MHVVALIDATE_OPTIONAL(self.ethnicity);
    MHVVALIDATE_STRINGOPTIONAL(self.ssn, MHVClientError_InvalidPersonalDemographics);
    MHVVALIDATE_OPTIONAL(self.maritalStatus);
    MHVVALIDATE_OPTIONAL(self.isDeceased);
    MHVVALIDATE_OPTIONAL(self.dateOfDeath);
    MHVVALIDATE_OPTIONAL(self.religion);
    MHVVALIDATE_OPTIONAL(self.isVeteran);
    MHVVALIDATE_OPTIONAL(self.education);
    MHVVALIDATE_OPTIONAL(self.isDisabled);
    MHVVALIDATE_STRINGOPTIONAL(self.donor, MHVClientError_InvalidPersonalDemographics);

    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_name content:self.name];
    [writer writeElement:c_element_birthdate content:self.birthDate];
    [writer writeElement:c_element_bloodType content:self.bloodType];
    [writer writeElement:c_element_ethnicity content:self.ethnicity];
    [writer writeElement:c_element_ssn value:self.ssn];
    [writer writeElement:c_element_marital content:self.maritalStatus];
    [writer writeElement:c_element_employment value:self.employmentStatus];
    [writer writeElement:c_element_deceased content:self.isDeceased];
    [writer writeElement:c_element_dateOfDeath content:self.dateOfDeath];
    [writer writeElement:c_element_religion content:self.religion];
    [writer writeElement:c_element_veteran content:self.isVeteran];
    [writer writeElement:c_element_education content:self.education];
    [writer writeElement:c_element_disabled content:self.isDisabled];
    [writer writeElement:c_element_donor value:self.organDonor];
}

- (void)deserialize:(XReader *)reader
{
    self.name = [reader readElement:c_element_name asClass:[MHVName class]];
    self.birthDate = [reader readElement:c_element_birthdate asClass:[MHVDateTime class]];
    self.bloodType = [reader readElement:c_element_bloodType asClass:[MHVCodableValue class]];
    self.ethnicity = [reader readElement:c_element_ethnicity asClass:[MHVCodableValue class]];
    self.ssn = [reader readStringElement:c_element_ssn];
    self.maritalStatus = [reader readElement:c_element_marital asClass:[MHVCodableValue class]];
    self.employmentStatus = [reader readStringElement:c_element_employment];
    self.isDeceased = [reader readElement:c_element_deceased asClass:[MHVBool class]];
    self.dateOfDeath = [reader readElement:c_element_dateOfDeath asClass:[MHVApproxDateTime class]];
    self.religion = [reader readElement:c_element_religion asClass:[MHVCodableValue class]];
    self.isVeteran = [reader readElement:c_element_veteran asClass:[MHVBool class]];
    self.education = [reader readElement:c_element_education asClass:[MHVCodableValue class]];
    self.isDisabled = [reader readElement:c_element_disabled asClass:[MHVBool class]];
    self.organDonor = [reader readStringElement:c_element_donor];
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
    return [[MHVThing alloc] initWithType:[MHVPersonalDemographics typeID]];
}

+ (BOOL)isSingletonType
{
    return TRUE;
}

@end

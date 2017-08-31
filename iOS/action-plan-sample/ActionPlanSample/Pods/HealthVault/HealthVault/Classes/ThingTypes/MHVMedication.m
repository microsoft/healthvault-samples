//
// MHVMedication.m
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
#import "MHVMedication.h"

static NSString *const c_typeid = @"30cafccc-047d-4288-94ef-643571f7919d";
static NSString *const c_typename = @"medication";

static NSString *const c_element_name = @"name";
static NSString *const c_element_genericName = @"generic-name";
static NSString *const c_element_dose = @"dose";
static NSString *const c_element_strength = @"strength";
static NSString *const c_element_frequency = @"frequency";
static NSString *const c_element_route = @"route";
static NSString *const c_element_indication = @"indication";
static NSString *const c_element_startDate = @"date-started";
static NSString *const c_element_stopDate = @"date-discontinued";
static NSString *const c_element_prescribed = @"prescribed";
static NSString *const c_element_prescription = @"prescription";

@implementation MHVMedication

- (MHVPerson *)prescriber
{
    return (self.prescription) ? self.prescription.prescriber : nil;
}

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (name)
    {
        _name = [[MHVCodableValue alloc] initWithText:name];
        MHVCHECK_NOTNULL(_name);
    }

    return self;
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
    return [[MHVVocabularyIdentifier alloc] initWithFamily:c_rxNormFamily andName:@"RxNorm Active Medicines"];
}

+ (MHVVocabularyIdentifier *)vocabForDoseUnits
{
    return [[MHVVocabularyIdentifier alloc] initWithFamily:c_hvFamily andName:@"medication-dose-units"];
}

+ (MHVVocabularyIdentifier *)vocabForStrengthUnits
{
    return [[MHVVocabularyIdentifier alloc] initWithFamily:c_hvFamily andName:@"medication-strength-unit"];
}

+ (MHVVocabularyIdentifier *)vocabForRoute
{
    return [[MHVVocabularyIdentifier alloc] initWithFamily:c_hvFamily andName:@"medication-routes"];
}

+ (MHVVocabularyIdentifier *)vocabForIsPrescribed
{
    return [[MHVVocabularyIdentifier alloc] initWithFamily:c_hvFamily andName:@"medication-prescribed"];
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN

        MHVVALIDATE(self.name, MHVClientError_InvalidMedication);

    MHVVALIDATE_OPTIONAL(self.genericName);
    MHVVALIDATE_OPTIONAL(self.dose);
    MHVVALIDATE_OPTIONAL(self.strength);
    MHVVALIDATE_OPTIONAL(self.frequency);
    MHVVALIDATE_OPTIONAL(self.route);
    MHVVALIDATE_OPTIONAL(self.indication);
    MHVVALIDATE_OPTIONAL(self.startDate);
    MHVVALIDATE_OPTIONAL(self.stopDate);
    MHVVALIDATE_OPTIONAL(self.prescribed);
    MHVVALIDATE_OPTIONAL(self.prescription);

    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_name content:self.name];
    [writer writeElement:c_element_genericName content:self.genericName];
    [writer writeElement:c_element_dose content:self.dose];
    [writer writeElement:c_element_strength content:self.strength];
    [writer writeElement:c_element_frequency content:self.frequency];
    [writer writeElement:c_element_route content:self.route];
    [writer writeElement:c_element_indication content:self.indication];
    [writer writeElement:c_element_startDate content:self.startDate];
    [writer writeElement:c_element_stopDate content:self.stopDate];
    [writer writeElement:c_element_prescribed content:self.prescribed];
    [writer writeElement:c_element_prescription content:self.prescription];
}

- (void)deserialize:(XReader *)reader
{
    self.name = [reader readElement:c_element_name asClass:[MHVCodableValue class]];
    self.genericName = [reader readElement:c_element_genericName asClass:[MHVCodableValue class]];
    self.dose = [reader readElement:c_element_dose asClass:[MHVApproxMeasurement class]];
    self.strength = [reader readElement:c_element_strength asClass:[MHVApproxMeasurement class]];
    self.frequency = [reader readElement:c_element_frequency asClass:[MHVApproxMeasurement class]];
    self.route = [reader readElement:c_element_route asClass:[MHVCodableValue class]];
    self.indication = [reader readElement:c_element_indication asClass:[MHVCodableValue class]];
    self.startDate = [reader readElement:c_element_startDate asClass:[MHVApproxDateTime class]];
    self.stopDate = [reader readElement:c_element_stopDate asClass:[MHVApproxDateTime class]];
    self.prescribed = [reader readElement:c_element_prescribed asClass:[MHVCodableValue class]];
    self.prescription = [reader readElement:c_element_prescription asClass:[MHVPrescription class]];
}

+ (NSString *)typeID
{
    return c_typeid;
}

+ (NSString *)XRootElement
{
    return c_typename;
}

- (NSString *)typeName
{
    return NSLocalizedString(@"Medication", @"Medication Type Name");
}

+ (MHVThing *)newThing
{
    return [[MHVThing alloc] initWithType:[MHVMedication typeID]];
}

@end

//
// MHVInsurance.m
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

#import "MHVInsurance.h"
#import "MHVValidator.h"

static NSString *const c_typeid = @"9366440c-ec81-4b89-b231-308a4c4d70ed";
static NSString *const c_typename = @"payer";

static NSString *const c_element_planName = @"plan-name";
static NSString *const c_element_coverage = @"coverage-type";
static NSString *const c_element_carrierID = @"carrier-id";
static NSString *const c_element_groupNum = @"group-num";
static NSString *const c_element_planCode = @"plan-code";
static NSString *const c_element_subscriberID = @"subscriber-id";
static NSString *const c_element_personCode = @"person-code";
static NSString *const c_element_subscriberName = @"subscriber-name";
static NSString *const c_element_subsriberDOB = @"subscriber-dob";
static NSString *const c_element_isPrimary = @"is-primary";
static NSString *const c_element_expirationDate = @"expiration-date";
static NSString *const c_element_contact = @"contact";

@implementation MHVInsurance

- (NSString *)toString
{
    return (self.planName) ? self.planName : @"";
}

- (NSString *)description
{
    return [self toString];
}

+ (MHVVocabularyIdentifier *)vocabForCoverage
{
    return [[MHVVocabularyIdentifier alloc] initWithFamily:c_hvFamily andName:@"coverage-types"];
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN

    MHVVALIDATE_STRINGOPTIONAL(self.planName, MHVClientError_InvalidInsurance);
    MHVVALIDATE_OPTIONAL(self.coverageType);
    MHVVALIDATE_STRINGOPTIONAL(self.carrierID, MHVClientError_InvalidInsurance);
    MHVVALIDATE_STRINGOPTIONAL(self.groupNum, MHVClientError_InvalidInsurance);
    MHVVALIDATE_STRINGOPTIONAL(self.planCode, MHVClientError_InvalidInsurance);
    MHVVALIDATE_STRINGOPTIONAL(self.subscriberID, MHVClientError_InvalidInsurance);
    MHVVALIDATE_STRINGOPTIONAL(self.personCode, MHVClientError_InvalidInsurance);
    MHVVALIDATE_STRINGOPTIONAL(self.subscriberName, MHVClientError_InvalidInsurance);
    MHVVALIDATE_OPTIONAL(self.subscriberDOB);
    MHVVALIDATE_OPTIONAL(self.isPrimary);
    MHVVALIDATE_OPTIONAL(self.expirationDate);
    MHVVALIDATE_OPTIONAL(self.contact);

    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_planName value:self.planName];
    [writer writeElement:c_element_coverage content:self.coverageType];
    [writer writeElement:c_element_carrierID value:self.carrierID];
    [writer writeElement:c_element_groupNum value:self.groupNum];
    [writer writeElement:c_element_planCode value:self.planCode];
    [writer writeElement:c_element_subscriberID value:self.subscriberID];
    [writer writeElement:c_element_personCode value:self.personCode];
    [writer writeElement:c_element_subscriberName value:self.subscriberName];
    [writer writeElement:c_element_subsriberDOB content:self.subscriberDOB];
    [writer writeElement:c_element_isPrimary content:self.isPrimary];
    [writer writeElement:c_element_expirationDate content:self.expirationDate];
    [writer writeElement:c_element_contact content:self.contact];
}

- (void)deserialize:(XReader *)reader
{
    self.planName = [reader readStringElement:c_element_planName];
    self.coverageType = [reader readElement:c_element_coverage asClass:[MHVCodableValue class]];
    self.carrierID = [reader readStringElement:c_element_carrierID];
    self.groupNum = [reader readStringElement:c_element_groupNum];
    self.planCode = [reader readStringElement:c_element_planCode];
    self.subscriberID = [reader readStringElement:c_element_subscriberID];
    self.personCode = [reader readStringElement:c_element_personCode];
    self.subscriberName = [reader readStringElement:c_element_subscriberName];
    self.subscriberDOB = [reader readElement:c_element_subsriberDOB asClass:[MHVDateTime class]];
    self.isPrimary = [reader readElement:c_element_isPrimary asClass:[MHVBool class]];
    self.expirationDate = [reader readElement:c_element_expirationDate asClass:[MHVDateTime class]];
    self.contact = [reader readElement:c_element_contact asClass:[MHVContact class]];
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
    return [[MHVThing alloc] initWithType:[MHVInsurance typeID]];
}

- (NSString *)typeName
{
    return NSLocalizedString(@"Insurance", @"Insurance Type Name");
}

@end

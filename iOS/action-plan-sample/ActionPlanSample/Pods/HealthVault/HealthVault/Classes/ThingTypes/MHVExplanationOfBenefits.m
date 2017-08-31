//
//  MHVExplanationOfBenefits.m
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

#import "MHVExplanationOfBenefits.h"

static NSString *const c_typeid = @"356fbba9-e0c9-4f4f-b0d9-4594f2490d2f";
static NSString *const c_typename = @"explanation-of-benefits";

static NSString *const c_element_date_submitted = @"date-submitted";
static NSString *const c_element_patient = @"patient";
static NSString *const c_element_relationship_to_member = @"relationship-to-member";
static NSString *const c_element_plan = @"plan";
static NSString *const c_element_group_id = @"group-id";
static NSString *const c_element_member_id = @"member-id";
static NSString *const c_element_claim_type = @"claim-type";
static NSString *const c_element_claim_id = @"claim-id";
static NSString *const c_element_submitted_by = @"submitted-by";
static NSString *const c_element_provider = @"provider";
static NSString *const c_element_currency = @"currency";
static NSString *const c_element_claim_totals = @"claim-totals";
static NSString *const c_element_services = @"services";

@implementation MHVExplanationOfBenefits

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_date_submitted content:self.dateSubmitted];
    [writer writeElement:c_element_patient content:self.patient];
    [writer writeElement:c_element_relationship_to_member content:self.relationshipToMember];
    [writer writeElement:c_element_plan content:self.plan];
    [writer writeElement:c_element_group_id content:self.groupId];
    [writer writeElement:c_element_member_id content:self.memberId];
    [writer writeElement:c_element_claim_type content:self.claimType];
    [writer writeElement:c_element_claim_id content:self.claimId];
    [writer writeElement:c_element_submitted_by content:self.submittedBy];
    [writer writeElement:c_element_provider content:self.provider];
    [writer writeElement:c_element_currency content:self.currency];
    [writer writeElement:c_element_claim_totals content:self.claimTotals];
    [writer writeElementArray:c_element_services elements:self.services];
}

- (void)deserialize:(XReader *)reader
{
    self.dateSubmitted = [reader readElement:c_element_date_submitted asClass:[MHVDateTime class]];
    self.patient = [reader readElement:c_element_patient asClass:[MHVPerson class]];
    self.relationshipToMember = [reader readElement:c_element_relationship_to_member asClass:[MHVCodableValue class]];
    self.plan = [reader readElement:c_element_plan asClass:[MHVOrganization class]];
    self.groupId = [reader readElement:c_element_group_id asClass:[MHVStringNZNW class]];
    self.memberId = [reader readElement:c_element_member_id asClass:[MHVStringNZNW class]];
    self.claimType = [reader readElement:c_element_claim_type asClass:[MHVCodableValue class]];
    self.claimId = [reader readElement:c_element_claim_id asClass:[MHVStringNZNW class]];
    self.submittedBy = [reader readElement:c_element_submitted_by asClass:[MHVOrganization class]];
    self.provider = [reader readElement:c_element_provider asClass:[MHVOrganization class]];
    self.currency = [reader readElement:c_element_currency asClass:[MHVCodableValue class]];
    self.claimTotals = [reader readElement:c_element_claim_totals asClass:[MHVClaimAmounts class]];
    self.services = [reader readElementArray:c_element_services asClass:[MHVEOBService class] andArrayClass:[NSMutableArray class]];
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


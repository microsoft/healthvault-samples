//
//  MHVExplanationOfBenefits.h
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

#import "MHVThing.h"
#import "MHVOrganization.h"
#import "MHVPerson.h"
#import "MHVStringNZNW.h"
#import "MHVClaimAmounts.h"
#import "MHVEOBService.h"

@interface MHVExplanationOfBenefits : MHVThingDataTyped

// -------------------------
//
// Data
//
// -------------------------
//
// (Required) The date when the claim was submitted.
//
@property (readwrite, nonatomic, strong) MHVDateTime *dateSubmitted;
//
// (Required) The name of the patient.
//
@property (readwrite, nonatomic, strong) MHVPerson *patient;
//
// (Optional) The relationship of the patient to the primary plan member.
//
@property (readwrite, nonatomic, strong) MHVCodableValue *relationshipToMember;
//
// (Required) The plan covering this claim.
//
@property (readwrite, nonatomic, strong) MHVOrganization *plan;
//
// (Optional) The group id for the member's plan.
//
@property (readwrite, nonatomic, strong) MHVStringNZNW *groupId;
//
// (Required) The member id of the plan member.
//
@property (readwrite, nonatomic, strong) MHVStringNZNW *memberId;
//
// (Required) The type of the claim (medical, dental, etc.)
//
@property (readwrite, nonatomic, strong) MHVCodableValue *claimType;
//
// (Required) The claim id.
//
@property (readwrite, nonatomic, strong) MHVStringNZNW *claimId;
//
// (Required) The organization that submitted this claim.
//
@property (readwrite, nonatomic, strong) MHVOrganization *submittedBy;
//
// (Required) The provider that performed the services.
//
@property (readwrite, nonatomic, strong) MHVOrganization *provider;
//
// (Required) The currency used.
//
@property (readwrite, nonatomic, strong) MHVCodableValue *currency;
//
// (Required) A summary of the financial information about this claim.
//
@property (readwrite, nonatomic, strong) MHVClaimAmounts *claimTotals;
//
// (Required) The service included in this claim.
//
@property (readwrite, nonatomic, strong) NSArray<MHVEOBService *> *services;

@end

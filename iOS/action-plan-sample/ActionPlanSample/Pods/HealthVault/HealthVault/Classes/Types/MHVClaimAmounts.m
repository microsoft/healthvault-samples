//
//  MHVClaimAmounts.m
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

#import "MHVClaimAmounts.h"

static NSString *const c_element_charged_amount = @"charged-amount";
static NSString *const c_element_negotiated_amount = @"negotiated-amount";
static NSString *const c_element_copay = @"copay";
static NSString *const c_element_deductible = @"deductible";
static NSString *const c_element_amount_not_covered = @"amount-not-covered";
static NSString *const c_element_eligible_for_benefits = @"eligible-for-benefits";
static NSString *const c_element_percentage_covered = @"percentage-covered";
static NSString *const c_element_coinsurance = @"coinsurance";
static NSString *const c_element_miscellaneous_adjustments = @"miscellaneous-adjustments";
static NSString *const c_element_benefits_paid = @"benefits-paid";
static NSString *const c_element_patient_responsibility = @"patient-responsibility";

@implementation MHVClaimAmounts

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_charged_amount content:self.chargedAmount];
    [writer writeElement:c_element_negotiated_amount content:self.negotiatedAmount];
    [writer writeElement:c_element_copay content:self.copay];
    [writer writeElement:c_element_deductible content:self.deductible];
    [writer writeElement:c_element_amount_not_covered content:self.amountNotCovered];
    [writer writeElement:c_element_eligible_for_benefits content:self.eligibleForBenefits];
    [writer writeElement:c_element_percentage_covered content:self.percentageCovered];
    [writer writeElement:c_element_coinsurance content:self.coinsurance];
    [writer writeElement:c_element_miscellaneous_adjustments content:self.miscellaneousAdjustments];
    [writer writeElement:c_element_benefits_paid content:self.benefitsPaid];
    [writer writeElement:c_element_patient_responsibility content:self.patientResponsibility];
}

- (void) deserialize:(XReader *)reader
{
    self.chargedAmount = [reader readElement:c_element_charged_amount asClass:[MHVDouble class]];
    self.negotiatedAmount = [reader readElement:c_element_negotiated_amount asClass:[MHVDouble class]];
    self.copay = [reader readElement:c_element_copay asClass:[MHVDouble class]];
    self.deductible = [reader readElement:c_element_deductible asClass:[MHVDouble class]];
    self.amountNotCovered = [reader readElement:c_element_amount_not_covered asClass:[MHVDouble class]];
    self.eligibleForBenefits = [reader readElement:c_element_eligible_for_benefits asClass:[MHVDouble class]];
    self.percentageCovered = [reader readElement:c_element_percentage_covered asClass:[MHVPercentage class]];
    self.coinsurance = [reader readElement:c_element_coinsurance asClass:[MHVDouble class]];
    self.miscellaneousAdjustments = [reader readElement:c_element_miscellaneous_adjustments asClass:[MHVDouble class]];
    self.benefitsPaid = [reader readElement:c_element_benefits_paid asClass:[MHVDouble class]];
    self.patientResponsibility = [reader readElement:c_element_patient_responsibility asClass:[MHVDouble class]];
}

@end

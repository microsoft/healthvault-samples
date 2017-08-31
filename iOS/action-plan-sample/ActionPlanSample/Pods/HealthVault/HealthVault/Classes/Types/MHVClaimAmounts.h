//
//  MHVClaimAmounts.h
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

#import "MHVType.h"
#import "MHVDouble.h"
#import "MHVPercentage.h"

@interface MHVClaimAmounts : MHVType

@property (readwrite, nonatomic, strong) MHVDouble *chargedAmount;
@property (readwrite, nonatomic, strong) MHVDouble *negotiatedAmount;
@property (readwrite, nonatomic, strong) MHVDouble *copay;
@property (readwrite, nonatomic, strong) MHVDouble *deductible;
@property (readwrite, nonatomic, strong) MHVDouble *amountNotCovered;
@property (readwrite, nonatomic, strong) MHVDouble *eligibleForBenefits;
@property (readwrite, nonatomic, strong) MHVPercentage *percentageCovered;
@property (readwrite, nonatomic, strong) MHVDouble *coinsurance;
@property (readwrite, nonatomic, strong) MHVDouble *miscellaneousAdjustments;
@property (readwrite, nonatomic, strong) MHVDouble *benefitsPaid;
@property (readwrite, nonatomic, strong) MHVDouble *patientResponsibility;

@end


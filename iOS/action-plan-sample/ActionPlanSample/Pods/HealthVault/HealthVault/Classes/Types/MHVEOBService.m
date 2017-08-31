//
//  MHVEOBService.m
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

#import "MHVEOBService.h"

static NSString *const c_element_service_type = @"service-type";
static NSString *const c_element_diagnosis = @"diagnosis";
static NSString *const c_element_billing_code = @"billing-code";
static NSString *const c_element_service_dates = @"service-dates";
static NSString *const c_element_claim_amounts = @"claim-amounts";
static NSString *const c_element_notes = @"notes";

@implementation MHVEOBService

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_service_type content:self.serviceType];
    [writer writeElement:c_element_diagnosis content:self.diagnosis];
    [writer writeElement:c_element_billing_code content:self.billingCode];
    [writer writeElement:c_element_service_dates content:self.serviceDates];
    [writer writeElement:c_element_claim_amounts content:self.claimAmounts];
    [writer writeElement:c_element_notes content:self.notes];
}

- (void)deserialize:(XReader *)reader
{
    self.serviceType = [reader readElement:c_element_service_type asClass:[MHVCodableValue class]];
    self.diagnosis = [reader readElement:c_element_diagnosis asClass:[MHVCodableValue class]];
    self.billingCode = [reader readElement:c_element_billing_code asClass:[MHVCodableValue class]];
    self.serviceDates = [reader readElement:c_element_service_dates asClass:[MHVDuration class]];
    self.claimAmounts = [reader readElement:c_element_claim_amounts asClass:[MHVClaimAmounts class]];
    self.notes = [reader readElement:c_element_notes asClass:[MHVStringNZNW class]];
}

@end


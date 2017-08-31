//
// MHVPrescription.m
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


#import "MHVValidator.h"
#import "MHVPrescription.h"

static NSString *const c_element_prescribedBy = @"prescribed-by";
static NSString *const c_element_datePrescribed = @"date-prescribed";
static NSString *const c_element_amount = @"amount-prescribed";
static NSString *const c_element_substitution = @"substitution";
static NSString *const c_element_refills = @"refills";
static NSString *const c_element_supply = @"days-supply";
static NSString *const c_element_expiration = @"prescription-expiration";
static NSString *const c_element_instructions = @"instructions";

@implementation MHVPrescription

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN

        MHVVALIDATE(self.prescriber, MHVClientError_InvalidPrescription);

    MHVVALIDATE_OPTIONAL(self.datePrescribed);
    MHVVALIDATE_OPTIONAL(self.amount);
    MHVVALIDATE_OPTIONAL(self.substitution);
    MHVVALIDATE_OPTIONAL(self.refills);
    MHVVALIDATE_OPTIONAL(self.daysSupply);
    MHVVALIDATE_OPTIONAL(self.expirationDate);
    MHVVALIDATE_OPTIONAL(self.instructions);

    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_prescribedBy content:self.prescriber];
    [writer writeElement:c_element_datePrescribed content:self.datePrescribed];
    [writer writeElement:c_element_amount content:self.amount];
    [writer writeElement:c_element_substitution content:self.substitution];
    [writer writeElement:c_element_refills content:self.refills];
    [writer writeElement:c_element_supply content:self.daysSupply];
    [writer writeElement:c_element_expiration content:self.expirationDate];
    [writer writeElement:c_element_instructions content:self.instructions];
}

- (void)deserialize:(XReader *)reader
{
    self.prescriber = [reader readElement:c_element_prescribedBy asClass:[MHVPerson class]];
    self.datePrescribed = [reader readElement:c_element_datePrescribed asClass:[MHVApproxDateTime class]];
    self.amount = [reader readElement:c_element_amount asClass:[MHVApproxMeasurement class]];
    self.substitution = [reader readElement:c_element_substitution asClass:[MHVCodableValue class]];
    self.refills = [reader readElement:c_element_refills asClass:[MHVNonNegativeInt class]];
    self.daysSupply = [reader readElement:c_element_supply asClass:[MHVPositiveInt class]];
    self.expirationDate = [reader readElement:c_element_expiration asClass:[MHVDate class]];
    self.instructions = [reader readElement:c_element_instructions asClass:[MHVCodableValue class]];
}

@end

//
// MHVPrescription.h
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


#import "MHVType.h"
#import "MHVBaseTypes.h"
#import "MHVPerson.h"
#import "MHVApproxDateTime.h"
#import "MHVApproxMeasurement.h"
#import "MHVCodableValue.h"
#import "MHVDate.h"

@interface MHVPrescription : MHVType
//
// Required
//
@property (readwrite, nonatomic, strong) MHVPerson *prescriber;
//
// Optional
//
@property (readwrite, nonatomic, strong) MHVApproxDateTime *datePrescribed;
@property (readwrite, nonatomic, strong) MHVApproxMeasurement *amount;
@property (readwrite, nonatomic, strong) MHVCodableValue *substitution;
@property (readwrite, nonatomic, strong) MHVNonNegativeInt *refills;
@property (readwrite, nonatomic, strong) MHVPositiveInt *daysSupply;
@property (readwrite, nonatomic, strong) MHVDate *expirationDate;
@property (readwrite, nonatomic, strong) MHVCodableValue *instructions;

@end

//
// MHVConditionEntry.h
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

#import <Foundation/Foundation.h>
#import "MHVType.h"
#import "MHVCodableValue.h"
#import "MHVApproxDate.h"

@interface MHVConditionEntry : MHVType

// -------------------------
//
// Data
//
// -------------------------
//
// (Required)
// Vocabularies: icd9, snomed
//
@property (readwrite, nonatomic, strong) MHVCodableValue *name;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) MHVApproxDate *onsetDate;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) MHVApproxDate *resolutionDate;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) NSString *resolution;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) MHVCodableValue *occurrence;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) MHVCodableValue *severity;

// -------------------------
//
// Initializers
//
// -------------------------
- (instancetype)initWithName:(NSString *)name;

// -------------------------
//
// Text
//
// -------------------------
- (NSString *)toString;

@end


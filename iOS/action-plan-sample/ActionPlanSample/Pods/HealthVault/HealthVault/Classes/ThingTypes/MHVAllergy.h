//
// MHVAllergy.h
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

#import "MHVTypes.h"
#import "MHVVocabulary.h"

@interface MHVAllergy : MHVThingDataTyped

// -------------------------
//
// Data
//
// -------------------------
//
// (Required) E.g. Allergy to Pollen
//
@property (readwrite, nonatomic, strong) MHVCodableValue *name;
//
// (Optional) Reaction to the allergy
// Preferred Vocab: icd9cm
//
@property (readwrite, nonatomic, strong) MHVCodableValue *reaction;
//
// (Optional) Approximately when first observed
//
@property (readwrite, nonatomic, strong) MHVApproxDateTime *firstObserved;
//
// (Optional) E.g. Pollen
// Preferred Vocab: allergen-type
//
@property (readwrite, nonatomic, strong) MHVCodableValue *allergenType;
//
// (Optional) Clinical allergen code
// Preferred Vocab: icd9cm
//
@property (readwrite, nonatomic, strong) MHVCodableValue *allergenCode;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) MHVPerson *treatmentProvider;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) MHVCodableValue *treatment;
//
// (Optional) - Does treatment negate the effects of the allergy?
//
@property (readwrite, nonatomic, strong) MHVBool *isNegated;

// -------------------------
//
// Initializers
//
// -------------------------
- (instancetype)initWithName:(NSString *)name;

// -------------------------
//
// Standard Vocabs
//
// -------------------------
+ (MHVVocabularyIdentifier *)vocabForType;
+ (MHVVocabularyIdentifier *)vocabForReaction;

// -------------------------
//
// Type Information
//
// -------------------------
+ (NSString *)typeID;
+ (NSString *)XRootElement;

- (NSString *)toString;

+ (MHVThing *)newThing;

@end

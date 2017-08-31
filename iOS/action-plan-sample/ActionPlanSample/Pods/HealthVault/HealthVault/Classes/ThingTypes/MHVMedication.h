//
// MHVMedication.h
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

#import <Foundation/Foundation.h>
#import "MHVTypes.h"
#import "MHVVocabulary.h"


@interface MHVMedication : MHVThingDataTyped

// -------------------------
//
// Data
//
// -------------------------
//
// (Required) Medication Name
// Vocabularies: RxNorm, NDC
//
@property (readwrite, nonatomic, strong) MHVCodableValue *name;
//
// (Optional)
// Vocabularies: RxNorm, NDC
//
@property (readwrite, nonatomic, strong) MHVCodableValue *genericName;
//
// (Optional)
// Vocabulary for Units: medication-dose-units
//
@property (readwrite, nonatomic, strong) MHVApproxMeasurement *dose;
//
// (Optional)
// Vocabulary for Units: medication-strength-unit
//
@property (readwrite, nonatomic, strong) MHVApproxMeasurement *strength;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) MHVApproxMeasurement *frequency;
//
// (Optional)
// Vocabulary for Units: medication-route
//
@property (readwrite, nonatomic, strong) MHVCodableValue *route;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) MHVCodableValue *indication;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) MHVApproxDateTime *startDate;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) MHVApproxDateTime *stopDate;
//
// (Optional) Was the medication prescribed?
// Vocabulary: medication-prescribed
//
@property (readwrite, nonatomic, strong) MHVCodableValue *prescribed;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) MHVPrescription *prescription;

//
// Convenience Properties
//
@property (readonly, nonatomic, strong) MHVPerson *prescriber;

// -------------------------
//
// Initializers
//
// -------------------------
- (instancetype)initWithName:(NSString *)name;

+ (MHVThing *)newThing;

// -------------------------
//
// Text
//
// -------------------------
- (NSString *)toString;

// -------------------------
//
// Standard Vocabularies
//
// -------------------------
+ (MHVVocabularyIdentifier *)vocabForName;  // RxNorm active medications

+ (MHVVocabularyIdentifier *)vocabForDoseUnits;
+ (MHVVocabularyIdentifier *)vocabForStrengthUnits;
+ (MHVVocabularyIdentifier *)vocabForRoute;
+ (MHVVocabularyIdentifier *)vocabForIsPrescribed;

// -------------------------
//
// Type information
//
// -------------------------
+ (NSString *)typeID;
+ (NSString *)XRootElement;

@end

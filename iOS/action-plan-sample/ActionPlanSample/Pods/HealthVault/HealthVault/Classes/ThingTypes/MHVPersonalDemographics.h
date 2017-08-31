//
// MHVPersonalDemographics.h
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

@interface MHVPersonalDemographics : MHVThingDataTyped

// -------------------------
//
// Data
//
// -------------------------
//
// ALL information is optional
//
@property (readwrite, nonatomic, strong) MHVName *name;
@property (readwrite, nonatomic, strong) MHVDateTime *birthDate;
@property (readwrite, nonatomic, strong) MHVCodableValue *bloodType;
@property (readwrite, nonatomic, strong) MHVCodableValue *ethnicity;
@property (readwrite, nonatomic, strong) NSString *ssn;
@property (readwrite, nonatomic, strong) MHVCodableValue *maritalStatus;
@property (readwrite, nonatomic, strong) NSString *employmentStatus;
@property (readwrite, nonatomic, strong) MHVBool *isDeceased;
@property (readwrite, nonatomic, strong) MHVApproxDateTime *dateOfDeath;
@property (readwrite, nonatomic, strong) MHVCodableValue *religion;
@property (readwrite, nonatomic, strong) MHVBool *isVeteran;
@property (readwrite, nonatomic, strong) MHVCodableValue *education;
@property (readwrite, nonatomic, strong) MHVBool *isDisabled;
@property (readwrite, nonatomic, strong) NSString *organDonor;

// -------------------------
//
// Initializers
//
// -------------------------
+ (MHVThing *)newThing;


- (NSString *)toString;

// -------------------------
//
// Vocab
//
// -------------------------
+ (MHVVocabularyIdentifier *)vocabForBloodType;
+ (MHVVocabularyIdentifier *)vocabForEthnicity;
+ (MHVVocabularyIdentifier *)vocabForMaritalStatus;

// -------------------------
//
// Type Information
//
// -------------------------
+ (NSString *)typeID;
+ (NSString *)XRootElement;


@end

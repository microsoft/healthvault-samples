//
// MHVCondition.h
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

@interface MHVCondition : MHVThingDataTyped

// -------------------------
//
// Data
//
// -------------------------
//
// (Required) This condition's name
// Vocabularies: icd9cm, Snomed etc
//
@property (readwrite, nonatomic, strong) MHVCodableValue *name;
//
// Optional:
//
@property (readwrite, nonatomic, strong) MHVApproxDateTime *onsetDate;
//
// Optional: 'acute', 'chronic' etc
// Vocabulary: condition-occurrence
//
@property (readwrite, nonatomic, strong) MHVCodableValue *status;
//
// Optional: Has the condition stoped?
//
@property (readwrite, nonatomic, strong) MHVApproxDateTime *stopDate;
//
// Optional
//
@property (readwrite, nonatomic, strong) NSString *stopReason;

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

// -------------------------
//
// Standard Vocabs
//
// -------------------------
+ (MHVVocabularyIdentifier *)vocabForStatus;

// -------------------------
//
// Type Information
//
// -------------------------
+ (NSString *)typeID;
+ (NSString *)XRootElement;

+ (MHVThing *)newThing;

@end

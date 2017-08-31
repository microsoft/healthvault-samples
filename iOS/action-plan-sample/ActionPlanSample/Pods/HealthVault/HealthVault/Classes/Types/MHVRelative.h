//
// MHVRelative.h
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
#import "MHVType.h"
#import "MHVCodableValue.h"
#import "MHVPerson.h"
#import "MHVApproxDate.h"
#import "MHVVocabulary.h"

@interface MHVRelative : MHVType

// -------------------------
//
// Data
//
// -------------------------
//
// (Required) - Mom, Dad, uncle etc
// Vocabulary: personal-relationship
//
@property (readwrite, nonatomic, strong) MHVCodableValue *relationship;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) MHVPerson *person;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) MHVApproxDate *dateOfBirth;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) MHVApproxDate *dateOfDeath;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) MHVCodableValue *regionOfOrigin;

// -------------------------
//
// Initializers
//
// -------------------------
- (instancetype)initWithRelationship:(NSString *)relationship;
- (instancetype)initWithPerson:(MHVPerson *)person andRelationship:(MHVCodableValue *)relationship;

// -------------------------
//
// Text
//
// -------------------------
- (NSString *)toString;

// -------------------------
//
// Vocab
//
// -------------------------
+ (MHVVocabularyIdentifier *)vocabForRelationship;
+ (MHVVocabularyIdentifier *)vocabForRegionOfOrigin;

@end

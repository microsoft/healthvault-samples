//
// MHVAddress.h
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
#import "MHVBaseTypes.h"
#import "MHVVocabulary.h"

@interface MHVAddress : MHVType

// -------------------------
//
// Data
//
// -------------------------
//
// (Optional) A description of this address, such as "Home"
//
@property (readwrite, nonatomic, strong) NSString *type;
@property (readwrite, nonatomic, strong) MHVBool *isPrimary;
//
// (Required)
//
@property (readwrite, nonatomic, strong) NSArray<NSString *> *street;
//
// (Required)
//
@property (readwrite, nonatomic, strong) NSString *city;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) NSString *state;
//
// (Required)
//
@property (readwrite, nonatomic, strong) NSString *postalCode;
//
// (Required)
//
@property (readwrite, nonatomic, strong) NSString *country;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) NSString *county;

@property (readonly, nonatomic) BOOL hasStreet;

// -------------------------
//
// Vocabs
//
// -------------------------
+ (MHVVocabularyIdentifier *)vocabForCountries;
+ (MHVVocabularyIdentifier *)vocabForUSStates;
+ (MHVVocabularyIdentifier *)vocabForCanadianProvinces;

// -------------------------
//
// Text
//
// -------------------------
- (NSString *)toString;

@end

//
// MHVName.h
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
#import "MHVCodableValue.h"
#import "MHVVocabulary.h"

@interface MHVName : MHVType

// -------------------------
//
// Data
//
// -------------------------
//
// (Required)
//
@property (readwrite, nonatomic, strong) NSString *fullName;
//
// (Optional)
// Vocabulary: name-prefixes
//
@property (readwrite, nonatomic, strong) MHVCodableValue *title;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) NSString *first;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) NSString *middle;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) NSString *last;
//
// (Optional)
// Vocabulary: name-suffixes
@property (readwrite, nonatomic, strong) MHVCodableValue *suffix;

// -------------------------
//
// Initializers
//
// -------------------------
- (instancetype)initWithFirst:(NSString *)first andLastName:(NSString *)last;
- (instancetype)initWithFirst:(NSString *)first middle:(NSString *)middle andLastName:(NSString *)last;
- (instancetype)initWithFullName:(NSString *)name;

// -------------------------
//
// Methods
//
// -------------------------
- (BOOL)buildFullName;

+ (MHVVocabularyIdentifier *)vocabForTitle;
+ (MHVVocabularyIdentifier *)vocabForSuffix;

// -------------------------
//
// Text
//
// -------------------------
// Returns the full name
- (NSString *)toString;

@end

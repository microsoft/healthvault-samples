//
// MHVCodedValue.h
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
#import "MHVVocabularyCodeItem.h"

// -------------------------
//
// A code from a standard vocabulary
// Includes the code, the vocabulary name, family and version
//
// -------------------------
@interface MHVCodedValue : MHVType

// -------------------------
//
// Data
//
// -------------------------
//
// (Required) Vocabulary Code
//
@property (readwrite, nonatomic, strong) NSString *code;
//
// (Required)The vocabulary code is from E.g. "Rx Norm Active Medications"
//
@property (readwrite, nonatomic, strong) NSString *vocabularyName;
//
// (Optional) Vocabulary Family. E.g. "RxNorm"
//
@property (readwrite, nonatomic, strong) NSString *vocabularyFamily;
//
// (Optional) Vocabulary Version
//
@property (readwrite, nonatomic, strong) NSString *vocabularyVersion;

// -------------------------
//
// Initializers
//
// -------------------------

- (instancetype)initWithCode:(NSString *)code andVocab:(NSString *)vocab;
- (instancetype)initWithCode:(NSString *)code vocab:(NSString *)vocab vocabFamily:(NSString *)family vocabVersion:(NSString *)version;

+ (MHVCodedValue *)fromCode:(NSString *)code andVocab:(NSString *)vocab;
+ (MHVCodedValue *)fromCode:(NSString *)code vocab:(NSString *)vocab vocabFamily:(NSString *)family vocabVersion:(NSString *)version;

// -------------------------
//
// Methods
//
// -------------------------

- (BOOL)isEqualToCodedValue:(MHVCodedValue *)value;
- (BOOL)isEqualToCode:(NSString *)code fromVocab:(NSString *)vocabName;
- (BOOL)isEqual:(id)object;

- (MHVCodedValue *)clone;

@end


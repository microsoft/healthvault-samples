//
// MHVCodableValue.h
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
#import "MHVCodedValue.h"

// -------------------------
//
// A Text value with an optional set of associated vocabulary codes
// E.g. the name of a medication, with optional RXNorm codes
//
// -------------------------
@interface MHVCodableValue : MHVType

// -------------------------
//
// Data
//
// -------------------------
//
// (Required)
//
@property (readwrite, nonatomic, strong) NSString *text;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) NSArray<MHVCodedValue *> *codes;
//
// Convenience properties
//
@property (readonly, nonatomic) BOOL hasCodes;
@property (readonly, nonatomic, strong) MHVCodedValue *firstCode;

// -------------------------
//
// Initializers
//
// -------------------------
- (instancetype)initWithText:(NSString *)textValue;
- (instancetype)initWithText:(NSString *)textValue andCode:(MHVCodedValue *)code;
- (instancetype)initWithText:(NSString *)textValue code:(NSString *)code andVocab:(NSString *)vocab;

+ (MHVCodableValue *)fromText:(NSString *)textValue;
+ (MHVCodableValue *)fromText:(NSString *)textValue andCode:(MHVCodedValue *)code;
+ (MHVCodableValue *)fromText:(NSString *)textValue code:(NSString *)code andVocab:(NSString *)vocab;

// -------------------------
//
// Methods
//
// -------------------------

- (BOOL)containsCode:(MHVCodedValue *)code;
- (BOOL)addCode:(MHVCodedValue *)code;
- (void)clearCodes;

- (MHVCodableValue *)clone;

// -------------------------
//
// Text
//
// -------------------------
- (NSString *)toString;
//
// Expects a format containing @%
//
- (NSString *)toStringWithFormat:(NSString *)format;
//
// Does a trimmed case insensitive comparison
//
- (BOOL)matchesDisplayText:(NSString *)text;

@end


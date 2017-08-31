//
// MHVVocabularyCodeItem.h
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

@interface MHVVocabularyCodeItem : MHVType

// -------------------------
//
// Data
//
// -------------------------
//
// (Required) - Vocabulary Code - such as RxNorm or Snomed code
//
@property (readwrite, nonatomic, strong) NSString *codeValue;
//
// (Required) - Vocab Display Text - the actual text
//
@property (readwrite, nonatomic, strong) NSString *displayText;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) NSString *abbreviationText;
//
// (Optional) - additional information about this vocab entry
// E.g. RxNorm can contain information about dosages and strengths
//
@property (readwrite, nonatomic, strong) NSString *infoXml;

// -------------------------
//
// Text
//
// -------------------------
- (NSString *)toString;
//
// Will do a trimmed, lower case comparison
//
- (BOOL)matchesDisplayText:(NSString *)text;

@end


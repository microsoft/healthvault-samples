//
// MHVPhone.h
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

@interface MHVPhone : MHVType

// -------------------------
//
// Data
//
// -------------------------
//
// (Required) Phone number
// Note: the SDK does not validate if the phone number is in valid
// phone number format.
//
@property (readwrite, nonatomic, strong) NSString *number;
//
// (Optional) A description of this number (Cell, Home, Work)
//
@property (readwrite, nonatomic, strong) NSString *type;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) MHVBool *isPrimary;

// -------------------------
//
// Initializers
//
// -------------------------
- (instancetype)initWithNumber:(NSString *)number;

// -------------------------
//
// Text
//
// -------------------------

- (NSString *)toString;

+ (MHVVocabularyIdentifier *)vocabForType;

@end


//
// MHVPerson.h
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
#import "MHVContact.h"
#import "MHVName.h"

@interface MHVPerson : MHVType

// -------------------------
//
// Data
//
// -------------------------
//
// (Required) Person's name
//
@property (readwrite, nonatomic, strong) MHVName *name;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) NSString *organization;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) NSString *training;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) NSString *identifier;
//
// (Optional) Contact information
//
@property (readwrite, nonatomic, strong) MHVContact *contact;
//
// (Optional)
// Vocabulary: person-types
//
@property (readwrite, nonatomic, strong) MHVCodableValue *type;

// -------------------------
//
// Initializers
//
// -------------------------
- (instancetype)initWithName:(NSString *)name andPhone:(NSString *)number;
- (instancetype)initWithName:(NSString *)name andEmail:(NSString *)email;
- (instancetype)initWithName:(NSString *)name phone:(NSString *)number andEmail:(NSString *)email;

- (instancetype)initWithFirstName:(NSString *)first lastName:(NSString *)last andPhone:(NSString *)number;
- (instancetype)initWithFirstName:(NSString *)first lastName:(NSString *)last andEmail:(NSString *)email;
- (instancetype)initWithFirstName:(NSString *)first lastName:(NSString *)last phone:(NSString *)phone andEmail:(NSString *)email;


// -------------------------
//
// Vocab
//
// -------------------------
+ (MHVVocabularyIdentifier *)vocabForPersonType;

// -------------------------
//
// Text
//
// -------------------------
//
// Returns the person's full name, if any
//
- (NSString *)toString;

@end

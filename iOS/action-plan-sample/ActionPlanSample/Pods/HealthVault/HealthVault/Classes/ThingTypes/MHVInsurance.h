//
// MHVInsurance.h
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

@interface MHVInsurance : MHVThingDataTyped

// ------------------
//
// Data
//
// -------------------
//
// (Optional) - Display Name for the plan
//
@property (readwrite, nonatomic, strong) NSString *planName;
//
// (Optional) - type of coverage E.g. 'Medical'
//
@property (readwrite, nonatomic, strong) MHVCodableValue *coverageType;
//
// (Optional)- carrier id
//
@property (readwrite, nonatomic, strong) NSString *carrierID;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) NSString *groupNum;
//
// (Optional) Plan code or prefix, such as MSJ
//
@property (readwrite, nonatomic, strong) NSString *planCode;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) NSString *subscriberID;
//
// (Optional) Person code OR SUFFIX. E.g. 01 = Subscriber
//
@property (readwrite, nonatomic, strong) NSString *personCode;
@property (readwrite, nonatomic, strong) NSString *subscriberName;
//
//
@property (readwrite, nonatomic, strong) MHVDateTime *subscriberDOB;
@property (readwrite, nonatomic, strong) MHVBool *isPrimary;
//
// (Optional) - When coverage expires
//
@property (readwrite, nonatomic, strong) MHVDateTime *expirationDate;
//
// (Optional) - Contact info
//
@property (readwrite, nonatomic, strong) MHVContact *contact;

// -------------------------
//
// Initializers
//
// -------------------------
+ (MHVThing *)newThing;

- (NSString *)toString;

// -------------------------
//
// Vocabulary
//
// -------------------------
+ (MHVVocabularyIdentifier *)vocabForCoverage;

// -------------------------
//
// Type information
//
// -------------------------
+ (NSString *)typeID;
+ (NSString *)XRootElement;


@end

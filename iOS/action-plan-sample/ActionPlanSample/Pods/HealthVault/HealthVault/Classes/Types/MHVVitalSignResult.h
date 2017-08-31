//
// MHVVitalSignResult.h
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
#import "MHVBaseTypes.h"
#import "MHVType.h"
#import "MHVCodableValue.h"

@interface MHVVitalSignResult : MHVType

// -------------------------
//
// Data
//
// -------------------------
//
// (Required)
// Vocabulary: vital-statistics
//
@property (readwrite, nonatomic, strong) MHVCodableValue *title;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) MHVDouble *value;
//
// (Optional)
// Vocabulary: lab-results-units
@property (readwrite, nonatomic, strong) MHVCodableValue *unit;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) MHVDouble *referenceMin;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) MHVDouble *referenceMax;
@property (readwrite, nonatomic, strong) NSString *textValue;
@property (readwrite, nonatomic, strong) MHVCodableValue *flag;

// -------------------------
//
// Initializers
//
// -------------------------

- (instancetype)initWithTitle:(MHVCodableValue *)title value:(double)value andUnit:(NSString *)unit;
- (instancetype)initWithTemperature:(double)value inCelsius:(BOOL)celsius;

// -------------------------
//
// Text
//
// -------------------------

//
// Format template => %@ %f %@
//
- (NSString *)toString;

@end


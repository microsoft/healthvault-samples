//
// MHVApproxMeasurement.h
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
#import "MHVMeasurement.h"

// -------------------------
//
// Sometimes it is not possible to get a precise numeric measurement.
// Descriptive (approx) measurements can include: "A lot", "Strong", "Weak", "Big", "Small"...
//
// -------------------------
@interface MHVApproxMeasurement : MHVType

// -------------------------
//
// Data
//
// -------------------------
//
// (Required) - You must supply at least a descriptive display text
//
@property (readwrite, nonatomic, strong) NSString *displayText;
//
// (Optional) - A coded measurement value
//
@property (readwrite, nonatomic, strong) MHVMeasurement *measurement;

//
// Convenience
//
@property (readonly, nonatomic) BOOL hasMeasurement;
// -------------------------
//
// Initializers
//
// -------------------------
- (instancetype)initWithDisplayText:(NSString *)text;
- (instancetype)initWithDisplayText:(NSString *)text andMeasurement:(MHVMeasurement *)measurement;

+ (MHVApproxMeasurement *)fromDisplayText:(NSString *)text;
+ (MHVApproxMeasurement *)fromDisplayText:(NSString *)text andMeasurement:(MHVMeasurement *)measurement;
+ (MHVApproxMeasurement *)fromValue:(double)value unitsText:(NSString *)unitsText unitsCode:(NSString *)code unitsVocab:(NSString *)vocab;

// -------------------------
//
// Text
//
// -------------------------
- (NSString *)toString;
- (NSString *)toStringWithFormat:(NSString *)format;

@end

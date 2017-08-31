//
// MHVMeasurement.h
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

// -------------------------
//
// Structured measurement, combining value and units
//
// -------------------------
@interface MHVMeasurement : MHVType

// -------------------------
//
// Data
//
// -------------------------
//
// (Required)
//
@property (readwrite, nonatomic) double value;
//
// (Required)
//
@property (readwrite, nonatomic, strong) MHVCodableValue *units;

// -------------------------
//
// Initializers
//
// -------------------------
- (instancetype)initWithValue:(double)value andUnits:(MHVCodableValue *)units;
- (instancetype)initWithValue:(double)value andUnitsString:(NSString *)units;

+ (MHVMeasurement *)fromValue:(double)value unitsDisplayText:(NSString *)unitsText unitsCode:(NSString *)code unitsVocab:(NSString *)vocab;
+ (MHVMeasurement *)fromValue:(double)value andUnits:(MHVCodableValue *)units;
+ (MHVMeasurement *)fromValue:(double)value andUnitsString:(NSString *)units;

// -------------------------
//
// Text
//
// -------------------------
- (NSString *)toString;
//
// Value  Units
// Expects string in the format "%f %@"
//
- (NSString *)toStringWithFormat:(NSString *)format;

@end

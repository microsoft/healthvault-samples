//
// Weight.h
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

@interface MHVWeight : MHVThingDataTyped

// -------------------------
//
// Data
//
// -------------------------
//
// (Required) When the measurement was made
//
@property (readwrite, nonatomic, strong) MHVDateTime *when;
//
// (Required) The weight measurement
// You can also use the inPounds and inKg properties to set the weight value
//
@property (readwrite, nonatomic, strong) MHVWeightMeasurement *value;

//
// Helper properties for manipulating weight
//
@property (readwrite, nonatomic) double inPounds;
@property (readwrite, nonatomic) double inKg;

// -------------------------
//
// Initializers
//
// -------------------------
- (instancetype)initWithKg:(double)kg andDate:(NSDate *)date;
- (instancetype)initWithPounds:(double)pounds andDate:(NSDate *)date;

+ (MHVThing *)newThing;
+ (MHVThing *)newThingWithKg:(double)kg andDate:(NSDate *)date;
+ (MHVThing *)newThingWithPounds:(double)pounds andDate:(NSDate *)date;

// -------------------------
//
// Text
//
// -------------------------
- (NSString *)toString;  // Returns weight in kg
- (NSString *)stringInPounds;
- (NSString *)stringInKg;
//
// These methods expect a format string with a %f in it, surrounded with other decorative text of your choice
//
- (NSString *)stringInPoundsWithFormat:(NSString *)format;
- (NSString *)stringInKgWithFormat:(NSString *)format;

// -------------------------
//
// Type Information
//
// -------------------------
+ (NSString *)typeID;
+ (NSString *)XRootElement;


@end

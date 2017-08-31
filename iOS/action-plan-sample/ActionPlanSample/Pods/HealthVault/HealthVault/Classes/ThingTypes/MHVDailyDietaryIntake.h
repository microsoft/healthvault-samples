//
// MHVDietaryIntake.h
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

// ------------------------
//
// DAILY Dietary Intake
// DEPRECATED.
// This type is obsolete.
// Use MHVDietaryIntake
//
// ------------------------
@interface MHVDailyDietaryIntake : MHVThingDataTyped

// -------------------------
//
// Data
//
// -------------------------
//
// (Required) - the day for this intake
//
@property (readwrite, nonatomic, strong) MHVDate *when;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) MHVPositiveInt *calories;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) MHVWeightMeasurement *totalFat;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) MHVWeightMeasurement *saturatedFat;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) MHVWeightMeasurement *transFat;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) MHVWeightMeasurement *protein;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) MHVWeightMeasurement *totalCarbs;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) MHVWeightMeasurement *sugar;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) MHVWeightMeasurement *dietaryFiber;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) MHVWeightMeasurement *sodium;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) MHVWeightMeasurement *cholesterol;

//
// Convenience properties
//
@property (readwrite, nonatomic) int caloriesValue;
@property (readwrite, nonatomic) double totalFatGrams;
@property (readwrite, nonatomic) double saturatedFatGrams;
@property (readwrite, nonatomic) double transFatGrams;
@property (readwrite, nonatomic) double proteinGrams;
@property (readwrite, nonatomic) double totalCarbGrams;
@property (readwrite, nonatomic) double sugarGrams;
@property (readwrite, nonatomic) double dietaryFiberGrams;
@property (readwrite, nonatomic) double sodiumMillgrams;
@property (readwrite, nonatomic) double cholesterolMilligrams;

+ (NSString *)typeID;
+ (NSString *)XRootElement;

+ (MHVThing *)newThing;

@end

//
// MHVExercise.h
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

@interface MHVExercise : MHVThingDataTyped

// -------------------------
//
// Data
//
// -------------------------
//
// (Required) When did you do this exercise
//
@property (readwrite, nonatomic, strong) MHVApproxDateTime *when;
//
// (Required) What activity did you perform?
// Preferred Vocabulary: exercise-activities
//
@property (readwrite, nonatomic, strong) MHVCodableValue *activity;
//
// Optional (a label)
//
@property (readwrite, nonatomic, strong) NSString *title;
//
// (Optional): Distance covered, if any
//
@property (readwrite, nonatomic, strong) MHVLengthMeasurement *distance;
//
// (Optional): Duration, if any
//
@property (readwrite, nonatomic, strong) MHVPositiveDouble *durationMinutes;
//
// (Optional): Additional details about the exercise
// E.g number of steps, calories burned...
//
// This collection of Name Value Pairs uses standardized names
// Standardized names should be taken from the vocabulary: exercise-detail-names
//
@property (readwrite, nonatomic, strong) NSArray<MHVNameValue *> *details;
//
// (Optional): Information about exercise segments
//
@property (readwrite, nonatomic, strong) NSMutableArray *segmentsXml;

// -----------------------------
//
// Convenience properties
//
// -----------------------------
@property (readonly, nonatomic) BOOL hasDetails;
@property (readwrite, nonatomic) double durationMinutesValue;

// -------------------------
//
// Initializers
//
// -------------------------
+ (MHVThing *)newThing;

- (instancetype)initWithDate:(NSDate *)date;

// -------------------------
//
// Methods
//
// -------------------------
//
// This assumes that the activity is from the standard vocabulary: exercise-activties
//
+ (MHVCodableValue *)createActivity:(NSString *)activity;
- (BOOL)setStandardActivity:(NSString *)activity;
//
// This assume that the exercise detail is from the standard vocab:exercise-detail-names
//
- (MHVNameValue *)getDetailWithNameCode:(NSString *)name;
- (BOOL)addOrUpdateDetailWithNameCode:(NSString *)name andValue:(MHVMeasurement *)value;

// -------------------------
//
// Exercise Details (self.details)
//
// -------------------------
+ (MHVNameValue *)createDetailWithNameCode:(NSString *)name andValue:(MHVMeasurement *)value;

+ (BOOL)isDetailForCaloriesBurned:(MHVNameValue *)nv;
+ (BOOL)isDetailForNumberOfSteps:(MHVNameValue *)nv;

//
// Uses VOCABULARIES
// - exercise-details-names for the detail Name
// - exercise-units for measurement units
//
+ (MHVCodableValue *)codeFromUnitsText:(NSString *)unitsText andUnitsCode:(NSString *)unitsCode;
+ (MHVCodableValue *)unitsCodeForCount;
+ (MHVCodableValue *)unitsCodeForCalories;

+ (MHVMeasurement *)measurementFor:(double)value unitsText:(NSString *)unitsText unitsCode:(NSString *)unitsCode;
+ (MHVMeasurement *)measurementForCount:(double)value;
+ (MHVMeasurement *)measurementForCalories:(double)value;

+ (MHVCodedValue *)detailNameWithCode:(NSString *)code;
+ (MHVCodedValue *)detailNameForSteps;
+ (MHVCodedValue *)detailNameForCaloriesBurned;

// -------------------------
//
// Vocabs
//
// -------------------------
+ (MHVVocabularyIdentifier *)vocabForActivities;
+ (MHVVocabularyIdentifier *)vocabForDetails;
+ (MHVVocabularyIdentifier *)vocabForUnits;


// -------------------------
//
// Type Information
//
// -------------------------

+ (NSString *)typeID;
+ (NSString *)XRootElement;

@end

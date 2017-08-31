//
// MHVBloodGlucose.h
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

@interface MHVBloodGlucose : MHVThingDataTyped

// -------------------------
//
// Data
//
// -------------------------
//
// (Required) when this measurement was taken
//
@property (readwrite, nonatomic, strong) MHVDateTime *when;
//
// (Required) Blood glucose value).
// You can also use the convenience inMmolPerLiter and inMgPerDL properties
//
@property (readwrite, nonatomic, strong) MHVBloodGlucoseMeasurement *value;
//
// (Required) What type of measurement (plasma, whole blood)
// Preferred Vocabulary: glucose-measurement-type
// You can use the createPlasmaMeasurementCode & createWholeBloodMeasurentCode methods
//
@property (readwrite, nonatomic, strong) MHVCodableValue *measurementType;
//
// (Optional) Is the reading outside operating tempature of the measuring device
//
@property (readwrite, nonatomic, strong) MHVBool *isOutsideOperatingTemp;
//
// (Optional) Was this reading the result of a control test?
//
@property (readwrite, nonatomic, strong) MHVBool *isControlTest;
//
// (Optional) How did this reading rate, relative to normal?
//
@property (readwrite, nonatomic) MHVRelativeRating normalcy;
//
// (Optional) measurement context
// Preferred Vocab: glucose-measurement-context
//
@property (readwrite, nonatomic, strong) MHVCodableValue *context;

//
// Convenience properties
//

@property (readwrite, nonatomic) double inMmolPerLiter;
@property (readwrite, nonatomic) double inMgPerDL;


// -------------------------
//
// Initializers
//
// -------------------------
- (instancetype)initWithMmolPerLiter:(double)value andDate:(NSDate *)date;

+ (MHVThing *)newThing;

// -------------------------
//
// Methods
//
// -------------------------
//
// You can use this to set the measurementType
//
+ (MHVCodableValue *)createPlasmaMeasurementType;
//
// You can use this to set the measurementType
//
+ (MHVCodableValue *)createWholeBloodMeasurementType;

+ (MHVVocabularyIdentifier *)vocabForMeasurementType;
+ (MHVVocabularyIdentifier *)vocabForContext;
+ (MHVVocabularyIdentifier *)vocabForNormalcy;

// -------------------------
//
// Text
//
// -------------------------
//
// These methods expect a format string containing a single %f
//
- (NSString *)stringInMmolPerLiter:(NSString *)format;
- (NSString *)stringInMgPerDL:(NSString *)format;
- (NSString *)toString;
- (NSString *)normalcyText;

// -------------------------
//
// Type information
//
// -------------------------
+ (NSString *)typeID;
+ (NSString *)XRootElement;

@end

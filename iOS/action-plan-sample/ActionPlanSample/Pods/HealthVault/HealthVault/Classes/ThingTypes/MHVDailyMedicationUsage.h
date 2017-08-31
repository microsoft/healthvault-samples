//
// MHVDailyMedicationUsage.h
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

@interface MHVDailyMedicationUsage : MHVThingDataTyped

// -------------------------
//
// Data
//
// -------------------------
//
// (Required) The day when the medication was consumed
//
@property (readwrite, nonatomic, strong) MHVDate *when;
//
// (Required) The drug/substance/supplement used
// Vocabulary: RxNorm
//
@property (readwrite, nonatomic, strong) MHVCodableValue *drugName;
//
// (Required) number of doses.
//
@property (readwrite, nonatomic, strong) MHVInt *dosesConsumed;
//
// (Optional) why the medication was taken
//
@property (readwrite, nonatomic, strong) MHVCodableValue *purpose;
//
// (Optional) How many doses were meant to be taken
//
@property (readwrite, nonatomic, strong) MHVInt *dosesIntended;
//
// All Optional
//
@property (readwrite, nonatomic, strong) MHVCodableValue *usageSchedule;
@property (readwrite, nonatomic, strong) MHVCodableValue *drugForm;
@property (readwrite, nonatomic, strong) MHVCodableValue *prescriptionType;
@property (readwrite, nonatomic, strong) MHVCodableValue *singleDoseDescription;

//
// Convenience
//
@property (readwrite, nonatomic) int dosesConsumedValue;
@property (readwrite, nonatomic) int dosesIntendedValue;

// -------------------------
//
// Initializers
//
// -------------------------
- (instancetype)initWithDoses:(int)doses forDrug:(MHVCodableValue *)drug onDay:(NSDate *)day;
- (instancetype)initWithDoses:(int)doses forDrug:(MHVCodableValue *)drug onDate:(MHVDate *)date;

+ (MHVThing *)newThing;

// -------------------------
//
// Text
//
// -------------------------
- (NSString *)toString;

// -------------------------
//
// Type Info
//
// -------------------------
+ (NSString *)typeID;
+ (NSString *)XRootElement;


@end

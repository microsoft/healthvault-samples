//
// MHVSleepJournal.h
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

typedef NS_ENUM (NSInteger, MHVWakeState)
{
    MHVWakeState_Unknown = 0,
    MHVWakeState_WideAwake = 1,
    MHVWakeState_Awake,
    MHVWakeState_Sleepy
};

// -------------------------
//
// Journal entries you make when you wake up in the morning
//
// -------------------------
@interface MHVSleepJournalAM : MHVThingDataTyped

// -------------------------
//
// Data
//
// -------------------------
//
// (Required) - Journal Entry is for this date/time
//
@property (readwrite, nonatomic, strong) MHVDateTime *when;
//
// (Required) - time you went to bed
//
@property (readwrite, nonatomic, strong) MHVTime *bedTime;
//
// (Required) - time you finally woke up and got out of bed
//
@property (readwrite, nonatomic, strong) MHVTime *wakeTime;
//
// (Required) - how long you slept for
//
@property (readwrite, nonatomic, strong) MHVNonNegativeInt *sleepMinutes;
//
// (Required) - how long it took you to fall asleep
//
@property (readwrite, nonatomic, strong) MHVNonNegativeInt *settlingMinutes;
//
// (Required) - how you felt when you woke up
//
@property (readwrite, nonatomic) MHVWakeState wakeState;
//
// (Optional) - how many times you woke up or had your sleep interrupted
//
@property (readwrite, nonatomic, strong) NSArray<MHVOccurence *> *awakenings;
//
// (Optional) - medications you took before going to bed
//
@property (readwrite, nonatomic, strong) MHVCodableValue *medicationsBeforeBed;

//
// Convenience
//
@property (readonly, nonatomic) BOOL hasAwakenings;
@property (readwrite, nonatomic) int sleepMinutesValue;
@property (readwrite, nonatomic) int settlingMinutesValue;

// -------------------------
//
// Initializers
//
// -------------------------

- (instancetype)initWithBedtime:(NSDate *)bedtime onDate:(NSDate *)date settlingMinutes:(int)settlingMinutes sleepingMinutes:(int)sleepingMinutes wokeupAt:(NSDate *)wakeTime;

+ (MHVThing *)newThing;

// -------------------------
//
// Type info
//
// -------------------------

+ (NSString *)typeID;
+ (NSString *)XRootElement;

@end

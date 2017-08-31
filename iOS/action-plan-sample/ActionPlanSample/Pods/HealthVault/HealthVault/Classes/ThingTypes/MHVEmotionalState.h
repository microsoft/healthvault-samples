//
// MHVEmotionalState.h
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

typedef NS_ENUM (NSInteger, MHVMood)
{
    MHVMoodUnknown = 0,
    MHVMoodDepressed,
    MHVMoodSad,
    MHVMoodNeutral,
    MHVMoodHappy,
    MHVMoodElated
};

NSString *stringFromMood(MHVMood mood);

typedef NS_ENUM (NSInteger, MHVWellBeing)
{
    MHVWellBeingUnknown = 0,
    MHVWellBeingSick,
    MHVWellBeingImpaired,
    MHVWellBeingAble,
    MHVWellBeingHealthy,
    MHVWellBeingVigorous
};

NSString *stringFromWellBeing(MHVWellBeing wellBeing);

@interface MHVEmotionalState : MHVThingDataTyped

// -------------------------
//
// Data
//
// -------------------------
//
// (Optional) Emotional state this THIS time
//
@property (readwrite, nonatomic, strong) MHVDateTime *when;
//
// (Optional) Mood rating - happy, depressed, sad..
//
@property (readwrite, nonatomic) MHVMood mood;
//
// (Optional) A relative stress level
//
@property (readwrite, nonatomic) MHVRelativeRating stress;
//
// (Optional) Sick, Healthy etc
//
@property (readwrite, nonatomic) MHVWellBeing wellbeing;

// -------------------------
//
// Initializers
//
// -------------------------
+ (MHVThing *)newThing;

// -------------------------
//
// Text
//
// -------------------------
- (NSString *)moodAsString;
- (NSString *)stressAsString;
- (NSString *)wellBeingAsString;

- (NSString *)toString;
// @Mood @Stress @WellBeing
- (NSString *)toStringWithFormat:(NSString *)format;

// -------------------------
//
// Type Info
//
// -------------------------
+ (NSString *)typeID;
+ (NSString *)XRootElement;


@end

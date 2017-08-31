//
// MHVSleepJournalPM.h
// MHVLib
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

typedef NS_ENUM (NSInteger, MHVSleepiness)
{
    MHVSleepiness_Unknown,
    MHVSleepiness_VerySleepy,
    MHVSleepiness_Tired,
    MHVSleepiness_Alert,
    MHVSleepiness_WideAwake
};

NSString *stringFromSleepiness(MHVSleepiness sleepiness);

@interface MHVSleepJournalPM : MHVThingDataTyped

// -------------------------
//
// Data
//
// -------------------------
///
// Required
//
@property (readwrite, nonatomic, strong) MHVDateTime *when;
@property (readwrite, nonatomic) MHVSleepiness sleepiness;
//
// Optional
//
@property (readwrite, nonatomic, strong) NSArray<MHVTime *> *caffeineIntakeTimes;
@property (readwrite, nonatomic, strong) NSArray<MHVTime *> *alcoholIntakeTimes;
@property (readwrite, nonatomic, strong) NSArray<MHVOccurence *> *naps;
@property (readwrite, nonatomic, strong) NSArray<MHVOccurence *> *exercise;

@property (readonly, nonatomic) BOOL hasCaffeineIntakeTimes;
@property (readonly, nonatomic) BOOL hasAlcoholIntakeTimes;
@property (readonly, nonatomic) BOOL hasNaps;
@property (readonly, nonatomic) BOOL hasExercise;

// -------------------------
//
// Initializers
//
// -------------------------
+ (MHVThing *)newThing;

- (NSString *)sleepinessAsString;

// -------------------------
//
// Type info
//
// -------------------------
+ (NSString *)typeID;
+ (NSString *)XRootElement;


@end

//
// MHVSleepJournalPM.m
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

#import "MHVValidator.h"
#import "MHVSleepJournalPM.h"
#import "NSArray+Utils.h"

static NSString *const c_typeid = @"031f5706-7f1a-11db-ad56-7bd355d89593";
static NSString *const c_typename = @"sleep-pm";

static NSString *const c_element_when = @"when";
static NSString *const c_element_caffeine = @"caffeine";
static NSString *const c_element_alcohol = @"alcohol";
static NSString *const c_element_nap = @"nap";
static NSString *const c_element_exercise = @"exercise";
static NSString *const c_element_sleepiness = @"sleepiness";

NSString *stringFromSleepiness(MHVSleepiness sleepiness)
{
    switch (sleepiness)
    {
        case MHVSleepiness_VerySleepy:
            return @"Very Sleepy";
            
        case MHVSleepiness_Tired:
            return @"Tired";
            
        case MHVSleepiness_Alert:
            return @"Alert";
            
        case MHVSleepiness_WideAwake:
            return @"Wide Awake";
            
        default:
            break;
    }
    
    return @"";
}

@interface MHVSleepJournalPM ()

@property (nonatomic, strong) MHVPositiveInt *sleepinessValue;

@end

@implementation MHVSleepJournalPM

- (NSArray<MHVTime *> *)caffeineIntakeTimes
{
    if (!_caffeineIntakeTimes)
    {
        _caffeineIntakeTimes = @[];
    }
    
    return _caffeineIntakeTimes;
}

- (BOOL)hasCaffeineIntakeTimes
{
    return ![NSArray isNilOrEmpty:self.caffeineIntakeTimes];
}

- (NSArray<MHVTime *> *)alcoholIntakeTimes
{
    if (!_alcoholIntakeTimes)
    {
        _alcoholIntakeTimes = @[];
    }
    
    return _alcoholIntakeTimes;
}

- (BOOL)hasAlcoholIntakeTimes
{
    return ![NSArray isNilOrEmpty:self.alcoholIntakeTimes];
}

- (NSArray<MHVOccurence *> *)naps
{
    if (!_naps)
    {
        _naps = @[];
    }
    
    return _naps;
}

- (BOOL)hasNaps
{
    return ![NSArray isNilOrEmpty:self.naps];
}

- (NSArray<MHVOccurence *> *)exercise
{
    if (!_exercise)
    {
        _exercise = @[];
    }
    
    return _exercise;
}

- (BOOL)hasExercise
{
    return ![NSArray isNilOrEmpty:self.exercise];
}

- (MHVSleepiness)sleepiness
{
    return (self.sleepinessValue) ? (MHVSleepiness)(self.sleepinessValue.value) : MHVSleepiness_Unknown;
}

- (void)setSleepiness:(MHVSleepiness)sleepiness
{
    if (sleepiness == MHVSleepiness_Unknown)
    {
        self.sleepinessValue = nil;
    }
    else
    {
        if (!self.sleepinessValue)
        {
            self.sleepinessValue = [[MHVPositiveInt alloc] init];
        }
        
        self.sleepinessValue.value = sleepiness;
    }
}

- (NSString *)sleepinessAsString
{
    return stringFromSleepiness(self.sleepiness);
}

- (NSDate *)getDate
{
    return [self.when toDate];
}

- (NSDate *)getDateForCalendar:(NSCalendar *)calendar
{
    return [self.when toDateForCalendar:calendar];
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN
    
    MHVVALIDATE(self.when, MHVClientError_InvalidSleepJournal);
    MHVVALIDATE(self.sleepinessValue, MHVClientError_InvalidSleepJournal);
    MHVVALIDATE_ARRAYOPTIONAL(self.caffeineIntakeTimes, MHVClientError_InvalidSleepJournal);
    MHVVALIDATE_ARRAYOPTIONAL(self.alcoholIntakeTimes, MHVClientError_InvalidSleepJournal);
    MHVVALIDATE_ARRAYOPTIONAL(self.naps, MHVClientError_InvalidSleepJournal);
    
    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_when content:self.when];
    [writer writeElementArray:c_element_caffeine elements:self.caffeineIntakeTimes];
    [writer writeElementArray:c_element_alcohol elements:self.alcoholIntakeTimes];
    [writer writeElementArray:c_element_nap elements:self.naps];
    [writer writeElementArray:c_element_exercise elements:self.exercise];
    [writer writeElement:c_element_sleepiness content:self.sleepinessValue];
}

- (void)deserialize:(XReader *)reader
{
    self.when = [reader readElement:c_element_when asClass:[MHVDateTime class]];
    self.caffeineIntakeTimes = [reader readElementArray:c_element_caffeine asClass:[MHVTime class] andArrayClass:[NSMutableArray class]];
    self.alcoholIntakeTimes = [reader readElementArray:c_element_alcohol asClass:[MHVTime class] andArrayClass:[NSMutableArray class]];
    self.naps = [reader readElementArray:c_element_nap asClass:[MHVOccurence class] andArrayClass:[NSMutableArray class]];
    self.exercise = [reader readElementArray:c_element_exercise asClass:[MHVOccurence class] andArrayClass:[NSMutableArray class]];
    self.sleepinessValue = [reader readElement:c_element_sleepiness asClass:[MHVPositiveInt class]];
}

+ (NSString *)typeID
{
    return c_typeid;
}

+ (NSString *)XRootElement
{
    return c_typename;
}

+ (MHVThing *)newThing
{
    return [[MHVThing alloc] initWithType:[MHVSleepJournalPM typeID]];
}

@end

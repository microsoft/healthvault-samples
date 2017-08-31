//
// MHVEmotionalState.m
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

#import "MHVEmotionalState.h"
#import "MHVValidator.h"

NSString *stringFromMood(MHVMood mood)
{
    switch (mood)
    {
        case MHVMoodDepressed:
            return @"Depressed";
            
        case MHVMoodSad:
            return @"Sad";
            
        case MHVMoodNeutral:
            return @"Neutral";
            
        case MHVMoodHappy:
            return @"Happy";
            
        case MHVMoodElated:
            return @"Elated";
            
        default:
            break;
    }
    
    return @"";
}

NSString *stringFromWellBeing(MHVWellBeing wellBeing)
{
    switch (wellBeing)
    {
        case MHVWellBeingSick:
            return @"Sick";
            
        case MHVWellBeingImpaired:
            return @"Impaired";
            
        case MHVWellBeingAble:
            return @"Able";
            
        case MHVWellBeingHealthy:
            return @"Healthy";
            
        case MHVWellBeingVigorous:
            return @"Vigorous";
            
        default:
            break;
    }
    
    return @"";
}

static NSString *const c_typeid = @"4b7971d6-e427-427d-bf2c-2fbcf76606b3";
static NSString *const c_typename = @"emotion";

static const xmlChar *x_element_when = XMLSTRINGCONST("when");
static const xmlChar *x_element_mood = XMLSTRINGCONST("mood");
static const xmlChar *x_element_stress = XMLSTRINGCONST("stress");
static const xmlChar *x_element_wellbeing = XMLSTRINGCONST("wellbeing");

@interface MHVEmotionalState ()

@property (nonatomic, strong) MHVOneToFive *moodValue;
@property (nonatomic, strong) MHVOneToFive *stressValue;
@property (nonatomic, strong) MHVOneToFive *wellbeingValue;

@end

@implementation MHVEmotionalState

- (NSDate *)getDate
{
    return [self.when toDate];
}

- (NSDate *)getDateForCalendar:(NSCalendar *)calendar
{
    return [self.when toDateForCalendar:calendar];
}

- (MHVMood)mood
{
    return (self.moodValue) ? (MHVMood)self.moodValue.value : MHVMoodUnknown;
}

- (void)setMood:(MHVMood)mood
{
    if (mood == MHVMoodUnknown)
    {
        self.moodValue = nil;
    }
    else
    {
        if (!self.moodValue)
        {
            self.moodValue = [[MHVOneToFive alloc] init];
        }
        
        self.moodValue.value = (int)mood;
    }
}

- (MHVRelativeRating)stress
{
    return (self.stressValue) ? (MHVRelativeRating)self.stressValue.value : MHVRelativeRating_None;
}

- (void)setStress:(MHVRelativeRating)stress
{
    if (stress == MHVRelativeRating_None)
    {
        self.stressValue = nil;
    }
    else
    {
        if (!self.stressValue)
        {
            self.stressValue = [[MHVOneToFive alloc] init];
        }
        
        self.stressValue.value = (int)stress;
    }
}

- (MHVWellBeing)wellbeing
{
    return (self.wellbeingValue) ? (MHVWellBeing)self.wellbeingValue.value : MHVWellBeingUnknown;
}

- (void)setWellbeing:(MHVWellBeing)wellbeing
{
    if (wellbeing == MHVWellBeingUnknown)
    {
        self.wellbeingValue = nil;
    }
    else
    {
        if (!self.wellbeingValue)
        {
            self.wellbeingValue = [[MHVOneToFive alloc] init];
        }
        
        self.wellbeingValue.value = (int)wellbeing;
    }
}

- (NSString *)moodAsString
{
    return stringFromMood(self.mood);
}

- (NSString *)wellBeingAsString
{
    return stringFromWellBeing(self.wellbeing);
}

- (NSString *)stressAsString
{
    return stringFromRating(self.stress);
}

- (NSString *)description
{
    return [self toString];
}

- (NSString *)toString
{
    return [self toStringWithFormat:@"Mood=%@, Stress=%@, Wellbeing=%@"];
}

- (NSString *)toStringWithFormat:(NSString *)format
{
    return [NSString stringWithFormat:format, [self moodAsString], [self stressAsString], [self wellBeingAsString]];
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN
    
    MHVVALIDATE_OPTIONAL(self.when);
    MHVVALIDATE_OPTIONAL(self.moodValue);
    MHVVALIDATE_OPTIONAL(self.stressValue);
    MHVVALIDATE_OPTIONAL(self.wellbeingValue);
    
    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementXmlName:x_element_when content:self.when];
    [writer writeElementXmlName:x_element_mood content:self.moodValue];
    [writer writeElementXmlName:x_element_stress content:self.stressValue];
    [writer writeElementXmlName:x_element_wellbeing content:self.wellbeingValue];
}

- (void)deserialize:(XReader *)reader
{
    self.when = [reader readElementWithXmlName:x_element_when asClass:[MHVDateTime class]];
    self.moodValue = [reader readElementWithXmlName:x_element_mood asClass:[MHVOneToFive class]];
    self.stressValue = [reader readElementWithXmlName:x_element_stress asClass:[MHVOneToFive class]];
    self.wellbeingValue = [reader readElementWithXmlName:x_element_wellbeing asClass:[MHVOneToFive class]];
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
    return [[MHVThing alloc] initWithType:[MHVEmotionalState typeID]];
}

- (NSString *)typeName
{
    return NSLocalizedString(@"Emotional state", @"Emotional state Type Name");
}

@end

//
// ThingDataTyped.m
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

#import "MHVValidator.h"
#import "MHVThingDataTyped.h"
#import "MHVThingTypes.h"

@implementation MHVThingDataTyped

- (NSString *)type
{
    return [[self class] typeID];
}

- (NSString *)rootElement
{
    return [[self class] XRootElement];
}

- (BOOL)hasRawData
{
    return FALSE;
}

- (BOOL)isSingleton
{
    return [[self class] isSingletonType];
}

- (NSDate *)getDate
{
    return nil;
}

- (NSDate *)getDateForCalendar:(NSCalendar *)calendar
{
    return [self getDate];
}

+ (NSString *)typeID
{
    return @"";
}

+ (NSString *)XRootElement
{
    return @"";
}

- (NSString *)typeName
{
    return @"";
}

+ (BOOL)isSingletonType
{
    return FALSE;
}

@end


static MHVTypeSystem *s_typeRegistry;

@interface MHVTypeSystem ()

@property (nonatomic, strong) NSMutableDictionary *types;
@property (nonatomic, strong) NSMutableDictionary *identifiers;

@end

@implementation MHVTypeSystem

+ (void)initialize
{
    s_typeRegistry = [[MHVTypeSystem alloc] init];

    [s_typeRegistry addClass:[MHVWeight class] forTypeID:[MHVWeight typeID]];
    [s_typeRegistry addClass:[MHVBloodPressure class] forTypeID:[MHVBloodPressure typeID]];
    [s_typeRegistry addClass:[MHVCholesterol class] forTypeID:[MHVCholesterol typeID]];
    [s_typeRegistry addClass:[MHVBloodGlucose class] forTypeID:[MHVBloodGlucose typeID]];
    [s_typeRegistry addClass:[MHVHeartRate class] forTypeID:[MHVHeartRate typeID]];
    [s_typeRegistry addClass:[MHVHeight class] forTypeID:[MHVHeight typeID]];
    [s_typeRegistry addClass:[MHVPeakFlow class] forTypeID:[MHVPeakFlow typeID]];

    [s_typeRegistry addClass:[MHVExercise class] forTypeID:[MHVExercise typeID]];
    [s_typeRegistry addClass:[MHVDailyMedicationUsage class] forTypeID:[MHVDailyMedicationUsage typeID]];
    [s_typeRegistry addClass:[MHVEmotionalState class] forTypeID:[MHVEmotionalState typeID]];
    [s_typeRegistry addClass:[MHVDailyDietaryIntake class] forTypeID:[MHVDailyDietaryIntake typeID]];
    [s_typeRegistry addClass:[MHVDietaryIntake class] forTypeID:[MHVDietaryIntake typeID]];
    [s_typeRegistry addClass:[MHVSleepJournalAM class] forTypeID:[MHVSleepJournalAM typeID]];
    [s_typeRegistry addClass:[MHVSleepJournalPM class] forTypeID:[MHVSleepJournalPM typeID]];

    [s_typeRegistry addClass:[MHVAllergy class] forTypeID:[MHVAllergy typeID]];
    [s_typeRegistry addClass:[MHVCondition class] forTypeID:[MHVCondition typeID]];
    [s_typeRegistry addClass:[MHVMedication class] forTypeID:[MHVMedication typeID]];
    [s_typeRegistry addClass:[MHVImmunization class] forTypeID:[MHVImmunization typeID]];
    [s_typeRegistry addClass:[MHVProcedure class] forTypeID:[MHVProcedure typeID]];
    [s_typeRegistry addClass:[MHVVitalSigns class] forTypeID:[MHVVitalSigns typeID]];
    [s_typeRegistry addClass:[MHVEncounter class] forTypeID:[MHVEncounter typeID]];
    [s_typeRegistry addClass:[MHVFamilyHistory class] forTypeID:[MHVFamilyHistory typeID]];
    [s_typeRegistry addClass:[MHVCCD class] forTypeID:[MHVCCD typeID]];
    [s_typeRegistry addClass:[MHVCCR class] forTypeID:[MHVCCR typeID]];
    [s_typeRegistry addClass:[MHVInsurance class] forTypeID:[MHVInsurance typeID]];
    [s_typeRegistry addClass:[MHVMessage class] forTypeID:[MHVMessage typeID]];
    [s_typeRegistry addClass:[MHVLabTestResults class] forTypeID:[MHVLabTestResults typeID]];

    [s_typeRegistry addClass:[MHVEmergencyOrProviderContact class] forTypeID:[MHVEmergencyOrProviderContact typeID]];
    [s_typeRegistry addClass:[MHVPersonalContactInfo class] forTypeID:[MHVPersonalContactInfo typeID]];
    [s_typeRegistry addClass:[MHVBasicDemographics class] forTypeID:[MHVBasicDemographics typeID]];
    [s_typeRegistry addClass:[MHVPersonalDemographics class] forTypeID:[MHVPersonalDemographics typeID]];
    [s_typeRegistry addClass:[MHVPersonalImage class] forTypeID:[MHVPersonalImage typeID]];

    [s_typeRegistry addClass:[MHVAssessment class] forTypeID:[MHVAssessment typeID]];
    [s_typeRegistry addClass:[MHVQuestionAnswer class] forTypeID:[MHVQuestionAnswer typeID]];

    [s_typeRegistry addClass:[MHVFile class] forTypeID:[MHVFile typeID]];
    
    [s_typeRegistry addClass:[MHVAdvanceDirective class] forTypeID:[MHVAdvanceDirective typeID]];
    [s_typeRegistry addClass:[MHVAerobicProfile class] forTypeID:[MHVAerobicProfile typeID]];
    [s_typeRegistry addClass:[MHVAllergicEpisode class] forTypeID:[MHVAllergicEpisode typeID]];
    [s_typeRegistry addClass:[MHVAppSpecificInformation class] forTypeID:[MHVAppSpecificInformation typeID]];
    [s_typeRegistry addClass:[MHVAppointment class] forTypeID:[MHVAppointment typeID]];
    [s_typeRegistry addClass:[MHVExplanationOfBenefits class] forTypeID:[MHVExplanationOfBenefits typeID]];
    [s_typeRegistry addClass:[MHVHealthGoal class] forTypeID:[MHVHealthGoal typeID]];
    [s_typeRegistry addClass:[MHVHealthJournalEntry class] forTypeID:[MHVHealthJournalEntry typeID]];
    [s_typeRegistry addClass:[MHVInsight class] forTypeID:[MHVInsight typeID]];
    [s_typeRegistry addClass:[MHVMedicalDevice class] forTypeID:[MHVMedicalDevice typeID]];
    [s_typeRegistry addClass:[MHVMenstruation class] forTypeID:[MHVMenstruation typeID]];
    [s_typeRegistry addClass:[MHVPlan class] forTypeID:[MHVPlan typeID]];
    [s_typeRegistry addClass:[MHVPregnancy class] forTypeID:[MHVPregnancy typeID]];
    [s_typeRegistry addClass:[MHVTaskThing class] forTypeID:[MHVTaskThing typeID]];
    [s_typeRegistry addClass:[MHVTaskTrackingEntry class] forTypeID:[MHVTaskTrackingEntry typeID]];
    [s_typeRegistry addClass:[MHVAsthmaInhaler class] forTypeID:[MHVAsthmaInhaler typeID]];
    [s_typeRegistry addClass:[MHVAsthmaInhalerUsage class] forTypeID:[MHVAsthmaInhalerUsage typeID]];
    [s_typeRegistry addClass:[MHVBodyComposition class] forTypeID:[MHVBodyComposition typeID]];
    [s_typeRegistry addClass:[MHVBodyDimension class] forTypeID:[MHVBodyDimension typeID]];
    [s_typeRegistry addClass:[MHVMedicalImageStudy class] forTypeID:[MHVMedicalImageStudy typeID]];
}

+ (MHVTypeSystem *)current
{
    return s_typeRegistry;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _types = [[NSMutableDictionary alloc] init];
        _identifiers = [[NSMutableDictionary alloc] init];
    }

    return self;
}

- (MHVThingDataTyped *)newFromTypeID:(NSString *)typeID
{
    Class class = nil;

    if (typeID != nil)
    {
        class = [self getClassForTypeID:typeID];
    }

    if (class == nil)
    {
        return nil;
    }

    return [[class alloc] init];
}

- (Class)getClassForTypeID:(NSString *)type
{
    MHVCHECK_STRING(type);

    @synchronized(self.types)
    {
        Class cls = [self.types objectForKey:type];

        if (!cls)
        {
            // Try forcing lower case
            cls = [self.types objectForKey:[type lowercaseString]];
        }

        return cls;
    }

    return nil;
}

- (NSString *)getTypeIDForClassName:(NSString *)name
{
    return [self.identifiers objectForKey:name];
}

- (BOOL)addClass:(Class)class forTypeID : (NSString *)typeID
{
    MHVCHECK_NOTNULL(typeID);
    MHVCHECK_NOTNULL(class);
    
    @synchronized(self.types)
    {
        typeID = [typeID lowercaseString];
        
        [self.types setObject:class forKey:typeID];
        
        NSString *name = NSStringFromClass(class);
        [self.identifiers setObject:typeID forKey:name];
    }
    
    return TRUE;
}

@end

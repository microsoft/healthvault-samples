//
// MHVClientResult.h
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

#if DEBUG
#define MHV_DETAILEDTYPEERRORS 1
#endif

#define MHVRESULT_SUCCESS [MHVClientResult success]
#define MHVERROR_UNKNOWN [MHVClientResult unknownError]

#ifdef MHV_DETAILEDTYPEERRORS
#define MHVMAKE_ERROR(code) [MHVClientResult fromCode:code fileName: __FILE__ lineNumber: __LINE__]
#else
#define MHVMAKE_ERROR(code) [MHVClientResult fromCode:code]
#endif


typedef NS_ENUM(NSInteger, MHVClientResultCode)
{
    MHVClientResult_Success = 0,
    //
    // Errors
    //
    MHVClientError_Unknown,
    MHVClientError_Web,
    MHVClientEror_InvalidMasterAppID,
    MHVClientError_UnknownServiceInstance,
    //
    // Base types
    //
    MHVClientError_InvalidGuid,
    MHVClientError_ValueOutOfRange,
    MHVClientError_InvalidStringLength,
    //
    // Types
    //
    MHVClientError_InvalidDate,
    MHVClientError_InvalidTime,
    MHVClientError_InvalidDateTime,
    MHVClientError_InvalidApproxDateTime,
    MHVClientError_InvalidCodedValue,
    MHVClientError_InvalidCodableValue,
    MHVClientError_InvalidDisplayValue,
    MHVClientError_InvalidMeasurement,
    MHVClientError_InvalidApproxMeasurement,
    MHVClientError_InvalidWeightMeasurement,
    MHVClientError_InvalidLengthMeasurement,
    MHVClientError_InvalidBloodGlucoseMeasurement,
    MHVClientError_InvalidConcentrationValue,
    MHVClientError_InvalidVitalSignResult,
    MHVClientError_InvalidNameValue,
    MHVClientError_InvalidDuration,
    MHVClientError_InvalidAddress,
    MHVClientError_InvalidPhone,
    MHVClientError_InvalidEmailAddress,
    MHVClientError_InvalidEmail,
    MHVClientError_InvalidContact,
    MHVClientError_InvalidName,
    MHVClientError_InvalidPerson,
    MHVClientError_InvalidOrganization,
    MHVClientError_InvalidPrescription,
    MHVClientError_InvalidThingKey,
    MHVClientError_InvalidRelatedThing,
    MHVClientError_InvalidThingType,
    MHVClientError_InvalidThingView,
    MHVClientError_InvalidThingQuery,
    MHVClientError_InvalidThing,
    MHVClientError_InvalidRecordReference,
    MHVClientError_InvalidRecord,
    MHVClientError_InvalidPersonInfo,
    MHVClientError_InvalidPendingThing,
    MHVClientError_InvalidThingList,
    MHVClientError_InvalidVocabIdentifier,
    MHVClientError_InvalidVocabThing,
    MHVClientError_InvalidVocabSearch,
    MHVClientError_InvalidAssessmentField,
    MHVClientError_InvalidOccurrence,
    MHVClientError_InvalidRelative,
    MHVClientError_InvalidFlow,
    MHVClientError_InvalidVolume,
    MHVClientError_InvalidMessageHeader,
    MHVClientError_InvalidMessageAttachment,
    MHVClientError_InvalidTestResultRange,
    MHVClientError_InvalidLabTestResultValue,
    MHVClientError_InvalidLabTestResultDetails,
    MHVClientError_InvalidLabTestResultsGroup,
    //
    // Blobs
    //
    MHVClientError_InvalidBlobInfo,
    //
    // Thing Types
    //
    MHVClientError_InvalidWeight,
    MHVClientError_InvalidBloodPressure,
    MHVClientError_InvalidCholesterol,
    MHVClientError_InvalidBloodGlucose,
    MHVClientError_InvalidHeight,
    MHVClientError_InvalidExercise,
    MHVClientError_InvalidAllergy,
    MHVClientError_InvalidCondition,
    MHVClientError_InvalidImmunization,
    MHVClientError_InvalidMedication,
    MHVClientError_InvalidProcedure,
    MHVClientError_InvalidVitalSigns,
    MHVClientError_InvalidEncounter,
    MHVClientError_InvalidFamilyHistory,
    MHVClientError_InvalidEmergencyContact,
    MHVClientError_InvalidPersonalContactInfo,
    MHVClientError_InvalidBasicDemographics,
    MHVClientError_InvalidPersonalDemographics,
    MHVClientError_InvalidDailyMedicationUsage,
    MHVClientError_InvalidAssessment,
    MHVClientError_InvalidQuestionAnswer,
    MHVClientError_InvalidSleepJournal,
    MHVClientError_InvalidDietaryIntake,
    MHVClientError_InvalidFile,
    MHVClientError_InvalidCCD,
    MHVClientError_InvalidCCR,
    MHVClientError_InvalidInsurance,
    MHVClientError_InvalidHeartRate,
    MHVClientError_InvalidPeakFlow,
    MHVClientError_InvalidMessage,
    MHVclientError_InvalidLabTestResults,
    //
    // Store
    //
    MHVClientError_Sync,
    MHVClientError_PutLocalStore
};

@interface MHVClientResult : NSObject

@property (readonly, nonatomic) BOOL isSuccess;
@property (readonly, nonatomic) BOOL isError;

@property (readonly, nonatomic) MHVClientResultCode error;
@property (readonly, nonatomic) const char *fileName;
@property (readonly, nonatomic) int lineNumber;

- (instancetype)init;
- (instancetype)initWithCode:(MHVClientResultCode)code;
- (instancetype)initWithCode:(MHVClientResultCode)code fileName:(const char *)fileName lineNumber:(int)line;

+ (MHVClientResult *)success;
+ (MHVClientResult *)unknownError;
+ (MHVClientResult *)fromCode:(MHVClientResultCode)code;
+ (MHVClientResult *)fromCode:(MHVClientResultCode)code fileName:(const char *)fileName lineNumber:(int)line;

@end

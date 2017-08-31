//
//  MHVMethod.h
//  MHVLib
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
#import "MHVHttpServiceOperationProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MHVMethod : NSObject <MHVHttpServiceOperationProtocol>

/**
 The name of the method to be called. Reference at: http://developer.healthvault.com/pages/methods/methods.aspx
 */
@property (nonatomic, strong, readonly) NSString *name;

/**
 The method version. The version will default to the latest method version at the time of the SDK release.
 */
@property (nonatomic, assign) NSInteger version;

/**
 Method parameters, which will be serialized into infoxml - Optional.
 */
@property (nonatomic, strong, nullable) NSString *parameters;

/**
 The record id for the person - Required if the method is record specfic (i.e. "GetThings").
 */
@property (nonatomic, strong, nullable) NSUUID *recordId;

/**
  An optional identifier that can be used to correlate a request.
 */
@property (nonatomic, strong, nullable) NSUUID *correlationId;

/**
 Pre-allocates a DOPU package id.

 @return An instance of MHVMethod.
 */
+ (MHVMethod *)allocatePackageId;

/**
 Creates a new alternate id for the record and person.
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)associateAlternateId;

/**
 Begin to stream binary data for a ThingBase.
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)beginPutBlob;

/**
 Begin to stream binary data for a DOPU package.
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)beginPutConnectPackageBlob;

/**
 Creates an application session token for use with the HealthVault service - Anonymous.
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)createAuthenticatedSessionToken;

/**
 Create a new DOPU package.
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)createConnectPackage;

/**
 Create a new Connect Request.
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)createConnectRequest;

/**
 Delete a DOPU package which has not yet been picked up.
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)deletePendingConnectPackage;

/**
 Delete a connect request which has not yet been accepted.
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)deletePendingConnectRequest;

/**
 Remove an alternate id for the record and person.
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)disassociateAlternateId;

/**
 Get an alternate ids for the record and person.
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)getAlternateIds;

/**
 Gets information about the registered application including name; description;
 authorization rules; and callback url.
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)getApplicationInfo;

/**
 Saves application specific information for the logged in user.
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)getApplicationSettings;

/**
 Get a list of accepted connect requests.
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)getAuthorizedConnectRequests;

/**
 Get all people authorized for an application.
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)getAuthorizedPeople;

/**
 Gets all the records that the user has authorized the application use.
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)getAuthorizedRecords;

/**
 Get a list of event subscriptions for the application.
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)getEventSubscriptions;

/**
 Get Meaningful Use Timley Access Report.
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)getMeaningfulUseTimelyAccessReport;

/**
 Get Meaningful Use VDT Report.
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)getMeaningfulUseVDTReport;

/**
 Gets information about the logged in user.
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)getPersonInfo;

/**
 Get record operations
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)getRecordOperations;

/**
 Gets generic service information about the HealthVault service - Anonymous.
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)getServiceDefinition;

/**
 Gets data from a HealthVault record.
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)getThings;

/**
 Gets information; including schemas; about the data types that can be stored in a
 health record.
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)getThingType;

/**
 Get a list of updated records for the application.
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)getUpdatedRecordsForApplication;

/**
 Get valid group memberships for the record.
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)getValidGroupMembership;

/**
 Gets information about clinical and other vocabularies that HealthVault supports.
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)getVocabulary;

/**
 Create a new application instance information from a master app id.  First step in SODA authentication - Anonymous.
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)newApplicationCreationInfo;

/**
 Generate a new signup code.
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)newSignupCode;

/**
 Adds or updates data in a health record.
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)putThings;

/**
 Gets the permissions that the application and user have to a health record.
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)queryPermissions;

/**
 Remove the application's record authorization.
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)removeApplicationRecordAuthorization;

/**
 Removes data from a health record.
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)removeThings;

/**
 Search a specific vocabulary and retrieve the matching vocabulary things.
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)searchVocabulary;

/**
 Get the instance where a HealthVault account should be created for the specified account location.
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)selectInstance;

/**
 Sends an SMTP message on behalf of the logged in user.
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)sendInsecureMessage;

/**
 Sends an SMTP message on behalf of the application.
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)sendInsecureMessageFromApplication;

/**
 Sets application specific data for the user.
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)setApplicationSettings;

/**
 Subscribe to an event.
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)subscribeToEvent;

/**
 Remove a subscription.
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)unsubscribeToEvent;

/**
 Update a subscription.
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)updateEventSubscription;

/**
 Update DOPU packages external id.
 
 @return An instance of MHVMethod.
 */
+ (MHVMethod *)updateExternalId;

@end

NS_ASSUME_NONNULL_END

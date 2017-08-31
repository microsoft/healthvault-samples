//
//  MHVMethod.m
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

#import "MHVMethod.h"

@interface MHVMethod ()

@property (nonatomic, assign) BOOL isAnonymous;

@end

@implementation MHVMethod

@synthesize cache = _cache;

- (instancetype)initWithName:(NSString *)name version:(int)version isAnonymous:(BOOL)isAnonymous
{
    self = [super init];
    
    if (self)
    {
        _name = name;
        _version = version;
        _isAnonymous = isAnonymous;
    }
    
    return self;
}

- (NSString *)getCacheKey
{
    return (self.parameters != nil) ? [self.name stringByAppendingString:self.parameters] : self.name;
}

+ (MHVMethod *)allocatePackageId;
{
    return [[MHVMethod alloc] initWithName:@"AllocatePackageId" version:1 isAnonymous:NO];
}

+ (MHVMethod *)associateAlternateId;
{
    return [[MHVMethod alloc] initWithName:@"AssociateAlternateId" version:1 isAnonymous:NO];
}

+ (MHVMethod *)beginPutBlob;
{
    return [[MHVMethod alloc] initWithName:@"BeginPutBlob" version:1 isAnonymous:NO];
}

+ (MHVMethod *)beginPutConnectPackageBlob;
{
    return [[MHVMethod alloc] initWithName:@"BeginPutConnectPackageBlob" version:1 isAnonymous:NO];
}

+ (MHVMethod *)createAuthenticatedSessionToken;
{
    return [[MHVMethod alloc] initWithName:@"CreateAuthenticatedSessionToken" version:2 isAnonymous:YES];
}

+ (MHVMethod *)createConnectPackage;
{
    return [[MHVMethod alloc] initWithName:@"CreateConnectPackage" version:1 isAnonymous:NO];
}

+ (MHVMethod *)createConnectRequest;
{
    return [[MHVMethod alloc] initWithName:@"CreateConnectRequest" version:1 isAnonymous:NO];
}

+ (MHVMethod *)deletePendingConnectPackage;
{
    return [[MHVMethod alloc] initWithName:@"DeletePendingConnectPackage" version:1 isAnonymous:NO];
}

+ (MHVMethod *)deletePendingConnectRequest;
{
    return [[MHVMethod alloc] initWithName:@"DeletePendingConnectRequest" version:1 isAnonymous:NO];
}

+ (MHVMethod *)disassociateAlternateId;
{
    return [[MHVMethod alloc] initWithName:@"DisassociateAlternateId" version:1 isAnonymous:NO];
}

+ (MHVMethod *)getAlternateIds;
{
    return [[MHVMethod alloc] initWithName:@"GetAlternateIds" version:1 isAnonymous:NO];
}

+ (MHVMethod *)getApplicationInfo;
{
    return [[MHVMethod alloc] initWithName:@"GetApplicationInfo" version:1 isAnonymous:NO];
}

+ (MHVMethod *)getApplicationSettings;
{
    return [[MHVMethod alloc] initWithName:@"GetApplicationSettings" version:1 isAnonymous:NO];
}

+ (MHVMethod *)getAuthorizedConnectRequests;
{
    return [[MHVMethod alloc] initWithName:@"GetAuthorizedConnectRequests" version:1 isAnonymous:NO];
}

+ (MHVMethod *)getAuthorizedPeople;
{
    return [[MHVMethod alloc] initWithName:@"GetAuthorizedPeople" version:1 isAnonymous:NO];
}

+ (MHVMethod *)getAuthorizedRecords;
{
    return [[MHVMethod alloc] initWithName:@"GetAuthorizedRecords" version:1 isAnonymous:NO];
}

+ (MHVMethod *)getEventSubscriptions;
{
    return [[MHVMethod alloc] initWithName:@"GetEventSubscriptions" version:1 isAnonymous:NO];
}

+ (MHVMethod *)getMeaningfulUseTimelyAccessReport;
{
    return [[MHVMethod alloc] initWithName:@"GetMeaningfulUseTimelyAccessReport" version:1 isAnonymous:NO];
}

+ (MHVMethod *)getMeaningfulUseVDTReport;
{
    return [[MHVMethod alloc] initWithName:@"GetMeaningfulUseVDTReport" version:1 isAnonymous:NO];
}

+ (MHVMethod *)getPersonInfo;
{
    return [[MHVMethod alloc] initWithName:@"GetPersonInfo" version:1 isAnonymous:NO];
}

+ (MHVMethod *)getRecordOperations
{
    return [[MHVMethod alloc] initWithName:@"GetRecordOperations" version:1 isAnonymous:NO];
}

+ (MHVMethod *)getServiceDefinition;
{
    return [[MHVMethod alloc] initWithName:@"GetServiceDefinition" version:2 isAnonymous:YES];
}

+ (MHVMethod *)getThings;
{
    return [[MHVMethod alloc] initWithName:@"GetThings" version:3 isAnonymous:NO];
}

+ (MHVMethod *)getThingType;
{
    return [[MHVMethod alloc] initWithName:@"GetThingType" version:1 isAnonymous:NO];
}

+ (MHVMethod *)getUpdatedRecordsForApplication;
{
    return [[MHVMethod alloc] initWithName:@"GetUpdatedRecordsForApplication" version:1 isAnonymous:NO];
}

+ (MHVMethod *)getValidGroupMembership;
{
    return [[MHVMethod alloc] initWithName:@"GetValidGroupMembership" version:1 isAnonymous:NO];
}

+ (MHVMethod *)getVocabulary;
{
    return [[MHVMethod alloc] initWithName:@"GetVocabulary" version:2 isAnonymous:NO];
}

+ (MHVMethod *)newApplicationCreationInfo;
{
    return [[MHVMethod alloc] initWithName:@"NewApplicationCreationInfo" version:1 isAnonymous:YES];
}

+ (MHVMethod *)newSignupCode;
{
    return [[MHVMethod alloc] initWithName:@"NewSignupCode" version:1 isAnonymous:NO];
}

+ (MHVMethod *)putThings;
{
    return [[MHVMethod alloc] initWithName:@"PutThings" version:2 isAnonymous:NO];
}

+ (MHVMethod *)queryPermissions;
{
    return [[MHVMethod alloc] initWithName:@"QueryPermissions" version:1 isAnonymous:NO];
}

+ (MHVMethod *)removeApplicationRecordAuthorization;
{
    return [[MHVMethod alloc] initWithName:@"RemoveApplicationRecordAuthorization" version:1 isAnonymous:NO];
}

+ (MHVMethod *)removeThings;
{
    return [[MHVMethod alloc] initWithName:@"RemoveThings" version:1 isAnonymous:NO];
}

+ (MHVMethod *)searchVocabulary;
{
    return [[MHVMethod alloc] initWithName:@"SearchVocabulary" version:1 isAnonymous:NO];
}

+ (MHVMethod *)selectInstance;
{
    return [[MHVMethod alloc] initWithName:@"SelectInstance" version:1 isAnonymous:NO];
}

+ (MHVMethod *)sendInsecureMessage;
{
    return [[MHVMethod alloc] initWithName:@"SendInsecureMessage" version:1 isAnonymous:NO];
}

+ (MHVMethod *)sendInsecureMessageFromApplication;
{
    return [[MHVMethod alloc] initWithName:@"SendInsecureMessageFromApplication" version:1 isAnonymous:NO];
}

+ (MHVMethod *)setApplicationSettings;
{
    return [[MHVMethod alloc] initWithName:@"SetApplicationSettings" version:1 isAnonymous:NO];
}

+ (MHVMethod *)subscribeToEvent;
{
    return [[MHVMethod alloc] initWithName:@"SubscribeToEvent" version:1 isAnonymous:NO];
}

+ (MHVMethod *)unsubscribeToEvent;
{
    return [[MHVMethod alloc] initWithName:@"UnsubscribeToEvent" version:1 isAnonymous:NO];
}

+ (MHVMethod *)updateEventSubscription;
{
    return [[MHVMethod alloc] initWithName:@"UpdateEventSubscription" version:1 isAnonymous:NO];
}

+ (MHVMethod *)updateExternalId
{
    return [[MHVMethod alloc] initWithName:@"UpdateExternalId" version:1 isAnonymous:NO];
}

@end

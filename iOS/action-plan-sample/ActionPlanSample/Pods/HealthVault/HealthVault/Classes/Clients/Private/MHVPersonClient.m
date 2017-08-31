//
//  MHVPersonClient.m
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

#import "MHVPersonClient.h"
#import "MHVConnectionProtocol.h"
#import "MHVHttpServiceProtocol.h"
#import "MHVValidator.h"
#import "MHVMethod.h"
#import "MHVPersonInfo.h"
#import "XSerializer.h"
#import "MHVServiceResponse.h"
#import "NSError+MHVError.h"
#import "MHVGetAuthorizedPeopleResult.h"
#import "MHVGetAuthorizedPeopleSettings.h"
#import "MHVApplicationSettings.h"
#import "MHVLogger.h"

@interface MHVPersonClient ()

@property (nonatomic, weak) id<MHVConnectionProtocol> connection;

@end

@implementation MHVPersonClient

@synthesize correlationId = _correlationId;

- (instancetype)initWithConnection:(id<MHVConnectionProtocol>)connection
{
    MHVASSERT_PARAMETER(connection);
    
    self = [super init];
    
    if (self)
    {
        _connection = connection;
    }
    
    return self;
}

- (void)getApplicationSettingsWithCompletion:(void(^)(NSString *_Nullable settings, NSError *_Nullable error))completion
{
    MHVASSERT_PARAMETER(completion);
    
    if (!completion)
    {
        return;
    }
    
    MHVMethod *method = [MHVMethod getApplicationSettings];
    
    [self.connection executeHttpServiceOperation:method
                                      completion:^(MHVServiceResponse * _Nullable response, NSError * _Nullable error)
     {
         if (error)
         {
             completion(nil, error);
             
             return;
         }
         
         MHVApplicationSettings *applicationSettings;
         
         XReader *reader = [[XReader alloc] initFromString:response.infoXml];
         
         if ([reader readStartElementWithName:@"info"])
         {
             applicationSettings = (MHVApplicationSettings *)[reader readElement:@"app-settings" asClass:[MHVApplicationSettings class]];
         }
         
         if (!applicationSettings)
         {
             completion(nil, [NSError error:[NSError MHVUnknownError] withDescription:@"The GetApplicationSettings response is invalid."]);
             
             return;
         }
         
         completion(applicationSettings.xmlSettings, nil);
     }];
}

- (void)setApplicationSettings:(NSString *_Nullable)settings
                    completion:(void(^_Nullable)(NSError *_Nullable error))completion
{
    MHVApplicationSettings *applicationSettings = [MHVApplicationSettings new];
    applicationSettings.xmlSettings = settings;

    if (![self isValidObject:applicationSettings])
    {
        if (completion)
        {
            completion([NSError MVHInvalidParameter:@"settings is not valid"]);
        }
        return;
    }
    
    MHVMethod *method = [MHVMethod setApplicationSettings];
    method.parameters = [self bodyForSetApplicationSettings:applicationSettings];
    
    [self.connection executeHttpServiceOperation:method
                                      completion:^(MHVServiceResponse * _Nullable response, NSError * _Nullable error)
     {
         if (completion)
         {
             completion(error);
         }
     }];
}

- (void)getAuthorizedPeopleWithCompletion:(void(^)(NSArray<MHVPersonInfo *> *_Nullable personInfos, NSError *_Nullable error))completion;
{
    MHVASSERT_PARAMETER(completion);
    
    if (!completion)
    {
        return;
    }

    [self getAuthorizedPeopleWithSettings:[MHVGetAuthorizedPeopleSettings new]
                              personInfos:nil
                               completion:completion];
}

- (void)getAuthorizedPeopleWithAuthorizationsCreatedSince:(NSDate *)authorizationsCreatedSince
                                               completion:(void(^)(NSArray<MHVPersonInfo *> *_Nullable personInfos, NSError *_Nullable error))completion
{
    MHVASSERT_PARAMETER(authorizationsCreatedSince);
    MHVASSERT_PARAMETER(completion);
    
    if (!completion)
    {
        return;
    }

    if (!authorizationsCreatedSince)
    {
        completion(nil, [NSError MVHRequiredParameterIsNil]);
        return;
    }

    MHVGetAuthorizedPeopleSettings *settings = [MHVGetAuthorizedPeopleSettings new];
    settings.authorizationsCreatedSince = authorizationsCreatedSince;
    
    [self getAuthorizedPeopleWithSettings:settings
                              personInfos:nil
                               completion:completion];
}

- (void)getAuthorizedPeopleWithSettings:(MHVGetAuthorizedPeopleSettings *)settings
                            personInfos:(NSArray<MHVPersonInfo *> *_Nullable)personInfos
                             completion:(void(^)(NSArray<MHVPersonInfo *> *_Nullable personInfos, NSError *_Nullable error))completion
{
    MHVASSERT_PARAMETER(settings);
    MHVASSERT_PARAMETER(completion);
    
    if (!completion)
    {
        return;
    }
    
    if (!settings)
    {
        completion(nil, [NSError MVHRequiredParameterIsNil]);
        return;
    }
    
    if (![self isValidObject:settings])
    {
        completion(nil, [NSError MVHInvalidParameter:@"settings object is not valid"]);
        return;
    }
    
    [self getAuthorizedPeopleWithParameters:[self bodyForGetAuthorizedPeopleSettings:settings]
                                 completion:^(MHVGetAuthorizedPeopleResult *_Nullable authorizedPeople, NSError *_Nullable error)
     {
         //If error, return
         if (error)
         {
             completion(nil, error);
             return;
         }
         
         //Add to the personInfos array
         NSArray<MHVPersonInfo *> *personInfosResult = personInfos;
         if (!personInfosResult)
         {
             personInfosResult = authorizedPeople.persons;
         }
         else
         {
             personInfosResult = [personInfosResult arrayByAddingObjectsFromArray:authorizedPeople.persons];
         }
         
         //If more results flag is set, need to recurse; otherwise done
         if (authorizedPeople.moreResults.value)
         {
             MHVGetAuthorizedPeopleSettings *nextSettings = [MHVGetAuthorizedPeopleSettings new];
             nextSettings.startingPersonId = [authorizedPeople.persons lastObject].ID;
             
             [self getAuthorizedPeopleWithSettings:nextSettings
                                       personInfos:personInfosResult
                                        completion:completion];
         }
         else
         {
             completion(personInfosResult, nil);
         }
     }];
}

- (void)getPersonInfoWithCompletion:(void(^)(MHVPersonInfo *_Nullable person, NSError *_Nullable error))completion
{
    MHVASSERT_PARAMETER(completion);
    
    if (!completion)
    {
        return;
    }
    
    [self.connection executeHttpServiceOperation:[MHVMethod getPersonInfo]
                                      completion:^(MHVServiceResponse * _Nullable response, NSError * _Nullable error)
     {
         if (error)
         {
             completion(nil, error);
             
             return;
         }
         
         MHVPersonInfo *personInfo;
         
         XReader *reader = [[XReader alloc] initFromString:response.infoXml];
         
         if ([reader readStartElementWithName:@"info"])
         {
             personInfo = (MHVPersonInfo *)[reader readElement:@"person-info" asClass:[MHVPersonInfo class]];
         }
         
         if (!personInfo)
         {
             completion(nil, [NSError error:[NSError MHVUnknownError] withDescription:@"The GetPersonInfo response is invalid."]);
             
             return;
         }

         completion(personInfo, nil);
     }];
}

- (void)getAuthorizedRecordsWithRecordIds:(NSArray<NSUUID *> *)recordIds
                               completion:(void(^)(NSArray<MHVRecord *> *_Nullable records, NSError *_Nullable error))completion
{
    MHVASSERT_PARAMETER(recordIds);
    MHVASSERT_PARAMETER(completion);
    
    if (!completion)
    {
        return;
    }
    
    if (!recordIds)
    {
        completion(nil, [NSError MVHRequiredParameterIsNil]);
        return;
    }
    
    MHVMethod *method = [MHVMethod getAuthorizedRecords];
    method.parameters = [self bodyForGetAuthorizedRecords:recordIds];
    
    [self.connection executeHttpServiceOperation:method
                                      completion:^(MHVServiceResponse * _Nullable response, NSError * _Nullable error)
     {
         if (error)
         {
             completion(nil, error);
             
             return;
         }
         
         NSArray<MHVRecord *> *healthRecords = (NSArray *)[XSerializer newFromString:response.infoXml
                                                                            withRoot:@"info"
                                                                      andElementName:@"record"
                                                                             asClass:[MHVRecord class]
                                                                       andArrayClass:[NSMutableArray class]];
         
         if (healthRecords.count != recordIds.count)
         {
             MHVLOG(@"Warning: %li records requested, %li results", recordIds.count, healthRecords.count);
         }
         
         completion(healthRecords, nil);
     }];
}

#pragma mark - Helpers

- (void)getAuthorizedPeopleWithParameters:(NSString *_Nonnull)parameters
                               completion:(void(^)(MHVGetAuthorizedPeopleResult *_Nullable authorizedPeople, NSError *_Nullable error))completion
{
    MHVMethod *method = [MHVMethod getAuthorizedPeople];
    method.parameters = parameters;
    
    [self.connection executeHttpServiceOperation:method
                                      completion:^(MHVServiceResponse * _Nullable response, NSError * _Nullable error)
     {
         if (error)
         {
             completion(nil, error);
             
             return;
         }
         
         MHVGetAuthorizedPeopleResult *peopleResult = (MHVGetAuthorizedPeopleResult *)[XSerializer newFromString:response.infoXml
                                                                                                        withRoot:@"info"
                                                                                                         asClass:[MHVGetAuthorizedPeopleResult class]];
         
         if (!peopleResult)
         {
             completion(nil, [NSError error:[NSError MHVUnknownError] withDescription:@"The GetAuthorizedPeople response is invalid."]);
             
             return;
         }
         
         if (peopleResult.persons.count < 1)
         {
             completion(nil, [NSError error:[NSError MHVUnknownError] withDescription:@"The GetAuthorizedPeople response has no authorized people."]);
             
             return;
         }
         
         completion(peopleResult, nil);
     }];
}

- (NSString *)bodyForSetApplicationSettings:(MHVApplicationSettings *)applicationSettings
{
    if (![self isValidObject:applicationSettings])
    {
        return nil;
    }
    
    XWriter *writer = [[XWriter alloc] initWithBufferSize:2048];
    
    [writer writeStartElement:@"info"];

    [XSerializer serialize:applicationSettings withRoot:@"app-settings" toWriter:writer];

    [writer writeEndElement];

    return [writer newXmlString];
}

- (NSString *)bodyForGetAuthorizedPeopleSettings:(MHVGetAuthorizedPeopleSettings *)authorizedPeopleSettings
{
    if (![self isValidObject:authorizedPeopleSettings])
    {
        return nil;
    }
    
    XWriter *writer = [[XWriter alloc] initWithBufferSize:2048];
    
    [writer writeStartElement:@"info"];
    
    [XSerializer serialize:authorizedPeopleSettings withRoot:@"parameters" toWriter:writer];
    
    [writer writeEndElement];
    
    return [writer newXmlString];
}

- (NSString *)bodyForGetAuthorizedRecords:(NSArray<NSUUID *> *)recordIds
{
    XWriter *writer = [[XWriter alloc] initWithBufferSize:2048];
    
    [writer writeStartElement:@"info"];
    
    for (NSUUID *uuid in recordIds)
    {
        [XSerializer serialize:[[MHVString alloc] initWith:uuid.UUIDString] withRoot:@"id" toWriter:writer];
    }

    [writer writeEndElement];
    
    return [writer newXmlString];
}

- (BOOL)isValidObject:(id)obj
{
    if ([obj respondsToSelector:@selector(validate)])
    {
        MHVClientResult *validationResult = [obj validate];
        if (validationResult.isError)
        {
            return NO;
        }
    }
    
    return YES;
}

@end

//
//  MHVSodaConnection.m
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

#import "MHVSodaConnection.h"
#import "NSError+MHVError.h"
#import "MHVKeychainServiceProtocol.h"
#import "MHVApplicationCreationInfo.h"
#import "MHVPersonInfo.h"
#import "MHVSessionCredential.h"
#import "MHVPlatformClientProtocol.h"
#import "MHVValidator.h"
#import "MHVShellAuthServiceProtocol.h"
#import "MHVServiceInstance.h"
#import "MHVConfiguration.h"
#import "MHVPersonClientProtocol.h"
#import "MHVPlatformConstants.h"
#import "MHVServiceDefinition.h"
#import "MHVSessionCredentialClientProtocol.h"
#import "MHVAuthSession.h"
#import "MHVClientFactory.h"
#import "NSArray+Utils.h"

static NSString *const kServiceInstanceKey = @"ServiceInstance";
static NSString *const kApplicationCreationInfoKey = @"ApplicationCreationInfo";
static NSString *const kSessionCredentialKey = @"SessionCredential";
static NSString *const kPersonInfoKey = @"PersonInfo";
static NSString *const kBlankUUID = @"00000000-0000-0000-0000-000000000000";

@interface MHVSodaConnection ()

@property (nonatomic, assign) BOOL isAuthUpdating;
@property (nonatomic, strong) dispatch_queue_t authQueue;
@property (nonatomic, strong) MHVPersonInfo *personInfo;
@property (nonatomic, strong) MHVApplicationCreationInfo *applicationCreationInfo;
@property (nonatomic, strong) id<MHVSessionCredentialClientProtocol> credentialClient;
@property (nonatomic, strong) MHVSessionCredential *sessionCredential;

// Dependencies
@property (nonatomic, strong) id<MHVKeychainServiceProtocol> keychainService;
@property (nonatomic, strong) id<MHVShellAuthServiceProtocol> shellAuthService;

@end

@implementation MHVSodaConnection

@synthesize serviceInstance = _serviceInstance;
@synthesize sessionCredential = _sessionCredential;
@synthesize personInfo = _personInfo;


- (instancetype)initWithConfiguration:(MHVConfiguration *)configuration
                    cacheSynchronizer:(id<MHVThingCacheSynchronizerProtocol>_Nullable)cacheSynchronizer
                   cacheConfiguration:(id<MHVThingCacheConfigurationProtocol>_Nullable)cacheConfiguration
                        clientFactory:(MHVClientFactory *)clientFactory
                          httpService:(id<MHVHttpServiceProtocol>)httpService
                      keychainService:(id<MHVKeychainServiceProtocol>)keychainService
                     shellAuthService:(id<MHVShellAuthServiceProtocol>)shellAuthService
{
    MHVASSERT_PARAMETER(keychainService);
    MHVASSERT_PARAMETER(shellAuthService);
    
    self = [super initWithConfiguration:configuration
                      cacheSynchronizer:cacheSynchronizer
                     cacheConfiguration:cacheConfiguration
                          clientFactory:clientFactory
                            httpService:httpService];
    
    if (self)
    {
        _keychainService = keychainService;
        _shellAuthService = shellAuthService;
        _credentialClient = [clientFactory credentialClientWithConnection:self];
        _authQueue = dispatch_queue_create("MHVSodaConnection.authQueue", DISPATCH_QUEUE_SERIAL);
        [self setConnectionPropertiesFromKeychain];
    }
    
    return self;
}

- (NSUUID *)applicationId
{
    return self.applicationCreationInfo.appInstanceId;
}

- (BOOL)isAuthenticated
{
    return (self.serviceInstance &&
            self.applicationCreationInfo &&
            self.sessionCredential &&
            self.personInfo);
}

- (void)authenticateWithViewController:(UIViewController *_Nullable)viewController
                            completion:(void(^_Nullable)(NSError *_Nullable error))completion;
{
    dispatch_async(self.authQueue, ^
    {
        if (![self canStartAuthWithCompletion:completion])
        {
            return;
        }
                       
        [self setConnectionPropertiesFromKeychain];
        
        if (self.isAuthenticated)
        {
            // The user is already authenticated
            [self finishAuthWithError:nil completion:completion];
            return;
        }
        
        [self provisionForSodaWithViewController:viewController completion:^(NSError * _Nullable error)
        {
            if (error)
            {
                [self finishAuthWithError:error completion:completion];
                [self clearConnectionProperties];
                
                return;
            }
            
            [self refreshSessionCredentialWithCompletion:^(NSError * _Nullable error)
            {
                if (error)
                {
                    [self finishAuthWithError:error completion:completion];
                    [self clearConnectionProperties];
                    
                    return;
                }
                
                [self getAuthorizedPersonInfoWithCompletion:^(NSError * _Nullable error)
                {
                    if (error)
                    {
                        [self clearConnectionProperties];
                    }
                    
                    [self finishAuthWithError:error completion:completion];
                }];
            }];
        }];
    });
}

- (void)authorizeAdditionalRecordsWithViewController:(UIViewController *_Nullable)viewController
                                          completion:(void(^_Nullable)(NSError *_Nullable error))completion
{
    dispatch_async(self.authQueue, ^
    {
        if (![self canStartAuthWithCompletion:completion])
        {
            return;
        }
        
        [self setConnectionPropertiesFromKeychain];
        
        if (!self.sessionCredential || !self.applicationCreationInfo)
        {
            [self finishAuthWithError:[NSError error:[NSError MHVUnauthorizedError] withDescription:@"Authorization required to authorize additional records. Must call authenticateWithViewController:completion: first."]
                           completion:completion];
            
            return;
        }
        
        [self.shellAuthService authorizeAdditionalRecordsWithViewController:viewController
                                                                   shellUrl:self.serviceInstance.shellUrl
                                                              appInstanceId:self.applicationId
                                                                 completion:^(NSError * _Nullable error)
        {
            if (error)
            {
                [self finishAuthWithError:error completion:completion];
                
                return;
            }
            
            [self getAuthorizedPersonInfoWithCompletion:^(NSError * _Nullable error)
            {
                [self finishAuthWithError:error completion:completion];
            }];
            
        }];
        
    });
}

- (void)deauthorizeApplicationWithCompletion:(void(^_Nullable)(NSError *_Nullable error))completion
{
    dispatch_async(self.authQueue, ^
    {
        if (![self canStartAuthWithCompletion:completion])
        {
            return;
        }
        
        // Delete authorization data from the keychain.
        if (![self removeConnectionPropertiesFromKeychain])
        {
            [self finishAuthWithError:[NSError error:[NSError MHVIOError] withDescription:@"One or more values could not be deleted from the keychain."]
                           completion:completion];
            
            return;
        }
        
        if (self.isAuthenticated)
        {
            [self removeAuthRecords:self.personInfo.records completion:^(NSError * _Nullable error)
            {
                _serviceInstance = nil;
                _applicationCreationInfo = nil;
                _sessionCredential = nil;
                _personInfo = nil;
                
                [self finishAuthWithError:error completion:completion];
            }];
        }
        else
        {
            [self clearConnectionProperties];
            [self finishAuthWithError:nil completion:completion];
        }
    });
}

#pragma mark - Private

// Use in conjunction with the authQueue to ensure various auth related calls are synchronized.
- (BOOL)canStartAuthWithCompletion:(void(^_Nullable)(NSError *_Nullable error))completion
{
    if (self.isAuthUpdating)
    {
        if (completion)
        {
            completion([NSError MHVAuthorizationInProgress]);
        }
        
        return NO;
    }
    
    self.isAuthUpdating = YES;
    
    return YES;
}

// Use in conjunction with the authQueue to ensure various auth related calls are synchronized.
- (void)finishAuthWithError:(NSError *)error completion:(void(^_Nullable)(NSError *_Nullable error))completion
{
    dispatch_async(self.authQueue, ^
    {
        if (completion)
        {
            completion(error);
        }
        
        self.isAuthUpdating = NO;
    });
}

- (void)provisionForSodaWithViewController:(UIViewController *_Nullable)viewController
                                completion:(void(^_Nullable)(NSError *_Nullable error))completion
{
    if (self.applicationCreationInfo && self.serviceInstance)
    {
        if (completion)
        {
            completion(nil);
        }
        
        return;
    }
    
     // Set a temporary service instance for the newApplicationCreationInfo call
    _serviceInstance = [MHVServiceInstance new];
    self.serviceInstance.instanceID = @"1";
    self.serviceInstance.name = @"Default";
    self.serviceInstance.instanceDescription = @"Default HealthVault instance";
    self.serviceInstance.healthServiceUrl = [self.configuration.defaultHealthVaultUrl URLByAppendingPathComponent: @"wildcat.ashx"];
    self.serviceInstance.shellUrl = self.configuration.defaultShellUrl;
    self.serviceInstance.restServiceUrl = self.configuration.restHealthVaultUrl;
    
    [self.platformClient newApplicationCreationInfoWithCompletion:^(MHVApplicationCreationInfo * _Nullable applicationCreationInfo, NSError * _Nullable error)
    {
        if (error)
        {
            if (completion)
            {
                completion(error);
            }
            
            return;
        }
        
        if(![self.keychainService setXMLObject:applicationCreationInfo forKey:kApplicationCreationInfoKey])
        {
            if (completion)
            {
                completion([NSError error:[NSError MHVIOError] withDescription:@"Could not save the application creation info to the keychain."]);
            }
            
            return;
        }
        
        _applicationCreationInfo = applicationCreationInfo;
        
        [self provisionWithViewController:viewController completion:completion];
    }];
}
         
- (void)provisionWithViewController:(UIViewController *_Nullable)viewController
                         completion:(void(^_Nullable)(NSError *_Nullable error))completion
{
    [self.shellAuthService provisionApplicationWithViewController:viewController
                                                         shellUrl:self.configuration.defaultShellUrl
                                                      masterAppId:self.configuration.masterApplicationId
                                                 appCreationToken:self.applicationCreationInfo.appCreationToken
                                                    appInstanceId:self.applicationId
                                                       completion:^(NSString * _Nullable instanceId, NSError * _Nullable error)
    {
        if (error)
        {
            if (completion)
            {
                completion(error);
            }
            
            return;
        }
        
        [self setServiceInstanceWithInstanceId:instanceId completion:completion];
        
    }];
}

- (void)setServiceInstanceWithInstanceId:(NSString *)instanceId
                              completion:(void(^_Nullable)(NSError *_Nullable error))completion
{
    [self.platformClient getServiceDefinitionWithWithLastUpdatedTime:nil
                                                    responseSections:MHVServiceInfoSectionsTopology
                                                          completion:^(MHVServiceDefinition * _Nullable serviceDefinition, NSError * _Nullable error)
    {
        if (error)
        {
            if (completion)
            {
                completion(error);
            }
            
            return;
        }
        
        NSArray<MHVServiceInstance *> *instances = serviceDefinition.systemInstances.instances;
        
        NSUInteger index = [instances indexOfObjectPassingTest:^BOOL(MHVServiceInstance *obj, NSUInteger idx, BOOL * _Nonnull stop)
        {
            return [obj.instanceID isEqualToString:instanceId];
        }];
        
        if (index == NSNotFound)
        {
            if (completion)
            {
                completion([NSError error:[NSError MHVNotFound] withDescription:[NSString stringWithFormat:@"The service instance for id %@ could not be found.", instanceId]]);
            }
            
            return;
        }
        
        MHVServiceInstance *instance = [instances objectAtIndex:index];
        
        if(![self.keychainService setXMLObject:instance forKey:kServiceInstanceKey])
        {
            if (completion)
            {
                completion([NSError error:[NSError MHVIOError] withDescription:@"Could not save the service instance to the keychain."]);
            }
            
            return;
        }
        
        _serviceInstance = instance;
        
        if (completion)
        {
            completion(nil);
        }
        
    }];
}

- (void)refreshSessionCredentialWithCompletion:(void(^_Nullable)(NSError *_Nullable error))completion
{
    [self.credentialClient getSessionCredentialWithSharedSecret:self.applicationCreationInfo.sharedSecret
                                                     completion:^(MHVSessionCredential * _Nullable credential, NSError * _Nullable error)
    {
        if (error)
        {
            if (completion)
            {
                completion(error);
            }
            
            return;
        }
        
        if(![self.keychainService setXMLObject:credential forKey:kSessionCredentialKey])
        {
            if (completion)
            {
                completion([NSError error:[NSError MHVIOError] withDescription:@"Could not save the session credential to the keychain."]);
            }
            
            return;
        }
        
        _sessionCredential = credential;
        
        if (completion)
        {
            completion(nil);
        }
        
    }];
}

- (void)getAuthorizedPersonInfoWithCompletion:(void(^_Nullable)(NSError *_Nullable error))completion
{
    [self.personClient getAuthorizedPeopleWithCompletion:^(NSArray<MHVPersonInfo *> *_Nullable personInfos, NSError * _Nullable error)
    {
         if (error)
         {
             if (completion)
             {
                 completion(error);
             }
             
             return;
         }
         
        MHVPersonInfo *personInfo = [personInfos firstObject];
         
        if (!personInfo.selectedRecordID ||
            [personInfo.selectedRecordID isEqual:[[NSUUID alloc] initWithUUIDString:kBlankUUID]])
        {
            personInfo.selectedRecordID = [personInfo.records firstObject].ID;
        }
        
        if(![self.keychainService setXMLObject:personInfo forKey:kPersonInfoKey])
        {
            if (completion)
            {
                completion([NSError error:[NSError MHVIOError] withDescription:@"Could not save the person info to the keychain."]);
            }
            
            return;
        }
        
        self.personInfo = personInfo;
        
        if (completion)
        {
            completion(nil);
        }
    }];
}

- (void)removeAuthRecords:(NSArray<MHVRecord *> *)records completion:(void(^_Nullable)(NSError *_Nullable error))completion
{
    if (records.count < 1)
    {
        if (completion)
        {
            completion(nil);
        }
        
        return;
    }

    __block MHVRecord *record = [records firstObject];
    
    [self.platformClient removeApplicationAuthorizationWithRecordId:record.ID completion:^(NSError * _Nullable error)
    {
        if (error)
        {
            // Errors here can be ignored, but we are logging them to help with debugging.
            MHVASSERT_MESSAGE(error.localizedDescription);
        }
        
        NSMutableArray *remainingRecords = [records mutableCopy];
        [remainingRecords removeObject:record];
        
        // Recurse through the record collection until there are no more records.
        [self removeAuthRecords:remainingRecords completion:completion];
        
    }];
}

- (void)setConnectionPropertiesFromKeychain
{
    if (!self.serviceInstance)
    {
       _serviceInstance = [self.keychainService xmlObjectForKey:kServiceInstanceKey];
    }
    
    if (!self.applicationCreationInfo)
    {
        self.applicationCreationInfo = [self.keychainService xmlObjectForKey:kApplicationCreationInfoKey];
    }
    
    if (!self.sessionCredential)
    {
        _sessionCredential = [self.keychainService xmlObjectForKey:kSessionCredentialKey];
    }
    
    if (!self.personInfo)
    {
        self.personInfo = [self.keychainService xmlObjectForKey:kPersonInfoKey];
    }
}

- (void)clearConnectionProperties
{
    [self removeConnectionPropertiesFromKeychain];
    
    _serviceInstance = nil;
    _applicationCreationInfo = nil;
    _sessionCredential = nil;
    _personInfo = nil;
}

- (BOOL)removeConnectionPropertiesFromKeychain
{
    BOOL serviceSuccess = [self.keychainService removeObjectForKey:kServiceInstanceKey];
    BOOL creationSuccess = [self.keychainService removeObjectForKey:kApplicationCreationInfoKey];
    BOOL credentialSuccess = [self.keychainService removeObjectForKey:kSessionCredentialKey];
    BOOL personSuccess = [self.keychainService removeObjectForKey:kPersonInfoKey];
    
    return serviceSuccess && creationSuccess && credentialSuccess && personSuccess;
}

- (MHVAuthSession *)authSession
{
    MHVAuthSession *authSession = [MHVAuthSession new];
    authSession.authToken = self.sessionCredential.token;
    authSession.offlinePersonId = self.personInfo.ID;
    
    return authSession;
}

@end

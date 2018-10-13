//
//  MHVConnection.m
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

#import "MHVConfiguration.h"
#import "MHVConfigurationConstants.h"
#import "MHVConnection.h"
#import "MHVAuthSession.h"
#import "MHVMethod.h"
#import "MHVSessionCredential.h"
#import "MHVRequestMessageCreatorProtocol.h"
#import "MHVRequestMessageCreator.h"
#import "MHVHttpServiceProtocol.h"
#import "MHVServiceInstance.h"
#import "NSError+MHVError.h"
#import "MHVErrorConstants.h"
#import "MHVServiceResponse.h"
#import "MHVHttpServiceRequest.h"
#import "MHVClientFactory.h"
#import "MHVApplicationCreationInfo.h"
#import "MHVValidator.h"
#import "MHVRestRequest.h"
#import "MHVBlobDownloadRequest.h"
#import "MHVBlobUploadRequest.h"
#import "MHVHttpServiceResponse.h"
#import "MHVPersonInfo.h"
#import "MHVLogger.h"
#import "MHVCryptographer.h"
#import "MHVClientInfo.h"
#import "MHVConnectionTaskResult.h"
#import "MHVStringExtensions.h"
#if THING_CACHE
#import "MHVThingCacheConfigurationProtocol.h"
#import "MHVThingClient.h"
#import "MHVThingCacheProtocol.h"
#import "MHVThingCacheSynchronizerProtocol.h"
#endif

static NSString *const kCorrelationIdContextKey = @"WC_CorrelationId";
static NSString *const kResponseIdContextKey = @"WC_ResponseId";

static NSInteger kUnauthorizedServerError = 401;
static NSInteger kInternalServerError = 500;

@interface MHVConnection ()

@property (nonatomic, strong) dispatch_queue_t completionQueue;
@property (nonatomic, strong) NSMutableArray<MHVHttpServiceRequest *> *requests;
@property (nonatomic, strong) MHVConfiguration *configuration;

// Clients
@property (nonatomic, strong) id<MHVPlatformClientProtocol> platformClient;
@property (nonatomic, strong) id<MHVPersonClientProtocol> personClient;
@property (nonatomic, strong) id<MHVRemoteMonitoringClientProtocol> remoteMonitoringClient;
@property (nonatomic, strong) id<MHVThingClientProtocol> thingClient;
@property (nonatomic, strong) id<MHVVocabularyClientProtocol> vocabularyClient;

// Dependencies
@property (nonatomic, strong) MHVClientFactory *clientFactory;
@property (nonatomic, strong) id<MHVHttpServiceProtocol> httpService;

#if THING_CACHE
@property (nonatomic, strong) id<MHVThingCacheSynchronizerProtocol> cacheSynchronizer;
#endif

@end

@implementation MHVConnection

@dynamic sessionCredential;
@dynamic personInfo;
@dynamic isAuthenticated;
@synthesize cacheConfiguration = _cacheConfiguration;

- (instancetype)initWithConfiguration:(MHVConfiguration *)configuration
                    cacheSynchronizer:(id<MHVThingCacheSynchronizerProtocol>_Nullable)cacheSynchronizer
                   cacheConfiguration:(id<MHVThingCacheConfigurationProtocol>_Nullable)cacheConfiguration
                        clientFactory:(MHVClientFactory *)clientFactory
                          httpService:(id<MHVHttpServiceProtocol>)httpService
{
    MHVASSERT_PARAMETER(configuration);
    MHVASSERT_PARAMETER(clientFactory);
    MHVASSERT_PARAMETER(httpService);
    
    self = [super init];
    
    if (self)
    {
        _configuration = configuration;
        _cacheConfiguration = cacheConfiguration;
        _clientFactory = clientFactory;
        _httpService = httpService;
        _requests = [NSMutableArray new];
        _completionQueue = dispatch_queue_create("MHVConnection.requestQueue", DISPATCH_QUEUE_SERIAL);
        
#if THING_CACHE
        _cacheSynchronizer = cacheSynchronizer;
        _cacheSynchronizer.connection = self;
#endif
    }
    
    return self;
}

#pragma mark - Public

- (NSUUID *_Nullable)applicationId;
{
    return nil;
}

- (void)executeHttpServiceOperation:(id<MHVHttpServiceOperationProtocol> _Nonnull)operation
                         completion:(void (^_Nullable)(MHVServiceResponse *_Nullable response, NSError *_Nullable error))completion
{
    MHVASSERT_PARAMETER(operation);
    
    dispatch_async(self.completionQueue, ^
                   {
                       if (!operation.isAnonymous && [NSString isNilOrEmpty:self.sessionCredential.token])
                       {
                           if (completion)
                           {
                               completion(nil, [NSError error:[NSError MHVUnauthorizedError] withDescription:@"The connection is not authenticated. You must first call authenticateWithViewController:completion: before this operation can be performed."]);
                           }
                           
                           return;
                       }
                       else
                       {
                           [self executeHttpServiceRequest:[[MHVHttpServiceRequest alloc] initWithServiceOperation:operation completion:completion]];
                       }
                   });
}

- (void)getPersonInfoWithCompletion:(void (^_Nonnull)(MHVPersonInfo *_Nullable, NSError *_Nullable error))completion;
{
    NSString *message = [NSString stringWithFormat:@"Subclasses must implement %@", NSStringFromSelector(_cmd)];\
    MHVASSERT_MESSAGE(message);
}

- (void)authenticateWithViewController:(UIViewController *_Nullable)viewController
                            completion:(void(^_Nullable)(NSError *_Nullable error))completion;
{
    NSString *message = [NSString stringWithFormat:@"Subclasses must implement %@", NSStringFromSelector(_cmd)];\
    MHVASSERT_MESSAGE(message);
}

- (id<MHVPersonClientProtocol> _Nullable)personClient;
{
    if (!_personClient)
    {
        _personClient = [self.clientFactory personClientWithConnection:self];
    }
    
    return _personClient;
}

- (id<MHVPlatformClientProtocol> _Nullable)platformClient
{
    if (!_platformClient)
    {
        _platformClient = [self.clientFactory platformClientWithConnection:self];
    };
    
    return _platformClient;
}

- (id<MHVThingClientProtocol> _Nullable)thingClient
{
    if (!_thingClient)
    {
#if THING_CACHE
        _thingClient = [self.clientFactory thingClientWithConnection:self
                                                  thingCacheDatabase:self.cacheSynchronizer.database];
#else
        _thingClient = [self.clientFactory thingClientWithConnection:self
                                                  thingCacheDatabase:nil];
#endif
    }
    
    return _thingClient;
}

- (id<MHVRemoteMonitoringClientProtocol> _Nullable)remoteMonitoringClient
{
    if (!_remoteMonitoringClient)
    {
        _remoteMonitoringClient = [self.clientFactory remoteMonitoringClientWithConnection:self];
    }
    
    return _remoteMonitoringClient;
}

- (id<MHVVocabularyClientProtocol> _Nullable)vocabularyClient
{
    if (!_vocabularyClient)
    {
        _vocabularyClient = [self.clientFactory vocabularyClientWithConnection:self];
    }
    
    return _vocabularyClient;
}

#pragma mark - Private

- (void)executeHttpServiceRequest:(MHVHttpServiceRequest *)request
{
    if ([request.serviceOperation isKindOfClass:[MHVMethod class]])
    {
        [self executeMethodRequest:request];
    }
    else if ([request.serviceOperation isKindOfClass:[MHVRestRequest class]])
    {
        [self executeRestRequest:request];
    }
    else if ([request.serviceOperation isKindOfClass:[MHVBlobDownloadRequest class]])
    {
        [self executeBlobDownloadRequest:request];
    }
    else if ([request.serviceOperation isKindOfClass:[MHVBlobUploadRequest class]])
    {
        [self executeBlobUploadRequest:request];
    }
    else
    {
        NSString *message = [NSString stringWithFormat:@"ServiceOperation not known: %@", NSStringFromClass([request.serviceOperation class])];
        MHVASSERT_MESSAGE(message);
    }
}

- (void)executeMethodRequest:(MHVHttpServiceRequest *)request
{
    MHVMethod *method = request.serviceOperation;


    MHVLOG(@"Execute Method: %@", method.name);
    
    if (request.serviceOperation.cache)
    {
        // Handle returning cached values
        MHVServiceResponse *cachedResponse = (MHVServiceResponse*)[request.serviceOperation.cache objectForKey:[request.serviceOperation getCacheKey]];
        if (cachedResponse)
        {
            request.completion(cachedResponse, cachedResponse.error);
            return;
        }
    }
    
    [self.httpService sendRequestForURL:self.serviceInstance.healthServiceUrl
                             httpMethod:nil
                                   body:[[self messageForMethod:method] dataUsingEncoding:NSUTF8StringEncoding]
                                headers:[self headersForMethod:method]
                             completion:^(MHVHttpServiceResponse * _Nullable response, NSError * _Nullable error)
    {
        if (error)
        {
            if (response.statusCode == kInternalServerError &&
                request.retryAttempts < self.configuration.retryOnInternal500Count)
            {
                //For 500 errors, should retry after a delay
                [self retryRequest:request];
                
                return;
            }
            else if (error.code == MHVErrorTypeUnauthorized)
            {
                [self refreshTokenAndReissueRequest:request];
                
                return;
            }
            else
            {
                MHVLOG(@"Execute %@ Method Error: %@", method.name, error.localizedDescription);
                if (request.completion)
                {
                    request.completion(nil, error);
                }
                
                return;
            }
        }
        else
        {
            
            [self parseResponse:response request:request isXML:YES completion:request.completion];
        }
    }];
}

- (void)executeRestRequest:(MHVHttpServiceRequest *)request
{
    // TODO: Add cache support
    MHVRestRequest *restRequest = request.serviceOperation;
    
    MHVLOG(@"Execute Request: %@", restRequest.path);

    // If no URL is set, build it from serviceInstance
    if (!restRequest.url)
    {
        [restRequest updateUrlWithServiceUrl:self.configuration.restHealthVaultUrl];
    }
    
    // Add authorization header
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
    if (!restRequest.isAnonymous)
    {
        headers[@"Authorization"] = [NSString stringWithFormat:@"MSH-V1 app-token=%@,offline-person-id=%@,record-id=%@", self.sessionCredential.token, self.personInfo.ID, self.personInfo.selectedRecordID];
    }
    
    // Add the required REST version header
    headers[@"x-ms-version"] = self.configuration.restVersion;

    // Add sdk version telemetry header
    headers[@"version"] = [MHVClientInfo telemetryInfo];
    
    headers[@"Content-Type"] = @"application/json";

    [self.httpService sendRequestForURL:restRequest.url
                             httpMethod:restRequest.httpMethod
                                   body:restRequest.body
                                headers:headers
                             completion:^(MHVHttpServiceResponse * _Nullable response, NSError * _Nullable error)
    {
        if (response.statusCode == kInternalServerError &&
            request.retryAttempts < self.configuration.retryOnInternal500Count)
        {
            //For 500 errors, should retry after a delay
            [self retryRequest:request];
            
            return;
        }
        else if (error.code == MHVErrorTypeUnauthorized ||
                 response.statusCode == kUnauthorizedServerError)
        {
            // If unauthorized, refresh token and retry request
            [self refreshTokenAndReissueRequest:request];
            
            return;
        }
        
        if (response.hasError)
        {
            if (request.completion)
            {
                if (!error)
                {
                    error = [NSError error:[NSError MHVNetworkError] withDescription:[NSString stringWithFormat:@"Response:%@(%@) - %@", @(response.statusCode), response.errorText, response.responseAsString]];
                }

                request.completion(nil, error);
            }

            return;
        }
        else if (error)
        {
            if (request.completion)
            {
                request.completion(nil, error);
            }
            
            return;
        }
        else
        {
            [self parseResponse:response request:request isXML:NO completion:request.completion];
        }
    }];
}

- (void)executeBlobDownloadRequest:(MHVHttpServiceRequest *)request
{
    // TODO: Add cache support
    MHVBlobDownloadRequest *blobDownloadRequest = request.serviceOperation;

    if (blobDownloadRequest.toFilePath)
    {
        //Download to file
        [self.httpService downloadFileWithUrl:blobDownloadRequest.url
                                   toFilePath:blobDownloadRequest.toFilePath
                                   completion:^(NSError * _Nullable error)
         {
             if (request.completion)
             {
                 request.completion(nil, error);
             }
         }];
    }
    else
    {
        //Download as data
        [self.httpService sendRequestForURL:blobDownloadRequest.url
                                 httpMethod:nil
                                       body:nil
                                    headers:nil
                                 completion:^(MHVHttpServiceResponse * _Nullable response, NSError * _Nullable error)
         {
             if (error)
             {
                 if (request.completion)
                 {
                     request.completion(nil, error);
                 }
             }
             else
             {
                 [self parseResponse:response request:request isXML:NO completion:request.completion];
             }
         }];
    }
}


- (void)executeBlobUploadRequest:(MHVHttpServiceRequest *)request
{
    MHVBlobUploadRequest *blobUploadRequest = request.serviceOperation;

    [self.httpService uploadBlobSource:blobUploadRequest.blobSource
                                 toUrl:blobUploadRequest.destinationURL
                             chunkSize:blobUploadRequest.chunkSize
                            completion:^(MHVHttpServiceResponse * _Nullable response, NSError * _Nullable error)
    {
        if (error)
        {
            if (request.completion)
            {
                request.completion(nil, error);
            }
            return;
        }
        
        MHVServiceResponse *serviceResponse = [[MHVServiceResponse alloc] initWithWebResponse:response isXML:NO];
        if (serviceResponse.error)
        {
            if (request.completion)
            {
                request.completion(nil, serviceResponse.error);
            }
        }
        else
        {
            if (request.completion)
            {
                request.completion(serviceResponse, nil);
            }
        }
    }];
}

- (NSString *)messageForMethod:(MHVMethod *)method
{
    MHVRequestMessageCreator *creator = [[MHVRequestMessageCreator alloc] initWithMethod:method
                                                                            sharedSecret:self.sessionCredential.sharedSecret
                                                                             authSession:[self authSession]
                                                                           configuration:self.configuration
                                                                                   appId:self.applicationId
                                                                             messageTime:[NSDate date]
                                                                           cryptographer:[MHVCryptographer new]];
    
    return creator.xmlString;
}

- (NSDictionary<NSString *, NSString *> *)headersForMethod:(MHVMethod *)method
{
    NSUUID *correlationId = method.correlationId != nil ? method.correlationId : [NSUUID new];
    
    return @{kCorrelationIdContextKey : correlationId.UUIDString};
}

- (void)parseResponse:(MHVHttpServiceResponse *)response
              request:(MHVHttpServiceRequest *)request
                isXML:(BOOL)isXML
           completion:(void (^_Nullable)(MHVServiceResponse *_Nullable response, NSError *_Nullable error))completion
{
    // If there is no completion, there is no need to parse the response.
    if (!completion)
    {
        return;
    }
    
    MHVServiceResponse *serviceResponse = [[MHVServiceResponse alloc] initWithWebResponse:response isXML:isXML];
    
    NSError *error = serviceResponse.error;
    
    if (error)
    {
        if (error.code == MHVErrorTypeUnauthorized)
        {
            [self refreshTokenAndReissueRequest:request];
            
            return;
        }
        
        serviceResponse = nil;
    }

    if (completion)
    {
        if (request.serviceOperation.cache)
        {
            [request.serviceOperation.cache setObject:serviceResponse forKey:[request.serviceOperation getCacheKey]];
        }
        
        completion(serviceResponse, error);
    }
}

- (void)retryRequest:(MHVHttpServiceRequest *)request
{
    request.retryAttempts += 1;
    
    MHVLOG(@"500 error from server, retrying in %0.1f seconds", self.configuration.retryOnInternal500SleepDuration);

    // Dispatch to main queue, so it holds a reference to the internal timer used by performSelector:withObject:afterDelay:
    [[NSOperationQueue mainQueue] addOperationWithBlock:^
    {
        [self performSelector:@selector(executeHttpServiceRequest:)
                   withObject:request
                   afterDelay:self.configuration.retryOnInternal500SleepDuration];
    }];
}

- (void)refreshSessionCredentialWithCompletion:(void(^_Nullable)(NSError *_Nullable error))completion
{
    NSString *message = [NSString stringWithFormat:@"Subclasses must implement %@", NSStringFromSelector(_cmd)];\
    MHVASSERT_MESSAGE(message);
}

- (void)refreshTokenAndReissueRequest:(MHVHttpServiceRequest *)request
{
    // If it already refreshed the token for this request, don't retry since refreshing again won't fix the problem
    if (request.hasRefreshedToken)
    {
        MHVLOG(@"The refreshed session authorization is invalid or expired.");
        
        if (request.completion)
        {
            request.completion(nil, [NSError error:[NSError MHVUnauthorizedError]
                                   withDescription:@"The session authorization was refreshed, but the new authorization is invalid or expired."]);
        }
        return;
    }
    request.hasRefreshedToken = YES;
    
    dispatch_async(self.completionQueue, ^
    {
        [self.requests addObject:request];
        
        if (self.requests.count > 1)
        {
            return;
        }
        
        MHVLOG(@"Refreshing Credentials");
        
        [self refreshSessionCredentialWithCompletion:^(NSError * _Nullable error)
        {
            dispatch_async(self.completionQueue, ^
            {
                MHVLOG(@"Refreshed token, re-issuing %li request(s)", (unsigned long)self.requests.count);
                
                while (self.requests.count > 0)
                {
                    MHVHttpServiceRequest *request = [self.requests firstObject];
                    
                    [self.requests removeObject:request];
                    
                    if (error)
                    {
                        if (request.completion)
                        {
                            request.completion(nil, error);
                        }
                        
                        return;
                    }
                    else
                    {
                        [self executeHttpServiceRequest:request];
                    }
                }
            });
        }];
    });
}

- (void)performBackgroundTasks:(void(^_Nullable)(MHVConnectionTaskResult *taskResult))completion
{
#if THING_CACHE
    if (!self.personInfo)
    {
        if (completion)
        {
            MHVConnectionTaskResult *result = [MHVConnectionTaskResult new];
            result.error = [NSError error:[NSError MHVUnauthorizedError] withDescription:@"User has not authenticated, can not sync cache"];
            completion(result);
        }
        return;
    }
    
    [self.cacheSynchronizer syncWithOptions:MHVCacheOptionsBackground
                                 completion:^(NSInteger syncedItemCount, NSError *_Nullable error)
     {
         if (completion)
         {
             MHVConnectionTaskResult *result = [MHVConnectionTaskResult new];
             result.thingCacheUpdateCount = syncedItemCount;
             result.error = error;
             
             completion(result);
         }
     }];
#else
    if (completion)
    {
        completion([MHVConnectionTaskResult new]);
    }
#endif
}

- (void)performForegroundTasks:(void (^)(MHVConnectionTaskResult * _Nonnull))completion
{
    //May change in the future, right now foreground and background tasks are the same
    [self performBackgroundTasks:completion];
}

- (MHVAuthSession *)authSession
{
    return nil;
}

@end

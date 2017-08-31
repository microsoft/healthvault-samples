//
//  MHVShellAuthService.m
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

#import "MHVShellAuthService.h"
#import "MHVValidator.h"
#import "NSError+MHVError.h"
#import "MHVConfiguration.h"
#import "MHVBrowserAuthBrokerProtocol.h"
#import "MHVDictionaryExtensions.h"
#import "MHVStringExtensions.h"

static NSString *const kInstanceIdKey = @"instanceId=";
static NSString *const kAppCreationQueryFormat = @"%@/redirect.aspx?target=CREATEAPPLICATION&targetqs=%@";
static NSString *const kAuthorizeRecordsQueryFormat =@"%@/redirect.aspx?target=APPAUTH&targetqs=%@";
static NSString *const kAppCreationArgs = @"?appid=%@&appCreationToken=%@&instanceName=%@&ismra=%@&mobile=true";
static NSString *const kAuthorizeRecordsArgs = @"?appid=%@&ismra=%@";

@interface MHVShellAuthService ()

@property (nonatomic, strong) MHVConfiguration *configuration;
@property (nonatomic, strong) id<MHVBrowserAuthBrokerProtocol> authBroker;
@property (nonatomic, strong) dispatch_queue_t authQueue;
@property (nonatomic, assign) BOOL isAuthInProgress;

@end

@implementation MHVShellAuthService

- (instancetype)initWithConfiguration:(MHVConfiguration *)configuration
                           authBroker:(id<MHVBrowserAuthBrokerProtocol>)authBroker
{
    MHVASSERT_PARAMETER(configuration);
    MHVASSERT_PARAMETER(authBroker);
    
    self = [super init];
    
    if (self)
    {
        _configuration = configuration;
        _authBroker = authBroker;
        _authQueue = dispatch_queue_create("MHVShellAuthService.authQueue", DISPATCH_QUEUE_SERIAL);
        _isAuthInProgress = NO;
    }
    
    return self;
}

#pragma mark - Public

- (void)provisionApplicationWithViewController:(UIViewController *_Nullable)viewController
                                      shellUrl:(NSURL *)shellUrl
                                   masterAppId:(NSUUID *)masterAppId
                              appCreationToken:(NSString *)appCreationToken
                                 appInstanceId:(NSUUID *)appInstanceId
                                    completion:(void (^)(NSString *_Nullable instanceId, NSError *_Nullable error))completion
{
    MHVASSERT_PARAMETER(shellUrl);
    MHVASSERT_PARAMETER(masterAppId);
    MHVASSERT_PARAMETER(appCreationToken);
    MHVASSERT_PARAMETER(appInstanceId);
    MHVASSERT_PARAMETER(completion);
    
    dispatch_async(self.authQueue, ^
    {
        if (!completion)
        {
            return;
        }
        
        if (self.isAuthInProgress)
        {
            completion(nil, [NSError MHVAuthorizationInProgress]);
            
            return;
        }
        
        self.isAuthInProgress = YES;
        
        if (!shellUrl || !masterAppId || !appCreationToken || !appInstanceId)
        {
            completion(nil, [NSError error:[NSError MVHInvalidParameter] withDescription:@"One or more required parameters are missing."]);
            
            self.isAuthInProgress = NO;
            
            return;
        }
        
        NSURL *startUrl = [self getApplicationCreationUrlWithShellUrl:shellUrl
                                                          queryFormat:kAppCreationQueryFormat
                                                                appId:masterAppId
                                                     appCreationToken:appCreationToken
                                                        appInstanceId:appInstanceId];
        
        NSURL *endUrl = [self endUrlWithShellUrl:shellUrl];
        
        [self.authBroker authenticateWithViewController:viewController
                                               startUrl:startUrl
                                                 endUrl:endUrl
                                             completion:^(NSURL * _Nullable successUrl, NSError * _Nullable error)
         {
            dispatch_async(self.authQueue, ^
            {
                if (error)
                {
                    completion(nil, error);
                    
                    self.isAuthInProgress = NO;
                    
                    return;
                }
                
                NSString *instanceId = [self instanceIdFromUrl:successUrl];
                
                if ([NSString isNilOrEmpty:instanceId])
                {
                    completion (nil, [NSError error:[NSError MHVUnknownError] withDescription:@"Failed to obtain an instanceId from the authorization service."]);
                    
                    self.isAuthInProgress = NO;
                    
                    return;
                }
                
                completion(instanceId, nil);
                
                self.isAuthInProgress = NO;
            });
        }];
    });
}

- (void)authorizeAdditionalRecordsWithViewController:(UIViewController *_Nullable)viewController
                                            shellUrl:(NSURL *)shellUrl
                                       appInstanceId:(NSUUID *)appInstanceId
                                          completion:(void (^_Nullable)(NSError *_Nullable error))completion
{
    MHVASSERT_PARAMETER(shellUrl);
    MHVASSERT_PARAMETER(appInstanceId);
    
    dispatch_async(self.authQueue, ^
    {
        if (!completion)
        {
            return;
        }
        
        if (self.isAuthInProgress)
        {
            completion([NSError MHVAuthorizationInProgress]);
            
            return;
        }
        
        self.isAuthInProgress = YES;
        
        if (!shellUrl || !appInstanceId)
        {
            if (completion)
            {
                completion([NSError error:[NSError MVHInvalidParameter] withDescription:@"One or more required parameters are missing."]);
            }
            
            self.isAuthInProgress = NO;
            
            return;
        }
        
        NSURL *startUrl = [self getApplicationCreationUrlWithShellUrl:shellUrl
                                                          queryFormat:kAuthorizeRecordsQueryFormat
                                                                appId:appInstanceId
                                                     appCreationToken:nil
                                                        appInstanceId:nil];
        
        NSURL *endUrl = [self endUrlWithShellUrl:shellUrl];
        
        [self.authBroker authenticateWithViewController:viewController
                                               startUrl:startUrl
                                                 endUrl:endUrl
                                             completion:^(NSURL * _Nullable successUrl, NSError * _Nullable error)
        {
            dispatch_async(self.authQueue, ^
            {
                if (completion)
                {
                    completion(error);
                }
                
                self.isAuthInProgress = NO;
            });
        }];
    });
}

#pragma mark - Private

- (NSURL *)getApplicationCreationUrlWithShellUrl:(NSURL *)shellUrl
                                     queryFormat:(NSString *)queryFormat
                                           appId:(NSUUID *)appId
                                appCreationToken:(NSString *)appCreationToken
                                   appInstanceId:(NSUUID *)appInstanceId
{
    CFStringRef tokenEncoded = CreateHVUrlEncode((__bridge CFStringRef)appCreationToken);
    
    CFStringRef instanceEncoded = CreateHVUrlEncode((__bridge CFStringRef)appInstanceId.UUIDString);
    
    NSString *isMultiRecord = self.configuration.isMultiRecordApp ? @"true" : @"false";
    
    NSString *queryString = nil;
    
    if (tokenEncoded && instanceEncoded)
    {
        queryString = [NSString stringWithFormat:kAppCreationArgs, appId, tokenEncoded, instanceEncoded, isMultiRecord];
        
        if (self.configuration.isMultiInstanceAware)
        {
            queryString = [queryString stringByAppendingString:@"&aib=true"];
        }
    }
    else
    {
        queryString = [NSString stringWithFormat:kAuthorizeRecordsArgs, appId, isMultiRecord];
    }

    if (tokenEncoded)
    {
        CFRelease(tokenEncoded);
    }
    if (instanceEncoded)
    {
        CFRelease(instanceEncoded);
    }

    CFStringRef queryStringEncoded = CreateHVUrlEncode((__bridge CFStringRef)queryString);
    
    NSString *urlString = [NSString stringWithFormat:queryFormat, shellUrl, (__bridge NSString *)queryStringEncoded];
    
    CFRelease(queryStringEncoded);
    
    return [[NSURL alloc] initWithString:urlString];
}

- (NSURL *)endUrlWithShellUrl:(NSURL *)shellUrl
{
    return [shellUrl URLByAppendingPathComponent:@"application/complete"];
}


- (NSString *)instanceIdFromUrl:(NSURL *)url
{
    NSDictionary* args = [NSDictionary dictionaryFromArgumentString:[url query]];
    
    if ([NSDictionary isNilOrEmpty:args])
    {
        return nil;
    }
    
    return [args objectForKey:@"instanceid"];
}

@end

//
//  MHVSessionCredentialClient.m
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

#import "MHVSessionCredentialClient.h"
#import "MHVConnectionProtocol.h"
#import "MHVValidator.h"
#import "MHVMethod.h"
#import "MHVDateExtensions.h"
#import "MHVSessionCredential.h"
#import "MHVServiceResponse.h"
#import "MHVConfiguration.h"
#import "XSerializer.h"
#import "NSError+MHVError.h"
#import "MHVStringExtensions.h"
#import "MHVCryptographer.h"

@interface MHVSessionCredentialClient ()

@property (nonatomic, weak) id<MHVConnectionProtocol> connection;
@property (nonatomic, strong) MHVCryptographer *cryptographer;

@end

@implementation MHVSessionCredentialClient

- (instancetype)initWithConnection:(id<MHVConnectionProtocol>)connection
                     cryptographer:(MHVCryptographer *)cryptographer
{
    MHVASSERT_PARAMETER(connection);
    
    self = [super init];
    
    if (self)
    {
        _connection = connection;
        _cryptographer = cryptographer;
    }
    
    return self;
}

- (void)getSessionCredentialWithSharedSecret:(NSString *)sharedSecret
                                  completion:(void (^_Nonnull)(MHVSessionCredential *_Nullable credential, NSError *_Nullable error))completion
{
    MHVASSERT_PARAMETER(completion);
    MHVASSERT_PARAMETER(sharedSecret);
    
    if (!completion)
    {
        return;
    }
    
    if ([NSString isNilOrEmpty:sharedSecret])
    {
        completion(nil, [NSError error:[NSError MVHInvalidParameter] withDescription:@"The 'sharedSecret' parameter is required."]);
    }
    
    MHVMethod *method = [MHVMethod createAuthenticatedSessionToken];
    method.parameters = [self infoSectionWithSharedSecret:sharedSecret];
    
    [self.connection executeHttpServiceOperation:method
                                      completion:^(MHVServiceResponse *_Nullable response, NSError *_Nullable error)
    {
        if (error)
        {
            if (completion)
            {
                completion(nil, error);
            }
            
            return;
        }

        MHVSessionCredential *credential = (MHVSessionCredential *)[XSerializer newFromString:response.infoXml withRoot:@"info" asClass:[MHVSessionCredential class]];
        
        if (!credential || [NSString isNilOrEmpty:credential.token] || [NSString isNilOrEmpty:credential.sharedSecret])
        {
            completion(nil, [NSError error:[NSError MHVUnknownError] withDescription:@"The CreateAuthenticatedSessionToken response is invalid."]);
            
            return;
        }
        
        completion(credential, nil);
        
    }];
}

- (NSString *)infoSectionWithSharedSecret:(NSString *)sharedSecret
{
    NSString *msgTimeString = [[NSDate date] dateToUtcString];
    
    NSMutableString *stringToSign = [NSMutableString new];
    
    [stringToSign appendString:@"<content>"];
    [stringToSign appendFormat:@"<app-id>%@</app-id>", self.connection.applicationId];
    [stringToSign appendString:@"<hmac>HMACSHA256</hmac>"];
    [stringToSign appendFormat:@"<signing-time>%@</signing-time>", msgTimeString];
    [stringToSign appendString:@"</content>"];
    
    NSData *keyData = [[NSData alloc] initWithBase64EncodedString:sharedSecret options:0];
    NSString *hmac = [self.cryptographer computeSha256Hmac:keyData data:stringToSign];
    
    NSMutableString *xml = [NSMutableString new];
    [xml appendString:@"<info>"];
    [xml appendString:@"<auth-info>"];
    [xml appendFormat:@"<app-id>%@</app-id>", self.connection.applicationId];
    [xml appendString:@"<credential>"];
    [xml appendString:@"<appserver2>"];
    [xml appendFormat:@"<hmacSig algName=\"HMACSHA256\">%@</hmacSig>", hmac];
    [xml appendString:stringToSign];
    [xml appendString:@"</appserver2>"];
    [xml appendString:@"</credential>"];
    [xml appendString:@"</auth-info>"];
    [xml appendString:@"</info>"];
    
    return xml;
}


@end

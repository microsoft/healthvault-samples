//
// MHVRequestMessageCreator.m
// MHVLib
//
// Copyright 2017 Microsoft Corp.
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

#import "MHVRequestMessageCreator.h"
#import "MHVDateExtensions.h"
#import "MHVStringExtensions.h"
#import "MHVCryptographer.h"
#import "MHVValidator.h"
#import "MHVMethod.h"
#import "MHVValidator.h"
#import "MHVConfiguration.h"
#import "MHVAuthSession.h"
#import "MHVClientInfo.h"

@interface MHVRequestMessageCreator ()

@property (nonatomic, strong) MHVMethod *method;
@property (nonatomic, strong) NSString *sharedSecret;
@property (nonatomic, strong) MHVAuthSession *authSession;
@property (nonatomic, strong) MHVConfiguration *configuration;
@property (nonatomic, strong) NSUUID *appId;
@property (nonatomic, strong) NSDate *messageTime;
@property (nonatomic, strong) MHVCryptographer *cryptographer;

@end

@implementation MHVRequestMessageCreator

- (instancetype)initWithMethod:(MHVMethod *)method
                  sharedSecret:(NSString *_Nullable)sharedSecret
                   authSession:(MHVAuthSession *)authSession
                 configuration:(MHVConfiguration *)configuration
                         appId:(NSUUID *)appId
                   messageTime:(NSDate *)messageTime
                 cryptographer:(MHVCryptographer *)cryptographer
{
    MHVASSERT_PARAMETER(method);
    MHVASSERT_PARAMETER(authSession);
    MHVASSERT_PARAMETER(configuration);
    MHVASSERT_PARAMETER(messageTime);
    MHVASSERT_PARAMETER(cryptographer);
    
    self = [super init];
    
    if (self)
    {
        _method = method;
        _sharedSecret = sharedSecret;
        _authSession = authSession;
        _configuration = configuration;
        _appId = appId;
        _messageTime = messageTime;
        _cryptographer = cryptographer;
    }
    
    return self;
}

- (NSString *)xmlString
{
    NSMutableString *xml = [NSMutableString new];
    
    [xml appendString:@"<wc-request:request xmlns:wc-request=\"urn:com.microsoft.wc.request\">"];
    
    NSString *infoString = self.method.parameters != nil ? self.method.parameters : @"<info />";
    
    NSMutableString *header = [[NSMutableString alloc] init];
    
    [self writeHeader:header forBody:infoString];
    
    [self writeAuth:xml forHeader:header];
    
    [xml appendString:header];
    
    [xml appendString:infoString];
    
    [xml appendString:@"</wc-request:request>"];
    
    return xml;
    
}

- (void)writeHeader:(NSMutableString *)header forBody:(NSString *)body
{
    [header appendXmlElementStart:@"header"];
    
    [self writeMethodHeaders:header];
    [self writeRecordHeaders:header];
    [self writeAuthSessionHeader:header];
    [self writeStandardHeaders:header];
    [self writeHashHeader:header forBody:body];
    
    [header appendXmlElementEnd:@"header"];
}

- (void)writeMethodHeaders:(NSMutableString *)header
{
    [header appendXmlElement:@"method" text:self.method.name];
    [header appendXmlElementStart:@"method-version"];
    [header appendFormat:@"%li",(long)self.method.version];
    [header appendXmlElementEnd:@"method-version"];
}

- (void)writeRecordHeaders:(NSMutableString *)header
{
    if (self.method.recordId)
    {
        [header appendXmlElement:@"record-id" text:self.method.recordId.UUIDString];
    }
}

- (void)writeStandardHeaders:(NSMutableString *)header
{
    [header appendXmlElement:@"msg-time" text:[self.messageTime dateToUtcString]];
    [header appendXmlElementStart:@"msg-ttl"];
    [header appendFormat:@"%ld", (long)self.configuration.requestTimeToLiveDuration];
    [header appendXmlElementEnd:@"msg-ttl"];
    [header appendXmlElement:@"version" text:[MHVClientInfo telemetryInfo]];
}

- (void)writeAuthSessionHeader:(NSMutableString *)header
{
    if ([NSString isNilOrEmpty:self.authSession.authToken] || self.method.isAnonymous)
    {
        NSUUID *appId = self.appId != nil ? self.appId : self.configuration.masterApplicationId;
        
        [header appendXmlElement:@"app-id" text:appId.UUIDString];
        return;
    }
    
    [header appendXmlElementStart:@"auth-session"];
    [header appendXmlElement:@"auth-token" text:self.authSession.authToken];
    
    if (self.authSession.userAuthToken)
    {
        [header appendXmlElement:@"user-auth-token" text:self.authSession.userAuthToken];
    }
    else if (self.authSession.offlinePersonId)
    {
        [header appendXmlElementStart:@"offline-person-info"];
        [header appendXmlElement:@"offline-person-id" text:self.authSession.offlinePersonId.UUIDString];
        [header appendXmlElementEnd:@"offline-person-info"];
    }
    
    [header appendXmlElementEnd:@"auth-session"];
}

- (void)writeHashHeader:(NSMutableString *)header forBody:(NSString *)body
{
    if (self.method.isAnonymous)
    {
        return;
    }
    
    [header appendXmlElementStart:@"info-hash"];
    [header appendFormat:@"<hash-data algName=\"SHA256\">%@</hash-data>", [self.cryptographer computeSha256Hash:body]];
    [header appendXmlElementEnd:@"info-hash"];
}

- (void)writeAuth:(NSMutableString *)xml forHeader:(NSString *)header
{
    if (self.sharedSecret && !self.method.isAnonymous)
    {
        NSData *decodedKey = [[NSData alloc] initWithBase64EncodedString:self.sharedSecret options:0];
        
        [xml appendXmlElementStart:@"auth"];
        [xml appendFormat:@"<hmac-data algName=\"HMACSHA256\">%@</hmac-data>", [self.cryptographer computeSha256Hmac:decodedKey data:header]];
        [xml appendXmlElementEnd:@"auth"];
    }
}

@end

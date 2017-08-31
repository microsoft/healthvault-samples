//
// MHVServiceResponse.h
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

#import <Foundation/Foundation.h>

@class MHVHttpServiceResponse;

typedef NS_ENUM (NSInteger, MHVServerStatusCode)
{
    MHVServerStatusCodeOK = 0,
    MHVServerStatusCodeFailed = 1,
    MHVServerStatusCodeBadHttp = 2,
    MHVServerStatusCodeInvalidXml = 3,
    MHVServerStatusCodeInvalidRequestIntegrity = 4,
    MHVServerStatusCodeBadMethod = 5,
    
    /// 6 = App does not exist, app is invalid, app is not active or calling IP is invalid.
    MHVServerStatusCodeInvalidApp = 6,
    MHVServerStatusCodeCredentialTokenExpired = 7,
    
    /// 8 = Security problem for current app.
    MHVServerStatusCodeInvalidToken = 8,
    MHVServerStatusCodeInvalidPerson = 9,
    MHVServerStatusCodeInvalidRecord = 10,
    MHVServerStatusCodeAccessDenied = 11,
    MHVServerStatusCodeInvalidThing = 13,
    MHVServerStatusCodeInvalidFilter = 15,
    MHVServerStatusCodeInvalidApplicationAuthorization = 18,
    MHVServerStatusCodeTypeIDNotFound = 19,
    MHVServerStatusCodeDuplicateCredentialFound = 22,
    MHVServerStatusCodeInvalidRecordState = 37,
    MHVServerStatusCodeRequestTimedOut = 49,
    MHVServerStatusCodeVersionStampMismatch = 61,
    
    /// 65 = Token has been expired and should be updated.
    MHVServerStatusCodeAuthSessionTokenExpired = 65,
    MHVServerStatusCodeRecordQuotaExceeded = 68,
    MHVServerStatusCodeApplicationLimitExceeded = 93,
    MHVServerStatusCodeVocabAccessDenied = 130,
    MHVServerStatusCodeInvalidAge = 157,
    MHVServerStatusCodeInvalidIPAddress = 158,
    MHVServerStatusCodeMaxRecordsExceeded = 160
};

@interface MHVServiceResponse : NSObject

// Gets the http response code...
@property (nonatomic, assign) int statusCode;

/// Gets or sets the informational part of the response.
@property (nonatomic, strong) NSString *infoXml;

/// Gets the response data
@property (nonatomic, strong) NSData *responseData;

@property (nonatomic, strong) NSError *error;

/// Initializes a new instance of the MHVServiceResponse class.
/// The response will be parsed into infoXml
/// @param response - the web response from server side.
/// @param isXML - whether the response HealthVault XML and infoXml should be filled.
- (instancetype)initWithWebResponse:(MHVHttpServiceResponse *)response isXML:(BOOL)isXML;

@end

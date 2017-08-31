//
// MHVServiceResponse.m
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

#import "MHVValidator.h"
#import "MHVServiceResponse.h"
#import "MHVResponse.h"
#import "NSError+MHVError.h"
#import "MHVErrorConstants.h"
#import "MHVHttpServiceResponse.h"

@implementation MHVServiceResponse

- (instancetype)initWithWebResponse:(MHVHttpServiceResponse *)response isXML:(BOOL)isXML
{
    self = [super init];
    
    if (self)
    {
        _statusCode = (int)response.statusCode;
        
        if (response.hasError)
        {
            if (_statusCode == 401)
            {
                _error = [NSError error:[NSError MHVUnauthorizedError] withDescription:@"The Authorization token is missing, malformed or expired."];
            }
        }
        else if (isXML)
        {
            NSString *xml = response.responseAsString;
            
            BOOL xmlReaderResult = [self deserializeXml:xml];
            
            if (!xmlReaderResult)
            {
                _error = [NSError error:[NSError MHVUnknownError] withDescription:[NSString stringWithFormat:@"Response was not a valid HealthVault response.\n%@",xml]];
            }
        }
        else
        {
            _responseData = response.responseAsData;
        }
    }
    
    return self;
}

- (BOOL)deserializeXml:(NSString *)xml
{
    MHVResponse *response = (MHVResponse *)[NSObject newFromString:xml withRoot:@"response" asClass:[MHVResponse class]];
    
    if (!response)
    {
        return NO;
    }
    
    MHVResponseStatus *status = response.status;
    
    if (status)
    {
        if (status.code == MHVServerStatusCodeAuthSessionTokenExpired)
        {
            self.error = [NSError error:[NSError MHVUnauthorizedError] withDescription:@"The Authorization token has expired."];
        }
        else
        {
            MHVServerError *error = status.error;
            
            if (error)
            {
                self.error = [NSError errorWithDomain:kMHVErrorDomain
                                                 code:status.code
                                             userInfo:@{
                                                        NSLocalizedFailureReasonErrorKey : [NSString stringWithFormat:@"%@\n%@\n%@",error.message, error.context, error.errorInfo]
                                                        }];
            }
        }
    }
    
    self.infoXml = response.body;
    
    return YES;
}

@end

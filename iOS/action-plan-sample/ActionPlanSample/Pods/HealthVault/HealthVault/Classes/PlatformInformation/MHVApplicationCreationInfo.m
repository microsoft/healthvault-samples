//
//  MHVApplicationCreationInfo.m
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

#import "MHVApplicationCreationInfo.h"
#import "MHVValidator.h"

static const xmlChar *x_element_app_id = XMLSTRINGCONST("app-id");
static const xmlChar *x_element_shared_secret = XMLSTRINGCONST("shared-secret");
static const xmlChar *x_element_app_token = XMLSTRINGCONST("app-token");

@implementation MHVApplicationCreationInfo

- (instancetype)initWithAppInstanceId:(NSUUID *)appInstanceId
                         sharedSecret:(NSString *)sharedSecret
                     appCreationToken:(NSString *)appCreationToken
{
    MHVASSERT_PARAMETER(appInstanceId);
    MHVASSERT_PARAMETER(sharedSecret);
    MHVASSERT_PARAMETER(appCreationToken);
    
    self = [super init];
    
    if (self)
    {
        _appInstanceId = appInstanceId;
        _sharedSecret = sharedSecret;
        _appCreationToken = appCreationToken;
    }
    
    return self;
}

- (void)deserialize:(XReader *)reader
{
    _appInstanceId = [[NSUUID alloc] initWithUUIDString:[reader readStringElementWithXmlName:x_element_app_id]];
    _sharedSecret = [reader readStringElementWithXmlName:x_element_shared_secret];
    _appCreationToken = [reader readStringElementWithXmlName:x_element_app_token];
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementXmlName:x_element_app_id value:self.appInstanceId.UUIDString];
    [writer writeElementXmlName:x_element_shared_secret value:self.sharedSecret];
    [writer writeElementXmlName:x_element_app_token value:self.appCreationToken];
}

@end

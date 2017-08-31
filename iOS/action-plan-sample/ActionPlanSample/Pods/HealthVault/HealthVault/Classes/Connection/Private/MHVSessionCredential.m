//
//  MHVSessionCredential.m
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

#import "MHVSessionCredential.h"
#import "MHVValidator.h"

static const xmlChar *x_element_token = XMLSTRINGCONST("token");
static const xmlChar *x_element_shared_secret = XMLSTRINGCONST("shared-secret");

@implementation MHVSessionCredential

- (instancetype)initWithToken:(NSString *)token sharedSecret:(NSString *)sharedSecret
{
    MHVASSERT_PARAMETER(token);
    MHVASSERT_PARAMETER(sharedSecret);
    
    self = [super init];
    
    if (self)
    {
        _token = token;
        _sharedSecret = sharedSecret;
    }
    
    return self;
}

- (void)deserialize:(XReader *)reader
{
    _token = [reader readStringElementWithXmlName:x_element_token];
    _sharedSecret = [reader readStringElementWithXmlName:x_element_shared_secret];
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementXmlName:x_element_token value:self.token];
    [writer writeElementXmlName:x_element_shared_secret value:self.sharedSecret];
}

@end

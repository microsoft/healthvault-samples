//
// MHVResponse.m
// MHVLib
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
//
#import "MHVValidator.h"
#import "MHVResponse.h"

static const xmlChar *x_element_status = XMLSTRINGCONST("status");

@implementation MHVResponse

- (BOOL)hasError
{
    return self.status != nil && self.status.hasError;
}

- (void)deserialize:(XReader *)reader
{
    self.status = [reader readElementWithXmlName:x_element_status asClass:[MHVResponseStatus class]];
    if (reader.isStartElement)
    {
        self.body = [reader readOuterXml];
    }
}

@end

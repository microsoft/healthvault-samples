//
// MHVResponseStatus.m
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
#import "MHVResponseStatus.h"

static const xmlChar *x_element_code = XMLSTRINGCONST("code");
static const xmlChar *x_element_error = XMLSTRINGCONST("error");

@implementation MHVResponseStatus

- (BOOL)hasError
{
    return self.code != 0 || self.error != nil;
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementXmlName:x_element_code intValue:self.code];
    [writer writeElementXmlName:x_element_error content:self.error];
}

- (void)deserialize:(XReader *)reader
{
    self.code = [reader readIntElementXmlName:x_element_code];
    self.error = [reader readElementWithXmlName:x_element_error asClass:[MHVServerError class]];
}

@end

//
// MHVServiceInstance.m
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
//

#import "MHVValidator.h"
#import "MHVServiceInstance.h"

static const xmlChar *x_element_id = XMLSTRINGCONST("id");
static const xmlChar *x_element_name = XMLSTRINGCONST("name");
static const xmlChar *x_element_description = XMLSTRINGCONST("description");
static const xmlChar *x_element_platform = XMLSTRINGCONST("platform-url");
static const xmlChar *x_element_shell = XMLSTRINGCONST("shell-url");

@implementation MHVServiceInstance

- (void)deserialize:(XReader *)reader
{
    self.instanceID = [reader readStringElementWithXmlName:x_element_id];
    self.name = [reader readStringElementWithXmlName:x_element_name];
    self.instanceDescription = [reader readStringElementWithXmlName:x_element_description];
    self.healthServiceUrl = [[NSURL alloc]initWithString:[reader readStringElementWithXmlName:x_element_platform]];
    self.shellUrl = [[NSURL alloc]initWithString:[reader readStringElementWithXmlName:x_element_shell]];
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementXmlName:x_element_id value:self.instanceID];
    [writer writeElementXmlName:x_element_name value:self.name];
    [writer writeElementXmlName:x_element_description value:self.instanceDescription];
    [writer writeElementXmlName:x_element_platform value:self.healthServiceUrl.absoluteString];
    [writer writeElementXmlName:x_element_shell value:self.shellUrl.absoluteString];
}

@end


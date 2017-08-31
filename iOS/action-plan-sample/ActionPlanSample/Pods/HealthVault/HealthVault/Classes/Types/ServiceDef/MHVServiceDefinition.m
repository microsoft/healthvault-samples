//
// MHVServiceDefinition.m
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
#import "MHVServiceDefinition.h"

static const xmlChar *x_element_platform = XMLSTRINGCONST("platform");
static const xmlChar *x_element_shell = XMLSTRINGCONST("shell");
static const xmlChar *x_element_instance = XMLSTRINGCONST("instances");
static NSString *const c_element_updated = @"updated-date";
static NSString *const c_element_sections = @"response-sections";
static NSString *const c_element_section = @"section";

@implementation MHVServiceDefinition

- (void)deserialize:(XReader *)reader
{
    self.platform = [reader readElementWithXmlName:x_element_platform
                                           asClass:[MHVPlatformInfo class]];
    self.shell = [reader readElementWithXmlName:x_element_shell
                                        asClass:[MHVShellInfo class]];
    [reader skipElement:@"xml-method"];
    [reader skipElement:@"common-schema"];
    self.systemInstances = [reader readElementWithXmlName:x_element_instance
                                                  asClass:[MHVSystemInstances class]];
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementXmlName:x_element_platform content:self.platform];
    [writer writeElementXmlName:x_element_shell content:self.shell];
    [writer writeElementXmlName:x_element_instance content:self.systemInstances];
}

@end

@implementation MHVServiceDefinitionParams

- (NSArray<NSString *> *)sections
{
    if (!_sections)
    {
        _sections = [[NSArray alloc] init];
    }
    
    return _sections;
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_updated dateValue:self.updatedSince];
    [writer writeElementArray:c_element_sections thingName:c_element_section elements:self.sections];
}

@end

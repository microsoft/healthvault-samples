//
// MHVConfigurationEntry.m
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

#import "MHVConfigurationEntry.h"

static const xmlChar *x_attribute_key = XMLSTRINGCONST("key");

@implementation MHVConfigurationEntry

- (void)deserializeAttributes:(XReader *)reader
{
    self.key = [reader readAttributeWithXmlName:x_attribute_key];
}

- (void)deserialize:(XReader *)reader
{
    self.value = [reader readValue];
}

- (void)serializeAttributes:(XWriter *)writer
{
    [writer writeAttributeXmlName:x_attribute_key value:self.key];
}

- (void)serialize:(XWriter *)writer
{
    [writer writeText:self.value];
}

@end

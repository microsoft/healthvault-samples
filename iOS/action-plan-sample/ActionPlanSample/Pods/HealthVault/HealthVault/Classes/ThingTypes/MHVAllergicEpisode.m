//
// MHVAllergicEpisode.m
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


#import "MHVAllergicEpisode.h"

static NSString *const c_typeid = @"d65ad514-c492-4b59-bd05-f3f6cb43ceb3";
static NSString *const c_typename = @"allergic-episode";

static NSString *const c_element_when = @"when";
static NSString *const c_element_name = @"name";
static NSString *const c_element_reaction = @"reaction";
static NSString *const c_element_treatment = @"treatment";

@implementation MHVAllergicEpisode

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_when content:self.when];
    [writer writeElement:c_element_name content:self.name];
    [writer writeElement:c_element_reaction content:self.reaction];
    [writer writeElement:c_element_treatment content:self.treatment];
}

- (void)deserialize:(XReader *)reader
{
    self.when = [reader readElement:c_element_when asClass:[MHVDateTime class]];
    self.name = [reader readElement:c_element_name asClass:[MHVCodableValue class]];
    self.reaction = [reader readElement:c_element_reaction asClass:[MHVCodableValue class]];
    self.treatment = [reader readElement:c_element_treatment asClass:[MHVCodableValue class]];
}


+ (NSString *)typeID
{
    return c_typeid;
}

+ (NSString *)XRootElement
{
    return c_typename;
}

@end

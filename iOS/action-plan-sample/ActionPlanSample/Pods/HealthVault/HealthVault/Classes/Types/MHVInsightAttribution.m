//
//  MHVInsightAttribution.m
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
//
#import "MHVInsightAttribution.h"

static NSString *const c_element_name = @"name";
static NSString *const c_element_attribution_required = @"attribution-required";

@implementation MHVInsightAttribution

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_name content:self.name];
    [writer writeElement:c_element_attribution_required content:self.attributionRequired];
}

- (void)deserialize:(XReader *)reader
{
    self.name = [reader readElement:c_element_name asClass:[MHVStringNZ256 class]];
    self.attributionRequired = [reader readElement:c_element_attribution_required asClass:[MHVBool class]];
}
@end

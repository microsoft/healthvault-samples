//
// MHVConcern.m
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

#import "MHVConcern.h"

static NSString *const c_typeid = @"aea2e8f2-11dd-4a7d-ab43-1d58764ebc19";
static NSString *const c_typename = @"concern";

static NSString *const c_element_description = @"description";
static NSString *const c_element_status = @"status";

@implementation MHVConcern

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_description content:self.descriptionText];
    [writer writeElement:c_element_status content:self.status];
}

- (void)deserialize:(XReader *)reader
{
    self.descriptionText = [reader readElement:c_element_description asClass:[MHVCodableValue class]];
    self.status = [reader readElement:c_element_status asClass:[MHVCodableValue class]];
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

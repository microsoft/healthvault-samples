//
//  MHVHealthJournalEntry.m
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

#import "MHVHealthJournalEntry.h"

static NSString *const c_typeid = @"21d75546-8717-4deb-8b17-a57f48917790";
static NSString *const c_typename = @"health-journal-entry";

static NSString *const c_element_when = @"when";
static NSString *const c_element_content = @"content";
static NSString *const c_element_category = @"category";

@implementation MHVHealthJournalEntry

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_when content:self.when];
    [writer writeElement:c_element_content content:self.content];
    [writer writeElement:c_element_category content:self.category];
}

- (void)deserialize:(XReader *)reader
{
    self.when = [reader readElement:c_element_when asClass:[MHVApproxDateTime class]];
    self.content = [reader readElement:c_element_content asClass:[MHVStringNZNW class]];
    self.category = [reader readElement:c_element_category asClass:[MHVCodableValue class]];
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

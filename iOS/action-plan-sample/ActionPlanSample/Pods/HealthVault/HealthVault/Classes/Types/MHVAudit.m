//
// MHVAudit.m
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

#import "MHVAudit.h"

static NSString *const c_element_when = @"timestamp";
static NSString *const c_element_appID = @"app-id";
static NSString *const c_element_personID = @"person-id";
static NSString *const c_element_action = @"audit-action";

@implementation MHVAudit

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_when dateValue:self.when];
    [writer writeElement:c_element_appID value:self.appID.UUIDString];
    [writer writeElement:c_element_personID value:self.personID.UUIDString];
    [writer writeElement:c_element_action value:self.action];
}

- (void)deserialize:(XReader *)reader
{
    self.when = [reader readDateElement:c_element_when];
    self.appID = [[NSUUID alloc] initWithUUIDString:[reader readStringElement:c_element_appID]];
    self.personID = [[NSUUID alloc] initWithUUIDString:[reader readStringElement:c_element_personID]];
    self.action = [reader readStringElement:c_element_action];
}

@end

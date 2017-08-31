//
// MHVGetAuthorizedPeopleSettings.m
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

#import "MHVGetAuthorizedPeopleSettings.h"

static NSString *const c_element_authorizationsCreatedSince = @"authorizations-created-since";
static NSString *const c_element_batchSize = @"num-results";
static NSString *const c_element_startingPersonId = @"person-id-cursor";

@implementation MHVGetAuthorizedPeopleSettings

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_authorizationsCreatedSince dateValue:self.authorizationsCreatedSince];
    if (self.batchSize > 0)
    {
        [writer writeElement:c_element_batchSize intValue:self.batchSize];
    }
    [writer writeElement:c_element_authorizationsCreatedSince value:self.startingPersonId.UUIDString];
}

- (void)deserialize:(XReader *)reader
{
    self.authorizationsCreatedSince = [reader readDateElement:c_element_authorizationsCreatedSince];
    self.batchSize = [reader readIntElement:c_element_batchSize];
    self.startingPersonId = [[NSUUID alloc] initWithUUIDString:[reader readStringElement:c_element_startingPersonId]];
}

@end

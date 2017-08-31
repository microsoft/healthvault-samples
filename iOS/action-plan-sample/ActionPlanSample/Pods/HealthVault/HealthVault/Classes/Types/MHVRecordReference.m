//
// MHVRecordReference.m
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

#import "MHVValidator.h"
#import "MHVRecordReference.h"

static NSString *const c_attribute_id = @"id";
static NSString *const c_attribute_personID = @"person-id";

@implementation MHVRecordReference

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN;

    MHVVALIDATE_STRING(self.ID, MHVClientError_InvalidRecordReference);

    MHVVALIDATE_SUCCESS;
}

- (void)serializeAttributes:(XWriter *)writer
{
    [writer writeAttribute:c_attribute_id value:self.ID.UUIDString];
    [writer writeAttribute:c_attribute_personID value:self.personID.UUIDString];
}

- (void)deserializeAttributes:(XReader *)reader
{
    self.ID = [[NSUUID alloc] initWithUUIDString:[reader readAttribute:c_attribute_id]];
    self.personID = [[NSUUID alloc] initWithUUIDString:[reader readAttribute:c_attribute_personID]];
}

@end

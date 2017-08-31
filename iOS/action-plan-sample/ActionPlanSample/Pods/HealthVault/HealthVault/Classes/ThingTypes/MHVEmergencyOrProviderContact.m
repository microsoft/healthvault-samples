//
// MHVEmergencyOrProviderContact.m
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

#import "MHVEmergencyOrProviderContact.h"
#import "MHVValidator.h"

static NSString *const c_typeid = @"25c94a9f-9d3d-4576-96dc-6791178a8143";
static NSString *const c_typename = @"person";

@implementation MHVEmergencyOrProviderContact

- (instancetype)initWithPerson:(MHVPerson *)person
{
    MHVCHECK_NOTNULL(person);

    self = [super init];
    if (self)
    {
        _person = person;
    }

    return self;
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN

        MHVVALIDATE(self.person, MHVClientError_InvalidEmergencyContact);

    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    if (self.person)
    {
        [self.person serialize:writer];
    }
}

- (void)deserialize:(XReader *)reader
{
    MHVPerson *person = [[MHVPerson alloc] init];
    self.person = person;

    [person deserialize:reader];
}

+ (NSString *)typeID
{
    return c_typeid;
}

+ (NSString *)XRootElement
{
    return c_typename;
}

+ (MHVThing *)newThing
{
    return [[MHVThing alloc] initWithType:[MHVEmergencyOrProviderContact typeID]];
}

- (NSString *)typeName
{
    return NSLocalizedString(@"Contact", @"Emergency or provider contact  Type Name");
}

@end

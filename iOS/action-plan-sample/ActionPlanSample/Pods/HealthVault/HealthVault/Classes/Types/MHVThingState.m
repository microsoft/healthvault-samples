//
// MHVThingState.m
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
#import "MHVThingState.h"

NSString *const c_thingstate_active = @"Active";
NSString *const c_thingstate_deleted = @"Deleted";

NSString *MHVThingStateToString(MHVThingState state)
{
    NSString *value = nil;

    if (state & MHVThingStateActive)
    {
        return c_thingstate_active;
    }

    if (state & MHVThingStateDeleted)
    {
        return c_thingstate_deleted;
    }

    return value;
}

MHVThingState MHVThingStateFromString(NSString *value)
{
    if (!value || [value isEqualToString:@""])
    {
        return MHVThingStateNone;
    }

    if ([value isEqualToString:c_thingstate_active])
    {
        return MHVThingStateActive;
    }

    if ([value isEqualToString:c_thingstate_deleted])
    {
        return MHVThingStateDeleted;
    }

    return MHVThingStateNone;
}

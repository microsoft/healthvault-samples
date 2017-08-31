//
// MHVThingSection.m
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
#import "MHVThingSection.h"

NSString *const c_thingsection_core = @"core";
NSString *const c_thingsection_audit = @"audits";
NSString *const c_thingsection_blob = @"blobpayload";
NSString *const c_thingsection_tags = @"tags";
NSString *const c_thingsection_permissions = @"effectivepermissions";
NSString *const c_thingsection_signatures = @"digitalsignatures";

NSString *MHVThingSectionToString(MHVThingSection section)
{
    switch (section)
    {
        case MHVThingSection_Core:
            return c_thingsection_core;

        case MHVThingSection_Audits:
            return c_thingsection_audit;

        case MHVThingSection_Blobs:
            return c_thingsection_blob;

        case MHVThingSection_Tags:
            return c_thingsection_tags;

        case MHVThingSection_Permissions:
            return c_thingsection_permissions;

        case MHVThingSection_Signatures:
            return c_thingsection_signatures;

        default:
            break;
    }

    return nil;
}

MHVThingSection MHVThingSectionFromString(NSString *value)
{
    if (!value || [value isEqualToString:@""])
    {
        return MHVThingSection_None;
    }

    MHVThingSection section = MHVThingSection_None;

    if ([value isEqualToString:c_thingsection_core])
    {
        section = MHVThingSection_Core;
    }
    else if ([value isEqualToString:c_thingsection_audit])
    {
        section = MHVThingSection_Audits;
    }
    else if ([value isEqualToString:c_thingsection_blob])
    {
        section = MHVThingSection_Blobs;
    }
    else if ([value isEqualToString:c_thingsection_tags])
    {
        section = MHVThingSection_Tags;
    }
    else if ([value isEqualToString:c_thingsection_permissions])
    {
        section = MHVThingSection_Permissions;
    }
    else if ([value isEqualToString:c_thingsection_signatures])
    {
        section = MHVThingSection_Signatures;
    }

    return section;
}

//
//  MHVPlatformConstants.h
//  MHVLib
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

#ifndef MHVPlatformConstants_h
#define MHVPlatformConstants_h

typedef NS_ENUM(NSUInteger, MHVServiceInfoSections)
{
    // No service info sections.
    MHVServiceInfoSectionsNone = 0,
    
    // Corresponds to ServiceInfo.HealthServiceUrl, ServiceInfo.Version, and ServiceInfo.ConfigurationValues.
    MHVServiceInfoSectionsPlatform = 0x1,
    
    // Corresponds to ServiceInfo.HealthServiceShellInfo.
    MHVServiceInfoSectionsShell = 0x2,
    
    // Corresponds to ServiceInfo.ServiceInstances and ServiceInfo.CurrentInstance.
    MHVServiceInfoSectionsTopology = 0x4,
    
    // Corresponds to ServiceInfo.Methods and ServiceInfo.IncludedSchemaUrls.
    MHVServiceInfoSectionsXmlOverHttpMethods = 0x8,
    
    // Not currently used.
    MHVServiceInfoSectionsMeaningfulUse = 0x10,
    
    // Retrieve all sections.
    MHVServiceInfoSectionsAll = MHVServiceInfoSectionsPlatform | MHVServiceInfoSectionsShell | MHVServiceInfoSectionsTopology | MHVServiceInfoSectionsXmlOverHttpMethods | MHVServiceInfoSectionsMeaningfulUse
};

#endif /* MHVPlatformConstants_h */

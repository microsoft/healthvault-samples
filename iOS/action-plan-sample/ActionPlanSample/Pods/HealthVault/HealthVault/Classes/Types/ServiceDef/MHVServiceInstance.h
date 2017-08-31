//
// MHVServiceInstance.h
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
//

#import "MHVType.h"

@interface MHVServiceInstance : MHVType

/**
 A string uniquely identifying the instance.
 */
@property (readwrite, nonatomic, strong) NSString *instanceID;

/**
 A friendly name for the instance.
 */
@property (readwrite, nonatomic, strong) NSString *name;

/**
 A friendly description of the instance.
 */
@property (readwrite, nonatomic, strong) NSString *instanceDescription;

/**
 A string representing a URL to the HealthVault service.
 */
@property (readwrite, nonatomic, strong) NSURL *healthServiceUrl;

/**
 A string representing a URL to the HealthVault Rest service.
 */
@property (readwrite, nonatomic, strong) NSURL *restServiceUrl;

/**
 A string representing the URL to access the HealthVault Shell.
 */
@property (readwrite, nonatomic, strong) NSURL *shellUrl;

@end


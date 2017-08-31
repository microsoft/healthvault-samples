//
//  MHVConfigurationConstants.h
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

#ifndef MHVConfigurationConstants_h
#define MHVConfigurationConstants_h

/*
 The default number of internal retries for 500 errors.
 */
static NSInteger const kDefaultRetryOnInternal500Count = 2;

/*
 Default URL for Shell application
 */
static NSString *const kDefaultShellUrlString = @"https://account.healthvault.com/";

/*
 Default URL for Rest API calls
 */
static NSString *const kDefaultRestUrlString = @"https://data.microsofthealth.net/";

/*
 Default version header for Rest API calls
 */
static NSString *const kDefaultRestVersion = @"1.0-preview2";

/*
 Default URL for HealthVault application
 */
static NSString *const kDefaultHealthVaultRootUrlString = @"https://platform.healthvault.com/platform/";

/*
 Default sleep duration in seconds.
 */
static NSTimeInterval const kDefaultRetryOnInternal500SleepDurationInSeconds = 1;

/*
 The default request time to live value.
 */
static NSTimeInterval const kDefaultRequestTimeToLiveDurationInSeconds = 60 * 30;

/*
 The default request time out value.
 */
static NSTimeInterval const kDefaultRequestTimeoutDurationInSeconds = 30;

/*
 The default blob upload chunk size.
 */
static NSInteger const kDefaultBlobChunkSizeInBytes = 1 << 21; // 2Mb.

#endif /* MHVConfigurationConstants_h */

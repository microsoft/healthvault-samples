//
//  MHVConfiguration.m
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

#import "MHVConfiguration.h"
#import "MHVConfigurationConstants.h"

@implementation MHVConfiguration

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        // Set default values
        self.defaultHealthVaultUrl = [[NSURL alloc] initWithString:kDefaultHealthVaultRootUrlString];
        self.defaultShellUrl = [[NSURL alloc] initWithString:kDefaultShellUrlString];
        self.restHealthVaultUrl = [[NSURL alloc] initWithString:kDefaultRestUrlString];
        self.restVersion = kDefaultRestVersion;
        self.requestTimeoutDuration = kDefaultRequestTimeoutDurationInSeconds;
        self.requestTimeToLiveDuration = kDefaultRequestTimeToLiveDurationInSeconds;
        self.retryOnInternal500Count = kDefaultRetryOnInternal500Count;
        self.retryOnInternal500SleepDuration = kDefaultRetryOnInternal500SleepDurationInSeconds;
        self.inlineBlobHashBlockSize = kDefaultBlobChunkSizeInBytes;
    }
    
    return self;
}

- (void)setDefaultHealthVaultUrl:(NSURL *)defaultHealthVaultUrl
{
    _defaultHealthVaultUrl = [self ensureTrailingSlashOnUrl:defaultHealthVaultUrl];
}

- (void)setDefaultShellUrl:(NSURL *)defaultShellUrl
{
    _defaultShellUrl = [self ensureTrailingSlashOnUrl:defaultShellUrl];
}

- (void)setRestHealthVaultUrl:(NSURL *)restHealthVaultUrl
{
    _restHealthVaultUrl = [self ensureTrailingSlashOnUrl:restHealthVaultUrl];
}

#pragma mark - Helpers

- (NSURL *)ensureTrailingSlashOnUrl:(NSURL *)url
{
    NSString *urlString = [url absoluteString];
    
    if ([urlString hasSuffix:@"/"])
    {
        return url;
    }
    
    return [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@", urlString, @"/"]];
}

@end

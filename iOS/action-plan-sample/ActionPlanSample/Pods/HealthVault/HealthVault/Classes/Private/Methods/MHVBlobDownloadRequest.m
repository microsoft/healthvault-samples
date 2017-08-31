//
// MHVBlobDownloadRequest.m
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

#import "MHVBlobDownloadRequest.h"
#import "MHVValidator.h"
#import "MHVLogger.h"

@implementation MHVBlobDownloadRequest

@synthesize cache = _cache;

- (instancetype)initWithURL:(NSURL *)url
                 toFilePath:(NSString *)toFilePath
{
    MHVASSERT_PARAMETER(url);
    MHVASSERT_PARAMETER(toFilePath);
    
    self = [super init];
    if (self)
    {
        _url = url;
        _toFilePath = toFilePath;
        _isAnonymous = YES;
    }
    return self;
}

- (NSString *)getCacheKey
{
    MHVLOG(@"getCacheKey not implemented for MHVBlobDownloadRequest");
    return @"";
}

@end

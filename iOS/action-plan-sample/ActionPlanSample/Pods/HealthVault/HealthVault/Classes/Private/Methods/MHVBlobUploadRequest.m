//
//  MHVBlobUploadRequest.m
//  MHVLib
//
//  Copyright (c) 2017 Microsoft Corporation. All rights reserved.
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

#import "MHVBlobUploadRequest.h"
#import "MHVValidator.h"
#import "MHVHttpServiceOperationProtocol.h"
#import "MHVConfigurationConstants.h"
#import "MHVLogger.h"

@interface MHVBlobUploadRequest ()

@property (nonatomic, assign) BOOL isAnonymous;

@end

@implementation MHVBlobUploadRequest

@synthesize cache = _cache;

- (instancetype)initWithBlobSource:(id<MHVBlobSourceProtocol>)blobSource
                    destinationURL:(NSURL *)destinationURL
                         chunkSize:(NSUInteger)chunkSize
{
    MHVASSERT_PARAMETER(blobSource);
    MHVASSERT_PARAMETER(destinationURL);
    
    self = [super init];
    if (self)
    {
        _blobSource = blobSource;
        _destinationURL = destinationURL;
        _chunkSize = chunkSize != 0 ? chunkSize : kDefaultBlobChunkSizeInBytes;
        _isAnonymous = YES;
    }
    return self;
}

- (NSString *)getCacheKey
{
    MHVLOG(@"getCacheKey not implemented for MHVBlobUploadRequest");
    return @"";
}

@end

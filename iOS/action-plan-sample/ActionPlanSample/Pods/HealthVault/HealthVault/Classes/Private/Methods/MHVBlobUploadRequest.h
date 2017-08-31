//
//  MHVBlobUploadRequest.h
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

#import "MHVBlobSource.h"
#import "MHVHttpServiceOperationProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MHVBlobUploadRequest : NSObject <MHVHttpServiceOperationProtocol>

/**
 Source for a blob upload
 */
@property (nonatomic, strong, readonly) id<MHVBlobSourceProtocol> blobSource;

/**
 Destination url for where to upload the blob
 */
@property (nonatomic, strong, readonly) NSURL *destinationURL;

/**
 Http chunk size for the blob upload
 */
@property (nonatomic, assign, readonly) NSUInteger chunkSize;

/**
 * Create blob upload request
 *
 * @param blobSource The source data for the blob to be uploaded (file or data in memory)
 * @param destinationURL URL where the blob is to be uploaded
 * @param chunkSize The size to use for Chunked uploads of the blob data.  
 *        If 0, kDefaultBlobChunkSizeInBytes will be used
 */
- (instancetype)initWithBlobSource:(id<MHVBlobSourceProtocol>)blobSource
                    destinationURL:(NSURL *)destinationURL
                         chunkSize:(NSUInteger)chunkSize;

@end

NS_ASSUME_NONNULL_END

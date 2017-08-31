//
// MHVBlobPutParameters.m
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

#import "MHVBlobPutParameters.h"

static NSString *const c_element_blockSize = @"block-size";
static NSString *const c_element_url = @"blob-ref-url";
static NSString *const c_element_chunkSize = @"blob-chunk-size";
static NSString *const c_element_maxSize = @"max-blob-size";
static NSString *const c_element_hashAlg = @"blob-hash-algorithm";
static NSString *const c_element_hashParams = @"blob-hash-parameters";

@implementation MHVBlobHashAlgorithmParameters

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_blockSize intValue:(int)self.blockSize];
}

- (void)deserialize:(XReader *)reader
{
    self.blockSize = [reader readIntElement:c_element_blockSize];
}

@end

@implementation MHVBlobPutParameters

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_url value:self.url];
    [writer writeElement:c_element_chunkSize intValue:(int)self.chunkSize];
    [writer writeElement:c_element_maxSize intValue:(int)self.maxSize];
    [writer writeElement:c_element_hashAlg value:self.hashAlgorithm];
    [writer writeElement:c_element_hashParams content:self.hashParams];
}

- (void)deserialize:(XReader *)reader
{
    self.url = [reader readStringElement:c_element_url];
    self.chunkSize = [reader readIntElement:c_element_chunkSize];
    self.maxSize = [reader readIntElement:c_element_maxSize];
    self.hashAlgorithm = [reader readStringElement:c_element_hashAlg];
    self.hashParams = [reader readElement:c_element_hashParams asClass:[MHVBlobHashAlgorithmParameters class]];
}

@end

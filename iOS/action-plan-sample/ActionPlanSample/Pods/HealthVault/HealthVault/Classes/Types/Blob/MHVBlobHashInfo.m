//
// MHVBlobHashInfo.m
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

#import "MHVBlobHashInfo.h"
#import "MHVValidator.h"

static NSString *const c_element_blockSize = @"block-size";
static NSString *const c_element_algorithm = @"algorithm";
static NSString *const c_element_params = @"params";
static NSString *const c_element_hash = @"hash";

@implementation MHVBlobHashAlgorithmParams

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN

    MHVVALIDATE_OPTIONAL(self.blockSize);

    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_blockSize content:self.blockSize];
}

- (void)deserialize:(XReader *)reader
{
    self.blockSize = [reader readElement:c_element_blockSize asClass:[MHVPositiveInt class]];
}

@end

@interface MHVBlobHashInfo ()

@property (nonatomic, strong) MHVStringZ255 *algorithmValue;
@property (nonatomic, strong) MHVStringNZ512 *hashValue;

@end

@implementation MHVBlobHashInfo

- (NSString *)algorithm
{
    return (self.algorithmValue) ? self.algorithmValue.value : nil;
}

- (void)setAlgorithm:(NSString *)algorithm
{
    if (!self.algorithmValue)
    {
        self.algorithmValue = [[MHVStringZ255 alloc] init];
    }
    
    self.algorithmValue.value = algorithm;
}

- (NSString *)hash
{
    return (self.hashValue) ? self.hashValue.value : nil;
}

- (void)setHash:(NSString *)hash
{
    if (!self.hashValue)
    {
        self.hashValue = [[MHVStringNZ512 alloc] init];
    }
    
    self.hashValue.value = hash;
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN

    MHVVALIDATE(self.algorithmValue, MHVClientError_InvalidBlobInfo);
    MHVVALIDATE_OPTIONAL(self.params);
    MHVVALIDATE(self.hashValue, MHVClientError_InvalidBlobInfo);

    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_algorithm content:self.algorithmValue];
    [writer writeElement:c_element_params content:self.params];
    [writer writeElement:c_element_hash content:self.hashValue];
}

- (void)deserialize:(XReader *)reader
{
    self.algorithmValue = [reader readElement:c_element_algorithm asClass:[MHVStringZ255 class]];
    self.params = [reader readElement:c_element_params asClass:[MHVBlobHashAlgorithmParams class]];
    self.hashValue = [reader readElement:c_element_hash asClass:[MHVStringNZ512 class]];
}

@end

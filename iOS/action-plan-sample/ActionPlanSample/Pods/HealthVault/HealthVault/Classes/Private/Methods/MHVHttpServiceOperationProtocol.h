//
//  MHVHttpServiceOperationProtocol.h
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

#import <Foundation/Foundation.h>

@protocol MHVHttpServiceOperationProtocol <NSObject>

/**
 A Boolean representing whether the operation call requires authentication
 */
@property (nonatomic, assign, readonly) BOOL isAnonymous;

/**
 Cache associated with the operation. If not null, when performing the operation
 the cache will first be checked. If a result is found in the cache, the cached
 data is returned, otherwise a network call is made and the result is added to the
 cache
 */
@property (nonatomic, readwrite) NSCache *cache;

/**
 Returns the unique key or hash which should be used to store an operation in a cache.
 */
-(NSString *) getCacheKey;

@end

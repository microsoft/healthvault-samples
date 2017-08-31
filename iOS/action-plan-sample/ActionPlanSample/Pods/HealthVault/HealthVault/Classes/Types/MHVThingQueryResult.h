//
// MHVThingQueryResult.h
// healthvault-ios-sdk
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

#import "MHVType.h"
@class MHVThing;

@interface MHVThingQueryResult : MHVType

/**
 A unique string to identify a given result. When using an query collection, a unique name can be assigned to each query and the corresponding result will have the same name. If the name property on the MHVThingQuery is not set a GUID will be assigned to the name property.
 */
@property (nonatomic, strong, readonly) NSString *name;

/**
 A collection of Things resulting from a given query.
 */
@property (nonatomic, strong, readonly) NSArray<MHVThing *> *things;

/**
 The total number of Things resulting from a given query (this INCLUDES the Things in the 'things' collection). The HealthVault iOS SDK will return a maximum of 240 Things for any given request. The 'count' property can be used to determine if there are more Things that can be fetched for a given query so data can be paged. For example, if an MHVThingQuery would result in 400 Things, the maximum of 240 things would be provided in the 'things' collection, and the 'total' property would be set to 400. A subsequest query can be made to fetch the remaining Things by setting the MHVThingQuery 'offset' property to 240 and the 'limit' property to 160.
 */
@property (nonatomic, assign, readonly) NSInteger count;

/**
 Indicates whether the query result is from the cache.
 */
@property (nonatomic, assign, readonly) BOOL isCachedResult;

- (instancetype)initWithName:(NSString *)name
                      things:(NSArray<MHVThing *> *)things
                       count:(NSInteger)count
              isCachedResult:(BOOL)isCachedResult;

@end


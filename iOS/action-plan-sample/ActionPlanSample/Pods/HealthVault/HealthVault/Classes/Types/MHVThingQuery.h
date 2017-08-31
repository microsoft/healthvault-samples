//
// MHVThingQuery.h
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

#import <Foundation/Foundation.h>
#import "MHVType.h"
#import "MHVInt.h"
#import "MHVThingKey.h"
#import "MHVThingFilter.h"
#import "MHVThingView.h"

@interface MHVThingQuery : MHVType


/**
 The name of the query (Optional);
 @note The name propery can be used to retrieve a query from a query collection, or identify data for a particualr query in the response.
 */
@property (readwrite, nonatomic, strong) NSString *name;

/**
 A collection of Thing Ids for items to be fetched (Optional).
 @note thingIDs, keys, and clientIDs collections are mutually exclusive - A single query can only contain thingIDs OR keys OR clientIDs.
 */
@property (readwrite, nonatomic, strong) NSArray<NSString *> *thingIDs;

/**
 A collection of Thing keys for items to be fetched (Optional). A Thing key is an object containing the Thing Id and Version for a given item - See MHVThingKey.
 @note thingIDs, keys, and clientIDs collections are mutually exclusive - A single query can only contain thingIDs OR keys OR clientIDs.
 */
@property (readwrite, nonatomic, strong) NSArray<MHVThingKey *> *keys;

/**
  A collection of Client Ids keys for items to be fetched (Optional).
 @note thingIDs, keys, and clientIDs collections are mutually exclusive - A single query can only contain thingIDs OR keys OR clientIDs.
 */
@property (readwrite, nonatomic, strong) NSArray<NSString *> *clientIDs;

/**
 A collection of Thing Filters that will be applied to the request (Optional).
 @note Filters are logically ANDed together within the collection. For example, if you add two filters, with the first filter having the type identifier for weight things and the other filter having the type identifier for height, you would get no results because there are no things that are of both types. However, if you specified one of the filters having the type identifier for weight and the other with a created date minimum, then you’d get all weight things that were created after the specified date.
 */
@property (readwrite, nonatomic, strong) NSArray<MHVThingFilter *> *filters;

/**
 Sets the content and format of the thing data retrieved (Optional).
 */
@property (readwrite, nonatomic, strong) MHVThingView *view;


/**
 Sets the maximum number of things that will be retrieved for a given request (Optional). The maximum value is 500 items per request. If not explicitly set by the caller, or set to more than 500 the property is set to 240.
*/
@property (readwrite, nonatomic) NSUInteger limit;

/**
 Specifies an offset at which Things will begin being returned (Optional). Effectively, the request skips the specified number of matching Things. For example, given a fetch that typically returns a, b, c, d, specifying an offset of 1 will return b, c, d, and an offset of 4 will return an empty array. The default value is 0;
 */
@property (readwrite, nonatomic) NSUInteger offset;

/**
 Flag to indicate if the query should used the Thing cache for results. The default value is YES.
 */
@property (readwrite, nonatomic) BOOL shouldUseCachedResults;

/**
 Initializes a new query and adds the given Thing Filter to the filters collection.

 @param filter The MHVThingFilter to be applied to the request.
 @return A new instance of MHVThingQuery.
 */
- (instancetype)initWithFilter:(MHVThingFilter *)filter;

/**
 Initializes a new query with the given Thing filter collection.
 
 @param filters The collection of MHVThingFilters to be applied to the request.
 @return A new instance of MHVThingQuery.
 */
- (instancetype)initWithFilters:(NSArray<MHVThingFilter *> *)filters;

/**
 Initializes a new query and adds the given Thing Key to the keys collection.

 @param key The MHVThingKey for the item to be fetched.
 @return A new instance of MHVThingQuery.
 */
- (instancetype)initWithThingKey:(MHVThingKey *)key;

/**
 Initializes a new query with the given Thing Keys collection.

 @param keys The collection of MHVThingKeys for the items to be fetched.
 @return A new instance of MHVThingQuery.
 */
- (instancetype)initWithThingKeys:(NSArray<MHVThingKey *> *)keys;

/**
 Initializes a new query and adds the given Thing Id to the keys collection.

 @param thingID The unique identifier for the Thing to be fetched.
 @return A new instance of MHVThingQuery.
 */
- (instancetype)initWithThingID:(NSString *)thingID;

/**
 Initializes a new query with the given Thing Id collection.

 @param ids The collection of unique identifiers for Things to be fetched.
 @return A new instance of MHVThingQuery.
 */
- (instancetype)initWithThingIDs:(NSArray<NSString *> *)ids;

@end


//
// MHVThingClient.m
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

#import "MHVThingClient.h"
#import "MHVValidator.h"
#import "MHVStringExtensions.h"
#import "MHVMethod.h"
#import "MHVRestRequest.h"
#import "MHVBlobDownloadRequest.h"
#import "MHVBlobUploadRequest.h"
#import "MHVBlobPutParameters.h"
#import "MHVServiceResponse.h"
#import "MHVTypes.h"
#import "NSError+MHVError.h"
#import "MHVErrorConstants.h"
#import "MHVConnectionProtocol.h"
#import "MHVPersonalImage.h"
#import "MHVLogger.h"
#import "MHVThingQueryResults.h"
#import "MHVThingQueryResult.h"
#import "MHVThingQueryResultInternal.h"
#import "MHVAsyncTask.h"
#import "MHVPendingMethod.h"
#import "NSArray+MHVThing.h"
#import "NSArray+MHVThingQuery.h"
#import "NSArray+MHVThingQueryResultInternal.h"
#if THING_CACHE
#import "MHVThingCacheProtocol.h"
#endif

@interface MHVThingClient ()

@property (nonatomic, weak) id<MHVConnectionProtocol> connection;
@property (nonatomic, strong) id<MHVThingCacheProtocol> cache;

@end

@implementation MHVThingClient

- (instancetype)initWithConnection:(id<MHVConnectionProtocol>)connection
                             cache:(id<MHVThingCacheProtocol> _Nullable)cache
{
    MHVASSERT_PARAMETER(connection);
    
    self = [super init];
    if (self)
    {
        _connection = connection;
        _cache = cache;
    }
    
    return self;
}

- (void)getThingWithThingId:(NSUUID *)thingId
                   recordId:(NSUUID *)recordId
                 completion:(void (^)(MHVThing *_Nullable thing, NSError *_Nullable error))completion
{
    MHVASSERT_PARAMETER(thingId);
    MHVASSERT_PARAMETER(recordId);
    MHVASSERT_PARAMETER(completion);
    
    if (!completion)
    {
        return;
    }
    
    if (!thingId || !recordId)
    {
        completion(nil, [NSError MVHRequiredParameterIsNil]);
        return;
    }
    
    MHVThingQuery *query = [[MHVThingQuery alloc] initWithThingID:[thingId UUIDString]];
    query.limit = 1;
    
    [self getThingsWithQuery:query
                    recordId:recordId
                  completion:^(MHVThingQueryResult *_Nullable result, NSError *_Nullable error)
     {
         if (error)
         {
             completion(nil, error);
         }
         else
         {
             completion(result.things.firstObject, nil);
         }
     }];
}

- (void)getThingsWithQuery:(MHVThingQuery *)query
                  recordId:(NSUUID *)recordId
                completion:(void(^)(MHVThingQueryResult *_Nullable result, NSError *_Nullable error))completion
{
    MHVASSERT_PARAMETER(query);
    MHVASSERT_PARAMETER(recordId);
    MHVASSERT_PARAMETER(completion);
    
    if (!completion)
    {
        return;
    }
    
    if (!query || !recordId)
    {
        completion(nil, [NSError MVHRequiredParameterIsNil]);
        return;
    }
    
    [self getThingsWithQueries:@[query]
                      recordId:recordId
                    completion:^(NSArray<MHVThingQueryResult *> *_Nullable results, NSError *_Nullable error)
     {
         if (error)
         {
             completion(nil, error);
         }
         else
         {
             completion(results.firstObject, nil);
         }
     }];
}

- (void)getThingsWithQueries:(NSArray<MHVThingQuery *> *)queries
                    recordId:(NSUUID *)recordId
                  completion:(void (^)(NSArray<MHVThingQueryResult *> *_Nullable results, NSError *_Nullable error))completion
{
    MHVASSERT_PARAMETER(queries);
    MHVASSERT_PARAMETER(recordId);
    MHVASSERT_PARAMETER(completion);
    
    if (!completion)
    {
        return;
    }
    
    if (!queries || !recordId)
    {
        completion(nil, [NSError MVHRequiredParameterIsNil]);
        return;
    }
    
    __block NSMutableArray<MHVThingQuery *> *queriesForCloud = [NSMutableArray new];
    NSMutableArray<MHVThingQuery *> *queriesForCache = [NSMutableArray new];
    
    //Give each query a unique name if it isn't already set
    for (MHVThingQuery *query in queries)
    {
        if ([NSString isNilOrEmpty:query.name])
        {
            query.name = [[NSUUID UUID] UUIDString];
        }
        
        if (query.shouldUseCachedResults)
        {
            [queriesForCache addObject:query];
        }
        else
        {
            [queriesForCloud addObject:query];
        }
    }
    
#if THING_CACHE
    // Check for cached results for the GetThings queries
    if (self.cache && queriesForCache > 0)
    {
        [self.cache cachedResultsForQueries:queriesForCache
                                   recordId:recordId
                                 completion:^(NSArray<MHVThingQueryResult *> * _Nullable resultCollection, NSError *_Nullable error)
         {
             // If error is because cache not ready or deleted, send request to HealthVault
             if (error && error.code != MHVErrorTypeCacheNotReady && error.code != MHVErrorTypeCacheDeleted)
             {
                 completion(nil, error);
             }
             else if (resultCollection && queriesForCloud.count < 1)
             {
                 completion(resultCollection, nil);
             }
             else
             {
                 // If there is no resultsCollection from the cache issue ALL queries to the cloud.
                 if (!resultCollection)
                 {
                     queriesForCloud = [queries mutableCopy];
                 }
                 
                 //No resultCollection or error, query HealthVault
                 [self getThingsWithQueries:queriesForCloud recordId:recordId currentResults:nil completion:^(NSArray<MHVThingQueryResult *> * _Nullable results, NSError * _Nullable error)
                 {
                     if (error)
                     {
                         completion(nil, error);
                     }
                     else
                     {
                         if (resultCollection.count > 0)
                         {
                             results = [results arrayByAddingObjectsFromArray:resultCollection];
                            
                             // Sort the results collection based on the original order of the query collection
                             results = [results sortedArrayUsingComparator:^NSComparisonResult(MHVThingQueryResult *result1, MHVThingQueryResult *result2)
                                        {
                                            return [@([queries indexOfQueryWithName:result1.name]) compare:@([queries indexOfQueryWithName:result2.name])];
                                        }];
                         }
                         
                         completion(results, nil);
                     }
                 }];
             }
         }];
    }
    else
    {
        [self getThingsWithQueries:queries recordId:recordId currentResults:nil completion:completion];
    }
    
#else
    // No caching
    [self getThingsWithQueries:queries recordId:recordId currentResults:nil completion:completion];
#endif
}

// Internal method that will fetch more pending items if not all results are returned for the query.
- (void)getThingsWithQueries:(NSArray<MHVThingQuery *> *)queries
                    recordId:(NSUUID *)recordId
              currentResults:(NSArray<MHVThingQueryResultInternal *> *_Nullable)currentResults
                  completion:(void(^)(NSArray<MHVThingQueryResult *> *_Nullable results, NSError *_Nullable error))completion
{
    __block NSArray<MHVThingQuery *> *initialQueries = queries;
    __block NSArray<MHVThingQueryResultInternal *> *results = currentResults;
    
    MHVMethod *method = [MHVMethod getThings];
    method.recordId = recordId;
    method.parameters = [self bodyForQueryCollection:queries];
    
    [self.connection executeHttpServiceOperation:method
                                      completion:^(MHVServiceResponse *_Nullable response, NSError *_Nullable error)
     {
         if (error)
         {
             completion(nil, error);
         }
         else
         {
             MHVThingQueryResults *queryResults = [self thingQueryResultsFromResponse:response];
             if (!queryResults)
             {
                 completion(nil, [NSError error:[NSError MHVUnknownError] withDescription:@"MHVThingQueryResults could not be extracted from the server response."]);
                 return;
             }
             
             NSMutableArray<MHVThingQuery *> *queriesForPendingThings = [NSMutableArray new];
             
             // Check for any Pending things, and build queries to fetch remaining things
             for (MHVThingQueryResultInternal *result in queryResults.results)
             {
                 MHVThingQuery *queryForResult = [initialQueries queryWithName:result.name];
                 
                 NSInteger pendingCount = queryForResult.limit - result.things.count;
                 
                 if (result.hasPendingThings && pendingCount > 0)
                 {
                     NSMutableArray *keys = [NSMutableArray new];
                     
                     for (NSInteger i = queryForResult.offset; i < result.pendingThings.count; i++)
                     {
                         MHVPendingThing *thing = result.pendingThings[i];
                         
                         [keys addObject:thing.key];
                         
                         if (keys.count == pendingCount)
                         {
                             break;
                         }
                     }
                     
                     if (keys.count > 0)
                     {
                         MHVThingQuery *query = [[MHVThingQuery alloc] initWithThingKeys:keys];
                         query.name = result.name;
                         [queriesForPendingThings addObject:query];
                     }
                 }
             }
             
             // Merge with existing results, creating results object if needed
             if (!results)
             {
                 results = @[];
             }
             results = [results mergeThingQueryResultArray:queryResults.results];
             
             // If there are queries to get more pending items, repeat; otherwise can call completion
             if (queriesForPendingThings.count > 0)
             {
                 [self getThingsWithQueries:queriesForPendingThings
                                   recordId:recordId
                             currentResults:results
                                 completion:completion];
                 return;
             }
             else
             {
                 
                 NSMutableArray<MHVThingQueryResult *> *resultCollection = [NSMutableArray new];
                 
                 for (MHVThingQueryResultInternal *result in results)
                 {
                     MHVThingQueryResult *externalResult = [[MHVThingQueryResult alloc] initWithName:result.name
                                                                                              things:result.things
                                                                                               count:result.thingCount + result.pendingCount
                                                                                      isCachedResult:result.isCachedResult];
                     [resultCollection addObject:externalResult];
                 }
                 
                 
                 completion(resultCollection, nil);
             }
         }
     }];
}

- (void)getThingsForThingClass:(Class)thingClass
                         query:(MHVThingQuery *_Nullable)query
                      recordId:(NSUUID *)recordId
                    completion:(void (^)(MHVThingQueryResult *_Nullable result, NSError *_Nullable error))completion
{
    MHVASSERT_PARAMETER(thingClass);
    MHVASSERT_PARAMETER(recordId);
    MHVASSERT_PARAMETER(completion);
    
    if (!completion)
    {
        return;
    }
    
    if (!thingClass || !recordId)
    {
        completion(nil, [NSError MVHRequiredParameterIsNil]);
        return;
    }
    
    MHVThingFilter *filter = [[MHVThingFilter alloc] initWithTypeClass:thingClass];
    if (!filter)
    {
        completion(nil, [NSError MVHInvalidParameter:[NSString stringWithFormat:@"%@ not found in HealthVault thing types", NSStringFromClass(thingClass)]]);
        return;
    }
    
    // Add filter to query argument, or create if argument is nil
    if (query)
    {
        query.filters = [query.filters arrayByAddingObject:filter];
    }
    else
    {
        query = [[MHVThingQuery alloc] initWithFilter:filter];
    }
    
    [self getThingsWithQuery:query recordId:recordId completion:completion];
}

#pragma mark - Create Things

- (void)createNewThing:(MHVThing *)thing
              recordId:(NSUUID *)recordId
            completion:(void(^_Nullable)(MHVThingKey *_Nullable thingKey, NSError *_Nullable error))completion
{
    MHVASSERT_PARAMETER(thing);
    MHVASSERT_PARAMETER(recordId);
    
    if (!thing || !recordId)
    {
        if (completion)
        {
            completion(nil, [NSError MVHRequiredParameterIsNil]);
        }
        
        return;
    }
    
    [self createNewThings:@[thing]
                 recordId:recordId
               completion:^(NSArray<MHVThingKey *> * _Nullable thingKeys, NSError * _Nullable error)
    {
        completion([thingKeys firstObject], error);
    }];
}

- (void)createNewThings:(NSArray<MHVThing *> *)things
               recordId:(NSUUID *)recordId
             completion:(void(^_Nullable)(NSArray<MHVThingKey *> *_Nullable thingKeys, NSError *_Nullable error))completion
{
    MHVASSERT_PARAMETER(things);
    MHVASSERT_PARAMETER(recordId);
    
    if (!things || !recordId)
    {
        if (completion)
        {
            completion(nil, [NSError MVHRequiredParameterIsNil]);
        }
        
        return;
    }
    
    for (MHVThing *thing in things)
    {
        [thing prepareForNew];

        //Check if thing is valid
        if (![self isValidObject:thing])
        {
            if (completion)
            {
                completion(nil, [NSError MVHInvalidParameter:[NSString stringWithFormat:@"Thing is not valid, code %li", (long)[thing validate].error]]);
            }
            
            return;
        }
    }
    
    MHVMethod *method = [MHVMethod putThings];
    method.recordId = recordId;
    method.parameters = [self bodyForThingCollection:things];
    
    [self.connection executeHttpServiceOperation:method
                                      completion:^(MHVServiceResponse *_Nullable response, NSError *_Nullable error)
     {
         NSArray<MHVThingKey *> *keys = [self thingKeyResultsFromResponse:response];
         
#if THING_CACHE
         
         // If the connection is offline cache the pending request.
         if ([self isOfflineError:error] && self.cache)
         {
             [self.cache cacheMethod:method
                              things:things
                          completion:^(NSArray<MHVThingKey *> *_Nullable keys, NSError *_Nullable cacheError)
              {
                  if (cacheError)
                  {
                      if (completion)
                      {
                          completion(nil, error);
                      }
                  }
                  else
                  {
                      if (completion)
                      {
                          completion(keys, nil);
                      }
                  }
              }];
             
             return;
         }
         else if (keys.count == things.count)
         {
             // Set Key on the added things
             for (NSInteger i = 0; i < things.count; i++)
             {
                 things[i].key = keys[i];
             }
             
             if (!error && self.cache)
             {
                 [self.cache addThings:things
                              recordId:recordId
                            completion:^(NSError * _Nullable error)
                  {
                      if (completion)
                      {
                          completion(keys, error);
                      }
                  }];
                 return;
             }
         }
         else
         {
             MHVASSERT_MESSAGE(@"Mismatch between added Thing count and Thing Keys");
         }
#endif
         if (completion)
         {
             completion(keys, error);
         }
     }];
}

#pragma mark - Update Things

- (void)updateThing:(MHVThing *)thing
           recordId:(NSUUID *)recordId
         completion:(void(^_Nullable)(MHVThingKey *_Nullable thingKey, NSError *_Nullable error))completion
{
    MHVASSERT_PARAMETER(thing);
    MHVASSERT_PARAMETER(recordId);
    
    if (!thing || !recordId)
    {
        if (completion)
        {
            completion(nil, [NSError MVHRequiredParameterIsNil]);
        }
        
        return;
    }
    
    [self updateThings:@[thing]
              recordId:recordId
            completion:^(NSArray<MHVThingKey *> * _Nullable thingKeys, NSError * _Nullable error)
    {
        if (completion)
        {
            completion(thingKeys ? thingKeys.firstObject : nil, error);
        }
    }];
}

- (void)updateThings:(NSArray<MHVThing *> *)things
            recordId:(NSUUID *)recordId
          completion:(void(^_Nullable)(NSArray<MHVThingKey *> *_Nullable thingKeys, NSError *_Nullable error))completion
{
    MHVASSERT_PARAMETER(things);
    MHVASSERT_PARAMETER(recordId);
    
    if (!things || !recordId)
    {
        if (completion)
        {
            completion(nil, [NSError MVHRequiredParameterIsNil]);
        }
        
        return;
    }
    
    for (MHVThing *thing in things)
    {
        [thing prepareForUpdate];

        //Check if thing is valid
        if (![self isValidObject:thing])
        {
            if (completion)
            {
                completion(nil, [NSError MVHInvalidParameter:[NSString stringWithFormat:@"Thing is not valid, code %li", (long)[thing validate].error]]);
            }
            
            return;
        }
    }
    
    MHVMethod *method = [MHVMethod putThings];
    method.recordId = recordId;
    method.parameters = [self bodyForThingCollection:things];
    
    [self.connection executeHttpServiceOperation:method
                                      completion:^(MHVServiceResponse *_Nullable response, NSError *_Nullable error)
     {
         NSArray<MHVThingKey *> *keys = [self thingKeyResultsFromResponse:response];
         
#if THING_CACHE
         // If the connection is offline cache the pending request.
         if ([self isOfflineError:error] && self.cache)
         {
             [self.cache cacheMethod:method
                              things:things
                          completion:^(NSArray<MHVThingKey *> *_Nullable keys, NSError *_Nullable cacheError)
              {
                  if (cacheError)
                  {
                      if (completion)
                      {
                          completion(nil, error);
                      }
                  }
                  else
                  {
                      if (completion)
                      {
                          completion(keys, nil);
                      }
                  }
              }];
             
             return;
         }
         else if (keys.count == things.count)
         {
             // Set Key on the updated things to update in cache
             for (NSInteger i = 0; i < things.count; i++)
             {
                 things[i].key = keys[i];
             }
             
             if (!error && self.cache)
             {
                 [self.cache updateThings:things
                                 recordId:recordId
                               completion:^(NSError * _Nullable error)
                  {
                      if (completion)
                      {
                          completion(keys, error);
                      }
                  }];
                 return;
             }
         }
         else
         {
             MHVASSERT_MESSAGE(@"Mismatch between updated Thing count and Thing Keys");
         }
#endif
         if (completion)
         {
             completion(keys, error);
         }
     }];
}

#pragma mark - Remove Things

- (void)removeThing:(MHVThing *)thing
           recordId:(NSUUID *)recordId
         completion:(void(^_Nullable)(NSError *_Nullable error))completion
{
    MHVASSERT_PARAMETER(thing);
    MHVASSERT_PARAMETER(recordId);
    
    if (!thing || !recordId)
    {
        if (completion)
        {
            completion([NSError MVHRequiredParameterIsNil]);
        }
        
        return;
    }
    
    [self removeThings:@[thing]
              recordId:recordId
            completion:completion];
}

- (void)removeThings:(NSArray<MHVThing *> *)things
            recordId:(NSUUID *)recordId
          completion:(void(^_Nullable)(NSError *_Nullable error))completion
{
    MHVASSERT_PARAMETER(things);
    MHVASSERT_PARAMETER(recordId);
    
    if (!things || !recordId)
    {
        if (completion)
        {
            completion([NSError MVHRequiredParameterIsNil]);
        }
        
        return;
    }
    
    MHVMethod *method = [MHVMethod removeThings];
    method.recordId = recordId;
    method.parameters = [self bodyForThingIdsFromThingCollection:things];
    
    [self.connection executeHttpServiceOperation:method
                                      completion:^(MHVServiceResponse *_Nullable response, NSError *_Nullable error)
     {
#if THING_CACHE
         // If the connection is offline cache the pending request.
         if ([self isOfflineError:error] && self.cache)
         {
             [self.cache cacheMethod:method
                              things:things
                          completion:^(NSArray<MHVThingKey *> *_Nullable keys, NSError * _Nullable cacheError)
             {
                 if (cacheError)
                 {
                     if (completion)
                     {
                         completion(error);
                     }
                 }
                 else
                 {
                     if (completion)
                     {
                         completion(nil);
                     }
                 }
             }];
             
             return;
         }
         else if (!error && self.cache)
         {
             [self.cache deleteThings:things
                             recordId:recordId
                           completion:^(NSError * _Nullable error)
              {
                  if (completion)
                  {
                      completion(error);
                  }
              }];
             return;
         }
#endif
         if (completion)
         {
             completion(error);
         }
     }];
}

#pragma mark - Blobs: URL Refresh

- (void)refreshBlobUrlsForThing:(MHVThing *)thing
                       recordId:(NSUUID *)recordId
                     completion:(void (^)(MHVThing *_Nullable thing, NSError *_Nullable error))completion
{
    MHVASSERT_PARAMETER(thing);
    MHVASSERT_PARAMETER(recordId);
    MHVASSERT_PARAMETER(completion);
    
    if (!completion)
    {
        return;
    }
    
    if (!thing || !recordId)
    {
        if (completion)
        {
            completion(nil, [NSError MVHRequiredParameterIsNil]);
        }
        
        return;
    }
    
    [self refreshBlobUrlsForThings:@[thing]
                          recordId:recordId
                        completion:^(NSArray<MHVThing *> *_Nullable resultThings, NSError *_Nullable error)
     {
         if (error)
         {
             completion(nil, error);
         }
         else
         {
             // Update the blobs on original thing & return that to the completion
             thing.blobs = resultThings.firstObject.blobs;
             
             completion(thing, nil);
         }
     }];
}

- (void)refreshBlobUrlsForThings:(NSArray<MHVThing *> *)things
                        recordId:(NSUUID *)recordId
                      completion:(void (^)(NSArray<MHVThing *> *_Nullable things, NSError *_Nullable error))completion
{
    MHVASSERT_PARAMETER(things);
    MHVASSERT_PARAMETER(recordId);
    MHVASSERT_PARAMETER(completion);
    
    if (!completion)
    {
        return;
    }
    
    if (!things || !recordId)
    {
        if (completion)
        {
            completion(nil, [NSError MVHRequiredParameterIsNil]);
        }
        
        return;
    }
    
    MHVThingQuery *query = [[MHVThingQuery alloc] initWithThingIDs:[things arrayOfThingIds]];
    query.view.sections = MHVThingSection_Standard | MHVThingSection_Blobs;
    
    [self getThingsWithQuery:query
                    recordId:recordId
                  completion:^(MHVThingQueryResult *_Nullable result, NSError *_Nullable error)
     {
         // Update the blobs on original thing collection & return that to the completion
         for (MHVThing *thing in result.things)
         {
             NSUInteger index = [things indexOfThingID:thing.thingID];
             if (index != NSNotFound)
             {
                 things[index].blobs = thing.blobs;
             }
         }
         
         if (completion)
         {
             completion(things, error);
         }
     }];
}

#pragma mark - Blobs: Download

- (void)downloadBlobData:(MHVBlobPayloadThing *)blobPayloadThing
              completion:(void (^)(NSData *_Nullable data, NSError *_Nullable error))completion
{
    MHVASSERT_PARAMETER(blobPayloadThing);
    MHVASSERT_PARAMETER(completion);
    
    if (!completion)
    {
        return;
    }
    
    if (!blobPayloadThing)
    {
        completion(nil, [NSError MVHRequiredParameterIsNil]);
        return;
    }
    
    // If blob has inline base64 encoded data, can return it immediately
    if (blobPayloadThing.inlineData)
    {
        completion(blobPayloadThing.inlineData, nil);
        return;
    }
    
    MHVBlobDownloadRequest *request = [[MHVBlobDownloadRequest alloc] initWithURL:[NSURL URLWithString:blobPayloadThing.blobUrl]
                                                                       toFilePath:nil];
    
    // Download from the URL
    [self.connection executeHttpServiceOperation:request
                                      completion:^(MHVServiceResponse *_Nullable response, NSError *_Nullable error)
     {
         if (error)
         {
             completion(nil, error);
         }
         else
         {
             completion(response.responseData, nil);
         }
     }];
}

- (void)downloadBlob:(MHVBlobPayloadThing *)blobPayloadThing
          toFilePath:(NSString *)filePath
          completion:(void (^)(NSError *_Nullable error))completion
{
    MHVASSERT_PARAMETER(blobPayloadThing);
    MHVASSERT_PARAMETER(filePath);
    MHVASSERT_PARAMETER(completion);
    
    if (!completion)
    {
        return;
    }
    
    if (!blobPayloadThing || !filePath)
    {
        completion([NSError MVHRequiredParameterIsNil]);
        return;
    }
    
    // If blob has inline base64 encoded data, can write to the desired file and return immediately
    if (blobPayloadThing.inlineData)
    {
        if ([blobPayloadThing.inlineData writeToFile:filePath atomically:YES])
        {
            completion(nil);
        }
        else
        {
            completion([NSError error:[NSError MHVIOError]
                      withDescription:@"Blob data could not be written to the file path"]);
        }
        return;
    }
    
    MHVBlobDownloadRequest *request = [[MHVBlobDownloadRequest alloc] initWithURL:[NSURL URLWithString:blobPayloadThing.blobUrl]
                                                                       toFilePath:filePath];
    
    // Download from the URL
    [self.connection executeHttpServiceOperation:request
                                      completion:^(MHVServiceResponse *_Nullable response, NSError *_Nullable error)
     {
         completion(error);
     }];
}

- (void)getPersonalImageWithRecordId:(NSUUID *)recordId
                          completion:(void (^)(UIImage *_Nullable image, NSError *_Nullable error))completion
{
    if (!completion)
    {
        return;
    }
    
    // Get the personalImage thing, including the blob section
    MHVThingFilter *filter = [[MHVThingFilter alloc] initWithTypeID:MHVPersonalImage.typeID];
    MHVThingQuery *query = [[MHVThingQuery alloc] initWithFilter:filter];
    query.view.sections = MHVThingSection_Blobs;
    
    [self getThingsWithQuery:query
                    recordId:recordId
                  completion:^(MHVThingQueryResult *_Nullable result, NSError *_Nullable error)
     {
         // Get the defaultBlob from the first thing in the result collection; can be nil if no image has been set
         MHVThing *thing = [result.things firstObject];
         if (!thing)
         {
             completion(nil, nil);
             return;
         }
         
         MHVBlobPayloadThing *blob = [thing.blobs getDefaultBlob];
         if (!blob)
         {
             completion(nil, nil);
             return;
         }
         
         [self downloadBlobData:blob
                     completion:^(NSData *_Nullable data, NSError *_Nullable error)
          {
              if (error || !data)
              {
                  completion(nil, error);
              }
              else
              {
                  UIImage *personImage = [UIImage imageWithData:data];
                  if (personImage)
                  {
                      completion(personImage, nil);
                  }
                  else
                  {
                      completion(nil, [NSError error:[NSError MHVUnknownError]
                                     withDescription:@"Blob data could not be converted to UIImage"]);
                  }
              }
          }];
     }];
}

- (void)setPersonalImage:(NSData *)imageData
             contentType:(NSString *)contentType
                recordId:(NSUUID *)recordId
              completion:(void (^_Nullable)(NSError *_Nullable error))completion
{
    MHVASSERT_PARAMETER(imageData);
    MHVASSERT_PARAMETER(contentType);
    MHVASSERT_PARAMETER(recordId);
    
    if (!imageData || !contentType || !recordId)
    {
        if (completion)
        {
            completion([NSError MVHRequiredParameterIsNil]);
        }
        return;
    }
    
    if (![contentType isEqualToString:@"image/jpg"] &&
        ![contentType isEqualToString:@"image/jpeg"] &&
        ![contentType isEqualToString:@"image/png"] &&
        ![contentType isEqualToString:@"image/gif"])
    {
        if (completion)
        {
            completion([NSError error:[NSError MVHInvalidParameter]
                      withDescription:@"Personal image must be a standard image content-type"]);
        }
        return;
    }

    // Get the personalImage thing, including the blob section
    MHVThingFilter *filter = [[MHVThingFilter alloc] initWithTypeID:MHVPersonalImage.typeID];
    MHVThingQuery *query = [[MHVThingQuery alloc] initWithFilter:filter];
    query.view.sections = MHVThingSection_Blobs;
    
    [self getThingsWithQuery:query
                    recordId:recordId
                  completion:^(MHVThingQueryResult *_Nullable result, NSError *_Nullable error)
     {
         // Get the first thing in the result collection; can be nil if no personal image has been set
         MHVThing *thing = [result.things firstObject];
         if (!thing)
         {
             MHVLOG(@"No current personal image");
             thing = [MHVPersonalImage newThing];
         }
         
         MHVBlobMemorySource *memorySource = [[MHVBlobMemorySource alloc] initWithData:imageData];
         
         [self addBlobSource:memorySource
                     toThing:thing
                        name:@""
                 contentType:contentType
                    recordId:recordId
                  completion:^(MHVThing * _Nullable thing, NSError * _Nullable error)
         {
             if (completion)
             {
                 completion(error);
             }
         }];
     }];
}

- (void)addBlobSource:(id<MHVBlobSourceProtocol>)blobSource
              toThing:(MHVThing *)toThing
                 name:(NSString *_Nullable)name
          contentType:(NSString *)contentType
             recordId:(NSUUID *)recordId
           completion:(void(^)(MHVThing *_Nullable thing, NSError *_Nullable error))completion
{
    // Use empty string for name if not specified
    if (!name)
    {
        name = @"";
    }
    
    MHVASSERT_PARAMETER(blobSource);
    MHVASSERT_PARAMETER(toThing);
    MHVASSERT_PARAMETER(contentType);
    MHVASSERT_PARAMETER(recordId);
    MHVASSERT_PARAMETER(completion);
    
    if (!completion)
    {
        return;
    }
    
    if (!blobSource || !toThing || !contentType || !recordId)
    {
        completion(nil, [NSError MVHRequiredParameterIsNil]);
        return;
    }

    // 1. Get the location where to upload a new blob
    MHVMethod *putMethod = [MHVMethod beginPutBlob];
    putMethod.recordId = recordId;
    
    [self.connection executeHttpServiceOperation:putMethod
                                      completion:^(MHVServiceResponse * _Nullable response, NSError * _Nullable error)
    {
        if (error)
        {
            completion(nil, error);
            return;
        }
        
        MHVBlobPutParameters *putParams = [self blobPutParametersResultsFromResponse:response];

        if (!putParams.url)
        {
            completion(nil, [NSError error:[NSError MHVUnknownError] withDescription:@"Blob upload parameters did not have a URL"]);
            return;
        }
        
        if (blobSource.length > putParams.maxSize)
        {
            completion(nil, [NSError error:[NSError MHVIOError] withDescription:@"Blob size is to large to save to HealthVault"]);
            return;
        }

        // 2. Upload the blob to the URL retrieved
        MHVBlobUploadRequest *uploadRequest = [[MHVBlobUploadRequest alloc] initWithBlobSource:blobSource
                                                                                destinationURL:[NSURL URLWithString:putParams.url]
                                                                                     chunkSize:putParams.chunkSize];
        
        [self.connection executeHttpServiceOperation:uploadRequest
                                          completion:^(MHVServiceResponse * _Nullable response, NSError * _Nullable error)
         {
             if (error)
             {
                 completion(nil, error);
                 return;
             }
             
             // 3. Commit and save the blob by attaching it to the Thing
             MHVBlobPayloadThing *blob = [[MHVBlobPayloadThing alloc] initWithBlobName:name
                                                                           contentType:contentType
                                                                                length:blobSource.length
                                                                                andUrl:putParams.url];
             [toThing.blobs addOrUpdateBlob:blob];
             
             [self updateThing:toThing
                      recordId:recordId
                    completion:^(MHVThingKey *_Nullable thingKey, NSError * _Nullable error)
             {
                 if (!error && thingKey)
                 {
                     toThing.key = thingKey;
                 }
                 
                 completion(error == nil ? toThing : nil, error);
             }];
         }];
    }];
}

- (void)getRecordOperations:(NSUInteger)sequenceNumber
                   recordId:(NSUUID *)recordId
                 completion:(void (^)(MHVGetRecordOperationsResult *_Nullable result, NSError *_Nullable error))completion
{
    MHVASSERT_PARAMETER(recordId);
    MHVASSERT_PARAMETER(completion);
    
    if (!completion || !recordId)
    {
        completion(nil, [NSError MVHRequiredParameterIsNil]);
        return;
    }

    MHVMethod *method = [MHVMethod getRecordOperations];
    method.recordId = recordId;
    method.parameters = [NSString stringWithFormat:@"<info><record-operation-sequence-number>%li</record-operation-sequence-number></info>", (unsigned long)sequenceNumber];
    
    [self.connection executeHttpServiceOperation:method
                                      completion:^(MHVServiceResponse * _Nullable response, NSError * _Nullable error)
     {
         if (error)
         {
             completion(nil, error);
             return;
         }
         
         XReader *reader = [[XReader alloc] initFromString:response.infoXml];
         
         MHVGetRecordOperationsResult *result = (MHVGetRecordOperationsResult *)[NSObject newFromReader:reader
                                                                                               withRoot:@"info"
                                                                                                asClass:[MHVGetRecordOperationsResult class]];
         completion(result, nil);
     }];
}

#pragma mark - Internal methods

- (MHVThingQueryResults *)thingQueryResultsFromResponse:(MHVServiceResponse *)response
{
    XReader *reader = [[XReader alloc] initFromString:response.infoXml];
    
    return (MHVThingQueryResults *)[NSObject newFromReader:reader
                                                  withRoot:@"info"
                                                   asClass:[MHVThingQueryResults class]];
}

- (NSArray<MHVThingKey *> *)thingKeyResultsFromResponse:(MHVServiceResponse *)response
{
    return (NSArray *)[NSObject newFromString:response.infoXml
                                     withRoot:@"info"
                               andElementName:@"thing-id"
                                      asClass:[MHVThingKey class]
                                andArrayClass:[NSMutableArray class]];
}

- (MHVBlobPutParameters *)blobPutParametersResultsFromResponse:(MHVServiceResponse *)response
{
    XReader *reader = [[XReader alloc] initFromString:response.infoXml];
    return (MHVBlobPutParameters *)[NSObject newFromReader:reader
                                                  withRoot:@"info"
                                                   asClass:[MHVBlobPutParameters class]];
}

- (NSString *)bodyForQueryCollection:(NSArray<MHVThingQuery *> *)queries
{
    XWriter *writer = [[XWriter alloc] initWithBufferSize:2048];
    
    [writer writeStartElement:@"info"];
    
    for (MHVThingQuery *query in queries)
    {
        if ([self isValidObject:query])
        {
            [XSerializer serialize:query withRoot:@"group" toWriter:writer];
        }
    }
    
    [writer writeEndElement];
    
    return [writer newXmlString];
}

- (NSString *)bodyForThingCollection:(NSArray<MHVThing *> *)things
{
    XWriter *writer = [[XWriter alloc] initWithBufferSize:2048];
    
    [writer writeStartElement:@"info"];
    {
        for (MHVThing *thing in things)
        {
            if ([self isValidObject:thing])
            {
                [XSerializer serialize:thing withRoot:@"thing" toWriter:writer];
            }
        }
    }
    [writer writeEndElement];
    
    return [writer newXmlString];
}

- (NSString *)bodyForThingIdsFromThingCollection:(NSArray<MHVThing *> *)things
{
    XWriter *writer = [[XWriter alloc] initWithBufferSize:2048];
    
    [writer writeStartElement:@"info"];
    {
        for (MHVThing *thing in things)
        {
            if ([self isValidObject:thing.key])
            {
                [XSerializer serialize:thing.key withRoot:@"thing-id" toWriter:writer];
            }
        }
    }
    [writer writeEndElement];
    
    return [writer newXmlString];
}

- (BOOL)isValidObject:(id)obj
{
    if ([obj respondsToSelector:@selector(validate)])
    {
        MHVClientResult *validationResult = [obj validate];
        if (validationResult.isError)
        {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)isOfflineError:(NSError *)error
{    
    return [error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorNotConnectedToInternet;
}

@end

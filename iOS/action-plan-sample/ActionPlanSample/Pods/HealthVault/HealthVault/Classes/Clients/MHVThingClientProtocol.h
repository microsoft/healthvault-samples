//
//  MHVThingClientProtocol.h
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

#import <UIKit/UIKit.h>
#import "MHVClientProtocol.h"

@class MHVThing, MHVThingQuery, MHVThing, MHVThingQueryResult, MHVBlobPayloadThing, MHVGetRecordOperationsResult, MHVThingKey;

@protocol MHVThingCacheProtocol, MHVBlobSourceProtocol;

NS_ASSUME_NONNULL_BEGIN

@protocol MHVThingClientProtocol <NSObject>

/**
 * Gets the an individual thing by its ID
 *
 * @param thingId Identifier of the thing to be retrieved.
 * @param recordId an authorized person's record ID.
 * @param completion Envoked when the operation completes.
 *        MHVThing object will have the requested thing, or nil if the thing can not be retrieved.
 *        NSError object will be nil if there is no error when performing the operation.
 */
- (void)getThingWithThingId:(NSUUID *)thingId
                   recordId:(NSUUID *)recordId
                 completion:(void(^)(MHVThing *_Nullable thing, NSError *_Nullable error))completion;

/**
 * Get a collection of things
 *
 * @param query A thing query to perform
 * @param recordId an authorized person's record ID.
 * @param completion Envoked when the operation completes.
 *        MHVThingQueryResult object will have the requested things, or nil if no things were retrieved.
 *        NSError object will be nil if there is no error when performing the operation.
 */
- (void)getThingsWithQuery:(MHVThingQuery *)query
                  recordId:(NSUUID *)recordId
                completion:(void(^)(MHVThingQueryResult *_Nullable result, NSError *_Nullable error))completion;

/**
 * Get several collections of things
 *
 * @param queries A collection of thing queries to perform
 * @param recordId an authorized person's record ID.
 * @param completion Envoked when the operation completes.
 *        NSArray<MHVThingQueryResult *> object will have a collection of the requested query results, or nil if no results retrieved.
 *        NSError object will be nil if there is no error when performing the operation.
 */
- (void)getThingsWithQueries:(NSArray<MHVThingQuery *> *)queries
                    recordId:(NSUUID *)recordId
                  completion:(void(^)(NSArray<MHVThingQueryResult *> *_Nullable results, NSError *_Nullable error))completion;

/**
 * Get a collection of things of a particular class, optionally associated with a query
 * IE, get all things of MHVBloodPressure class,
 *
 * @param thingClass The thing class to retrieve
 * @param query A query to use with this request; for example to add a filter to get all thingClass objects after a date
 * @param recordId an authorized person's record ID.
 * @param completion Envoked when the operation completes.
 *        MHVThingQueryResult object will have the requested things, or nil if no things were retrieved.
 *        NSError object will be nil if there is no error when performing the operation.
 */
- (void)getThingsForThingClass:(Class )thingClass
                         query:(MHVThingQuery *_Nullable)query
                      recordId:(NSUUID *)recordId
                    completion:(void(^)(MHVThingQueryResult *_Nullable result, NSError *_Nullable error))completion;

/**
 * Store a new Thing in the HealthVault service
 *
 * @param thing The thing to be added
 * @param recordId an authorized person's record ID.
 * @param completion Envoked when the operation completes.
 *        MHVThingKey thingKey A Thing Key for the Thing that was created or nil if there was an error.
 *        NSError object will be nil if there is no error when performing the operation.
 */
- (void)createNewThing:(MHVThing *)thing
              recordId:(NSUUID *)recordId
            completion:(void(^_Nullable)(MHVThingKey *_Nullable thingKey, NSError *_Nullable error))completion;

/**
 * Store several new Things in the HealthVault service
 *
 * @param things Collection of things to be added
 * @param recordId an authorized person's record ID.
 * @param completion Envoked when the operation completes.
 *        NSArray<MHVThingKey *> thingKeys A collection of Thing Keys for Things that were created or nil if there was an error.
 *        NSError object will be nil if there is no error when performing the operation.
 */
- (void)createNewThings:(NSArray<MHVThing *> *)things
               recordId:(NSUUID *)recordId
             completion:(void(^_Nullable)(NSArray<MHVThingKey *> *_Nullable thingKeys, NSError *_Nullable error))completion;

/**
 * Update an existing Thing in the HealthVault service
 *
 * @param thing The thing to be updated
 * @param recordId an authorized person's record ID.
 * @param completion Envoked when the operation completes.
 *        MHVThingKey thingKey A new Thing Key (including updated version) for the Thing that was updated or nil if there was an error.
 *        NSError object will be nil if there is no error when performing the operation.
 */
- (void)updateThing:(MHVThing *)thing
           recordId:(NSUUID *)recordId
         completion:(void(^_Nullable)(MHVThingKey *_Nullable thingKey, NSError *_Nullable error))completion;

/**
 * Update a collection of existing Things in the HealthVault service
 *
 * @param things Collection of things to be updated
 * @param recordId an authorized person's record ID.
 * @param completion Envoked when the operation completes.
 *        NSArray<MHVThingKey *> thingKeys A collection of Thing Keys (including updated versions) for Things that were updated or nil if there was an error.
 *        NSError object will be nil if there is no error when performing the operation.
 */
- (void)updateThings:(NSArray<MHVThing *> *)things
            recordId:(NSUUID *)recordId
          completion:(void(^_Nullable)(NSArray<MHVThingKey *> *_Nullable thingKeys, NSError *_Nullable error))completion;

/**
 * Remove an existing Thing from the HealthVault service
 *
 * @param thing The thing to be removed
 * @param recordId an authorized person's record ID.
 * @param completion Envoked when the operation completes.
 *        NSError object will be nil if there is no error when performing the operation.
 */
- (void)removeThing:(MHVThing *)thing
           recordId:(NSUUID *)recordId
         completion:(void(^_Nullable)(NSError *_Nullable error))completion;

/**
 * Remove a collection of existing Things from the HealthVault service
 *
 * @param things Collection of things to be removed
 * @param recordId an authorized person's record ID.
 * @param completion Envoked when the operation completes.
 *        NSError object will be nil if there is no error when performing the operation.
 */
- (void)removeThings:(NSArray<MHVThing *> *)things
            recordId:(NSUUID *)recordId
          completion:(void(^_Nullable)(NSError *_Nullable error))completion;

/**
 * Refresh the blobs collection on a thing.
 *
 * @note The URLs returned for blobs are valid for a limited time
 *
 * @param thing The thing to refresh
 * @param recordId an authorized person's record ID.
 * @param completion Envoked when the operation completes.
 *        MHVThing object that is updated with its .blobs object refreshed
 *        NSError object will be nil if there is no error when performing the operation.
 */
- (void)refreshBlobUrlsForThing:(MHVThing *)thing
                       recordId:(NSUUID *)recordId
                     completion:(void(^)(MHVThing *_Nullable thing, NSError *_Nullable error))completion;

/**
 * Refresh the blobs collection for a collection of things.
 *
 * @note The URLs returned for blobs are valid for a limited time
 *
 * @param things The things to refresh
 * @param recordId an authorized person's record ID.
 * @param completion Envoked when the operation completes.
 *        NSArray<MHVThing *> things updated with their .blobs objects refreshed
 *        NSError object will be nil if there is no error when performing the operation.
 */
- (void)refreshBlobUrlsForThings:(NSArray<MHVThing *> *)things
                        recordId:(NSUUID *)recordId
                      completion:(void(^)(NSArray<MHVThing *> *_Nullable things, NSError *_Nullable error))completion;

/**
 * Download a blob as NSData
 *
 * @param blobPayloadThing The blob to be downloaded
 * @param completion Envoked when the operation completes.
 *        NSData the data for the blob if successful
 *        NSError object will be nil if there is no error when performing the operation.
 */
- (void)downloadBlobData:(MHVBlobPayloadThing *)blobPayloadThing
              completion:(void(^)(NSData *_Nullable data, NSError *_Nullable error))completion;

/**
 * Download a blob and save it to a file
 *
 * @param blobPayloadThing The blob to be downloaded
 * @param toFilePath The location where the blob file should be saved
 * @param completion Envoked when the operation completes.
 *        NSError object will be nil if there is no error when performing the operation.
 */
- (void)downloadBlob:(MHVBlobPayloadThing *)blobPayloadThing
          toFilePath:(NSString *)toFilePath
          completion:(void(^)(NSError *_Nullable error))completion;

/**
 * Gets the personal image for a record
 *
 * @param recordId The record ID to retrieve the personal image
 * @param completion Envoked when the operation completes.
 *        UIImage image for the person if successful.
 *        NSError object will be nil if there is no error when performing the operation.
 *        Both values can be nil if no personal image is set.
 */
- (void)getPersonalImageWithRecordId:(NSUUID *)recordId
                          completion:(void(^)(UIImage *_Nullable image, NSError *_Nullable error))completion;

/**
 * Sets the personal image for a record
 *
 * @param imageData NSData for the image
 * @param contentType Http content type, such as @"image/jpg" @"image/png"
 * @param recordId The record ID to set the personal image
 * @param completion Envoked when the operation completes.
 *        NSError object will be nil if there is no error when performing the operation.
 */
- (void)setPersonalImage:(NSData *)imageData
             contentType:(NSString *)contentType
                recordId:(NSUUID *)recordId
              completion:(void (^_Nullable)(NSError *_Nullable error))completion;

/**
 * Add a blob to a Thing
 *
 * @param blobSource The blob source data to be added to the thing
 * @param toThing The thing to add the blob
 * @param name The name of the blob
 *        If an existing blob on the thing has the same name, it will be updated to the new blobSource
 * @param contentType The http Content-Type, such as "image/jpeg"
 *        This will be set on as the Content-Type header when downloading from a blob URL
 * @param recordId an authorized person's record ID.
 * @param completion Envoked when the operation completes.
 *        MHVThing object with the blob added if successful
 *        NSError object will be nil if there is no error when performing the operation.
 */
- (void)addBlobSource:(id<MHVBlobSourceProtocol>)blobSource
              toThing:(MHVThing *)toThing
                 name:(NSString *_Nullable)name
          contentType:(NSString *)contentType
             recordId:(NSUUID *)recordId
           completion:(void(^)(MHVThing *_Nullable thing, NSError *_Nullable error))completion;

/**
 * Get the record operations that have happened since a sequence number
 *
 * @param sequenceNumber Retrieve all record operations that have happened after this sequence number.
 *        1 for the number will retrieve all operations since the account was created
 * @param recordId an authorized person's record ID.
 * @param completion Envoked when the operation completes.
 *        MHVGetRecordOperationsResult with all the operations and the latest sequence number
 *        NSError object will be nil if there is no error when performing the operation.
 */
 - (void)getRecordOperations:(NSUInteger)sequenceNumber
                   recordId:(NSUUID *)recordId
                 completion:(void (^)(MHVGetRecordOperationsResult *_Nullable result, NSError *_Nullable error))completion;

@end

NS_ASSUME_NONNULL_END


//
// MHVVocabularyClientProtocol.h
// HVLib
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

#import "MHVClientProtocol.h"
#import "MHVVocabularyKey.h"
#import "MHVVocabularyCodeItem.h"
#import "MHVVocabularySearchString.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * The protocol for HealthVault vocabulary clients
 */
@protocol MHVVocabularyClientProtocol <MHVClientProtocol>

/**
 * Retrieves a collection of key information for identifying and describing the vocabularies in the system.
 *
 * @param completion A completion block. On success will give an NSArray<MHVVocabularyKey *>. On error will give the error info.
 */
- (void)getVocabularyKeysWithCompletion:(void(^)(NSArray<MHVVocabularyKey *> *_Nullable vocabularyKeys, NSError *_Nullable error))completion;


/**
 * Retrieves lists of vocabulary things for the specified vocabulary in the user's current culture.
 *
 * @param key The key for the vocabulary to fetch.
 * @param cultureIsFixed Healthvault looks for the vocabulary things for the culture info specified by the system. If this parameter is set to NO or is not specified and if things are not found for the specified culture then things for the default fallback culture will be returned. If this parameter is set to YES then fallback will not occur.
 * @param completion A completion block. On success will give the matching MHVVocabularyCodeItem. On error will give the error info.
 */
- (void)getVocabularyWithKey:(MHVVocabularyKey *)key
              cultureIsFixed:(BOOL)cultureIsFixed
                  completion:(void(^)(MHVVocabularyCodeSet *_Nullable vocabulary, NSError *_Nullable error))completion;

/**
 * Retrieves lists of vocabulary things for the specified vocabulary in the user's current culture.
 *
 * @param key The key for the vocabulary to fetch.
 * @param cultureIsFixed Healthvault looks for the vocabulary things for the culture info specified by the system. If this parameter is set to NO or is not specified and if things are not found for the specified culture then things for the default fallback culture will be returned. If this parameter is set to YES then fallback will not occur.
 * @param ensureTruncatedValues When vocabularies have a large number of CodeItems, their data may be truncated when returned from HealthVault. By setting this value to YES, the client will automatically gather and return all CodeItems for a vocabulary. This may result in multiple requests to HealthVault. If set to NO, the client will make one request and the values may be truncated if they exceed to limit on the server.
 * @param completion A completion block. On success will give the matching MHVVocabularyCodeItem. On error will give the error info.
 */
- (void)getVocabularyWithKey:(MHVVocabularyKey *)key
              cultureIsFixed:(BOOL)cultureIsFixed
       ensureTruncatedValues:(BOOL)ensureTruncatedValues
                  completion:(void(^)(MHVVocabularyCodeSet *_Nullable vocabulary, NSError *_Nullable error))completion;

/**
 * Retrieves lists of vocabulary things for the specified vocabularies in the user's current culture.
 *
 * @param vocabularyKeys An array of VocabularyKeys identifying the requested vocabularies.
 * @param cultureIsFixed Healthvault looks for the vocabulary things for the culture info specified by the system. If this parameter is set to NO or is not specified and if things are not found for the specified culture then things for the default fallback culture will be returned. If this parameter is set to YES then fallback will not occur.
 * @param completion A completion block. On success will give one of the specified vocabularies and its things, or empty strings. On error will give the error info.
 */
- (void)getVocabulariesWithVocabularyKeys:(NSArray<MHVVocabularyKey *> *)vocabularyKeys
                           cultureIsFixed:(BOOL)cultureIsFixed
                               completion:(void(^)(NSArray<MHVVocabularyCodeSet *> * _Nullable vocabularies, NSError *_Nullable error))completion;

/**
 * Retrieves lists of vocabulary things for the specified vocabularies in the user's current culture.
 *
 * @param vocabularyKeys An array of VocabularyKeys identifying the requested vocabularies.
 * @param cultureIsFixed Healthvault looks for the vocabulary things for the culture info specified by the system. If this parameter is set to NO or is not specified and if things are not found for the specified culture then things for the default fallback culture will be returned. If this parameter is set to YES then fallback will not occur.
 * @param ensureTruncatedValues When vocabularies have a large number of CodeItems, their data may be truncated when returned from HealthVault. By setting this value to YES, the client will automatically gather and return all CodeItems for a vocabulary. This may result in multiple requests to HealthVault. If set to NO, the client will make one request and the values may be truncated if they exceed to limit on the server.
 * @param completion A completion block. On success will give one of the specified vocabularies and its things, or empty strings. On error will give the error info.
 */
- (void)getVocabulariesWithVocabularyKeys:(NSArray<MHVVocabularyKey *> *)vocabularyKeys
                           cultureIsFixed:(BOOL)cultureIsFixed
                    ensureTruncatedValues:(BOOL)ensureTruncatedValues
                               completion:(void(^)(NSArray<MHVVocabularyCodeSet *> * _Nullable vocabularies, NSError *_Nullable error))completion;

/**
 * Searches all vocabulary keys and retrieves those matching the provided search parameters
 *
 * @param searchValue The search string to use.
 * @param searchMode The type of search to perform.
 * @param maxResults The maximum number of results to return. If null, all matching results are returned, up to a maximum number defined by the service config value with key maxResultsPerVocabularyRetrieval.
 * @param completion A completion block. On success will give a NSArray<MHVVocabularyKey *> populated with entries matching the search criteria. On error will give the error info.
 */
- (void)searchVocabularyKeysWithSearchValue:(NSString *)searchValue
                                 searchMode:(MHVSearchMode)searchMode
                                 maxResults:(NSNumber * _Nullable)maxResults
                                 completion:(void(^)(NSArray<MHVVocabularyKey *> * _Nullable vocabularyKeys, NSError * _Nullable error))completion;

/**
 * Searches a specific vocabulary and retrieves the matching vocabulary things.
 *
 * @param searchValue The search string to use.
 * @param searchMode The type of search mode to perform.
 * @param vocabularyKey The key to perform the search on.
 * @param maxResults The maximum number of results to return. If null, all matching results are returned, up to a maximum number defined by the service config value with key maxResultsPerVocabularyRetrieval.
 * @param completion A completion block. On success will give a NSArray<MHVVocabularyCodeSet *> populated with entries matching the search criteria. On error will give the error info.
 */
- (void)searchVocabularyWithSearchValue:(NSString *)searchValue
                             searchMode:(MHVSearchMode)searchMode
                          vocabularyKey:(MHVVocabularyKey *)vocabularyKey
                             maxResults:(NSNumber *_Nullable)maxResults
                             completion:(void(^)(NSArray<MHVVocabularyCodeSet *> *_Nullable codeSet, NSError *_Nullable error))completion;


/**
 * Enables or disables caching of vocabulary responses
 *
 * @param cacheEnabled If YES (default), caching will be enabled for all subsequent calls. If NO, caching will be disabled for all subsequent calls.
 */
- (void)setCacheEnabled:(BOOL)cacheEnabled;

/**
 * Clears any items currently in the vocabulary cache.
 */
- (void)clearCache;

@end

NS_ASSUME_NONNULL_END

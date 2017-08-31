//
//  MHVVocabularyClient.m
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

#import "MHVVocabularyClient.h"
#import "MHVValidator.h"
#import "MHVVocabularyCodeItem.h"
#import "MHVVocabularySearchParams.h"
#import "MHVMethod.h"
#import "MHVServiceResponse.h"
#import "NSError+MHVError.h"
#import "MHVConnectionProtocol.h"

@interface MHVVocabularyClient ()

@property (nonatomic, weak) id<MHVConnectionProtocol> connection;
@property (nonatomic, readwrite) BOOL cacheEnabled;

@end

@implementation MHVVocabularyClient

@synthesize correlationId = _correlationId;

- (instancetype)initWithConnection:(id<MHVConnectionProtocol>)connection
{
    MHVASSERT_PARAMETER(connection);
    
    self = [super init];
    if (self)
    {
        _connection = connection;
        _cache = [[NSCache alloc] init];
        _cacheEnabled = YES;
    }
    
    return self;
}

- (void)getVocabularyKeysWithCompletion:(void(^)(NSArray<MHVVocabularyKey *> *_Nullable vocabularyKeys, NSError *_Nullable error))completion
{
    MHVASSERT_PARAMETER(completion);
    
    if (!completion)
    {
        return;
    }
    
    MHVMethod *method = [MHVMethod getVocabulary];
    [self applyCachingIfEnabledForMethod:method];
    
    [self.connection executeHttpServiceOperation:method completion:^(MHVServiceResponse *_Nullable response, NSError  *_Nullable error)
    {
        if (error)
        {
            completion(nil, error);
            return;
        }
        
        NSArray<MHVVocabularyKey *> *vocabularyKeys = (NSArray *)[XSerializer newFromString:response.infoXml
                                                                                   withRoot:@"info"
                                                                             andElementName:@"vocabulary-key"
                                                                                    asClass:[MHVVocabularyKey class]
                                                                              andArrayClass:[NSMutableArray class]];
        
        if (!vocabularyKeys)
        {
            completion(nil, [NSError error:[NSError MHVUnknownError] withDescription:@"The Vocabulary Key response is invalid."]);
            return;
        }
        
        completion(vocabularyKeys, nil);
        return;
    }];
}

- (void)getVocabularyWithKey:(MHVVocabularyKey *)key
              cultureIsFixed:(BOOL)cultureIsFixed
                  completion:(void(^)(MHVVocabularyCodeSet *_Nullable vocabulary, NSError *_Nullable error))completion
{
    [self getVocabularyWithKey:key cultureIsFixed:cultureIsFixed ensureTruncatedValues:NO completion:completion];
}

- (void)getVocabularyWithKey:(MHVVocabularyKey *)key
              cultureIsFixed:(BOOL)cultureIsFixed
       ensureTruncatedValues:(BOOL)ensureTruncatedValues
                  completion:(void(^)(MHVVocabularyCodeSet *_Nullable vocabulary, NSError *_Nullable error))completion
{
    MHVASSERT_PARAMETER(key);
    MHVASSERT_PARAMETER(completion);
    
    if (!completion)
    {
        return;
    }
    
    if (!key)
    {
        completion(nil, [NSError error:[NSError MVHInvalidParameter] withDescription:@"key cannot be nil"]);
        return;
    }
    
    [self getVocabulariesWithVocabularyKeys:@[key]
                             cultureIsFixed:cultureIsFixed
                      ensureTruncatedValues:ensureTruncatedValues
                                 completion:^(NSArray<MHVVocabularyCodeSet *> * _Nullable vocabularies, NSError * _Nullable error)
    {
        if (error)
        {
            completion(nil, error);
            return;
        }
        
        if (!vocabularies)
        {
            completion(nil, [NSError error:[NSError MHVUnknownError] withDescription:@"The MHVVocabularyCodeSet response is invalid."]);
            return;
        }
        
        completion([vocabularies firstObject], nil);
        return;
    }];
    
    return;
}

- (void)getVocabulariesWithVocabularyKeys:(NSArray<MHVVocabularyKey *> *)vocabularyKeys
                           cultureIsFixed:(BOOL)cultureIsFixed
                               completion:(void(^)(NSArray<MHVVocabularyCodeSet *>* _Nullable vocabularies, NSError *_Nullable error))completion
{
    [self getVocabulariesWithVocabularyKeys:vocabularyKeys cultureIsFixed:cultureIsFixed ensureTruncatedValues:NO completion:completion];
}

- (void)getVocabulariesWithVocabularyKeys:(NSArray<MHVVocabularyKey *> *)vocabularyKeys
                           cultureIsFixed:(BOOL)cultureIsFixed
                    ensureTruncatedValues:(BOOL)ensureTruncatedValues
                               completion:(void(^)(NSArray<MHVVocabularyCodeSet *>* _Nullable vocabularies, NSError *_Nullable error))completion
{
    MHVASSERT_PARAMETER(vocabularyKeys);
    MHVASSERT_PARAMETER(completion);
    
    if (!completion)
    {
        return;
    }
    
    if (!vocabularyKeys)
    {
        completion(nil, [NSError error:[NSError MVHInvalidParameter] withDescription:@"vocabularyKeys cannot be nil"]);
        return;
    }
    
    [self getVocabulariesWithKeys:vocabularyKeys
                   cultureIsFixed:cultureIsFixed
            ensureTruncatedValues:ensureTruncatedValues
                       completion:^(NSArray<MHVVocabularyCodeSet *> * _Nullable vocabularies, NSError * _Nullable error)
    {
        if (error)
        {
            completion(nil, error);
            return;
        }
        
        if (!vocabularyKeys)
        {
            completion(nil, [NSError error:[NSError MHVUnknownError] withDescription:@"Error occurred while getting vocabularies"]);
            return;
        }
        
        completion(vocabularies, nil);
    }];
}

- (void)searchVocabularyKeysWithSearchValue:(NSString *)searchValue
                                 searchMode:(MHVSearchMode)searchMode
                                 maxResults:(NSNumber * _Nullable)maxResults
                                 completion:(void(^)(NSArray<MHVVocabularyKey *> * _Nullable vocabularyKeys, NSError * _Nullable))completion
{
    MHVASSERT_PARAMETER(searchValue);
    MHVASSERT_PARAMETER(searchMode);
    MHVASSERT_PARAMETER(completion);
    
    if (!completion)
    {
        return;
    }
    
    if (!searchValue)
    {
        completion(nil, [NSError error:[NSError MVHInvalidParameter] withDescription:@"searchValue cannot be nil"]);
        return;
    }
    
    if (!searchMode)
    {
        completion(nil, [NSError error:[NSError MVHInvalidParameter] withDescription:@"searchMode cannot be nil"]);
        return;
    }
    
    MHVMethod *method = [self getVocabularySearchMethodWithSearchValue:searchValue andSearchMode:searchMode andMaxResults:maxResults andVocabularyKey:nil];
    [self applyCachingIfEnabledForMethod:method];
    
    [self.connection executeHttpServiceOperation:method completion:^(MHVServiceResponse * _Nullable response, NSError * _Nullable error)
     {
         if (error)
         {
             completion(nil, error);
             return;
         }
         
         NSArray<MHVVocabularyKey *> *vocabularyKeys = (NSArray *)[XSerializer newFromString:response.infoXml
                                                                                    withRoot:@"info"
                                                                              andElementName:@"vocabulary-key"
                                                                                     asClass:[MHVVocabularyKey class]
                                                                               andArrayClass:[NSMutableArray class]];
         
         completion(vocabularyKeys, nil);
         return;
     }];
}

- (void)searchVocabularyWithSearchValue:(NSString *)searchValue
                             searchMode:(MHVSearchMode)searchMode
                          vocabularyKey:(MHVVocabularyKey *)vocabularyKey
                             maxResults:(NSNumber *_Nullable)maxResults
                             completion:(void(^)(NSArray<MHVVocabularyCodeSet *> *_Nullable vocabularyKeys, NSError *_Nullable error))completion
{
    MHVASSERT_PARAMETER(searchValue);
    MHVASSERT_PARAMETER(searchMode);
    MHVASSERT_PARAMETER(vocabularyKey);
    MHVASSERT_PARAMETER(completion);
    
    if (!completion)
    {
        return;
    }
    
    if (!searchValue)
    {
        completion(nil, [NSError error:[NSError MVHInvalidParameter] withDescription:@"searcValue cannot be nil"]);
        return;
    }
    
    if (!searchMode)
    {
        completion(nil, [NSError error:[NSError MVHInvalidParameter] withDescription:@"searchMode cannot be nil"]);
        return;
    }
    
    if (!vocabularyKey)
    {
        completion(nil, [NSError error:[NSError MVHInvalidParameter] withDescription:@"vocabularyKey cannot be nil"]);
        return;
    }
    
    MHVMethod * method = [self getVocabularySearchMethodWithSearchValue:searchValue andSearchMode:searchMode andMaxResults:maxResults andVocabularyKey:vocabularyKey];
    [self applyCachingIfEnabledForMethod:method];
    
    [self.connection executeHttpServiceOperation:method completion:^(MHVServiceResponse * _Nullable response, NSError * _Nullable error)
     {
         if (error)
         {
             completion(nil, error);
             return;
         }
         
         NSArray<MHVVocabularyCodeSet *> *vocabularyCodeSet = (NSArray *)[XSerializer newFromString:response.infoXml
                                                                                           withRoot:@"info"
                                                                                     andElementName:@"code-set-result"
                                                                                            asClass:[MHVVocabularyCodeSet class]
                                                                                      andArrayClass:[NSMutableArray class]];
         
         completion(vocabularyCodeSet, nil);
         return;
     }];
}

- (void)setCacheEnabled:(BOOL)cacheEnabled
{
    _cacheEnabled = cacheEnabled;
}

- (void)clearCache
{
    [self.cache removeAllObjects];
}

#pragma mark - Private
- (void)applyCachingIfEnabledForMethod:(MHVMethod *)method
{
    if (self.cacheEnabled)
    {
        method.cache = self.cache;
    }
}
/**
 * Gets a NSArray<MHVVocabularyCodeSet *> with VocabularyCodeSets for each of the VocabularyKeys provided
 *
 * @param vocabularyKeys The keys to get the VocabularyCodeSets for
 * @param cultureIsFixed Is the culture fixed
 * @param ensureTruncatedValues If true the method will execute recursively until all VocabularyCodeSets are
          returned for each key. If false the method will execute once and if any of the VocabularyCodeSets is larger
          than the server configured max return count, any VocabularyCodeSets over the max will be omitted.
 * @param completion The completion called when the method execution is complete.
 */
- (void)getVocabulariesWithKeys:(NSArray<MHVVocabularyKey *> *)vocabularyKeys
                 cultureIsFixed:(BOOL)cultureIsFixed
          ensureTruncatedValues:(BOOL)ensureTruncatedValues
                     completion:(void(^)(NSArray<MHVVocabularyCodeSet *>* _Nullable vocabularies, NSError *_Nullable error))completion
{
    MHVMethod *method = [self getVocabularyGetMethodWithKeys:vocabularyKeys withCultureIsFixed:cultureIsFixed];
    [self applyCachingIfEnabledForMethod:method];
    
    // 1) Request all Vocabularies based on the provided VocabularyKeyCollection
    [self.connection executeHttpServiceOperation:method completion:^(MHVServiceResponse * _Nullable response, NSError * _Nullable error) {
        if (error)
        {
            completion(nil, error);
            return;
        }
        
        NSArray<MHVVocabularyCodeSet *> *vocabularies = (NSArray *)[XSerializer newFromString:response.infoXml
                                                                                     withRoot:@"info"
                                                                               andElementName:@"vocabulary"
                                                                                      asClass:[MHVVocabularyCodeSet class]
                                                                                andArrayClass:[NSMutableArray class]];
        
        // 2) If we are not interested in truncated values, return the current list as in (no recursion)
        if (!ensureTruncatedValues)
        {
            completion(vocabularies, nil);
            return;
        }
        
        // 3) If we are interested in resolving truncated properties then we start by filtering all remaining
        //    truncated vocabs into a new list
        NSMutableArray<MHVVocabularyKey *> *truncatedKeys = [NSMutableArray new];
        for (MHVVocabularyCodeSet *vocabulary in vocabularies)
        {
            if (vocabulary.isTruncated)
            {
                [truncatedKeys addObject:[[MHVVocabularyKey alloc]initFromVocabulary:vocabulary]];
            }
        }
        
        if ([truncatedKeys count] > 0)
        {
            // 4) If there are truncated vocabs remaining, we recursively call back into this method but this
            //    time we only include the keys which are still truncated
            [self getVocabulariesWithKeys:truncatedKeys
                           cultureIsFixed:cultureIsFixed
                    ensureTruncatedValues:ensureTruncatedValues
                               completion:^(NSArray<MHVVocabularyCodeSet *> * _Nullable truncatedVocabularies, NSError * _Nullable error)
            {
                
                if (error)
                {
                    // 5) If at any point we have an error, we notify the completion of the error. This will
                    //    propigate through all recursive instances of this function call, eventually calling
                    //    the completion of the original invocation
                    completion(nil, error);
                    return;
                }
                
                if (!truncatedVocabularies)
                {
                    // 6) If there is an issue parsing a response we generate and error and call through to the
                    //    completion. If this happens during a recursive call, the error will propigate back up
                    //    to the original invocation of the method
                    completion(nil, [NSError error:[NSError MHVUnknownError] withDescription:@"Error occurred while getting truncated vocabularies"]);
                    return;
                }
                
                // 7) Here we have to map and copy the newly received MHVVocabularyCodeSets to the existing
                //    NSArray<MHVVocabularyCodeSet *> so the consume gets a single uniform collection
                for (MHVVocabularyCodeSet *vocab in truncatedVocabularies)
                {
                    MHVVocabularyIdentifier *identifier = [vocab getVocabularyID];
                    
                    // TODO: Better way to do lookup and copy?
                    for (MHVVocabularyCodeSet *targetVocab in vocabularies)
                    {
                        if ([[targetVocab getVocabularyID] isEqual:identifier])
                        {
                            targetVocab.vocabularyCodeItems = [targetVocab.vocabularyCodeItems arrayByAddingObjectsFromArray:vocab.vocabularyCodeItems];
                            
                            // 8) It is important to constantly update the vocab in the main NSArray<MHVVocabularyCodeSet *>
                            // to note whether it is truncated or not. When we receive the final set of vocabs from the
                            // endpoint the vocab goes from a Truncated to Non-truncated state and we need to track this.
                            [targetVocab setIsTruncated:vocab.isTruncated];
                            break;
                        }
                    }
                }
                
                // 9) Complete with the current set of vocabularies to the previous caller (which may be a recursive call)
                completion(vocabularies, nil);
                return;
            }];
        }
        else
        {
            // 10) If there are no more truncated values, return the current list. This will start to unwind
            //     the recursion.
            completion(vocabularies, nil);
            return;
        }
    }];
}

- (MHVMethod *) getVocabularyGetMethodWithKeys:(NSArray<MHVVocabularyKey *> *)vocabularyKeys
                            withCultureIsFixed:(BOOL)cultureIsFixed
{
    XWriter *writer = [[XWriter alloc] initWithBufferSize:2048];
    [writer writeStartElement:@"info"];
    [writer writeStartElement:@"vocabulary-parameters"];
    
    for (MHVVocabularyKey *key in vocabularyKeys)
    {
        [writer writeStartElement:@"vocabulary-key"];
        [key serialize:writer];
        [writer writeEndElement];
    }
    
    [writer writeElement:@"fixed-culture" boolValue:cultureIsFixed];
    [writer writeEndElement];   // </vocabulary-parameters>
    [writer writeEndElement];   // </info>
    
    MHVMethod *method = [MHVMethod getVocabulary];
    method.parameters = [writer newXmlString];
    
    return method;
}

- (MHVMethod *) getVocabularySearchMethodWithSearchValue:(NSString *)searchValue
                                           andSearchMode:(MHVSearchMode)searchMode
                                           andMaxResults:(NSNumber * _Nullable)maxResults
                                        andVocabularyKey:(MHVVocabularyKey * _Nullable)vocabularyKey
{
    MHVVocabularySearchParams *searchParams = [[MHVVocabularySearchParams alloc] initWithText:searchValue];
    [searchParams.text setMatchType:searchMode];
    if (maxResults)
    {
        [searchParams setMaxResults:[maxResults integerValue]];
    }
    
    XWriter *writer = [[XWriter alloc] initWithBufferSize:2048];
    [writer writeStartElement:@"info"];
    
    if (vocabularyKey)
    {
        [writer writeStartElement:@"vocabulary-key"];
        [vocabularyKey serialize:writer];
        [writer writeEndElement];   // </vocabulary-key>
    }
    
    [writer writeStartElement:@"text-search-parameters"];
    [searchParams serialize:writer];
    [writer writeEndElement];   // </text-search-parameters>
    [writer writeEndElement];   // </info>
    
    MHVMethod *method = [MHVMethod searchVocabulary];
    method.parameters = [writer newXmlString];
    
    return method;
}

@end

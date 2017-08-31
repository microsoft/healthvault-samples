//
// NSArray+MHVVocabularyCodeItem.h
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

@class MHVVocabularyCodeItem;

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (MHVVocabularyCodeItem)

/**
 Returns vocabulary sorted by display text
 Should only be used with arrays with objects of type MHVVocabularyCodeItem
 
 @return NSArray sorted array
 */
- (NSArray<MHVVocabularyCodeItem *> *)sortedByDisplayText;

/**
 Returns vocabulary sorted by vocabulary code text
 Should only be used with arrays with objects of type MHVVocabularyCodeItem
 
 @return NSArray sorted array
 */
- (NSArray<MHVVocabularyCodeItem *> *)sortedByCode;

/**
 Returns index of the vocab code in the array
 Should only be used with arrays with objects of type MHVVocabularyCodeItem
 
 @return NSArray index of code or NSNotFound
 */
- (NSUInteger)indexOfVocabCode:(NSString *)code;

/**
 Returns MHVVocabularyCodeItem for a code
 Should only be used with arrays with objects of type MHVVocabularyCodeItem
 
 @return MHVVocabularyCodeItem the vocab code item or nil
 */
- (MHVVocabularyCodeItem *_Nullable)getThingWithCode:(NSString *)code;

/**
 Returns display text for a code
 Should only be used with arrays with objects of type MHVVocabularyCodeItem
 
 @return NSString the display text or nil
 */
- (NSString *_Nullable)displayTextForCode:(NSString *)code;

/**
 Returns all display strings
 Should only be used with arrays with objects of type MHVVocabularyCodeItem
 
 @return NSArray the array of display string values
 */
- (NSArray<NSString *> *)displayStrings;

@end

NS_ASSUME_NONNULL_END

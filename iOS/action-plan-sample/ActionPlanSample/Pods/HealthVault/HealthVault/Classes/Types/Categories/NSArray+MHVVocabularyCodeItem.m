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

#import "NSArray+MHVVocabularyCodeItem.h"
#import "MHVVocabularyCodeItem.h"

@implementation NSArray (MHVVocabularyCodeItem)

- (NSArray<MHVVocabularyCodeItem *> *)sortedByDisplayText
{
    return [self sortedArrayUsingComparator:^NSComparisonResult(MHVVocabularyCodeItem *codeItem1, MHVVocabularyCodeItem *codeItem2)
     {
         return [codeItem1.displayText compare:codeItem2.displayText];
     }];
}

- (NSArray<MHVVocabularyCodeItem *> *)sortedByCode
{
    return [self sortedArrayUsingComparator:^NSComparisonResult(MHVVocabularyCodeItem *codeItem1, MHVVocabularyCodeItem *codeItem2)
            {
                return [codeItem1.codeValue compare:codeItem2.codeValue];
            }];
}

- (NSUInteger)indexOfVocabCode:(NSString *)code
{
    for (NSUInteger i = 0; i < self.count; i++)
    {
        MHVVocabularyCodeItem *vocabCodeItem = [self objectAtIndex:i];
        if ([vocabCodeItem isKindOfClass:[MHVVocabularyCodeItem class]])
        {
            if ([vocabCodeItem.codeValue isEqualToString:code])
            {
                return i;
            }
        }
    }
    
    return NSNotFound;
}

- (MHVVocabularyCodeItem *)getThingWithCode:(NSString *)code
{
    NSUInteger index = [self indexOfVocabCode:code];
    
    if (index == NSNotFound)
    {
        return nil;
    }
    
    return [self objectAtIndex:index];
}

- (NSString *)displayTextForCode:(NSString *)code
{
    MHVVocabularyCodeItem *vocabThing = [self getThingWithCode:code];
    
    if (!vocabThing)
    {
        return nil;
    }
    
    return vocabThing.displayText;
}

- (NSArray *)displayStrings
{
    NSMutableArray *strings = [[NSMutableArray alloc] initWithCapacity:self.count];
    
    for (MHVVocabularyCodeItem *vocabCodeItem in self)
    {
        if ([vocabCodeItem isKindOfClass:[MHVVocabularyCodeItem class]])
        {
            [strings addObject:vocabCodeItem.displayText];
        }
    }
    return strings;
}

@end

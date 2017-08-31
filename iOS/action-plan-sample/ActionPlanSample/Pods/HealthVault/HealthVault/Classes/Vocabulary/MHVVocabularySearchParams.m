//
// MHVVocabularySearch.m
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

#import "MHVValidator.h"
#import "MHVVocabularySearchParams.h"

static NSString *const c_element_text = @"search-string";
static NSString *const c_element_max = @"max-results";

@implementation MHVVocabularySearchParams

- (instancetype)initWithText:(NSString *)text
{
    MHVCHECK_STRING(text);
    
    self = [super init];
    if (self)
    {
        _text = [[MHVVocabularySearchString alloc] initWith:text];
        MHVCHECK_NOTNULL(_text);
        
        _maxResults = 25;
    }
    return self;
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN

    MHVVALIDATE(self.text, MHVClientError_InvalidVocabSearch);

    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_text content:self.text];
    if (self.maxResults > 0)
    {
        [writer writeElement:c_element_max intValue:(int)self.maxResults];
    }
}

- (void)deserialize:(XReader *)reader
{
    self.text = [reader readElement:c_element_text asClass:[MHVVocabularySearchString class]];
    self.maxResults = [reader readIntElement:c_element_max];
}

@end

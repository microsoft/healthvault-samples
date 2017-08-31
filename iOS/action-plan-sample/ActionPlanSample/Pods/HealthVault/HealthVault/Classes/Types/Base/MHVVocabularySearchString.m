//
// MHVVocabularySearchString.m
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
#import "MHVVocabularySearchString.h"

NSString *MHVSearchModeToString(MHVSearchMode type)
{
    switch (type)
    {
        case MHVSearchModeFullText:
            return @"FullText";

        case MHVSearchModePrefix:
            return @"Prefix";

        case MHVSearchModeContains:
            return @"Contains";
            
        default:
            break;
    }

    return @"";
}

MHVSearchMode MHVSearchModeFromString(NSString *string)
{
    if ([string isEqualToString:@"FullText"])
    {
        return MHVSearchModeFullText;
    }

    if ([string isEqualToString:@"Prefix"])
    {
        return MHVSearchModePrefix;
    }

    if ([string isEqualToString:@"Contains"])
    {
        return MHVSearchModeContains;
    }
    
    return MHVSearchModeNone;
}

static NSString *const c_attribute_matchType = @"search-mode";

@implementation MHVVocabularySearchString

- (void)serializeAttributes:(XWriter *)writer
{
    NSString *matchType = MHVSearchModeToString(self.matchType);

    [writer writeAttribute:c_attribute_matchType value:matchType];
}

- (void)deserializeAttributes:(XReader *)reader
{
    NSString *mode = nil;

    mode = [reader readAttribute:c_attribute_matchType];
    if (mode && ![mode isEqualToString:@""])
    {
        self.matchType = MHVSearchModeFromString(mode);
    }
}

@end

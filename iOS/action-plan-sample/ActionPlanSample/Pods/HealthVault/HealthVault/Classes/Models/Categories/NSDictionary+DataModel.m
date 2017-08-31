//
// NSDictionary+DataModel.m
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

#import "NSDictionary+DataModel.h"
#import "MHVValidator.h"

@implementation NSDictionary (DataModel)

- (instancetype)initWithObject:(id)object objectParameters:(Class)unused;
{
    if (!object || [object isKindOfClass:[NSNull class]])
    {
        return nil;
    }
    else if ([object isKindOfClass:[NSDictionary class]])
    {
        self = [self initWithDictionary:(NSDictionary*)object];
    }
    else
    {
        MHVASSERT_TRUE(NO, @"Unsupported class: %@", NSStringFromClass([object class]));
    }
    
    return self;
}

- (NSString*)jsonRepresentationWithObjectParameters:(NSObject*)ignored
{
    NSMutableString *json = [NSMutableString new];
    for (id key in self.allKeys)
    {
        if ([self[key] respondsToSelector:@selector(jsonRepresentationWithObjectParameters:)])
        {
            [json appendString:(json.length > 0 ? @", " : @"{")];
            [json appendString:[key jsonRepresentationWithObjectParameters:nil]];
            [json appendString:@": "];
            [json appendString:[self[key] jsonRepresentationWithObjectParameters:nil]];
        }
    }
    
    [json appendString:(json.length > 0 ? @"}" : @"{ }")];
    
    return json;
}

- (NSDictionary *)dictionaryByAddingEntriesFromDictionary:(NSDictionary *)dictionary
{
    if (!dictionary)
    {
        return self;
    }
    
    NSMutableDictionary *merged = [self mutableCopy];
    [merged addEntriesFromDictionary:dictionary];
    return merged;
}

- (NSDictionary *)dictionaryByAddingEntriesFromDictionary:(NSDictionary *)dictionary forKeys:(NSArray<NSString *> *)keys
{
    if (!dictionary || keys.count == 0)
    {
        return self;
    }
    
    NSMutableDictionary *merged = [self mutableCopy];
    for (NSString *key in keys)
    {
        if (dictionary[key])
        {
            merged[key] = dictionary[key];
        }
    }
    return merged;
}

@end

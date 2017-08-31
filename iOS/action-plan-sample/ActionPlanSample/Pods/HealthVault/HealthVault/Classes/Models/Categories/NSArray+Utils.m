//
// NSArray+Utils.m
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

#import "NSArray+Utils.h"
#import "MHVValidator.h"

@implementation NSArray (Utils)

- (NSArray *)convertAll:(id (^)(id obj))converter
{
    MHVASSERT_PARAMETER(converter);
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:self.count];
    
    for (id object in self)
    {
        [array addObject:converter(object)];
    }
    
    return array;
}

- (NSArray *)map:(id (^)(id obj, NSUInteger idx, BOOL *stop))mapper
{
    NSMutableArray *mappedArray = [NSMutableArray array];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [mappedArray addObject:mapper(obj, idx, stop)];
    }];

    return mappedArray;
}

- (BOOL)areAllObjectsOfClass:(Class)theClass
{
    for (id object in self)
    {
        if (![object isKindOfClass:theClass])
        {
            return NO;
        }
    }
    return YES;
}

+ (BOOL)isNilOrEmpty:(NSArray *)array;
{
    return array == nil || array.count == 0;
}
@end

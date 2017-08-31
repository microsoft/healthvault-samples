//
// MHVQueuedDictionary.m
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

#import "MHVQueuedDictionary.h"

@interface MHVQueuedDictionary ()

@property (nonatomic, strong) NSMutableDictionary   *dictionary;
@property (nonatomic, strong) NSMutableArray        *orderedKeys;
@property (nonatomic, assign) NSInteger             maxQueue;

@end

@implementation MHVQueuedDictionary

- (instancetype)initWithMaxQueue:(NSInteger)maxQueue
{
    self = [super init];
    if (self)
    {
        _maxQueue = maxQueue;
        //Adds and removes if it's > maxQueue, so need space for 1 more
        _dictionary = [[NSMutableDictionary alloc] initWithCapacity:maxQueue + 1];
        _orderedKeys = [[NSMutableArray alloc] initWithCapacity:maxQueue + 1];
    }
    return self;
}

- (void)removeObjectForKey:(id)aKey
{
    [self.dictionary removeObjectForKey:aKey];
    [self.orderedKeys removeObject:aKey];
}

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    BOOL hadObject = ([self.dictionary objectForKey:aKey] != nil);
    
    //Sets even if key already there in case object changes
    [self.dictionary setObject:anObject forKey:aKey];

    //Remember keys in the order added
    //If already existed it moves to the end, so will be removed last
    if (hadObject)
    {
        [self.orderedKeys removeObject:aKey];
    }
    [self.orderedKeys addObject:aKey];
    
    //Full, remove the oldest/first
    if (self.orderedKeys.count > self.maxQueue)
    {
        id oldestKey = [self.orderedKeys firstObject];
        [self removeObjectForKey:oldestKey];
    }
}

- (id)objectForKey:(id)aKey
{
    return [self.dictionary objectForKey:aKey];
}

- (NSUInteger)count
{
    return [self.dictionary count];
}


@end

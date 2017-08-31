//
// MHVJsonCacheService.m
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


#import "MHVJsonCacheService.h"
#import "MHVQueuedDictionary.h"
#import "MHVJsonCacheItem.h"
#import "MHVJsonCacheRetainObjectProtocol.h"

@interface MHVJsonCacheService ()

@property (nonatomic, strong) MHVQueuedDictionary *jsonObjectCache;

@end


@implementation MHVJsonCacheService

- (instancetype)initWithMaxCacheSize:(NSInteger)cacheSize
{
    self = [super init];
    if (self)
    {
        _jsonObjectCache = [[MHVQueuedDictionary alloc] initWithMaxQueue:cacheSize];
    }
    return self;
}

- (id)objectForKey:(NSString*)aKey itemClass:(Class)itemClass
{
    if (!aKey)
    {
        return nil;
    }
    
    MHVJsonCacheItem *cacheItem;
    @synchronized(self.jsonObjectCache)
    {
        cacheItem = [self.jsonObjectCache objectForKey:aKey];
    }
    
    if (cacheItem.toClass == itemClass)
    {
        //If plain Array or Dictionary, do deeper copies.
        if ([cacheItem.object conformsToProtocol:@protocol(MHVJsonCacheRetainObjectProtocol)])
        {
            //Many data models are not changed in the app, so don't need to copy since that adds time for big objects
            // *events can rename, but the rename process changes the .name property directly & resets for success/failure
            return cacheItem.object;
        }
        else if ([cacheItem.object isKindOfClass:[NSArray class]])
        {
            //TODO: I don't think this will work if it's an NSArray of NSArrays...but we don't have any data models like that yet
            return [[NSArray alloc] initWithArray:cacheItem.object copyItems:YES];
        }
        else if ([cacheItem.object isKindOfClass:[NSDictionary class]])
        {
            return [[NSDictionary alloc] initWithDictionary:cacheItem.object copyItems:YES];
        }
        else
        {
            return [cacheItem.object copy];
        }
    }
    return nil;
}

//Does pass in item class rather than looking at object since deserializing a MHVUserEvent, it is correct to get back a MHVRunEvent
- (void)setObject:(id)object itemClass:(Class)itemClass forKey:(NSString*)aKey
{
    if (!aKey)
    {
        return;
    }
    
    //Good JSON converted to an object, add to cache.
    if (object && [object conformsToProtocol:@protocol(NSCopying)])
    {
        MHVJsonCacheItem *cacheItem = [MHVJsonCacheItem new];
        cacheItem.jsonHash = aKey;
        //Many data models are not changed in the app, so don't need to copy since that adds time for big objects
        // *events can rename, but the rename process changes the .name property directly & resets for success/failure
        if ([object conformsToProtocol:@protocol(MHVJsonCacheRetainObjectProtocol)])
        {
            cacheItem.object = object;
        }
        else
        {
            cacheItem.object = [object copy];
        }
        cacheItem.toClass = itemClass;
        
        @synchronized(self.jsonObjectCache)
        {
            [self.jsonObjectCache setObject:cacheItem forKey:aKey];
        }
    }
}

@end

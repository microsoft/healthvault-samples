//
// MHVBlobPayload.m
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
//

#import "MHVBlobPayload.h"
#import "MHVValidator.h"
#import "NSArray+Utils.h"

static NSString *const c_element_blob = @"blob";

@interface MHVBlobPayload ()

@property (readwrite, nonatomic, strong) NSArray<MHVBlobPayloadThing *> *things;

@end

@implementation MHVBlobPayload

- (NSArray<MHVBlobPayloadThing *> *)things
{
    if (!_things)
    {
        _things = @[];
    }
    
    return _things;
}

- (BOOL)hasThings
{
    return ![NSArray isNilOrEmpty:self.things];
}

- (MHVBlobPayloadThing *)getDefaultBlob
{
    return [self getBlobNamed:@""];
}

- (MHVBlobPayloadThing *)getBlobNamed:(NSString *)name
{
    if (!self.hasThings)
    {
        return nil;
    }
    
    NSUInteger index = [self indexOfBlobNamed:name];
    if (index == NSNotFound)
    {
        return nil;
    }
    
    return self.things[index];
}

- (NSURL *)getUrlForBlobNamed:(NSString *)name
{
    MHVBlobPayloadThing *blob = [self getBlobNamed:name];
    
    if (!blob)
    {
        return nil;
    }
    
    return [NSURL URLWithString:blob.blobUrl];
}

- (BOOL)addOrUpdateBlob:(MHVBlobPayloadThing *)blob
{
    MHVCHECK_NOTNULL(blob);
    
    if (self.things)
    {
        NSUInteger existingIndex = [self indexOfBlobNamed:blob.name];
        if (existingIndex != NSNotFound)
        {
            NSMutableArray *thingsCopy = [self.things mutableCopy];
            [thingsCopy removeObjectAtIndex:existingIndex];
            self.things = thingsCopy;
        }
    }
    
    if (!self.things)
    {
        self.things = @[];
    }

    MHVCHECK_NOTNULL(self.things);
    
    self.things = [self.things arrayByAddingObject:blob];
    
    return TRUE;
}

- (NSUInteger)indexOfBlobNamed:(NSString *)name
{
    for (NSUInteger i = 0; i < self.things.count; ++i)
    {
        MHVBlobPayloadThing *thing = [self.things objectAtIndex:i];
        NSString *blobName = thing.name;
        if ([blobName isEqualToString:name])
        {
            return i;
        }
    }
    
    return NSNotFound;
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN
    
    MHVVALIDATE_ARRAY(self.things, MHVClientError_InvalidBlobInfo);
    
    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementArray:c_element_blob elements:self.things];
}

- (void)deserialize:(XReader *)reader
{
    self.things = [reader readElementArray:c_element_blob
                                   asClass:[MHVBlobPayloadThing class]
                             andArrayClass:[NSMutableArray class]];
}

@end

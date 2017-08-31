//
// MHVJsonSerializer.m
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


#import "MHVJsonSerializer.h"
#import "MHVPropertyIntrospection.h"
#import "NSData+Utils.h"
#import "MHVJsonCacheItem.h"
#import "MHVQueuedDictionary.h"
#import "MHVJsonEnumProtocol.h"
#import "MHVJsonCacheRetainObjectProtocol.h"
#import "MHVDataModelProtocol.h"
#import "MHVJsonCacheService.h"
#import "NSString+DataModel.h"
#import "NSArray+DataModel.h"
#import "NSDictionary+DataModel.h"
#import "MHVValidator.h"

static NSInteger kJSONCacheMaxItems = 25;


@implementation MHVJsonSerializer

#pragma mark - Serialization

+ (NSString *)serialize:(id)object
{
    MHVASSERT([object respondsToSelector:@selector(jsonRepresentationWithObjectParameters:)]);
    
    if (![object respondsToSelector:@selector(jsonRepresentationWithObjectParameters:)])
    {
        return nil;
    }
    return [object jsonRepresentationWithObjectParameters:nil];
}

#pragma mark - Deserialization

+ (id)deserialize:(NSString *)json toClass:(Class)toClass shouldCache:(BOOL)shouldCache
{
    //One cache object
    //TODO: Make this serializer injectable, then this can be a regular property
    static MHVJsonCacheService *jsonCacheService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        jsonCacheService = [[MHVJsonCacheService alloc] initWithMaxCacheSize:kJSONCacheMaxItems];
    });
    
    //Handle data models that are simple NSNumber or NSString objects, ie 10
    if (toClass == [NSNumber class])
    {
        return @([json doubleValue]);
    }
    
    if (!toClass || toClass == [NSString class])
    {
        return json;
    }
    
    if (!json)
    {
        return nil;
    }
    
    NSData *encodedData = [json dataUsingEncoding:NSUTF8StringEncoding];
    if (!encodedData)
    {
        return  nil;
    }

    if (toClass == [NSData class])
    {
        return encodedData;
    }

    NSString *jsonHash = nil;
    
    if(shouldCache)
    {
        //See if the same data has already been deserialized into the same type of object
        jsonHash = [encodedData SHA512];
        id cachedObject = [jsonCacheService objectForKey:jsonHash itemClass:toClass];
        if (cachedObject)
        {
            MHVLogEvent([NSString stringWithFormat:@"Used Cached Object: %@", NSStringFromClass([cachedObject class])]);
            return cachedObject;
        }
    }
    
    //Not cached, deserialize
    NSError *error = nil;
    id root = [NSJSONSerialization JSONObjectWithData:encodedData options:0 error:&error];
    if(!root)
    {
        return  nil;
    }
    
    if (toClass == [NSDictionary class] && [root isKindOfClass:[NSDictionary class]])
    {
        //Want an NSDictionary, done
        return root;
    }
    
    //Other cases (numbers/data) handled above, should be a data model if it gets here
    MHVASSERT([toClass conformsToProtocol:@protocol(MHVDataModelProtocol)]);
    
    id deserializedObject = nil;
    if ([root isKindOfClass:[NSDictionary class]])
    {
        deserializedObject = [[toClass alloc] initWithObject:root objectParameters:nil];
    }
    else if ([root isKindOfClass:[NSArray class]])
    {
        deserializedObject = [[NSArray alloc] initWithObject:root objectParameters:toClass];
    }
    
    //Good JSON converted to an object, add to cache.
    if (deserializedObject && shouldCache && jsonHash)
    {
        [jsonCacheService setObject:deserializedObject itemClass:toClass forKey:jsonHash];
    }
    
    return deserializedObject;
}

//TODO: Update so this is injectable & not class methods
+ (id)deserializeJsonFile:(NSString *)file ofType:(NSString *)type inBundle:(NSBundle *)bundle toClass:(Class)toClass
{
    NSString *filePath = [bundle pathForResource:file ofType:type];
    MHVASSERT_TRUE(filePath, @"file path is nil");
    
    if (!filePath)
    {
        return nil;
    }
    
    NSString *jsonString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    
    return [MHVJsonSerializer deserialize:jsonString toClass:toClass shouldCache:NO];
}

+ (NSString *)unstringify:(NSString *)string
{
    // Convert \" to "
    string = [string stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    // Remove leading and trailing quotes "
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
    return string;
}

@end

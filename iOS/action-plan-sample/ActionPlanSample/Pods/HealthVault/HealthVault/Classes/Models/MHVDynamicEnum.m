//
// MHVDynamicEnum.m
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

#import "MHVDynamicEnum.h"
#import <objc/runtime.h>
#import "MHVValidator.h"

static NSArray<NSString *> *prefixList = nil;

@implementation MHVDynamicEnum

+ (void)initialize
{
    prefixList = @[@"MHV"];
}

- (NSDictionary *)enumMap
{
    return [[self class] enumMap];
}

- (NSDictionary *)aliasMap
{
    return [[self class] aliasMap];
}

+ (NSDictionary *)enumMap
{
    NSAssert(NO, @"MHVDynamicEnum subclasses must implement");
    return nil;
}

+ (NSDictionary *)aliasMap
{
    return nil;
}

+ (BOOL)resolveClassMethod:(SEL)selector
{
    MHVASSERT_TRUE(![[self stripPrefix:NSStringFromClass([self class])] isEqualToString:NSStringFromClass([self class])], @"Prefix on dynamic enum class not recognized!");
    
    // TODO: Enums are allowed to have an optional prefix of 'MHV', this is to get around a strange apple
    // bug where enum names collide with private library methods. Because of this we strip the the prefix
    // if it exists. 
    NSString *selectorName = [self stripPrefix:NSStringFromSelector(selector)];
    
    if (selectorName.length > 0 && ![selectorName isEqualToString:@"enumMap"])
    {
        NSDictionary *map = [self enumMap];
        
        //Check as-is first
        if (!map[selectorName])
        {
            //Not found, convert "unknown" to "Unknown" for enum map keys
            selectorName = [[[selectorName substringToIndex:1] uppercaseString] stringByAppendingString:[selectorName substringFromIndex:1]];
            
            if (!map[selectorName])
            {
                //Still not found, try uppercase (for GET/PUT http enums)
                selectorName = [selectorName uppercaseString];
            }
        }
        
        Class objcClass = object_getClass(self);
        NSInteger value = 0;
        
        if (map[selectorName])
        {
            //Matched, return enum for that value
            value = [map[selectorName] integerValue];
        }
        else
        {
            //Not found, 0 is always Unknown
            MHVLogEvent([NSString stringWithFormat:@"Enum value not found for %@.%@", NSStringFromClass([self class]), NSStringFromSelector(selector)]);
            value = 0;
        }
        
        IMP implementation  = imp_implementationWithBlock((id)^(id self) {
            return [[self alloc] initWithInteger:value];
        });
        
        class_addMethod(objcClass, selector, implementation, "@@");
        return YES;
    }
    
    return [super resolveClassMethod:selector];
}

+ (NSString *)stripPrefix:(NSString *)enumName
{
    if (!enumName)
    {
        return nil;
    }
    
    for (NSString *prefix in prefixList)
    {
        if ([enumName hasPrefix:prefix])
        {
            // Try all prefixes. If a prefix matches, strip the prefix and return the name.
            return [enumName substringFromIndex:prefix.length];
        }
    }
    
    // None of prefixes matched. Return original name.
    return enumName;
}

@end

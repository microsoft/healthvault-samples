//
// NSArray+DataModel.m
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

#import "NSArray+DataModel.h"
#import "MHVDataModelDynamicClass.h"
#import "MHVValidator.h"

@implementation NSArray (DataModel)

- (instancetype)initWithObject:(id)object objectParameters:(Class)itemType;
{
    MHVASSERT_PARAMETER(itemType);
    
    if (!object || [object isKindOfClass:[NSNull class]])
    {
        return nil;
    }
    else if ([object isKindOfClass:[NSArray class]])
    {
        //Init all the items in the array
        NSMutableArray *itemsArray = [NSMutableArray new];
        for (id value in (NSArray*)object)
        {
            Class valueClass = itemType;

            //For things like UserEvents that can be an array of several classes (RunEvent, BikeEvent, etc)
            if ([valueClass conformsToProtocol:@protocol(MHVDataModelDynamicClass)])
            {
                valueClass = [(id<MHVDataModelDynamicClass>)valueClass classForObject:value];
            }
            
            MHVASSERT_TRUE(valueClass, @"Array item class unknown!");

            id item = [[valueClass alloc] initWithObject:value objectParameters:nil];
            if (item)
            {
                [itemsArray addObject:item];
            }
        }
        self = [self initWithArray:itemsArray];
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
    for (id object in self)
    {
        if ([object respondsToSelector:@selector(jsonRepresentationWithObjectParameters:)])
        {
            [json appendString:(json.length > 0 ? @", " : @"[")];
            [json appendString:[object jsonRepresentationWithObjectParameters:ignored]];
        }
    }
    
    [json appendString:(json.length > 0 ? @"]" : @"[ ]")];

    return json;
}

@end

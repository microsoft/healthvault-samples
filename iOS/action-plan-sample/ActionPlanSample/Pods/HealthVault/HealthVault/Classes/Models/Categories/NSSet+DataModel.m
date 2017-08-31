//
// NSSet+DataModel.m
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

#import "NSSet+DataModel.h"
#import "NSArray+DataModel.h"
#import "MHVValidator.h"

@implementation NSSet (DataModel)

- (instancetype)initWithObject:(id)object objectParameters:(Class)itemType;
{
    MHVASSERT_PARAMETER(itemType);
    
    if (!object || [object isKindOfClass:[NSNull class]])
    {
        return nil;
    }
    else if ([object isKindOfClass:[NSSet class]])
    {
        self = [self initWithSet:object];
    }
    else if ([object isKindOfClass:[NSArray class]])
    {
        NSArray *itemsArray = [[NSArray alloc] initWithObject:object objectParameters:itemType];
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

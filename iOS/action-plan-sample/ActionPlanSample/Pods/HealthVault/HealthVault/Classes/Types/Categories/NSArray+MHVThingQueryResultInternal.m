//
// NSArray+MHVThingQueryResultInternal.m
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

#import "NSArray+MHVThingQueryResultInternal.h"
#import "MHVThingQueryResultInternal.h"

@implementation NSArray (MHVThingQueryResultInternal)

- (MHVThingQueryResultInternal *)resultWithName:(NSString *)name
{
    for (MHVThingQueryResultInternal *result in self)
    {
        if ([result.name isEqualToString:name])
        {
            return result;
        }
    }
    return nil;
}

- (NSArray<MHVThingQueryResultInternal *> *)mergeThingQueryResultArray:(NSArray<MHVThingQueryResultInternal *> *)array
{
    NSMutableArray *copy = [self mutableCopy];
    
    for (MHVThingQueryResultInternal *result in array)
    {
        if (![result isKindOfClass:[MHVThingQueryResultInternal class]])
        {
            return self;
        }
        
        MHVThingQueryResultInternal *existingResult = [copy resultWithName:result.name];
        
        if (existingResult)
        {
            // If the existing result did not contain things, new collections for things must be initialized
            if (!existingResult.things)
            {
                existingResult.things = result.things;
            }
            else
            {
                existingResult.things = [existingResult.things arrayByAddingObjectsFromArray:result.things];
            }
            
            // Remove retrieved things from pendingThings array
            NSMutableArray *pendingThingsCopy = [existingResult.pendingThings mutableCopy];
            
            for (MHVThing *thing in result.things)
            {
                for (NSInteger i = 0; i < pendingThingsCopy.count; i++)
                {
                    MHVPendingThing *pendingThing = pendingThingsCopy[i];
                    
                    if ([pendingThing.key.thingID isEqualToString:thing.key.thingID])
                    {
                        [pendingThingsCopy removeObjectAtIndex:i];
                        break;
                    }
                }
            }
            
            existingResult.pendingThings = pendingThingsCopy;
        }
        else
        {
            [copy addObject:result];
        }
    }
    
    return copy;
}

@end

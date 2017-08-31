//
// NSArray+MHVThing.h
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


#import "NSArray+MHVThing.h"
#import "MHVThing.h"

@implementation NSArray (MHVThing)

- (NSArray<NSString *> *)arrayOfThingIds
{
    NSMutableArray<NSString *> *collection = [NSMutableArray new];

    for (MHVThing *thing in self)
    {
        if ([thing isKindOfClass:[MHVThing class]])
        {
            
            [collection addObject:thing.thingID];
        }
    }

    return collection;
}

- (NSUInteger)indexOfThingID:(NSString *)thingID
{
    for (NSUInteger i = 0; i < self.count; ++i)
    {
        id obj = [self objectAtIndex:i];

        if (obj== [NSNull null])
        {
            continue;
        }

        if ([obj isKindOfClass:[MHVThing class]])
        {
            MHVThing *thing = (MHVThing *)obj;
            if ([thing.thingID isEqualToString:thingID])
            {
                return i;
            }
        }
    }

    return NSNotFound;
}

- (NSString *)toString
{
    if (self.count == 0)
    {
        return @"";
    }
    
    NSMutableString *text = [[NSMutableString alloc] init];
    
    for (NSUInteger i = 0, count = self.count; i < count; ++i)
    {
        id obj = [self objectAtIndex:i];
        NSString *descr = [obj description];
        if (!descr || [descr isEqualToString:@""])
        {
            continue;
        }
        
        if (i > 0)
        {
            [text appendString:@"\r\n"];
        }
        
        [text appendString:descr];
    }
    
    return text;
}

- (BOOL)containsThingID:(NSString *)thingID
{
    return [self indexOfThingID:thingID] != NSNotFound;
}

@end

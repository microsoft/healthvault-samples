//
// MHVFamilyHistory.m
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

#import "MHVFamilyHistory.h"
#import "MHVValidator.h"
#import "NSArray+Utils.h"

static NSString *const c_typeid = @"4a04fcc8-19c1-4d59-a8c7-2031a03f21de";
static NSString *const c_typename = @"family-history";

static NSString *const c_element_condition = @"condition";
static NSString *const c_element_relative = @"relative";

@implementation MHVFamilyHistory

- (NSArray<MHVConditionEntry *> *)conditions
{
    if (!_conditions)
    {
        _conditions = @[];
    }

    return _conditions;
}

- (BOOL)hasConditions
{
    return ![NSArray isNilOrEmpty:self.conditions];
}

- (MHVConditionEntry *)firstCondition
{
    return self.hasConditions ? [self.conditions objectAtIndex:0] : nil;
}

- (NSString *)toString
{
    if (!self.hasConditions)
    {
        return @"";
    }

    if (self.conditions.count == 1)
    {
        return [[self.conditions objectAtIndex:0] toString];
    }

    NSMutableString *output = [[NSMutableString alloc] init];
    
    for (NSUInteger i = 0; i < self.conditions.count; ++i)
    {
        if (i > 0)
        {
            [output appendString:@","];
        }

        [output appendString:[[self.conditions objectAtIndex:i] toString]];
    }

    return output;
}

- (NSString *)description
{
    return [self toString];
}

- (instancetype)initWithRelative:(MHVRelative *)relative andCondition:(MHVConditionEntry *)condition
{
    MHVASSERT_PARAMETER(relative);
    MHVASSERT_PARAMETER(condition);
    
    if (!relative || !condition)
    {
        return nil;
    }

    self = [super init];
    
    if (self)
    {
        _relative = relative;
        _conditions = @[condition];
    }
    
    return self;
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN

    MHVVALIDATE_OPTIONAL(self.relative);

    MHVVALIDATE_ARRAYOPTIONAL(self.conditions, MHVClientError_InvalidFamilyHistory);

    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementArray:c_element_condition elements:self.conditions];
    [writer writeElement:c_element_relative content:self.relative];
}

- (void)deserialize:(XReader *)reader
{
    self.conditions = [reader readElementArray:c_element_condition
                                       asClass:[MHVConditionEntry class]
                                 andArrayClass:[NSMutableArray class]];
    self.relative = [reader readElement:c_element_relative asClass:[MHVRelative class]];
}

+ (NSString *)typeID
{
    return c_typeid;
}

+ (NSString *)XRootElement
{
    return c_typename;
}

+ (MHVThing *)newThing
{
    return [[MHVThing alloc] initWithType:[MHVFamilyHistory typeID]];
}

- (NSString *)typeName
{
    return NSLocalizedString(@"Family History", @"Family History Type Name");
}

@end

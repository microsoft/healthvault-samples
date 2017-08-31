//
// MHVLabTestResults.m
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

#import "MHVLabTestResults.h"
#import "MHVValidator.h"
#import "NSArray+Utils.h"

static NSString *const c_typeid = @"5800eab5-a8c2-482a-a4d6-f1db25ae08c3";
static NSString *const c_typename = @"lab-test-results";

static const xmlChar *x_element_when = XMLSTRINGCONST("when");
static NSString *const c_element_labGroup = @"lab-group";
static const xmlChar *x_element_labGroup = XMLSTRINGCONST("lab-group");
static const xmlChar *x_element_orderedBy = XMLSTRINGCONST("ordered-by");

@implementation MHVLabTestResults

- (MHVLabTestResultsGroup *)firstGroup
{
    if ([NSArray isNilOrEmpty:self.labGroup])
    {
        return nil;
    }

    return [self.labGroup objectAtIndex:0];
}

- (NSArray<MHVLabTestResultsGroup *> *)getAllGroups
{
    NSMutableArray *allGroups = [[NSMutableArray alloc] init];

    MHVCHECK_NOTNULL(allGroups);

    for (MHVLabTestResultsGroup *group in self.labGroup)
    {
        [group addToCollection:allGroups];
    }

    return allGroups;
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN;

    MHVVALIDATE_OPTIONAL(self.when);
    MHVVALIDATE_ARRAY(self.labGroup, MHVclientError_InvalidLabTestResults);
    MHVVALIDATE_OPTIONAL(self.orderedBy);

    MHVVALIDATE_SUCCESS;
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementXmlName:x_element_when content:self.when];
    [writer writeElementArray:c_element_labGroup elements:self.labGroup];
    [writer writeElementXmlName:x_element_orderedBy content:self.orderedBy];
}

- (void)deserialize:(XReader *)reader
{
    self.when = [reader readElementWithXmlName:x_element_when asClass:[MHVApproxDateTime class]];
    self.labGroup = [reader readElementArrayWithXmlName:x_element_labGroup asClass:[MHVLabTestResultsGroup class] andArrayClass:[NSMutableArray class]];
    self.orderedBy = [reader readElementWithXmlName:x_element_orderedBy asClass:[MHVOrganization class]];
}

- (NSString *)toString
{
    MHVLabTestResultsGroup *group = [self firstGroup];

    if (!group)
    {
        return @"";
    }

    return [[group groupName] toString];
}

- (NSString *)description
{
    return [self toString];
}

+ (MHVThing *)newThing
{
    return [[MHVThing alloc] initWithType:[MHVLabTestResults typeID]];
}

+ (NSString *)typeID
{
    return c_typeid;
}

+ (NSString *)XRootElement
{
    return c_typename;
}

- (NSString *)typeName
{
    return NSLocalizedString(@"Lab Test Results", @"Lab Test Results Type Name");
}

@end

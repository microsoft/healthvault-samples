//
// MHVLabTestResultsGroup.m
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

#import "MHVValidator.h"
#import "MHVLabTestResultsGroup.h"
#import "NSArray+Utils.h"

static const xmlChar *x_element_groupName = XMLSTRINGCONST("group-name");
static const xmlChar *x_element_laboratory = XMLSTRINGCONST("laboratory-name");
static const xmlChar *x_element_status = XMLSTRINGCONST("status");
static NSString *const c_element_subGroups = @"sub-groups";
static const xmlChar *x_element_subGroups = XMLSTRINGCONST("sub-groups");
static NSString *const c_element_results = @"results";
static const xmlChar *x_element_results = XMLSTRINGCONST("results");

@implementation MHVLabTestResultsGroup

- (BOOL)hasSubGroups
{
    return ![NSArray isNilOrEmpty:self.subGroups];
}

- (void)addToCollection:(NSMutableArray *)groups
{
    [groups addObject:self];
    
    if (self.hasSubGroups)
    {
        for (NSUInteger i = 0; i < self.subGroups.count; ++i)
        {
            [[self.subGroups objectAtIndex:i] addToCollection:groups];
        }
    }
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN;

    MHVVALIDATE(self.groupName, MHVClientError_InvalidLabTestResultsGroup);
    MHVVALIDATE_OPTIONAL(self.laboratory);
    MHVVALIDATE_OPTIONAL(self.status);
    MHVVALIDATE_ARRAYOPTIONAL(self.subGroups, MHVClientError_InvalidLabTestResultsGroup);
    MHVVALIDATE_ARRAYOPTIONAL(self.results, MHVClientError_InvalidLabTestResultsGroup);

    MHVVALIDATE_SUCCESS;
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementXmlName:x_element_groupName content:self.groupName];
    [writer writeElementXmlName:x_element_laboratory content:self.laboratory];
    [writer writeElementXmlName:x_element_status content:self.status];
    [writer writeElementArray:c_element_subGroups elements:self.subGroups];
    [writer writeElementArray:c_element_results elements:self.results];
}

- (void)deserialize:(XReader *)reader
{
    self.groupName = [reader readElementWithXmlName:x_element_groupName asClass:[MHVCodableValue class]];
    self.laboratory = [reader readElementWithXmlName:x_element_laboratory asClass:[MHVOrganization class]];
    self.status = [reader readElementWithXmlName:x_element_status asClass:[MHVCodableValue class]];
    self.subGroups = [reader readElementArrayWithXmlName:x_element_subGroups
                                                 asClass:[MHVLabTestResultsGroup class]
                                           andArrayClass:[NSMutableArray class]];
    self.results = [reader readElementArrayWithXmlName:x_element_results
                                               asClass:[MHVLabTestResultsDetails class]
                                         andArrayClass:[NSMutableArray class]];
}

@end

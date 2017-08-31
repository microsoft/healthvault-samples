//
// MHVGetAuthorizedPeopleResult.m
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

#import "MHVGetAuthorizedPeopleResult.h"

static NSString *const c_element_results = @"response-results";
static NSString *const c_element_person = @"person-info";
static NSString *const c_element_more = @"more-results";

@implementation MHVGetAuthorizedPeopleResult

- (void)serialize:(XWriter *)writer
{
    [writer writeStartElement:c_element_results];

    [writer writeElementArray:c_element_results thingName:c_element_person elements:self.persons];
    [writer writeElement:c_element_more content:self.moreResults];

    [writer writeEndElement];
}

- (void)deserialize:(XReader *)reader
{
    [reader  readStartElementWithName:c_element_results];

    self.persons = [reader readElementArray:c_element_person
                                    asClass:[MHVPersonInfo class]
                              andArrayClass:[NSMutableArray class]];
    self.moreResults = [reader readElement:c_element_more asClass:[MHVBool class]];

    [reader readEndElement];
}

@end

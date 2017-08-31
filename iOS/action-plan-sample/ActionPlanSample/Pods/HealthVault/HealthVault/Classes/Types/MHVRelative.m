//
// MHVRelative.m
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

#import "MHVValidator.h"
#import "MHVRelative.h"

static NSString *const c_element_relationship = @"relationship";
static NSString *const c_element_name = @"relative-name";
static NSString *const c_element_dateOfBirth = @"date-of-birth";
static NSString *const c_element_dateOfDeath = @"date-of-death";
static NSString *const c_element_region = @"region-of-origin";

@implementation MHVRelative

- (instancetype)initWithRelationship:(NSString *)relationship
{
    return [self initWithPerson:nil andRelationship:[MHVCodableValue fromText:relationship]];
}

- (instancetype)initWithPerson:(MHVPerson *)person andRelationship:(MHVCodableValue *)relationship
{
    self = [super init];
    if (self)
    {
        if (person)
        {
            _person = person;
        }

        if (relationship)
        {
            _relationship = relationship;
        }
    }

    return self;
}

- (NSString *)description
{
    return [self toString];
}

- (NSString *)toString
{
    if (self.person)
    {
        return [self.person toString];
    }

    return (self.relationship) ? [self.relationship toString] : @"";
}

+ (MHVVocabularyIdentifier *)vocabForRelationship
{
    return [[MHVVocabularyIdentifier alloc] initWithFamily:c_hvFamily andName:@"personal-relationship"];
}

+ (MHVVocabularyIdentifier *)vocabForRegionOfOrigin
{
    return [[MHVVocabularyIdentifier alloc] initWithFamily:c_hvFamily andName:@"family-history-region-of-origin"];
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN

    MHVVALIDATE(self.relationship, MHVClientError_InvalidRelative);
    MHVVALIDATE_OPTIONAL(self.person);
    MHVVALIDATE_OPTIONAL(self.dateOfBirth);
    MHVVALIDATE_OPTIONAL(self.dateOfDeath);
    MHVVALIDATE_OPTIONAL(self.regionOfOrigin);

    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_relationship content:self.relationship];
    [writer writeElement:c_element_name content:self.person];
    [writer writeElement:c_element_dateOfBirth content:self.dateOfBirth];
    [writer writeElement:c_element_dateOfDeath content:self.dateOfDeath];
    [writer writeElement:c_element_region content:self.regionOfOrigin];
}

- (void)deserialize:(XReader *)reader
{
    self.relationship = [reader readElement:c_element_relationship asClass:[MHVCodableValue class]];
    self.person = [reader readElement:c_element_name asClass:[MHVPerson class]];
    self.dateOfBirth = [reader readElement:c_element_dateOfBirth asClass:[MHVApproxDate class]];
    self.dateOfDeath = [reader readElement:c_element_dateOfDeath asClass:[MHVApproxDate class]];
    self.regionOfOrigin = [reader readElement:c_element_region asClass:[MHVCodableValue class]];
}

@end

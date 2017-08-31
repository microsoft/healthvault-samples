//
// MHVPhone.m
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
#import "MHVPhone.h"

static NSString *const c_element_description = @"description";
static NSString *const c_element_isPrimary = @"is-primary";
static NSString *const c_element_number = @"number";

@implementation MHVPhone

- (instancetype)initWithNumber:(NSString *)number
{
    MHVCHECK_STRING(number);

    self = [super init];
    if (self)
    {
        _number = number;
    }

    return self;
}

- (NSString *)description
{
    return [self toString];
}

- (NSString *)toString
{
    return (self.number) ? self.number : @"";
}

+ (MHVVocabularyIdentifier *)vocabForType
{
    return [[MHVVocabularyIdentifier alloc] initWithFamily:c_hvFamily andName:@"phone-types"];
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN

        MHVVALIDATE_STRING(self.number, MHVClientError_InvalidPhone);

    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_description value:self.type];
    [writer writeElement:c_element_isPrimary content:self.isPrimary];
    [writer writeElement:c_element_number value:self.number];
}

- (void)deserialize:(XReader *)reader
{
    self.type = [reader readStringElement:c_element_description];
    self.isPrimary = [reader readElement:c_element_isPrimary asClass:[MHVBool class]];
    self.number = [reader readStringElement:c_element_number];
}

@end


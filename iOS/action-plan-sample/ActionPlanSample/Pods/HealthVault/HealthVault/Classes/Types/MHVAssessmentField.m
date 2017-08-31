//
// MHVAssessmentField.m
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

#import "MHVAssessmentField.h"
#import "MHVValidator.h"

static NSString *const c_element_name = @"name";
static NSString *const c_element_value = @"value";
static NSString *const c_element_group = @"group";

@implementation MHVAssessmentField

- (instancetype)initWithName:(NSString *)name andValue:(NSString *)value
{
    return [self initWithName:name value:value andGroup:nil];
}

- (instancetype)initWithName:(NSString *)name value:(NSString *)value andGroup:(NSString *)group
{
    self = [super init];
    if (self)
    {
        _name = [[MHVCodableValue alloc] initWithText:name];
        MHVCHECK_NOTNULL(_name);

        _value = [[MHVCodableValue alloc] initWithText:value];
        MHVCHECK_NOTNULL(_value);

        if (group)
        {
            _fieldGroup = [[MHVCodableValue alloc] initWithText:group];
            MHVCHECK_NOTNULL(_fieldGroup);
        }
    }

    return self;
}

+ (MHVAssessmentField *)from:(NSString *)name andValue:(NSString *)value
{
    return [[MHVAssessmentField alloc] initWithName:name andValue:value];
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN

    MHVVALIDATE(self.name, MHVClientError_InvalidAssessmentField);
    MHVVALIDATE(self.value, MHVClientError_InvalidAssessmentField);
    MHVVALIDATE_OPTIONAL(self.fieldGroup);

    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_name content:self.name];
    [writer writeElement:c_element_value content:self.value];
    [writer writeElement:c_element_group content:self.fieldGroup];
}

- (void)deserialize:(XReader *)reader
{
    self.name = [reader readElement:c_element_name asClass:[MHVCodableValue class]];
    self.value = [reader readElement:c_element_value asClass:[MHVCodableValue class]];
    self.fieldGroup = [reader readElement:c_element_group asClass:[MHVCodableValue class]];
}

@end

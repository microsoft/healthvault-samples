//
// MHVCondition.m
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

#import "MHVCondition.h"
#import "MHVValidator.h"

static NSString *const c_typeid = @"7ea7a1f9-880b-4bd4-b593-f5660f20eda8";
static NSString *const c_typename = @"condition";

static NSString *const c_element_name = @"name";
static NSString *const c_element_onset = @"onset-date";
static NSString *const c_element_status = @"status";
static NSString *const c_element_stop = @"stop-date";
static NSString *const c_element_reason = @"stop-reason";

@implementation MHVCondition

- (instancetype)initWithName:(NSString *)name
{
    MHVCHECK_STRING(name);

    self = [super init];
    if (self)
    {
        _name = [[MHVCodableValue alloc] initWithText:name];
        MHVCHECK_NOTNULL(_name);
    }

    return self;
}

- (NSString *)description
{
    return [self toString];
}

- (NSString *)toString
{
    return (self.name) ? [self.name toString] : @"";
}

+ (MHVVocabularyIdentifier *)vocabForStatus
{
    return [[MHVVocabularyIdentifier alloc] initWithFamily:c_hvFamily andName:@"condition-occurrence"];
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN

    MHVVALIDATE(self.name, MHVClientError_InvalidCondition);
    MHVVALIDATE_OPTIONAL(self.onsetDate);
    MHVVALIDATE_OPTIONAL(self.status);
    MHVVALIDATE_OPTIONAL(self.stopDate);
    MHVVALIDATE_STRINGOPTIONAL(self.stopReason, MHVClientError_InvalidCondition);

    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_name content:self.name];
    [writer writeElement:c_element_onset content:self.onsetDate];
    [writer writeElement:c_element_status content:self.status];
    [writer writeElement:c_element_stop content:self.stopDate];
    [writer writeElement:c_element_reason value:self.stopReason];
}

- (void)deserialize:(XReader *)reader
{
    self.name = [reader readElement:c_element_name asClass:[MHVCodableValue class]];
    self.onsetDate = [reader readElement:c_element_onset asClass:[MHVApproxDateTime class]];
    self.status = [reader readElement:c_element_status asClass:[MHVCodableValue class]];
    self.stopDate = [reader readElement:c_element_stop asClass:[MHVApproxDateTime class]];
    self.stopReason = [reader readStringElement:c_element_reason];
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
    return [[MHVThing alloc] initWithType:[MHVCondition typeID]];
}

- (NSString *)typeName
{
    return NSLocalizedString(@"Condition", @"Condition Type Name");
}

@end

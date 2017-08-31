//
// MHVProcedure.m
// MHVLib
//
// Copyright (c) 2017 Microsoft Corporation. All rights reserved.

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
#import "MHVProcedure.h"

static NSString *const c_typeid = @"df4db479-a1ba-42a2-8714-2b083b88150f";
static NSString *const c_typename = @"procedure";

static NSString *const c_element_when = @"when";
static NSString *const c_element_name = @"name";
static NSString *const c_element_location = @"anatomic-location";
static NSString *const c_element_primaryprovider = @"primary-provider";
static NSString *const c_element_secondaryprovider = @"secondary-provider";

@implementation MHVProcedure

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

- (NSDate *)getDate
{
    return (self.when) ? [self.when toDate] : nil;
}

- (NSDate *)getDateForCalendar:(NSCalendar *)calendar
{
    return (self.when) ? [self.when toDateForCalendar:calendar] : nil;
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN

    MHVVALIDATE(self.name, MHVClientError_InvalidProcedure);
    MHVVALIDATE_OPTIONAL(self.when);
    MHVVALIDATE_OPTIONAL(self.anatomicLocation);
    MHVVALIDATE_OPTIONAL(self.primaryProvider);
    MHVVALIDATE_OPTIONAL(self.secondaryProvider);

    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_when content:self.when];
    [writer writeElement:c_element_name content:self.name];
    [writer writeElement:c_element_location content:self.anatomicLocation];
    [writer writeElement:c_element_primaryprovider content:self.primaryProvider];
    [writer writeElement:c_element_secondaryprovider content:self.secondaryProvider];
}

- (void)deserialize:(XReader *)reader
{
    self.when = [reader readElement:c_element_when asClass:[MHVApproxDateTime class]];
    self.name = [reader readElement:c_element_name asClass:[MHVCodableValue class]];
    self.anatomicLocation = [reader readElement:c_element_location asClass:[MHVCodableValue class]];
    self.primaryProvider = [reader readElement:c_element_primaryprovider asClass:[MHVPerson class]];
    self.secondaryProvider = [reader readElement:c_element_secondaryprovider asClass:[MHVPerson class]];
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
    return [[MHVThing alloc] initWithType:[MHVProcedure typeID]];
}

- (NSString *)typeName
{
    return NSLocalizedString(@"Procedure", @"Procedure Type Name");
}

@end

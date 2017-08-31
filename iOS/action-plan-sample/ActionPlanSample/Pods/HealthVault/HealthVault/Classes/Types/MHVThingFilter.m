//
// MHVThingFilter.m
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
#import "MHVThingFilter.h"
#import "MHVThingDataTyped.h"

static NSString *const c_element_typeID = @"type-id";
static NSString *const c_element_state = @"thing-state";
static NSString *const c_element_edateMin = @"eff-date-min";
static NSString *const c_element_edateMax = @"eff-date-max";
static NSString *const c_element_cappID = @"created-app-id";
static NSString *const c_element_cpersonID = @"created-person-id";
static NSString *const c_element_uappID = @"updated-app-id";
static NSString *const c_element_upersonID = @"updated-person-id";
static NSString *const c_element_cdateMin = @"created-date-min";
static NSString *const c_element_cdateMax = @"created-date-max";
static NSString *const c_element_udateMin = @"updated-date-min";
static NSString *const c_element_udateMax = @"updated-date-max";
static NSString *const c_element_xpath = @"xpath";

@interface MHVThingFilter ()

@property (readwrite, nonatomic, strong)  NSArray<NSString *> *typeIDs;

@end

@implementation MHVThingFilter

- (void)serialize:(XWriter *)writer
{
    [writer writeElementArray:c_element_typeID elements:self.typeIDs];
    
    if (self.state != MHVThingStateNone)
    {
        [writer writeElement:c_element_state value:MHVThingStateToString(self.state)];
    }
    
    [writer writeElement:c_element_edateMin dateValue:self.effectiveDateMin];
    [writer writeElement:c_element_edateMax dateValue:self.effectiveDateMax];
    [writer writeElement:c_element_cappID value:self.createdByAppID];
    [writer writeElement:c_element_cpersonID value:self.createdByPersonID];
    [writer writeElement:c_element_uappID value:self.updatedByAppID];
    [writer writeElement:c_element_upersonID value:self.updatedByPersonID];
    [writer writeElement:c_element_cdateMin dateValue:self.createDateMin];
    [writer writeElement:c_element_cdateMax dateValue:self.createDateMax];
    [writer writeElement:c_element_udateMin dateValue:self.updateDateMin];
    [writer writeElement:c_element_udateMax dateValue:self.updateDateMax];
    [writer writeElement:c_element_xpath value:self.xpath];
}

- (void)deserialize:(XReader *)reader
{
    self.typeIDs = [reader readStringElementArray:c_element_typeID];
    
    NSString *state = [reader readStringElement:c_element_state];
    
    if (state)
    {
        self.state = MHVThingStateFromString(state);
    }
    
    self.effectiveDateMin = [reader readDateElement:c_element_edateMin];
    self.effectiveDateMax = [reader readDateElement:c_element_edateMax];
    self.createdByAppID = [reader readStringElement:c_element_cappID];
    self.createdByPersonID = [reader readStringElement:c_element_cpersonID];
    self.updatedByAppID = [reader readStringElement:c_element_uappID];
    self.updatedByPersonID = [reader readStringElement:c_element_upersonID];
    self.createDateMin = [reader readDateElement:c_element_cdateMin];
    self.createDateMax = [reader readDateElement:c_element_cdateMax];
    self.updateDateMin = [reader readDateElement:c_element_udateMin];
    self.updateDateMax = [reader readDateElement:c_element_udateMax];
    self.xpath = [reader readStringElement:c_element_xpath];
}

- (NSArray<NSString *> *)typeIDs
{
    if (!_typeIDs)
    {
        _typeIDs = @[];
    }
    
    return _typeIDs;
}

- (instancetype)init
{
    return [self initWithTypeID:nil];
}

- (instancetype)initWithTypeID:(NSString *)typeID
{
    self = [super init];
    if (self)
    {
        if (typeID)
        {
            _typeIDs = @[typeID];
        }
        
        self.state = MHVThingStateActive;
    }
    return self;
}

- (instancetype)initWithTypeIDs:(NSArray<NSString *> *)typeIDs
{
    self = [super init];
    if (self)
    {
        if (typeIDs)
        {
            _typeIDs = typeIDs;
        }
        
        self.state = MHVThingStateActive;
    }
    return self;
}

- (instancetype)initWithTypeClass:(Class)typeClass
{
    NSString *typeID = [[MHVTypeSystem current] getTypeIDForClassName:NSStringFromClass(typeClass)];
    
    MHVCHECK_NOTNULL(typeID);
    
    return [self initWithTypeID:typeID];
}

@end


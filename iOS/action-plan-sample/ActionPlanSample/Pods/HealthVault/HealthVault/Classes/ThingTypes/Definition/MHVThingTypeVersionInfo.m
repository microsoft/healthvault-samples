//
//  MHVThingTypeVersionInfo.m
//  MHVLib
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

#import "MHVThingTypeVersionInfo.h"
#import "MHVThingTypeOrderByProperty.h"

static NSString* const c_element_version_type_id = @"version-type-id";
static NSString* const c_element_version_name = @"version-name";
static NSString* const c_element_version_sequence = @"version-sequence";
static NSString* const c_element_order_by_properties = @"order-by-properties";
static NSString* const c_element_property = @"property";

@implementation MHVThingTypeVersionInfo

- (void)deserializeAttributes:(XReader *) reader
{
    [super deserializeAttributes:reader];
    
    _versionTypeId = [[NSUUID alloc] initWithUUIDString:[reader readAttribute:c_element_version_type_id]];
    _name = [reader readAttribute:c_element_version_name];
    [reader readIntAttribute:c_element_version_sequence intValue:&_versionSequence];
}

- (void)deserialize:(XReader *)reader
{
    NSString *orderByProperties = [reader readElementRaw:c_element_order_by_properties];
    _orderByProperties = (NSArray *)[XSerializer newFromString:orderByProperties
                                                      withRoot:c_element_order_by_properties
                                                andElementName:c_element_property
                                                       asClass:[MHVThingTypeOrderByProperty class]
                                                 andArrayClass:[NSMutableArray class]];
}

@end

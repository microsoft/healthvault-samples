//
//  MHVThingTypeOrderByProperty.m
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

#import "MHVThingTypeOrderByProperty.h"
#import "MHVLinearItemTypePropertyConverer.h"

static NSString *const c_element_name = @"name";
static NSString *const c_element_type = @"type";
static NSString *const c_element_xpath = @"xpath";
static NSString *const c_element_converter = @"converter";

@implementation MHVThingTypeOrderByProperty

- (void)deserializeAttributes:(XReader *) reader
{
    [super deserializeAttributes:reader];
    
    _name = [reader readAttribute:c_element_name];
    _type = [reader readAttribute:c_element_type];
    _xpath = [reader readAttribute:c_element_xpath];
}

- (void)deserialize:(XReader *)reader
{
    _converter = [reader readElement:c_element_converter asClass:[MHVLinearItemTypePropertyConverer class]];
}

@end


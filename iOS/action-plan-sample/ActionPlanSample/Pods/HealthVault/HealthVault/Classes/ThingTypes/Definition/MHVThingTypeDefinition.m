//
//  MHVThingTypeDefinition.m
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

#import "MHVThingTypeDefinition.h"
#import "MHVBool.h"
#import "MHVThingTypeVersionInfo.h"

static NSString *const c_element_id = @"id";
static NSString *const c_element_name = @"name";
static NSString *const c_element_uncreatable = @"uncreatable";
static NSString *const c_element_immutable = @"immutable";
static NSString *const c_element_singleton = @"singleton";
static NSString *const c_element_xsd = @"xsd";
static NSString *const c_element_versions = @"versions";
static NSString *const c_element_version_info = @"version-info";
static NSString *const c_element_effective_date_xpath = @"effective-date-xpath";
static NSString *const c_element_updated_end_date_xpath =@"updated-end-date-xpath";
static NSString *const c_element_allow_readonly = @"allow-readonly";

@implementation MHVThingTypeDefinition

- (void)deserialize:(XReader *)reader
{
    _typeId = [[NSUUID alloc] initWithUUIDString:[reader readStringElement:c_element_id]];
    _name = [reader readStringElement:c_element_name];
    MHVBool *uncreatable = [reader readElement:c_element_uncreatable asClass:[MHVBool class]];
    
    if (uncreatable)
    {
        _isCreatable = [[MHVBool alloc] initWith:!uncreatable.value];
    
    }
    _isImmutable = [reader readElement:c_element_immutable asClass:[MHVBool class]];
    _isSingletonType = [reader readElement:c_element_singleton asClass:[MHVBool class]];
    _xmlSchemaDefinition = [reader readStringElement:c_element_xsd];
    
    NSString *versions = [reader readElementRaw:c_element_versions];
    _versions = (NSArray *)[XSerializer newFromString:versions
                                             withRoot:c_element_versions
                                       andElementName:c_element_version_info
                                              asClass:[MHVThingTypeVersionInfo class]
                                        andArrayClass:[NSMutableArray class]];
    
    _effectiveDateXPath = [reader readStringElement:c_element_effective_date_xpath];
    _updatedEndDateXPath = [reader readStringElement:c_element_updated_end_date_xpath];
    _allowReadOnly = [reader readElement:c_element_allow_readonly asClass:[MHVBool class]];
}

@end

//
// MHVThingView.m
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
#import "MHVThingView.h"
#import "NSArray+Utils.h"

static NSString *const c_element_section = @"section";
static NSString *const c_element_xml = @"xml";
static NSString *const c_element_versions = @"type-version-format";

@interface MHVThingView ()

@end

@implementation MHVThingView

- (NSArray<NSString *> *)transforms
{
    if (!_transforms)
    {
        _transforms = [[NSArray alloc] init];
    }

    return _transforms;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _sections = MHVThingSection_Standard;

        _typeVersions = [[NSArray alloc] init];

        MHVCHECK_NOTNULL(_typeVersions);
    }

    return self;
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN;

    MHVVALIDATE_ARRAYOPTIONAL(self.typeVersions, MHVClientError_InvalidThingView);

    MHVVALIDATE_SUCCESS;
}

- (void)serialize:(XWriter *)writer
{
    NSArray<NSString *> *sections = [self createStringsFromSections];
    [writer writeElementArray:c_element_section elements:sections];
    if (self.sections & MHVThingSection_Data)
    {
        [writer writeEmptyElement:c_element_xml];
    }
    
    [writer writeElementArray:c_element_xml elements:self.transforms];
    [writer writeElementArray:c_element_versions elements:self.typeVersions];
}

- (void)deserialize:(XReader *)reader
{
    NSArray<NSString *> *sections = [reader readStringElementArray:c_element_section];
    self.transforms = [reader readStringElementArray:c_element_xml];
    self.typeVersions = [reader readStringElementArray:c_element_versions];
    
    self.sections = [self stringsToSections:sections];
    if ([self.transforms containsObject:@""])
    {
        self.sections |= MHVThingSection_Data;
        
        NSMutableArray *transformsCopy = [self.transforms mutableCopy];
        [transformsCopy removeObject:@""];
        self.transforms = transformsCopy;
    }
}

#pragma mark - Internal methods

- (NSArray<NSString *> *)createStringsFromSections
{
    NSMutableArray<NSString *> *array = [[NSMutableArray alloc] init];

    if (self.sections & MHVThingSection_Core)
    {
        [array addObject:MHVThingSectionToString(MHVThingSection_Core)];
    }

    if (self.sections & MHVThingSection_Audits)
    {
        [array addObject:MHVThingSectionToString(MHVThingSection_Audits)];
    }

    if (self.sections & MHVThingSection_Blobs)
    {
        [array addObject:MHVThingSectionToString(MHVThingSection_Blobs)];
    }

    if (self.sections & MHVThingSection_Tags)
    {
        [array addObject:MHVThingSectionToString(MHVThingSection_Tags)];
    }

    if (self.sections & MHVThingSection_Permissions)
    {
        [array addObject:MHVThingSectionToString(MHVThingSection_Permissions)];
    }

    if (self.sections & MHVThingSection_Signatures)
    {
        [array addObject:MHVThingSectionToString(MHVThingSection_Signatures)];
    }

    return array;
}

- (MHVThingSection)stringsToSections:(NSArray<NSString *> *)strings
{
    MHVThingSection section = MHVThingSection_None;

    if (![NSArray isNilOrEmpty:strings])
    {
        for (NSString *string in strings)
        {
            section |= MHVThingSectionFromString(string);
        }
    }

    return section;
}

@end

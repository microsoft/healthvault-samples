//
//  MHVThingTypeDefinitionRequestParameters.m
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

#import "MHVThingTypeDefinitionRequestParameters.h"

static NSString *const c_element_id = @"id";
static NSString *const c_element_section = @"section";
static NSString *const c_element_last_client_refresh = @"last-client-refresh";
static NSString *const c_element_image_type = @"image-type";

@interface MHVThingTypeDefinitionRequestParameters ()

@property (nonatomic, strong) NSArray<NSString *> *typeIds;
@property (nonatomic, assign) MHVThingTypeSections sections;
@property (nonatomic, strong) NSArray<NSString *> *imageTypes;
@property (nonatomic, strong) NSDate *lastClientRefreshDate;

@end

@implementation MHVThingTypeDefinitionRequestParameters

- (instancetype)initWithTypeIds:(NSArray<NSString *> *_Nullable)typeIds
                       sections:(MHVThingTypeSections)sections
                     imageTypes:(NSArray<NSString *> *_Nullable)imageTypes
          lastClientRefreshDate:(NSDate *_Nullable)lastClientRefreshDate
{
    self = [super init];
    
    if (self)
    {
        _typeIds = typeIds;
        _sections = sections;
        _imageTypes = imageTypes;
        _lastClientRefreshDate = lastClientRefreshDate;
    }
    
    return self;
}

- (void)serialize:(XWriter *)writer
{
    // Write each typeId as a separate element
    for (NSString *typeId in self.typeIds)
    {
        [writer writeElement:c_element_id value:typeId];
    }
    
    // Write each section
    if ((self.sections & MHVThingTypeSectionsCore) == MHVThingTypeSectionsCore)
    {
        [writer writeElement:c_element_section value:@"core"];
    }
    
    if ((self.sections & MHVThingTypeSectionsXsd) == MHVThingTypeSectionsXsd)
    {
        [writer writeElement:c_element_section value:@"xsd"];
    }
    
    if ((self.sections & MHVThingTypeSectionsVersions) == MHVThingTypeSectionsVersions)
    {
        [writer writeElement:c_element_section value:@"versions"];
    }
    
    if ((self.sections & MHVThingTypeSectionsEffectiveDateXPath) == MHVThingTypeSectionsEffectiveDateXPath)
    {
        [writer writeElement:c_element_section value:@"effectivedatexpath"];
    }
    
    // Write each image type as a separate element
    for (NSString *imageType in self.imageTypes)
    {
        [writer writeElement:c_element_image_type value:imageType];
    }
    
    // Write the last client refresh date (if not nil)
    if (self.lastClientRefreshDate)
    {
        [writer writeElement:c_element_last_client_refresh dateValue:self.lastClientRefreshDate];
    }
}

@end

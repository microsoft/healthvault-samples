//
//  MHVServiceDefinitionRequestParameters.m
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

#import "MHVServiceDefinitionRequestParameters.h"

static const xmlChar *x_element_updated_date = XMLSTRINGCONST("updated-date");
static NSString *const c_element_response_sections = @"response-sections";
static NSString *const c_element_section = @"section";

@interface MHVServiceDefinitionRequestParameters ()

@property (nonatomic, assign) MHVServiceInfoSections infoSections;
@property (nonatomic, strong) NSArray *sectionsArray;
@property (nonatomic, strong) NSDate *lastUpdatedTime;

@end

@implementation MHVServiceDefinitionRequestParameters

- (instancetype)initWithInfoSections:(MHVServiceInfoSections)infoSections
                     lastUpdatedTime:(NSDate *)lastUpdatedTime
{
    self = [super init];
    
    if (self)
    {
        _infoSections = infoSections;
        _lastUpdatedTime = lastUpdatedTime;
    }
    
    return self;
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementXmlName:x_element_updated_date dateValue:self.lastUpdatedTime];
    [writer writeElementArray:c_element_response_sections thingName:c_element_section elements:self.sectionsArray];
}

- (NSArray *)sectionsArray
{
    if (!_sectionsArray)
    {
        NSMutableArray *sections = [NSMutableArray new];
        
        if ((self.infoSections & MHVServiceInfoSectionsPlatform) == MHVServiceInfoSectionsPlatform)
        {
            [sections addObject:@"platform"];
        }
        
        if ((self.infoSections & MHVServiceInfoSectionsShell) == MHVServiceInfoSectionsShell)
        {
            [sections addObject:@"shell"];
        }
        
        if ((self.infoSections & MHVServiceInfoSectionsTopology) == MHVServiceInfoSectionsTopology)
        {
            [sections addObject:@"topology"];
        }
        
        if ((self.infoSections & MHVServiceInfoSectionsXmlOverHttpMethods) == MHVServiceInfoSectionsXmlOverHttpMethods)
        {
            [sections addObject:@"xml-over-http-methods"];
        }
        
        if ((self.infoSections & MHVServiceInfoSectionsMeaningfulUse) == MHVServiceInfoSectionsMeaningfulUse)
        {
            [sections addObject:@"meaningful-use"];
        }
        
        _sectionsArray = sections;
    }
    
    return _sectionsArray;
}

@end

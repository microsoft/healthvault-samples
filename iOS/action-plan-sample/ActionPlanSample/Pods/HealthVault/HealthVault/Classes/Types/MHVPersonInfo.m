//
// MHVPersonInfo.m
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
#import "MHVPersonInfo.h"
#import "NSArray+Utils.h"

static NSString *const c_element_id = @"person-id";
static NSString *const c_element_name = @"name";
static NSString *const c_element_settings = @"app-settings";
static NSString *const c_element_selectedID = @"selected-record-id";
static NSString *const c_element_more = @"more-records";
static NSString *const c_element_record = @"record";
static NSString *const c_element_groups = @"groups";
static NSString *const c_element_culture = @"preferred-culture";
static NSString *const c_element_uiculture = @"preferred-uiculture";

@interface MHVPersonInfo ()

@property (readwrite, nonatomic, strong) MHVApplicationSettings *applicationSettingsInternal;

@end

@implementation MHVPersonInfo

- (BOOL)hasRecords
{
    return !([NSArray isNilOrEmpty:self.records]);
}

- (NSString *)applicationSettings
{
    return self.applicationSettingsInternal.xmlSettings;
}

- (void)setApplicationSettings:(NSString *)applicationSettings
{
    if (!self.applicationSettingsInternal)
    {
        self.applicationSettingsInternal = [MHVApplicationSettings new];
    }
    
    self.applicationSettingsInternal.xmlSettings = applicationSettings;
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN;

    MHVVALIDATE_STRING(self.ID, MHVClientError_InvalidPersonInfo);
    MHVVALIDATE_ARRAY(self.records, MHVClientError_InvalidPersonInfo);

    MHVVALIDATE_SUCCESS;
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_id value:self.ID.UUIDString];
    [writer writeElement:c_element_name value:self.name];
    [writer writeElement:c_element_settings content:self.applicationSettingsInternal];
    [writer writeElement:c_element_selectedID value:self.selectedRecordID.UUIDString];
    [writer writeElement:c_element_more content:self.moreRecords];
    [writer writeElementArray:c_element_record elements:self.records];
    [writer writeRaw:self.groupsXml];
    [writer writeRaw:self.preferredCultureXml];
    [writer writeRaw:self.preferredUICultureXml];
}

- (void)deserialize:(XReader *)reader
{
    self.ID = [[NSUUID alloc] initWithUUIDString:[reader readStringElement:c_element_id]];
    self.name = [reader readStringElement:c_element_name];
    self.applicationSettingsInternal = [reader readElement:c_element_settings asClass:[MHVApplicationSettings class]];
    self.selectedRecordID = [[NSUUID alloc] initWithUUIDString:[reader readStringElement:c_element_selectedID]];
    self.moreRecords = [reader readElement:c_element_more asClass:[MHVBool class]];
    self.records = [reader readElementArray:c_element_record asClass:[MHVRecord class] andArrayClass:[NSMutableArray class]];
    self.groupsXml = [reader readElementRaw:c_element_groups];
    self.preferredCultureXml = [reader readElementRaw:c_element_culture];
    self.preferredUICultureXml = [reader readElementRaw:c_element_uiculture];
    //
    // Fix up records with personIDs
    //
    [self addPersonIDToRecords];
}

#pragma mark - Internal methods

- (void)addPersonIDToRecords
{
    for (MHVRecord *record in self.records)
    {
        record.personID = self.ID;
    }
}

@end


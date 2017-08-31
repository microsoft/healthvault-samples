//
// MHVPersonInfo.h
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

#import <Foundation/Foundation.h>
#import "MHVBaseTypes.h"
#import "MHVType.h"
#import "MHVRecord.h"
#import "MHVApplicationSettings.h"

@interface MHVPersonInfo : MHVType

@property (readwrite, nonatomic, strong) NSUUID *ID;
@property (readwrite, nonatomic, strong) NSString *name;
@property (readwrite, nonatomic, strong) NSUUID *selectedRecordID;
@property (readwrite, nonatomic, strong) MHVBool *moreRecords;
@property (readwrite, nonatomic, strong) NSArray<MHVRecord *> *records;
@property (readwrite, nonatomic, strong) NSString *groupsXml;
@property (readwrite, nonatomic, strong) NSString *preferredCultureXml;
@property (readwrite, nonatomic, strong) NSString *preferredUICultureXml;

/**
 * @note applicationSettings will not be processed by HealthVault, but must be valid XML
 */
@property (readwrite, nonatomic, strong) NSString *applicationSettings;

@property (readonly, nonatomic) BOOL hasRecords;

@end


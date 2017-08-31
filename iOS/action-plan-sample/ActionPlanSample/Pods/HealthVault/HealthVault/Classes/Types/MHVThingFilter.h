//
// MHVThingFilter.h
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
#import "MHVType.h"
#import "MHVThingState.h"

/**
 A object used to determines which Things are returned in a given query. All properties are optional.
 @note Each option is logically ANDed with the other options in the filter.
 */
@interface MHVThingFilter : MHVType

/**
 Only Things with the specified state will be returned.
 @note Although available as a filter field, the only allowed state for applications to specify is MHVThingStateActive, which is also the default.
 */
@property (readwrite, nonatomic) MHVThingState state;

/**
 Only Things with an effective date after the one specified will be returned.
 */
@property (readwrite, nonatomic, strong) NSDate *effectiveDateMin;

/**
 Only Things with an effective date before the date specified will be returned.
 */
@property (readwrite, nonatomic, strong) NSDate *effectiveDateMax;

/**
 Only Things that were created by the specified application will be returned.
 @note In the case of master-child and SODA applications, applications created based on the same master are not considered equivalent for this query. The child application identifier must be specified.
 */
@property (readwrite, nonatomic, strong) NSString *createdByAppID;

/**
 Only Things that were created by the specified person will be returned.
 */
@property (readwrite, nonatomic, strong) NSString *createdByPersonID;

/**
 Only Things that were last updated by the specified application will be returned.
 @note In the case of master-child and SODA applications, applications created based on the same master are not considered equivalent for this query. The child application identifier must be specified.
 */
@property (readwrite, nonatomic, strong) NSString *updatedByAppID;

/**
 Only Things that were last updated by the specified person will be returned.
 */
@property (readwrite, nonatomic, strong) NSString *updatedByPersonID;

/**
 Only Things that were created after the specified date will be returned.
 */
@property (readwrite, nonatomic, strong) NSDate *createDateMin;

/**
 Only Things that were created before the specified date will be returned.
 */
@property (readwrite, nonatomic, strong) NSDate *createDateMax;

/**
 Only Things that were last updated after the specified date will be returned.
 */
@property (readwrite, nonatomic, strong) NSDate *updateDateMin;

/**
 Only Things that were last updated before the specified date will be returned.
 */
@property (readwrite, nonatomic, strong) NSDate *updateDateMax;

/**
 A Boolean condition expressed in XPath into the data XML portion of the thing. Only items matching that expression are returned.
 @note HealthVault supports querying for things based on XPath predicates. The predicates define search criteria into the thing data.
 All XPaths must start with /thing/data-xml. HealthVault supports querying on any child element or attribute under data-xml. See https://docs.microsoft.com/en-us/healthvault/concepts/xml-api/querying-data
 */
@property (readwrite, nonatomic, strong) NSString *xpath;

/**
 Only Things that are of the given Type Id(s) contained in the collection will be returned.
 @note The Type Ids in this collection are logically ORed.
 */
@property (readonly, nonatomic, strong)  NSArray<NSString *> *typeIDs;

- (instancetype)initWithTypeID:(NSString *)typeID;
- (instancetype)initWithTypeIDs:(NSArray<NSString *> *)typeIDs;
- (instancetype)initWithTypeClass:(Class)typeClass;

@end


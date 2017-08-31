//
//  MHVThingTypeVersionInfo.h
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

#import "MHVType.h"

@class MHVThingTypeOrderByProperty;

NS_ASSUME_NONNULL_BEGIN


/**
 Represents the version information for a thing type.
 */
@interface MHVThingTypeVersionInfo : MHVType

/**
 A unique identifier for the versioned thing type.
 */
@property (nonatomic, strong, readonly, nullable) NSUUID *versionTypeId;

/**
 The name for this version of the thing type
 */
@property (nonatomic, strong, readonly, nullable) NSString *name;

/**
 The sequence number for the thing type version. The sequence number starts at one and is incremented for each new version of the type that gets added.
 */
@property (nonatomic, assign, readonly) int versionSequence;

/**
 The set of properties that the thing-type can be ordered by in the result.
 */
@property (nonatomic, strong, readonly, nullable) NSArray<MHVThingTypeOrderByProperty *> *orderByProperties;

@end

NS_ASSUME_NONNULL_END

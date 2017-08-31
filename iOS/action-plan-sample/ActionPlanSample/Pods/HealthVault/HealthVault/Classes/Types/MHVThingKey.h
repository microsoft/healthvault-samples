//
// MHVThingKey.h
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

@interface MHVThingKey : MHVType

@property (readwrite, nonatomic, strong) NSString *thingID;
@property (readwrite, nonatomic, strong) NSString *version;
@property (readonly, nonatomic, assign) BOOL hasVersion;

- (instancetype)initNew;
- (instancetype)initWithID:(NSString *)thingID;
- (instancetype)initWithID:(NSString *)thingID andVersion:(NSString *)version;
- (instancetype)initWithKey:(MHVThingKey *)key;

- (BOOL)isVersion:(NSString *)version;
- (BOOL)isLocal;

- (BOOL)isEqualToKey:(MHVThingKey *)key;

+ (MHVThingKey *)local;
+ (MHVThingKey *)newLocal;

@end

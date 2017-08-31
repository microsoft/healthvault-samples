//
// MHVJsonEnumProtocol.h
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

#ifndef MHVCommon_MHVJsonEnumProtocol_h
#define MHVCommon_MHVJsonEnumProtocol_h

#import <Foundation/Foundation.h>

static NSString *const kEnumUndefined = @"EnumUndefined";

@protocol MHVJsonEnumProtocol <NSObject>

- (instancetype)initWithString:(NSString *)string;
- (instancetype)initWithInteger:(NSInteger)integer;
- (instancetype)initWithObject:(id)object;

+ (NSObject<MHVJsonEnumProtocol> *)undefined;

+ (NSObject<MHVJsonEnumProtocol> *)fromString:(NSString *)string;

+ (NSObject<MHVJsonEnumProtocol> *)fromInteger:(NSInteger)integer;

- (NSString *)stringValue;

- (NSInteger)integerValue;

@end

#endif

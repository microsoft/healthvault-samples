//
// MHVEnum.h
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

#ifndef MHVCommon_MHVEnum_h
#define MHVCommon_MHVEnum_h

#import "MHVJsonEnumProtocol.h"

static NSString *kEnumSerializeAsNumber = @"SerializeAsNumber";

@interface MHVEnum : NSObject<MHVJsonEnumProtocol, NSCopying, NSCoding>

@property (nonatomic, assign, readonly) NSInteger   integerValue;
@property (nonatomic, strong, readonly) NSString    *stringValue;

- (instancetype)initWithString:(NSString *)string;
- (instancetype)initWithCaseInsensitiveString:(NSString *)string;
- (instancetype)initWithInteger:(NSInteger)integer;
- (BOOL)isEqualToEnum:(MHVEnum *)object;

- (instancetype)initWithObject:(id)object objectParameters:(NSObject*)ignored;
- (NSString*)jsonRepresentationWithObjectParameters:(NSObject*)ignored;

@end

#endif

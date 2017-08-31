//
// NSUUID+DataModel.m
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

#import "NSUUID+DataModel.h"
#import "MHVValidator.h"

@implementation NSUUID (DataModel)

- (instancetype)initWithObject:(id)object objectParameters:(NSObject*)ignored
{
    if (!object || [object isKindOfClass:[NSNull class]])
    {
        return nil;
    }
    else if ([object isKindOfClass:[NSString class]])
    {
        self = [self initWithUUIDString:object];
    }
    else if ([object isKindOfClass:[NSUUID class]])
    {
        self = [object copy];
    }
    else
    {
        MHVASSERT_TRUE(NO, @"Unsupported class: %@", NSStringFromClass([object class]));
    }
    return self;
}

- (NSString*)jsonRepresentationWithObjectParameters:(NSObject*)ignored
{
    return [NSString stringWithFormat:@"\"%@\"", [self UUIDString]];
}

@end

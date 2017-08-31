//
// NSData+DataModel.m
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

#import "NSData+DataModel.h"
#import "MHVValidator.h"

@implementation NSData (DataModel)

- (instancetype)initWithObject:(id)object objectParameters:(NSObject*)ignored
{
    if (!object || [object isKindOfClass:[NSNull class]])
    {
        return nil;
    }
    else if ([object isKindOfClass:[NSData class]])
    {
        self = [self initWithData:object];
    }
    else
    {
        MHVASSERT_TRUE(NO, [NSString stringWithFormat:@"Unsupported class: %@", NSStringFromClass([object class])]);
    }
    return self;
}

- (NSString*)jsonRepresentationWithObjectParameters:(NSObject*)ignored
{
    // TODO: supports UTF8 and base64 encoding should be added
    MHVASSERT_TRUE([((NSString *)ignored) isEqualToString:@"UTF8"], @"NSData+DataModel only supports UTF8");
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

@end

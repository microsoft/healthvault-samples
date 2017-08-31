//
// MHVConstrainedString.m
// MHVLib
//
// Copyright (c) 2012, 2014 Microsoft Corporation. All rights reserved.
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

#import "MHVConstrainedString.h"

@implementation MHVString

- (NSUInteger)length
{
    return (self.value != nil) ? self.value.length : 0;
}

- (instancetype)initWith:(NSString *)value
{
    self = [super init];
    if (self)
    {
        _value = value;
    }

    return self;
}

- (NSString *)description
{
    return self.value;
}

- (void)serialize:(XWriter *)writer
{
    [writer writeText:self.value];
}

- (void)deserialize:(XReader *)reader
{
    self.value = [reader readValue];
}

- (BOOL)isEqual:(id)string
{
    if ([string isKindOfClass:[NSString class]])
    {
        return [self.value isEqualToString:(NSString *)string];
    }
    else if ([string isKindOfClass:[MHVString class]])
    {
        return [self.value isEqualToString:((MHVString *)string).value];
    }
    return NO;
}

@end


@implementation MHVConstrainedString

- (NSUInteger)minLength
{
    return 1;
}

- (NSUInteger)maxLength
{
    return INT32_MAX;
}

- (MHVClientResult *)validate
{
    if ([self validateValue:self.value])
    {
        return MHVRESULT_SUCCESS;
    }
    else
    {
        return MHVMAKE_ERROR(MHVClientError_ValueOutOfRange);
    }
}

- (BOOL)validateValue:(NSString *)value
{
    int length = (value != nil) ? (int)value.length : 0;

    return self.minLength <= length && length <= self.maxLength;
}

@end

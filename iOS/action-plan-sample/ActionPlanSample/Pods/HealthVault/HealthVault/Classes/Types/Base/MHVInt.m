//
// MHVInt.m
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

#import "MHVInt.h"
#import "MHVValidator.h"

@implementation MHVInt

- (instancetype)initWith:(int)value
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
    return [self toString];
}

- (NSString *)toString
{
    return [self toStringWithFormat:@"%d"];
}

- (NSString *)toStringWithFormat:(NSString *)format
{
    return [NSString localizedStringWithFormat:format, self.value];
}

- (void)serialize:(XWriter *)writer
{
    [writer writeInt:self.value];
}

- (void)deserialize:(XReader *)reader
{
    self.value = [reader readInt];
}

+ (MHVInt *)fromInt:(int)value
{
    return [[MHVInt alloc] initWith:value];
}

@end

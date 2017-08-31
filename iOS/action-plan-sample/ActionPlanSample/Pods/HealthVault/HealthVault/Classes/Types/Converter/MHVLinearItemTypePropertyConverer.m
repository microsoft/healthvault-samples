//
//  MHVLinearItemTypePropertyConverer.m
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

#import "MHVLinearItemTypePropertyConverer.h"

static const xmlChar *x_element_offset = XMLSTRINGCONST("offset");
static const xmlChar *x_element_multiplier = XMLSTRINGCONST("multiplier");

@implementation MHVLinearItemTypePropertyConverer

- (instancetype)initWithMultiplier:(double)multiplier offset:(double)offset
{
    self = [super init];
    
    if (self)
    {
        _multiplier = multiplier;
        _offset = offset;
    }
    
    return self;
}

- (double)convertDoubleValue:(double)doubleValue
{
    return (doubleValue * self.multiplier) + self.offset;
}

- (void)deserialize:(XReader *)reader
{
    _offset = [reader readDoubleElementXmlName:x_element_offset];
    _multiplier = [reader readDoubleElementXmlName:x_element_multiplier];
}

@end

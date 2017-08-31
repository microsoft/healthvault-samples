//
// MHVThingRaw.m
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

#import "MHVValidator.h"
#import "MHVThingRaw.h"

@interface MHVThingRaw ()

@property (nonatomic, strong) NSString *root;

@end

@implementation MHVThingRaw

- (BOOL)hasRawData
{
    return TRUE;
}

- (NSString *)rootElement
{
    return self.root;
}

- (void)serialize:(XWriter *)writer
{
    if (self.xml)
    {
        [writer writeRaw:self.xml];
    }
}

- (void)deserialize:(XReader *)reader
{
    self.root = reader.localName;
    self.xml = [reader readElementRaw:self.root];
}

@end

//
// MHVThingQueryResult.m
// healthvault-ios-sdk
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

#import "MHVThingQueryResult.h"

@implementation MHVThingQueryResult

- (instancetype)initWithName:(NSString *)name
                      things:(NSArray<MHVThing *> *)things
                       count:(NSInteger)count
              isCachedResult:(BOOL)isCachedResult
{
    self = [super init];
    
    if (self)
    {
        _name = name;
        _things = things;
        _count = count;
        _isCachedResult = isCachedResult;
    }
    
    return self;
}

@end


//
//  MHVAlert.m
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

#import "MHVAlert.h"

static NSString *const c_element_dow = @"dow";
static NSString *const c_element_time = @"time";

@implementation MHVAlert

-(void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_dow content:self.dow];
    [writer writeElement:c_element_time content:self.time];
}

- (void)deserialize:(XReader *)reader
{
    self.dow = [reader readElement:c_element_dow asClass:[MHVDow class]];
    self.time = [reader readElement:c_element_time asClass:[MHVTime class]];
}

@end


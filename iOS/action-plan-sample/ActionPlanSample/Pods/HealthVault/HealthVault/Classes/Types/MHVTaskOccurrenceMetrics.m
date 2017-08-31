//
//  MHVTaskOccurrenceMetrics.m
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

#import "MHVTaskOccurrenceMetrics.h"

static NSString *const c_element_evaluate_targets = @"evaluate-targets";
static NSString *const c_element_targets = @"targets";

@implementation MHVTaskOccurrenceMetrics

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_evaluate_targets content:self.evaulateTargets];
    [writer writeElementArray:c_element_targets elements:self.targets];
}

- (void)deserialize:(XReader *)reader
{
    self.evaulateTargets = [reader readElement:c_element_evaluate_targets asClass:[MHVBool class]];
    self.targets = [reader readElementArray:c_element_targets asClass:[MHVTaskRangeMetrics class] andArrayClass:[NSMutableArray class]];
}

@end

//
// MHVGetRecordOperationsResult.m
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
//

#import "MHVGetRecordOperationsResult.h"

static NSString *const c_element_latest_sequence = @"latest-record-operation-sequence-number";
static NSString *const c_element_operations = @"operations";
static NSString *const c_element_record_operation = @"record-operation";

@implementation MHVGetRecordOperationsResult

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_latest_sequence intValue:(int)self.latestRecordOperationSequenceNumber];
    [writer writeElementArray:c_element_operations elements:self.operations];
}

- (void)deserialize:(XReader *)reader
{
    self.latestRecordOperationSequenceNumber = [reader readIntElement:c_element_latest_sequence];
    
    if ([reader isStartElementWithName:c_element_operations])
    {
        self.operations = [reader readElementArray:c_element_operations
                                         thingName:c_element_record_operation
                                           asClass:[MHVRecordOperation class]
                                     andArrayClass:[NSMutableArray class]];
    }
}

@end

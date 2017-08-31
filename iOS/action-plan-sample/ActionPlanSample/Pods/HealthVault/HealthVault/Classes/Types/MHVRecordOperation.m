//
// MHVRecordOperation.h
// MHVLib
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

#import "MHVRecordOperation.h"

static NSString *const c_element_operation = @"operation";
static NSString *const c_element_sequence_number = @"sequence-number";
static NSString *const c_element_thing_id = @"thing-id";
static NSString *const c_element_type_id = @"type-id";
static NSString *const c_element_eff_date = @"eff-date";
static NSString *const c_element_updated_end_date = @"updated-end-date";

@implementation MHVRecordOperation

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_operation value:self.operation];
    [writer writeElement:c_element_sequence_number intValue:self.sequenceNumber];
    [writer writeElement:c_element_thing_id value:self.thingId];
    [writer writeElement:c_element_type_id value:self.typeId];
    [writer writeElement:c_element_eff_date dateValue:self.effectiveDate];
    [writer writeElement:c_element_updated_end_date dateValue:self.updatedEndDate];
}

- (void)deserialize:(XReader *)reader
{
    self.operation = [reader readStringElement:c_element_operation];
    self.sequenceNumber = [reader readIntElement:c_element_sequence_number];
    self.thingId = [reader readStringElement:c_element_thing_id];
    self.typeId = [reader readStringElement:c_element_type_id];
    self.effectiveDate = [reader readDateElement:c_element_eff_date];
    self.updatedEndDate = [reader readDateElement:c_element_updated_end_date];
}

@end

//
//  MHVTaskTrackingEntry.m
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

#import "MHVTaskTrackingEntry.h"

static NSString *const c_typeid = @"b54a6e00-c1fb-4e22-8694-0a4ae94e8cb6";
static NSString *const c_typename = @"task-tracking-entry";

static NSString *const c_element_tracking_time = @"tracking-time";
static NSString *const c_element_tracking_type = @"tracking-type";
static NSString *const c_element_tracking_status = @"tracking-status";
static NSString *const c_element_occurrence_start_time = @"occurrence-start-time";
static NSString *const c_element_occurrence_end_time = @"occurrence-end-time";
static NSString *const c_element_completion_start_time = @"completion-start-time";
static NSString *const c_element_completion_end_time = @"completion-end-time";

@implementation MHVTaskTrackingEntry

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_tracking_time content:self.trackingTime];
    [writer writeElement:c_element_tracking_type value:self.trackingType.stringValue];
    [writer writeElement:c_element_tracking_status value:self.trackingStatus.stringValue];
    [writer writeElement:c_element_occurrence_start_time content:self.occurrenceStartTime];
    [writer writeElement:c_element_occurrence_end_time content:self.occurrenceEndTime];
    [writer writeElement:c_element_completion_start_time content:self.completionStartTime];
    [writer writeElement:c_element_completion_end_time content:self.completionEndTime];
}

- (void)deserialize:(XReader *)reader
{
    self.trackingTime = [reader readElement:c_element_tracking_time asClass:[MHVDateTime class]];
    self.trackingType = [[MHVActionPlanTaskTrackingTrackingTypeEnum alloc] initWithString:[reader readStringElement:c_element_tracking_type]];
    self.trackingStatus = [[MHVActionPlanTaskTrackingTrackingStatusEnum alloc] initWithString:[reader readStringElement:c_element_tracking_status]];
    self.occurrenceStartTime = [reader readElement:c_element_occurrence_start_time asClass:[MHVDateTime class]];
    self.occurrenceEndTime = [reader readElement:c_element_occurrence_end_time asClass:[MHVDateTime class]];
    self.completionStartTime = [reader readElement:c_element_completion_start_time asClass:[MHVDateTime class]];
    self.completionEndTime = [reader readElement:c_element_completion_end_time asClass:[MHVDateTime class]];
}

+ (NSString *)typeID
{
    return c_typeid;
}

+ (NSString *)XRootElement
{
    return c_typename;
}

@end

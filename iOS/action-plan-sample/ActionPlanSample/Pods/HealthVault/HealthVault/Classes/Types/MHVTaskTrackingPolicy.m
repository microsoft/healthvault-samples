//
//  MHVTaskTrackingPolicy.m
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

#import "MHVTaskTrackingPolicy.h"

NSString *const c_element_is_auto_trackable = @"is-auto-trackable";
NSString *const c_element_source_types = @"source-types";
NSString *const c_element_trigger_types = @"trigger-types";
NSString *const c_element_occurrence_metrics = @"occurrence-metrics";
NSString *const c_element_completion_metrics = @"completion-metrics";
NSString *const c_element_target_events = @"target-events";

@implementation MHVTaskTrackingPolicy

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_is_auto_trackable content:self.isAutoTrackable];
    [writer writeElement:c_element_source_types content:self.sourceTypes];
    [writer writeElement:c_element_trigger_types content:self.triggerTypes];
    [writer writeElement:c_element_occurrence_metrics content:self.occurrenceMetrics];
    [writer writeElement:c_element_completion_metrics content:self.completionMetrics];
    [writer writeElement:c_element_target_events content:self.targetEvents];
}

- (void)deserialize:(XReader *)reader
{
    self.isAutoTrackable = [reader readElement:c_element_is_auto_trackable asClass:[MHVBool class]];
    self.sourceTypes = [reader readElement:c_element_source_types asClass:[MHVTrackingSourceTypes class]];
    self.triggerTypes = [reader readElement:c_element_trigger_types asClass:[MHVTrackingTriggerTypes class]];
    self.occurrenceMetrics = [reader readElement:c_element_occurrence_metrics asClass:[MHVTaskOccurrenceMetrics class]];
    self.completionMetrics = [reader readElement:c_element_completion_metrics asClass:[MHVTaskCompletionMetrics class]];
    self.targetEvents = [reader readElement:c_element_target_events asClass:[MHVTaskTargetEvents class]];
}

@end

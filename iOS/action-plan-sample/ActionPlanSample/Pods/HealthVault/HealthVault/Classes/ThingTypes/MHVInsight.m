//
//  MHVInsight.m
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

#import "MHVInsight.h"

static NSString *const c_typeid = @"5d15b7bc-0499-4dc4-8df7-ef1a2332cfb5";
static NSString *const c_typename = @"insight";

static NSString *const c_element_raised_insight_id = @"raised-insight-id";
static NSString *const c_element_catalog_id = @"catalog-id";
static NSString *const c_element_when = @"when";
static NSString *const c_element_expiration_date = @"expiration-date";
static NSString *const c_element_channel = @"channel";
static NSString *const c_element_algo_class = @"algo-class";
static NSString *const c_element_directionality = @"directionality";
static NSString *const c_element_time_span_pivot = @"time-span-pivot";
static NSString *const c_element_comparison_pivot = @"comparison-pivot";
static NSString *const c_element_tone_pivot = @"tone-pivot";
static NSString *const c_element_scope_pivot = @"scope-pivot";
static NSString *const c_element_data_used_pivot = @"data-used-pivot";
static NSString *const c_element_annotation = @"annotation";
static NSString *const c_element_strength = @"strength";
static NSString *const c_element_confidence = @"confidence";
static NSString *const c_element_origin = @"origin";
static NSString *const c_element_tags = @"tags";
static NSString *const c_element_values = @"values";
static NSString *const c_element_links = @"links";
static NSString *const c_element_messages = @"messages";
static NSString *const c_element_attribution = @"attribution";

@implementation MHVInsight

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_raised_insight_id content:self.raisedInsightId];
    [writer writeElement:c_element_catalog_id content:self.catalogId];
    [writer writeElement:c_element_when content:self.when];
    [writer writeElement:c_element_expiration_date content:self.expirationDate];
    [writer writeElement:c_element_channel content:self.channel];
    [writer writeElement:c_element_algo_class content:self.catalogId];
    [writer writeElement:c_element_directionality content:self.directionality];
    [writer writeElement:c_element_time_span_pivot content:self.timeSpanPivot];
    [writer writeElement:c_element_comparison_pivot content:self.comparisonPivot];
    [writer writeElement:c_element_tone_pivot content:self.tonePivot];
    [writer writeElement:c_element_scope_pivot content:self.scopePivot];
    [writer writeElementArray:c_element_data_used_pivot elements:self.dataUsedPivot];
    [writer writeElement:c_element_annotation value:self.annotation];
    [writer writeElement:c_element_strength content:self.strength];
    [writer writeElement:c_element_confidence content:self.confidence];
    [writer writeElementArray:c_element_tags elements:self.tags];
    [writer writeElementArray:c_element_values elements:self.values];
    [writer writeElementArray:c_element_links elements:self.links];
    [writer writeElement:c_element_messages content:self.messages];
    [writer writeElement:c_element_attribution content:self.attribution];
}

- (void)deserialize:(XReader *)reader
{
    self.raisedInsightId = [reader readElement:c_element_raised_insight_id asClass:[MHVString128 class]];
    self.catalogId = [reader readElement:c_element_catalog_id asClass:[MHVString128 class]];
    self.when = [reader readElement:c_element_when asClass:[MHVDateTime class]];
    self.expirationDate = [reader readElement:c_element_expiration_date asClass:[MHVDateTime class]];
    self.channel = [reader readElement:c_element_channel asClass:[MHVString128 class]];
    self.catalogId = [reader readElement:c_element_algo_class asClass:[MHVString128 class]];
    self.directionality = [reader readElement:c_element_directionality asClass:[MHVString128 class]];
    self.timeSpanPivot = [reader readElement:c_element_time_span_pivot asClass:[MHVString128 class]];
    self.comparisonPivot = [reader readElement:c_element_comparison_pivot asClass:[MHVString128 class]];
    self.tonePivot = [reader readElement:c_element_tone_pivot asClass:[MHVString128 class]];
    self.scopePivot = [reader readElement:c_element_scope_pivot asClass:[MHVString128 class]];
    self.dataUsedPivot = [reader readElementArray:c_element_data_used_pivot asClass:[MHVString class] andArrayClass:[NSMutableArray class]];
    self.annotation = [reader readStringElement:c_element_annotation];
    self.strength = [reader readElement:c_element_strength asClass:[MHVPositiveDouble class]];
    self.confidence = [reader readElement:c_element_confidence asClass:[MHVPositiveDouble class]];
    self.tags = [reader readElementArray:c_element_tags asClass:[MHVString1024NW class] andArrayClass:[NSMutableArray class]];
    self.values = [reader readElementArray:c_element_values asClass:[MHVStructuredInsightValue class] andArrayClass:[NSMutableArray class]];
    self.links = [reader readElementArray:c_element_links asClass:[MHVStructuredInsightValue class] andArrayClass:[NSMutableArray class]];
    self.messages = [reader readElement:c_element_messages asClass:[MHVInsightMessages class]];
    self.attribution = [reader readElement:c_element_attribution asClass:[MHVInsightAttribution class]];
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

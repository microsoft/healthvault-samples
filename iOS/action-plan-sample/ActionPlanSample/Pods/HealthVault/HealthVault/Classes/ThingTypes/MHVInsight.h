//
//  MHVInsight.h
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

#import "MHVThing.h"
#import "MHVString128.h"
#import "MHVString1024.h"
#import "MHVStructuredInsightValue.h"
#import "MHVInsightMessages.h"
#import "MHVInsightAttribution.h"

@interface MHVInsight : MHVThingDataTyped

//
// (Required) Unique id of this insight instance.
//
@property (readwrite, nonatomic, strong) MHVString128 *raisedInsightId;
//
// (Required) Id of the catalog item for this insight.
//
@property (readwrite, nonatomic, strong) MHVString128 *catalogId;
//
// (Required) The date and time the insight was created.
//
@property (readwrite, nonatomic, strong) MHVDateTime *when;
//
// (Required) Date when the insight expires.
//
@property (readwrite, nonatomic, strong) MHVDateTime* expirationDate;
//
// (Optional) Shows what does this Insight impact. For example sleep or activity etc.
//
@property (readwrite, nonatomic, strong) MHVString128 *channel;
//
// (Optional) Represents the algorithm class used to create this Insight.
//
@property (readwrite, nonatomic, strong) MHVString128 *algoClass;
//
// (Optional) Represents which way the Insight is trending. For example positive, negative or neutral.
//
@property (readwrite, nonatomic, strong) MHVString128 *directionality;
//
// (Optional) Represents the aggregation time span of the data. For example, data is aggregated weekly or daily.
//
@property (readwrite, nonatomic, strong) MHVString128 *timeSpanPivot;
//
// (Optional) Represents how the user was compared for deriving this Insight. Example with themselves or people similar to the user.
//
@property (readwrite, nonatomic, strong) MHVString128 *comparisonPivot;
//
// (Optional) Represents the tone of the Insight, like better or worse.
//
@property (readwrite, nonatomic, strong) MHVString128 *tonePivot;
//
// (Optional) Represents the scope of the Insight. For example, for a specific event or event types.
//
@property (readwrite, nonatomic, strong) MHVString128 *scopePivot;
//
// (Optional) Represents a list of data types used as input to the insight calculation.
//
@property (readwrite, nonatomic, strong) NSArray<NSString *> *dataUsedPivot;
//
// (Optional) Describes how we got to this conclusion and why this Insight is relevant to the user.
//
@property (readwrite, nonatomic, strong) NSString *annotation;
//
// (Optional) Represents the strength of the data used for calculating the Insights.
//
@property (readwrite, nonatomic, strong) MHVPositiveDouble *strength;
//
// (Optional) Confidence level of our result.
//
@property (readwrite, nonatomic, strong) MHVPositiveDouble *confidence;
//
// (Optional) Where was this insight generated.
//
@property (readwrite, nonatomic, strong) MHVString128 *origin;
//
// (Optional) Tags associated with this insight. Can be used by clients for grouping, filtering etc.
//
@property (readwrite, nonatomic, strong) NSArray<MHVString1024NW *> *tags;
//
// (Optional) Values associated with the insight message. Each value will be a parameter to a format string.
//
@property (readwrite, nonatomic, strong) NSArray<MHVStructuredInsightValue *> *values;
//
// (Optional) List of actions associated with this insight.
//
@property (readwrite, nonatomic, strong) NSArray<MHVStructuredInsightValue *> *links;
//
// (Optional) Collection of message strings associated with this Insight.
//
@property (readwrite, nonatomic, strong) MHVInsightMessages *messages;
//
// (Optional) Attribution related information for this Insight.
//
@property (readwrite, nonatomic, strong) MHVInsightAttribution *attribution;

@end

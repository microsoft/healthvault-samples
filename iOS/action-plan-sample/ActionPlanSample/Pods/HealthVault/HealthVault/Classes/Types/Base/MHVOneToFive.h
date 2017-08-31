//
// MHVOneToFive.h
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

#import <Foundation/Foundation.h>
#import "MHVConstrainedInt.h"

typedef NS_ENUM (NSInteger, MHVRelativeRating)
{
    MHVRelativeRating_None = 0,
    MHVRelativeRating_VeryLow,
    MHVRelativeRating_Low,
    MHVRelativeRating_Moderate,
    MHVRelativeRating_High,
    MHVRelativeRating_VeryHigh
};

NSString *stringFromRating(MHVRelativeRating rating);

typedef NS_ENUM (NSInteger, MHVNormalcyRating)
{
    MHVNormalcy_Unknown = 0,
    MHVNormalcy_WellBelowNormal,
    MHVNormalcy_BelowNormal,
    MHVNormalcy_Normal,
    MHVNormalcy_AboveNormal,
    MHVNormalcy_WellAboveNormal
};

NSString *stringFromNormalcy(MHVNormalcyRating rating);


@interface MHVOneToFive : MHVConstrainedInt

@end

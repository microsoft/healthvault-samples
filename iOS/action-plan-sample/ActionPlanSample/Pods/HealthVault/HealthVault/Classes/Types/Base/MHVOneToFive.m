//
// MHVOneToFive.m
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

#import "MHVOneToFive.h"

NSString *stringFromRating(MHVRelativeRating rating)
{
    switch (rating)
    {
        case MHVRelativeRating_VeryLow:
            return @"Very Low";

        case MHVRelativeRating_Low:
            return @"Low";

        case MHVRelativeRating_Moderate:
            return @"Moderate";

        case MHVRelativeRating_High:
            return @"High";

        case MHVRelativeRating_VeryHigh:
            return @"Very High";

        default:
            break;
    }

    return @"";
}

NSString *stringFromNormalcy(MHVNormalcyRating rating)
{
    switch (rating)
    {
        case MHVNormalcy_WellAboveNormal:
            return @"Well Below Normal";

        case MHVNormalcy_BelowNormal:
            return @"Below Normal";

        case MHVNormalcy_Normal:
            return @"Normal";

        case MHVNormalcy_AboveNormal:
            return @"Above Normal";

        case MHVNormalcy_WellBelowNormal:
            return @"Well Above Normal";

        default:
            break;
    }

    return @"";
}

@implementation MHVOneToFive

- (int)min
{
    return 1;
}

- (int)max
{
    return 5;
}

@end

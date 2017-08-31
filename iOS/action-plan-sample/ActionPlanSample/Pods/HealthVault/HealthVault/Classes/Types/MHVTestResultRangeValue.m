//
// MHVTestResultRangeValue.m
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

#import "MHVValidator.h"
#import "MHVTestResultRangeValue.h"

static const xmlChar *x_element_minRange = XMLSTRINGCONST("minimum-range");
static const xmlChar *x_element_maxRange = XMLSTRINGCONST("maximum-range");

@implementation MHVTestResultRangeValue

- (double)minRangeValue
{
    return self.minRange ? self.minRange.value : NAN;
}

- (void)setMinRangeValue:(double)minRangeValue
{
    if (isnan(minRangeValue))
    {
        self.minRange = nil;
    }
    else
    {
        if (!self.minRange)
        {
            self.minRange = [[MHVDouble alloc] init];
        }
        
        self.minRange.value = minRangeValue;
    }
}

- (double)maxRangeValue
{
    return self.maxRange ? self.maxRange.value : NAN;
}

- (void)setMaxRangeValue:(double)maxRangeValue
{
    if (isnan(maxRangeValue))
    {
        self.maxRange = nil;
    }
    else
    {
        if (!self.maxRange)
        {
            self.maxRange = [[MHVDouble alloc] init];
        }
        
        self.maxRange.value = maxRangeValue;
    }
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementXmlName:x_element_minRange content:self.minRange];
    [writer writeElementXmlName:x_element_maxRange content:self.maxRange];
}

- (void)deserialize:(XReader *)reader
{
    self.minRange = [reader readElementWithXmlName:x_element_minRange asClass:[MHVDouble class]];
    self.maxRange = [reader readElementWithXmlName:x_element_maxRange asClass:[MHVDouble class]];
}

@end

//
// MHVPeakFlow.m
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
//

#import "MHVValidator.h"
#import "MHVPeakFlow.h"

static NSString *const c_typeID = @"5d8419af-90f0-4875-a370-0f881c18f6b3";
static NSString *const c_typeName = @"peak-flow";

static const xmlChar *x_element_when = XMLSTRINGCONST("when");
static const xmlChar *x_element_pef = XMLSTRINGCONST("pef");
static const xmlChar *x_element_fev1 = XMLSTRINGCONST("fev1");
static const xmlChar *x_element_fev6 = XMLSTRINGCONST("fev6");
static const xmlChar *x_element_flags = XMLSTRINGCONST("measurement-flags");

@implementation MHVPeakFlow

- (double)pefValue
{
    return (self.peakExpiratoryFlow) ? self.peakExpiratoryFlow.litersPerSecondValue : NAN;
}

- (void)setPefValue:(double)pefValue
{
    if (isnan(pefValue))
    {
        self.peakExpiratoryFlow = nil;
    }
    else
    {
        if (!self.peakExpiratoryFlow)
        {
            self.peakExpiratoryFlow = [[MHVFlowValue alloc] init];
        }
        
        self.peakExpiratoryFlow.litersPerSecondValue = pefValue;
    }
}

- (instancetype)initWithDate:(NSDate *)when
{
    self = [super init];
    if (self)
    {
        _when = [[MHVApproxDateTime alloc] initWithDate:when];
        MHVCHECK_NOTNULL(_when);
    }
    
    return self;
}

- (NSDate *)getDate
{
    return [self.when toDate];
}

- (NSDate *)getDateForCalendar:(NSCalendar *)calendar
{
    return [self.when toDateForCalendar:calendar];
}

- (NSString *)toString
{
    return [NSString localizedStringWithFormat:@"pef: %@, fev1: %@",
            self.peakExpiratoryFlow ? [self.peakExpiratoryFlow toString] : @"",
            self.forcedExpiratoryVolume1 ? [self.forcedExpiratoryVolume1 toString] : @""];
}

- (NSString *)description
{
    return [self toString];
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN;
    
    MHVVALIDATE(self.when, MHVClientError_InvalidPeakFlow);
    MHVVALIDATE_OPTIONAL(self.peakExpiratoryFlow);
    MHVVALIDATE_OPTIONAL(self.forcedExpiratoryVolume1);
    MHVVALIDATE_OPTIONAL(self.forcedExpiratoryVolume6);
    MHVVALIDATE_OPTIONAL(self.flags);
    
    MHVVALIDATE_SUCCESS;
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementXmlName:x_element_when content:self.when];
    [writer writeElementXmlName:x_element_pef content:self.peakExpiratoryFlow];
    [writer writeElementXmlName:x_element_fev1 content:self.forcedExpiratoryVolume1];
    [writer writeElementXmlName:x_element_fev6 content:self.forcedExpiratoryVolume6];
    [writer writeElementXmlName:x_element_flags content:self.flags];
}

- (void)deserialize:(XReader *)reader
{
    self.when = [reader readElementWithXmlName:x_element_when asClass:[MHVApproxDateTime class]];
    self.peakExpiratoryFlow = [reader readElementWithXmlName:x_element_pef asClass:[MHVFlowValue class]];
    self.forcedExpiratoryVolume1 = [reader readElementWithXmlName:x_element_fev1 asClass:[MHVVolumeValue class]];
    self.forcedExpiratoryVolume6 = [reader readElementWithXmlName:x_element_fev6 asClass:[MHVVolumeValue class]];
    self.flags = [reader readElementWithXmlName:x_element_flags asClass:[MHVCodableValue class]];
}

+ (NSString *)typeID
{
    return c_typeID;
}

+ (NSString *)XRootElement
{
    return c_typeName;
}

+ (MHVThing *)newThing
{
    return [[MHVThing alloc] initWithType:[MHVPeakFlow typeID]];
}

- (NSString *)typeName
{
    return NSLocalizedString(@"Peak Flow", @"Peak Flow Type Name");
}

@end

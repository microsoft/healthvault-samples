//
// MHVApproxMeasurement.m
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

#import "MHVApproxMeasurement.h"
#import "MHVValidator.h"

static NSString *const c_element_display = @"display";
static NSString *const c_element_structured = @"structured";

@implementation MHVApproxMeasurement

- (BOOL)hasMeasurement
{
    return self.measurement != nil;
}

- (instancetype)initWithDisplayText:(NSString *)text
{
    return [self initWithDisplayText:text andMeasurement:nil];
}

- (instancetype)initWithDisplayText:(NSString *)text andMeasurement:(MHVMeasurement *)measurement
{
    MHVCHECK_STRING(text);

    self = [super init];
    if (self)
    {
        _displayText = text;
        
        if (measurement)
        {
            _measurement = measurement;
        }
    }
    return self;
}

+ (MHVApproxMeasurement *)fromDisplayText:(NSString *)text
{
    return [[MHVApproxMeasurement alloc] initWithDisplayText:text];
}

+ (MHVApproxMeasurement *)fromDisplayText:(NSString *)text andMeasurement:(MHVMeasurement *)measurement
{
    return [[MHVApproxMeasurement alloc] initWithDisplayText:text andMeasurement:measurement];
}

+ (MHVApproxMeasurement *)fromValue:(double)value unitsText:(NSString *)unitsText unitsCode:(NSString *)code unitsVocab:(NSString *)vocab
{
    MHVMeasurement *measurement = [MHVMeasurement fromValue:value unitsDisplayText:unitsText unitsCode:code unitsVocab:vocab];

    MHVCHECK_NOTNULL(measurement);

    NSString *displayText = [NSString localizedStringWithFormat:@"%g %@", value, unitsText];
    MHVCHECK_NOTNULL(displayText);

    MHVApproxMeasurement *approxMeasurement = [MHVApproxMeasurement fromDisplayText:displayText andMeasurement:measurement];
    return approxMeasurement;
}

- (NSString *)description
{
    return [self toString];
}

- (NSString *)toString
{
    if (self.displayText)
    {
        return self.displayText;
    }

    if (self.measurement)
    {
        return [self.measurement toString];
    }

    return @"";
}

- (NSString *)toStringWithFormat:(NSString *)format
{
    if (self.measurement)
    {
        return [self.measurement toStringWithFormat:format];
    }

    return (self.displayText) ? self.displayText : @"";
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN

    MHVVALIDATE_STRING(self.displayText, MHVClientError_InvalidApproxMeasurement);

    MHVVALIDATE_OPTIONAL(self.measurement);

    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_display value:self.displayText];
    [writer writeElement:c_element_structured content:self.measurement];
}

- (void)deserialize:(XReader *)reader
{
    self.displayText = [reader readStringElement:c_element_display];
    self.measurement = [reader readElement:c_element_structured asClass:[MHVMeasurement class]];
}

@end

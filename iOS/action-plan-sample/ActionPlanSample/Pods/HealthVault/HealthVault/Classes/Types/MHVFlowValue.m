//
// MHVFlowValue.m
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

#import "MHVFlowValue.h"
#import "MHVValidator.h"

static const xmlChar *x_element_litersPerSecond = XMLSTRINGCONST("liters-per-second");
static const xmlChar *x_element_displayValue = XMLSTRINGCONST("display");

@implementation MHVFlowValue

- (double)litersPerSecondValue
{
    return _litersPerSecond ? _litersPerSecond.value : NAN;
}

- (void)setLitersPerSecondValue:(double)litersPerSecondValue
{
    if (isnan(litersPerSecondValue))
    {
        _litersPerSecond = nil;
    }
    else
    {
        if (!_litersPerSecond)
        {
            _litersPerSecond = [[MHVPositiveDouble alloc] init];
        }
        
        _litersPerSecond.value = litersPerSecondValue;
    }
    
    [self updateDisplayText];
}

- (instancetype)initWithLitersPerSecond:(double)value
{
    self = [super init];
    if (self)
    {
        [self setLitersPerSecondValue:value];
    }
    
    return self;
}

- (BOOL)updateDisplayText
{
    if (!self.litersPerSecond)
    {
        self.displayValue = nil;
        return FALSE;
    }
    
    self.displayValue = [[MHVDisplayValue alloc] initWithValue:self.litersPerSecond.value andUnits:[MHVFlowValue flowUnits]];
    
    return self.displayValue != nil;
}

- (NSString *)toString
{
    return [self toStringWithFormat:@"%.1f L/s"];
}

- (NSString *)toStringWithFormat:(NSString *)format
{
    if (!self.litersPerSecond)
    {
        return @"";
    }
    
    return [NSString localizedStringWithFormat:format, self.litersPerSecondValue];
}

- (NSString *)description
{
    return [self toString];
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN
    
    MHVVALIDATE(self.litersPerSecond, MHVClientError_InvalidFlow);
    MHVVALIDATE_OPTIONAL(self.displayValue);
    
    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementXmlName:x_element_litersPerSecond content:self.litersPerSecond];
    [writer writeElementXmlName:x_element_displayValue content:self.displayValue];
}

- (void)deserialize:(XReader *)reader
{
    self.litersPerSecond = [reader readElementWithXmlName:x_element_litersPerSecond asClass:[MHVPositiveDouble class]];
    self.displayValue = [reader readElementWithXmlName:x_element_displayValue asClass:[MHVDisplayValue class]];
}

+ (NSString *)flowUnits
{
    return NSLocalizedString(@"L/s", @"Liters per second");
}

@end

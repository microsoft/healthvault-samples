//
// MHVVolumeValue.m
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

#import "MHVValidator.h"
#import "MHVVolumeValue.h"

static const xmlChar *x_element_liters = XMLSTRINGCONST("liters");
static const xmlChar *x_element_displayValue = XMLSTRINGCONST("display");

@implementation MHVVolumeValue

- (double)litersValue
{
    return self.liters ? self.liters.value : NAN;
}

- (void)setLitersValue:(double)litersValue
{
    if (isnan(litersValue))
    {
        self.liters = nil;
    }
    else
    {
        if (!self.liters)
        {
            self.liters = [[MHVPositiveDouble alloc] init];
        }
        
        self.liters.value = litersValue;
    }
    
    [self updateDisplayText];
}

- (instancetype)initWithLiters:(double)value
{
    self = [super init];
    if (self)
    {
        [self setLitersValue:value];
    }
    
    return self;
}

- (BOOL)updateDisplayText
{
    if (!self.liters)
    {
        self.displayValue = nil;
        return FALSE;
    }
    
    self.displayValue = [[MHVDisplayValue alloc] initWithValue:self.liters.value andUnits:[MHVVolumeValue volumeUnits]];
    
    return self.displayValue != nil;
}

- (NSString *)toString
{
    return [self toStringWithFormat:@"%.1f L"];
}

- (NSString *)toStringWithFormat:(NSString *)format
{
    if (!self.liters)
    {
        return @"";
    }
    
    return [NSString localizedStringWithFormat:format, self.litersValue];
}

- (NSString *)description
{
    return [self toString];
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN
    
    MHVVALIDATE(self.liters, MHVClientError_InvalidVolume);
    MHVVALIDATE_OPTIONAL(self.displayValue);
    
    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementXmlName:x_element_liters content:self.liters];
    [writer writeElementXmlName:x_element_displayValue content:self.displayValue];
}

- (void)deserialize:(XReader *)reader
{
    self.liters = [reader readElementWithXmlName:x_element_liters asClass:[MHVPositiveDouble class]];
    self.displayValue = [reader readElementWithXmlName:x_element_displayValue asClass:[MHVDisplayValue class]];
}

+ (NSString *)volumeUnits
{
    return NSLocalizedString(@"L", @"Liters");
}

@end

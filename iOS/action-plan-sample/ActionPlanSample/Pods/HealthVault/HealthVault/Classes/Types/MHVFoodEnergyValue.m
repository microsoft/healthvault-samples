//
// MHVFoodEnergyValue.m
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

#import "MHVFoodEnergyValue.h"
#import "MHVValidator.h"

static const xmlChar *x_element_calories = XMLSTRINGCONST("calories");
static const xmlChar *x_element_displayValue = XMLSTRINGCONST("display");

@implementation MHVFoodEnergyValue

- (double)caloriesValue
{
    return (_calories) ? _calories.value : NAN;
}

- (void)setCaloriesValue:(double)caloriesValue
{
    if (isnan(caloriesValue))
    {
        _calories = nil;
    }
    else
    {
        if (!_calories)
        {
            _calories = [[MHVNonNegativeDouble alloc] init];
        }
        
        _calories.value = caloriesValue;
    }
    
    [self updateDisplayText];
}

- (instancetype)initWithCalories:(double)value
{
    self = [super init];
    if (self)
    {
        [self setCaloriesValue:value];
    }
    
    return self;
}

- (BOOL)updateDisplayText
{
    self.displayValue = nil;
    if (!self.calories)
    {
        return FALSE;
    }
    
    self.displayValue = [[MHVDisplayValue alloc] initWithValue:self.calories.value andUnits:[MHVFoodEnergyValue calorieUnits]];
    
    return self.displayValue != nil;
}

- (NSString *)toString
{
    return [self toStringWithFormat:@"%.0f cal"];
}

- (NSString *)toStringWithFormat:(NSString *)format
{
    if (!self.calories)
    {
        return @"";
    }
    
    return [NSString localizedStringWithFormat:format, self.caloriesValue];
}

+ (NSString *)calorieUnits
{
    return NSLocalizedString(@"cal", @"Calorie units");
}

- (NSString *)description
{
    return [self toString];
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN
    
    MHVVALIDATE(self.calories, MHVClientError_InvalidDietaryIntake);
    MHVVALIDATE_OPTIONAL(self.displayValue);
    
    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementXmlName:x_element_calories content:self.calories];
    [writer writeElementXmlName:x_element_displayValue content:self.displayValue];
}

- (void)deserialize:(XReader *)reader
{
    self.calories = [reader readElementWithXmlName:x_element_calories asClass:[MHVNonNegativeDouble class]];
    self.displayValue = [reader readElementWithXmlName:x_element_displayValue asClass:[MHVDisplayValue class]];
}

+ (MHVFoodEnergyValue *)fromCalories:(double)value
{
    return [[MHVFoodEnergyValue alloc] initWithCalories:value];
}

@end

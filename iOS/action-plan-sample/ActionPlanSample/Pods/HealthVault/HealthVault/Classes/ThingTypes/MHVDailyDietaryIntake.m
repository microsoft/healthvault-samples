//
// MHVDietaryIntake.m
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

#import "MHVDailyDietaryIntake.h"
#import "MHVValidator.h"

static NSString *const c_typeid = @"9c29c6b9-f40e-44ff-b24e-fba6f3074638";
static NSString *const c_typename = @"dietary-intake-daily";

static NSString *const c_element_when = @"when";
static NSString *const c_element_calories = @"calories";
static NSString *const c_element_totalFat = @"total-fat";
static NSString *const c_element_saturatedFat = @"saturated-fat";
static NSString *const c_element_transFat = @"trans-fat";
static NSString *const c_element_protein = @"protein";
static NSString *const c_element_carbs = @"total-carbohydrates";
static NSString *const c_element_fiber = @"dietary-fiber";
static NSString *const c_element_sugar = @"sugars";
static NSString *const c_element_sodium = @"sodium";
static NSString *const c_element_cholesterol = @"cholesterol";

@implementation MHVDailyDietaryIntake

- (int)caloriesValue
{
    return (self.calories) ? self.calories.value : -1;
}

- (void)setCaloriesValue:(int)caloriesValue
{
    if (!self.calories)
    {
        self.calories = [[MHVPositiveInt alloc] init];
    }
    
    self.calories.value = caloriesValue;
}

- (double)totalFatGrams
{
    return (self.totalFat) ? self.totalFat.inGrams : NAN;
}

- (void)setTotalFatGrams:(double)totalFatGrams
{
    if (!self.totalFat)
    {
        self.totalFat = [[MHVWeightMeasurement alloc] init];
    }
    
    self.totalFat.inGrams = totalFatGrams;
}

- (double)saturatedFatGrams
{
    return (self.saturatedFat) ? self.saturatedFat.inGrams : NAN;
}

- (void)setSaturatedFatGrams:(double)saturatedFatGrams
{
    if (!self.saturatedFat)
    {
        self.saturatedFat = [[MHVWeightMeasurement alloc] init];
    }
    
    self.saturatedFat.inGrams = saturatedFatGrams;
}

- (double)transFatGrams
{
    return (self.transFat) ? self.transFat.inGrams : NAN;
}

- (void)setTransFatGrams:(double)transFatGrams
{
    if (!self.transFat)
    {
        self.transFat = [[MHVWeightMeasurement alloc] init];
    }
    
    self.transFat.inGrams = transFatGrams;
}

- (double)proteinGrams
{
    return (self.protein) ? self.protein.inGrams : NAN;
}

- (void)setProteinGrams:(double)proteinGrams
{
    if (!self.protein)
    {
        self.protein = [[MHVWeightMeasurement alloc] init];
    }
    
    self.protein.inGrams = proteinGrams;
}

- (double)totalCarbGrams
{
    return (self.totalCarbs) ? self.totalCarbs.inGrams : NAN;
}

- (void)setTotalCarbGrams:(double)totalCarbGrams
{
    if (!self.totalCarbs)
    {
        self.totalCarbs = [[MHVWeightMeasurement alloc] init];
    }
    
    self.totalCarbs.inGrams = totalCarbGrams;
}

- (double)sugarGrams
{
    return (self.sugar) ? self.sugar.inGrams : NAN;
}

- (void)setSugarGrams:(double)sugarGrams
{
    if (!self.sugar)
    {
        self.sugar = [[MHVWeightMeasurement alloc] init];
    }
    
    self.sugar.inGrams = sugarGrams;
}

- (double)dietaryFiberGrams
{
    return (self.dietaryFiber) ? self.dietaryFiber.inGrams : NAN;
}

- (void)setDietaryFiberGrams:(double)dietaryFiberGrams
{
    if (!self.dietaryFiber)
    {
        self.dietaryFiber = [[MHVWeightMeasurement alloc] init];
    }
    
    self.dietaryFiber.inGrams = dietaryFiberGrams;
}

- (double)sodiumMillgrams
{
    return (self.sodium) ? self.sodium.inMilligrams : NAN;
}

- (void)setSodiumMillgrams:(double)sodiumMillgrams
{
    if (!self.sodium)
    {
        self.sodium = [[MHVWeightMeasurement alloc] init];
    }
    
    self.sodium.inMilligrams = sodiumMillgrams;
}

- (double)cholesterolMilligrams
{
    return (self.cholesterol) ? self.cholesterol.inMilligrams : NAN;
}

- (void)setCholesterolMilligrams:(double)cholesterolMilligrams
{
    if (!self.cholesterol)
    {
        self.cholesterol = [[MHVWeightMeasurement alloc] init];
    }
    
    self.cholesterol.inMilligrams = cholesterolMilligrams;
}

- (NSDate *)getDate
{
    return [self.when toDate];
}

- (NSDate *)getDateForCalendar:(NSCalendar *)calendar
{
    return [self.when toDateForCalendar:calendar];
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN
    
    MHVVALIDATE(self.when, MHVClientError_InvalidDietaryIntake);
    
    MHVVALIDATE_OPTIONAL(self.calories);
    MHVVALIDATE_OPTIONAL(self.totalFat);
    MHVVALIDATE_OPTIONAL(self.saturatedFat);
    MHVVALIDATE_OPTIONAL(self.transFat);
    MHVVALIDATE_OPTIONAL(self.protein);
    MHVVALIDATE_OPTIONAL(self.totalCarbs);
    MHVVALIDATE_OPTIONAL(self.dietaryFiber);
    MHVVALIDATE_OPTIONAL(self.sugar);
    MHVVALIDATE_OPTIONAL(self.sodium);
    MHVVALIDATE_OPTIONAL(self.cholesterol);
    
    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_when content:self.when];
    [writer writeElement:c_element_calories content:self.calories];
    [writer writeElement:c_element_totalFat content:self.totalFat];
    [writer writeElement:c_element_saturatedFat content:self.saturatedFat];
    [writer writeElement:c_element_transFat content:self.transFat];
    [writer writeElement:c_element_protein content:self.protein];
    [writer writeElement:c_element_carbs content:self.totalCarbs];
    [writer writeElement:c_element_fiber content:self.dietaryFiber];
    [writer writeElement:c_element_sugar content:self.sugar];
    [writer writeElement:c_element_sodium content:self.sodium];
    [writer writeElement:c_element_cholesterol content:self.cholesterol];
}

- (void)deserialize:(XReader *)reader
{
    self.when = [reader readElement:c_element_when asClass:[MHVDate class]];
    self.calories = [reader readElement:c_element_calories asClass:[MHVPositiveInt class]];
    self.totalFat = [reader readElement:c_element_totalFat asClass:[MHVWeightMeasurement class]];
    self.saturatedFat = [reader readElement:c_element_saturatedFat asClass:[MHVWeightMeasurement class]];
    self.transFat = [reader readElement:c_element_transFat asClass:[MHVWeightMeasurement class]];
    self.protein = [reader readElement:c_element_protein asClass:[MHVWeightMeasurement class]];
    self.totalCarbs = [reader readElement:c_element_carbs asClass:[MHVWeightMeasurement class]];
    self.dietaryFiber = [reader readElement:c_element_fiber asClass:[MHVWeightMeasurement class]];
    self.sugar = [reader readElement:c_element_sugar asClass:[MHVWeightMeasurement class]];
    self.sodium = [reader readElement:c_element_sodium asClass:[MHVWeightMeasurement class]];
    self.cholesterol = [reader readElement:c_element_cholesterol asClass:[MHVWeightMeasurement class]];
}

+ (NSString *)typeID
{
    return c_typeid;
}

+ (NSString *)XRootElement
{
    return c_typename;
}

+ (MHVThing *)newThing
{
    return [[MHVThing alloc] initWithType:[MHVDailyDietaryIntake typeID]];
}

@end

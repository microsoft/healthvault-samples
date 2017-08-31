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
//

#import "MHVDietaryIntake.h"
#import "MHVValidator.h"

static NSString *const c_typeid = @"089646a6-7e25-4495-ad15-3e28d4c1a71d";
static NSString *const c_typename = @"dietary-intake";

static NSString *const c_element_additionalFacts = @"additional-nutrition-facts";

static const xmlChar *x_element_foodThing = XMLSTRINGCONST("food-thing");
static const xmlChar *x_element_servingSize = XMLSTRINGCONST("serving-size");
static const xmlChar *x_element_servingsConsumed = XMLSTRINGCONST("servings-consumed");
static const xmlChar *x_element_meal = XMLSTRINGCONST("meal");
static const xmlChar *x_element_when = XMLSTRINGCONST("when");
static const xmlChar *x_element_calories = XMLSTRINGCONST("energy");
static const xmlChar *x_element_energyFat = XMLSTRINGCONST("energy-from-fat");
static const xmlChar *x_element_totalFat = XMLSTRINGCONST("total-fat");
static const xmlChar *x_element_saturatedFat = XMLSTRINGCONST("saturated-fat");
static const xmlChar *x_element_transFat = XMLSTRINGCONST("trans-fat");
static const xmlChar *x_element_monounsaturatedFat = XMLSTRINGCONST("monounsaturated-fat");
static const xmlChar *x_element_polyunsaturatedFat = XMLSTRINGCONST("polyunsaturated-fat");

static const xmlChar *x_element_protein = XMLSTRINGCONST("protein");
static const xmlChar *x_element_carbs = XMLSTRINGCONST("carbohydrates");
static const xmlChar *x_element_fiber = XMLSTRINGCONST("dietary-fiber");
static const xmlChar *x_element_sugars = XMLSTRINGCONST("sugars");
static const xmlChar *x_element_sodium = XMLSTRINGCONST("sodium");
static const xmlChar *x_element_cholesterol = XMLSTRINGCONST("cholesterol");

static const xmlChar *x_element_calcium = XMLSTRINGCONST("calcium");
static const xmlChar *x_element_iron = XMLSTRINGCONST("iron");
static const xmlChar *x_element_magnesium = XMLSTRINGCONST("magnesium");
static const xmlChar *x_element_phosphorus = XMLSTRINGCONST("phosphorus");
static const xmlChar *x_element_potassium = XMLSTRINGCONST("potassium");
static const xmlChar *x_element_zinc = XMLSTRINGCONST("zinc");

static const xmlChar *x_element_vitaminA = XMLSTRINGCONST("vitamin-A-RAE");
static const xmlChar *x_element_vitaminE = XMLSTRINGCONST("vitamin-E");
static const xmlChar *x_element_vitaminD = XMLSTRINGCONST("vitamin-D");
static const xmlChar *x_element_vitaminC = XMLSTRINGCONST("vitamin-C");
static const xmlChar *x_element_thiamin = XMLSTRINGCONST("thiamin");
static const xmlChar *x_element_riboflavin = XMLSTRINGCONST("riboflavin");
static const xmlChar *x_element_niacin = XMLSTRINGCONST("niacin");
static const xmlChar *x_element_vitaminB6 = XMLSTRINGCONST("vitamin-B-6");
static const xmlChar *x_element_folate = XMLSTRINGCONST("folate-DFE");
static const xmlChar *x_element_vitaminB12 = XMLSTRINGCONST("vitamin-B-12");
static const xmlChar *x_element_vitaminK = XMLSTRINGCONST("vitamin-K");

@implementation MHVDietaryIntake

- (NSDate *)getDate
{
    return (self.when) ? [self.when toDate] : nil;
}

- (NSDate *)getDateForCalendar:(NSCalendar *)calendar
{
    return (self.when) ? [self.when toDateForCalendar:calendar] : nil;
}

+ (MHVVocabularyIdentifier *)vocabForFood
{
    return [[MHVVocabularyIdentifier alloc] initWithFamily:c_usdaFamily andName:@"food-description"];
}

+ (MHVVocabularyIdentifier *)vocabForMeals
{
    return [[MHVVocabularyIdentifier alloc] initWithFamily:c_hvFamily andName:@"dietary-intake-meals"];
}

+ (MHVCodableValue *)mealCodeForBreakfast
{
    return [[MHVDietaryIntake vocabForMeals] codableValueForText:@"Breakfast" andCode:@"B"];
}

+ (MHVCodableValue *)mealCodeForLunch
{
    return [[MHVDietaryIntake vocabForMeals] codableValueForText:@"Lunch" andCode:@"L"];
}

+ (MHVCodableValue *)mealCodeForDinner
{
    return [[MHVDietaryIntake vocabForMeals] codableValueForText:@"Dinner" andCode:@"D"];
}

+ (MHVCodableValue *)mealCodeForSnack
{
    return [[MHVDietaryIntake vocabForMeals] codableValueForText:@"Snack" andCode:@"S"];
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN

        MHVVALIDATE(self.foodThing, MHVClientError_InvalidDietaryIntake);

    MHVVALIDATE_OPTIONAL(self.servingSize);
    MHVVALIDATE_OPTIONAL(self.servingsConsumed);
    MHVVALIDATE_OPTIONAL(self.meal);
    MHVVALIDATE_OPTIONAL(self.when);

    MHVVALIDATE_OPTIONAL(self.calories);
    MHVVALIDATE_OPTIONAL(self.caloriesFromFat);
    MHVVALIDATE_OPTIONAL(self.totalFat);
    MHVVALIDATE_OPTIONAL(self.saturatedFat);
    MHVVALIDATE_OPTIONAL(self.transFat);
    MHVVALIDATE_OPTIONAL(self.monounsaturatedFat);
    MHVVALIDATE_OPTIONAL(self.polyunsaturatedFat);

    MHVVALIDATE_OPTIONAL(self.protein);
    MHVVALIDATE_OPTIONAL(self.carbs);
    MHVVALIDATE_OPTIONAL(self.dietaryFiber);
    MHVVALIDATE_OPTIONAL(self.sugar);
    MHVVALIDATE_OPTIONAL(self.sodium);
    MHVVALIDATE_OPTIONAL(self.cholesterol);

    MHVVALIDATE_OPTIONAL(self.calcium);
    MHVVALIDATE_OPTIONAL(self.iron);
    MHVVALIDATE_OPTIONAL(self.magnesium);
    MHVVALIDATE_OPTIONAL(self.phosphorus);
    MHVVALIDATE_OPTIONAL(self.potassium);
    MHVVALIDATE_OPTIONAL(self.zinc);

    MHVVALIDATE_OPTIONAL(self.vitaminA);
    MHVVALIDATE_OPTIONAL(self.vitaminE);
    MHVVALIDATE_OPTIONAL(self.vitaminD);
    MHVVALIDATE_OPTIONAL(self.vitaminC);
    MHVVALIDATE_OPTIONAL(self.thiamin);
    MHVVALIDATE_OPTIONAL(self.riboflavin);
    MHVVALIDATE_OPTIONAL(self.niacin);
    MHVVALIDATE_OPTIONAL(self.vitaminB6);
    MHVVALIDATE_OPTIONAL(self.folate);
    MHVVALIDATE_OPTIONAL(self.vitaminB12);
    MHVVALIDATE_OPTIONAL(self.vitaminK);

    MHVVALIDATE_OPTIONAL(self.additionalFacts);

    MHVVALIDATE_SUCCESS
}

- (void)deserialize:(XReader *)reader
{
    self.foodThing = [reader readElementWithXmlName:x_element_foodThing asClass:[MHVCodableValue class]];
    self.servingSize = [reader readElementWithXmlName:x_element_servingSize asClass:[MHVCodableValue class]];
    self.servingsConsumed = [reader readElementWithXmlName:x_element_servingsConsumed asClass:[MHVNonNegativeDouble class]];
    self.meal = [reader readElementWithXmlName:x_element_meal asClass:[MHVCodableValue class]];

    self.when = [reader readElementWithXmlName:x_element_when asClass:[MHVDateTime class]];

    self.calories = [reader readElementWithXmlName:x_element_calories asClass:[MHVFoodEnergyValue class]];
    self.caloriesFromFat = [reader readElementWithXmlName:x_element_energyFat asClass:[MHVFoodEnergyValue class]];
    self.totalFat = [reader readElementWithXmlName:x_element_totalFat asClass:[MHVWeightMeasurement class]];
    self.saturatedFat = [reader readElementWithXmlName:x_element_saturatedFat asClass:[MHVWeightMeasurement class]];
    self.transFat = [reader readElementWithXmlName:x_element_transFat asClass:[MHVWeightMeasurement class]];
    self.monounsaturatedFat = [reader readElementWithXmlName:x_element_monounsaturatedFat asClass:[MHVWeightMeasurement class]];
    self.polyunsaturatedFat = [reader readElementWithXmlName:x_element_polyunsaturatedFat asClass:[MHVWeightMeasurement class]];

    self.protein = [reader readElementWithXmlName:x_element_protein asClass:[MHVWeightMeasurement class]];
    self.carbs = [reader readElementWithXmlName:x_element_carbs asClass:[MHVWeightMeasurement class]];
    self.dietaryFiber = [reader readElementWithXmlName:x_element_fiber asClass:[MHVWeightMeasurement class]];
    self.sugar = [reader readElementWithXmlName:x_element_sugars asClass:[MHVWeightMeasurement class]];
    self.sodium = [reader readElementWithXmlName:x_element_sodium asClass:[MHVWeightMeasurement class]];
    self.cholesterol = [reader readElementWithXmlName:x_element_cholesterol asClass:[MHVWeightMeasurement class]];

    self.calcium = [reader readElementWithXmlName:x_element_calcium asClass:[MHVWeightMeasurement class]];
    self.iron = [reader readElementWithXmlName:x_element_iron asClass:[MHVWeightMeasurement class]];
    self.magnesium = [reader readElementWithXmlName:x_element_magnesium asClass:[MHVWeightMeasurement class]];
    self.phosphorus = [reader readElementWithXmlName:x_element_phosphorus asClass:[MHVWeightMeasurement class]];
    self.potassium = [reader readElementWithXmlName:x_element_potassium asClass:[MHVWeightMeasurement class]];
    self.zinc = [reader readElementWithXmlName:x_element_zinc asClass:[MHVWeightMeasurement class]];

    self.vitaminA = [reader readElementWithXmlName:x_element_vitaminA asClass:[MHVWeightMeasurement class]];
    self.vitaminE = [reader readElementWithXmlName:x_element_vitaminE asClass:[MHVWeightMeasurement class]];
    self.vitaminD = [reader readElementWithXmlName:x_element_vitaminD asClass:[MHVWeightMeasurement class]];
    self.vitaminC = [reader readElementWithXmlName:x_element_vitaminC asClass:[MHVWeightMeasurement class]];
    self.thiamin = [reader readElementWithXmlName:x_element_thiamin asClass:[MHVWeightMeasurement class]];
    self.riboflavin = [reader readElementWithXmlName:x_element_riboflavin asClass:[MHVWeightMeasurement class]];
    self.niacin = [reader readElementWithXmlName:x_element_niacin asClass:[MHVWeightMeasurement class]];
    self.vitaminB6 = [reader readElementWithXmlName:x_element_vitaminB6 asClass:[MHVWeightMeasurement class]];
    self.folate = [reader readElementWithXmlName:x_element_folate asClass:[MHVWeightMeasurement class]];
    self.vitaminB12 = [reader readElementWithXmlName:x_element_vitaminB12 asClass:[MHVWeightMeasurement class]];
    self.vitaminK = [reader readElementWithXmlName:x_element_vitaminK asClass:[MHVWeightMeasurement class]];

    self.additionalFacts = [reader readElement:c_element_additionalFacts asClass:[MHVAdditionalNutritionFacts class]];
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementXmlName:x_element_foodThing content:self.foodThing];
    [writer writeElementXmlName:x_element_servingSize content:self.servingSize];
    [writer writeElementXmlName:x_element_servingsConsumed content:self.servingsConsumed];
    [writer writeElementXmlName:x_element_meal content:self.meal];

    [writer writeElementXmlName:x_element_when content:self.when];

    [writer writeElementXmlName:x_element_calories content:self.calories];
    [writer writeElementXmlName:x_element_energyFat content:self.caloriesFromFat];
    [writer writeElementXmlName:x_element_totalFat content:self.totalFat];
    [writer writeElementXmlName:x_element_saturatedFat content:self.saturatedFat];
    [writer writeElementXmlName:x_element_transFat content:self.transFat];
    [writer writeElementXmlName:x_element_monounsaturatedFat content:self.monounsaturatedFat];
    [writer writeElementXmlName:x_element_polyunsaturatedFat content:self.polyunsaturatedFat];

    [writer writeElementXmlName:x_element_protein content:self.protein];
    [writer writeElementXmlName:x_element_carbs content:self.carbs];
    [writer writeElementXmlName:x_element_fiber content:self.dietaryFiber];
    [writer writeElementXmlName:x_element_sugars content:self.sugar];
    [writer writeElementXmlName:x_element_sodium content:self.sodium];
    [writer writeElementXmlName:x_element_cholesterol content:self.cholesterol];

    [writer writeElementXmlName:x_element_calcium content:self.calcium];
    [writer writeElementXmlName:x_element_iron content:self.iron];
    [writer writeElementXmlName:x_element_magnesium content:self.magnesium];
    [writer writeElementXmlName:x_element_phosphorus content:self.phosphorus];
    [writer writeElementXmlName:x_element_potassium content:self.potassium];
    [writer writeElementXmlName:x_element_zinc content:self.zinc];

    [writer writeElementXmlName:x_element_vitaminA content:self.vitaminA];
    [writer writeElementXmlName:x_element_vitaminE content:self.vitaminE];
    [writer writeElementXmlName:x_element_vitaminD content:self.vitaminD];
    [writer writeElementXmlName:x_element_vitaminC content:self.vitaminC];
    [writer writeElementXmlName:x_element_thiamin content:self.thiamin];
    [writer writeElementXmlName:x_element_riboflavin content:self.riboflavin];
    [writer writeElementXmlName:x_element_niacin content:self.niacin];
    [writer writeElementXmlName:x_element_vitaminB6 content:self.vitaminB6];
    [writer writeElementXmlName:x_element_folate content:self.folate];
    [writer writeElementXmlName:x_element_vitaminB12 content:self.vitaminB12];
    [writer writeElementXmlName:x_element_vitaminK content:self.vitaminK];

    [writer writeElement:c_element_additionalFacts content:self.additionalFacts];
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
    return [[MHVThing alloc] initWithType:[MHVDietaryIntake typeID]];
}

- (NSString *)typeName
{
    return NSLocalizedString(@"Dietary intake", @"Dietary intake type Name");
}

+ (void)registerType
{
    [[MHVTypeSystem current] addClass:[MHVDietaryIntake class] forTypeID:[MHVDietaryIntake typeID]];
}

@end

//
// MHVNutritionFact.m
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
#import "MHVNutritionFact.h"

static NSString *const c_element_name = @"name";
static NSString *const c_element_fact = @"fact";
static NSString *const c_element_nutritionFact = @"nutrition-fact";

@implementation MHVNutritionFact

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_name content:self.name];
    [writer writeElement:c_element_fact content:self.fact];
}

- (void)deserialize:(XReader *)reader
{
    self.name = [reader readElement:c_element_name asClass:[MHVCodableValue class]];
    self.fact = [reader readElement:c_element_fact asClass:[MHVMeasurement class]];
}

@end

@implementation MHVAdditionalNutritionFacts

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN
    
    MHVVALIDATE_ARRAY(self.facts, MHVClientError_InvalidDietaryIntake);
    
    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementArray:c_element_nutritionFact elements:self.facts];
}

- (void)deserialize:(XReader *)reader
{
    self.facts = [reader readElementArray:c_element_nutritionFact
                                  asClass:[MHVNutritionFact class]
                            andArrayClass:[NSMutableArray class]];
}

@end

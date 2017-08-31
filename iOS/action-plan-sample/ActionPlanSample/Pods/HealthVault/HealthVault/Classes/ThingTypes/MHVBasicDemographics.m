//
// BasicDemographics.m
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

#import "MHVBasicDemographics.h"
#import "MHVValidator.h"

static NSString *const c_gender_female = @"f";
static NSString *const c_gender_male = @"m";

NSString *stringFromGender(MHVGender gender)
{
    NSString *genderString = nil;

    switch (gender)
    {
        case MHVGenderFemale:
            genderString = c_gender_female;
            break;

        case MHVGenderMale:
            genderString = c_gender_male;
            break;

        default:
            break;
    }

    return genderString;
}

MHVGender stringToGender(NSString *genderString)
{
    if ([genderString isEqualToString:c_gender_female])
    {
        return MHVGenderFemale;
    }

    if ([genderString isEqualToString:c_gender_male])
    {
        return MHVGenderMale;
    }

    return MHVGenderNone;
}

static NSString *const c_typeid = @"3b3e6b16-eb69-483c-8d7e-dfe116ae6092";
static NSString *const c_typename = @"basic";

static NSString *const c_element_gender = @"gender";
static NSString *const c_element_birthyear = @"birthyear";
static NSString *const c_element_country = @"country";
static NSString *const c_element_postcode = @"postcode";
static NSString *const c_element_city = @"city";
static NSString *const c_element_state = @"state";
static NSString *const c_element_dow = @"firstdow";
static NSString *const c_element_lang = @"language";

@interface MHVBasicDemographics ()

@property (nonatomic, strong) MHVInt *firstDOW;

@end

@implementation MHVBasicDemographics

- (NSString *)genderAsString
{
    return stringFromGender(self.gender);
}

+ (MHVVocabularyIdentifier *)vocabForGender
{
    return [[MHVVocabularyIdentifier alloc] initWithFamily:c_hvFamily andName:@"gender-types"];
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN

        MHVVALIDATE_OPTIONAL(self.birthYear);

    MHVVALIDATE_OPTIONAL(self.country);

    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_gender value:stringFromGender(self.gender)];
    [writer writeElement:c_element_birthyear content:self.birthYear];
    [writer writeElement:c_element_country content:self.country];
    [writer writeElement:c_element_postcode value:self.postalCode];
    [writer writeElement:c_element_city value:self.city];
    [writer writeElement:c_element_state content:self.state];
    [writer writeElement:c_element_dow content:self.firstDOW];
    [writer writeRaw:self.languageXml];
}

- (void)deserialize:(XReader *)reader
{
    NSString *gender = [reader readStringElement:c_element_gender];

    if (gender)
    {
        self.gender = stringToGender(gender);
    }

    self.birthYear = [reader readElement:c_element_birthyear asClass:[MHVYear class]];
    self.country = [reader readElement:c_element_country asClass:[MHVCodableValue class]];
    self.postalCode = [reader readStringElement:c_element_postcode];
    self.city = [reader readStringElement:c_element_city];
    self.state = [reader readElement:c_element_state asClass:[MHVCodableValue class]];
    self.firstDOW = [reader readElement:c_element_dow asClass:[MHVInt class]];
    self.languageXml = [reader readElementRaw:c_element_lang];
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
    return [[MHVThing alloc] initWithType:[MHVBasicDemographics typeID]];
}

+ (BOOL)isSingletonType
{
    return TRUE;
}

@end

//
// MHVAllergy.m
// MHVLib
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

#import "MHVAllergy.h"
#import "MHVValidator.h"

static NSString *const c_typeid = @"52bf9104-2c5e-4f1f-a66d-552ebcc53df7";
static NSString *const c_typename = @"allergy";

static NSString *const c_element_name = @"name";
static NSString *const c_element_reaction = @"reaction";
static NSString *const c_element_first = @"first-observed";
static NSString *const c_element_allergenType = @"allergen-type";
static NSString *const c_element_allergenCode = @"allergen-code";
static NSString *const c_element_treatmentProvider = @"treatment-provider";
static NSString *const c_element_treatment = @"treatment";
static NSString *const c_element_negated = @"is-negated";

@implementation MHVAllergy

- (instancetype)initWithName:(NSString *)name
{
    MHVCHECK_NOTNULL(name);

    self = [super init];
    if (self)
    {
        _name = [[MHVCodableValue alloc] initWithText:name];
        MHVCHECK_NOTNULL(_name);
    }

    return self;
}

- (NSDate *)getDate
{
    return (self.firstObserved) ? [self.firstObserved toDate] : nil;
}

- (NSDate *)getDateForCalendar:(NSCalendar *)calendar
{
    return (self.firstObserved) ? [self.firstObserved toDateForCalendar:calendar] : nil;
}

- (NSString *)description
{
    return [self toString];
}

- (NSString *)toString
{
    return (self.name) ? [self.name toString] : @"";
}

+ (MHVVocabularyIdentifier *)vocabForType
{
    return [[MHVVocabularyIdentifier alloc] initWithFamily:c_hvFamily andName:@"allergen-type"];
}

+ (MHVVocabularyIdentifier *)vocabForReaction
{
    return [[MHVVocabularyIdentifier alloc] initWithFamily:c_hvFamily andName:@"reactions"];
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN

        MHVVALIDATE(self.name, MHVClientError_InvalidAllergy);

    MHVVALIDATE_OPTIONAL(self.reaction);
    MHVVALIDATE_OPTIONAL(self.firstObserved);
    MHVVALIDATE_OPTIONAL(self.allergenType);
    MHVVALIDATE_OPTIONAL(self.allergenCode);
    MHVVALIDATE_OPTIONAL(self.treatmentProvider);
    MHVVALIDATE_OPTIONAL(self.treatment);
    MHVVALIDATE_OPTIONAL(self.isNegated);

    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_name content:self.name];
    [writer writeElement:c_element_reaction content:self.reaction];
    [writer writeElement:c_element_first content:self.firstObserved];
    [writer writeElement:c_element_allergenType content:self.allergenType];
    [writer writeElement:c_element_allergenCode content:self.allergenCode];
    [writer writeElement:c_element_treatmentProvider content:self.treatmentProvider];
    [writer writeElement:c_element_treatment content:self.treatment];
    [writer writeElement:c_element_negated content:self.isNegated];
}

- (void)deserialize:(XReader *)reader
{
    self.name = [reader readElement:c_element_name asClass:[MHVCodableValue class]];
    self.reaction = [reader readElement:c_element_reaction asClass:[MHVCodableValue class]];
    self.firstObserved = [reader readElement:c_element_first asClass:[MHVApproxDateTime class]];
    self.allergenType = [reader readElement:c_element_allergenType asClass:[MHVCodableValue class]];
    self.allergenCode = [reader readElement:c_element_allergenCode asClass:[MHVCodableValue class]];
    self.treatmentProvider = [reader readElement:c_element_treatmentProvider asClass:[MHVPerson class]];
    self.treatment = [reader readElement:c_element_treatment asClass:[MHVCodableValue class]];
    self.isNegated = [reader readElement:c_element_negated asClass:[MHVBool class]];
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
    return [[MHVThing alloc] initWithType:[MHVAllergy typeID]];
}

- (NSString *)typeName
{
    return NSLocalizedString(@"Allergy", @"Allergy Type Name");
}

@end

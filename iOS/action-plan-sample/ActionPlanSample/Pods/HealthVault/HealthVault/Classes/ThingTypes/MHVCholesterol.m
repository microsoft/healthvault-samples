//
// MHVCholesterol.m
// MHVLib
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

#import "MHVCholesterol.h"
#import "MHVValidator.h"

static NSString *const c_typeid = @"98f76958-e34f-459b-a760-83c1699add38";
static NSString *const c_typename = @"cholesterol-profile";

double const c_cholesterolMolarMass = 386.6;  // g/mol
double const c_triglyceridesMolarMass = 885.7; // g/mol

static const xmlChar *x_element_when = XMLSTRINGCONST("when");
static const xmlChar *x_element_ldl = XMLSTRINGCONST("ldl");
static const xmlChar *x_element_hdl = XMLSTRINGCONST("hdl");
static const xmlChar *x_element_total = XMLSTRINGCONST("total-cholesterol");
static const xmlChar *x_element_triglycerides = XMLSTRINGCONST("triglyceride");

@implementation MHVCholesterol

- (NSDate *)getDate
{
    return [self.when toDate];
}

- (NSDate *)getDateForCalendar:(NSCalendar *)calendar
{
    return [self.when toDateForCalendar:calendar];
}

- (double)ldlValue
{
    return (self.ldl) ? self.ldl.mmolPerLiter : NAN;
}

- (void)setLdlValue:(double)ldl
{
    if (!self.ldl)
    {
        self.ldl = [[MHVConcentrationValue alloc] init];
    }
    
    self.ldl.mmolPerLiter = ldl;
}

- (double)hdlValue
{
    return (self.hdl) ? self.hdl.mmolPerLiter : NAN;
}

- (void)setHdlValue:(double)hdl
{
    if (!self.hdl)
    {
        self.hdl = [[MHVConcentrationValue alloc] init];
    }
    
    self.hdl.mmolPerLiter = hdl;
}

- (double)triglyceridesValue
{
    return (self.triglycerides) ? self.triglycerides.mmolPerLiter : NAN;
}

- (void)setTriglyceridesValue:(double)triglycerides
{
    if (!self.triglycerides)
    {
        self.triglycerides = [[MHVConcentrationValue alloc] init];
    }
    
    self.triglycerides.mmolPerLiter = triglycerides;
}

- (double)totalValue
{
    return (self.total) ? self.total.mmolPerLiter : NAN;
}

- (void)setTotalValue:(double)totalValue
{
    if (!self.total)
    {
        self.total = [[MHVConcentrationValue alloc] init];
    }
    
    self.total.mmolPerLiter = totalValue;
}

- (double)ldlValueMgDL
{
    return (self.ldl) ? [self.ldl mgPerDL:c_cholesterolMolarMass] : NAN;
}

- (void)setLdlValueMgDL:(double)ldlValueMgDL
{
    if (!self.ldl)
    {
        self.ldl = [[MHVConcentrationValue alloc] init];
    }
    
    [self.ldl setMgPerDL:ldlValueMgDL gramsPerMole:c_cholesterolMolarMass];
}

- (double)hdlValueMgDL
{
    return (self.hdl) ? [self.hdl mgPerDL:c_cholesterolMolarMass] : NAN;
}

- (void)setHdlValueMgDL:(double)hdlValueMgDL
{
    if (!self.hdl)
    {
        self.hdl = [[MHVConcentrationValue alloc] init];
    }
    
    [self.hdl setMgPerDL:hdlValueMgDL gramsPerMole:c_cholesterolMolarMass];
}

- (double)triglyceridesValueMgDl
{
    return (self.triglycerides) ? [self.triglycerides mgPerDL:c_triglyceridesMolarMass] : NAN;
}

- (void)setTriglyceridesValueMgDl:(double)triglyceridesMgDl
{
    if (!self.triglycerides)
    {
        self.triglycerides = [[MHVConcentrationValue alloc] init];
    }
    
    [self.triglycerides setMgPerDL:triglyceridesMgDl gramsPerMole:c_triglyceridesMolarMass];
}

- (double)totalValueMgDL
{
    return (self.total) ? [self.total mgPerDL:c_cholesterolMolarMass] : NAN;
}

- (void)setTotalValueMgDL:(double)totalValueMgDL
{
    if (!self.total)
    {
        self.total = [[MHVConcentrationValue alloc] init];
    }
    
    [self.total setMgPerDL:totalValueMgDL gramsPerMole:c_cholesterolMolarMass];
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN
    
    MHVVALIDATE(self.when, MHVClientError_InvalidCholesterol);
    MHVVALIDATE_OPTIONAL(self.ldl);
    MHVVALIDATE_OPTIONAL(self.hdl);
    MHVVALIDATE_OPTIONAL(self.total);
    MHVVALIDATE_OPTIONAL(self.triglycerides);
    
    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementXmlName:x_element_when content:self.when];
    [writer writeElementXmlName:x_element_ldl content:self.ldl];
    [writer writeElementXmlName:x_element_hdl content:self.hdl];
    [writer writeElementXmlName:x_element_total content:self.total];
    [writer writeElementXmlName:x_element_triglycerides content:self.triglycerides];
}

- (void)deserialize:(XReader *)reader
{
    self.when = [reader readElementWithXmlName:x_element_when asClass:[MHVDateTime class]];
    self.ldl = [reader readElementWithXmlName:x_element_ldl asClass:[MHVConcentrationValue class]];
    self.hdl = [reader readElementWithXmlName:x_element_hdl asClass:[MHVConcentrationValue class]];
    self.total = [reader readElementWithXmlName:x_element_total asClass:[MHVConcentrationValue class]];
    self.triglycerides = [reader readElementWithXmlName:x_element_triglycerides asClass:[MHVConcentrationValue class]];
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
    return [[MHVThing alloc] initWithType:[MHVCholesterol typeID]];
}

- (NSString *)typeName
{
    return NSLocalizedString(@"Cholesterol", @"Cholesterol Type Name");
}

@end

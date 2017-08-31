//
// MHVDisplayValue.m
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

#import "MHVDisplayValue.h"
#import "MHVValidator.h"
#import "XLib.h"

static const xmlChar *x_attribute_units = XMLSTRINGCONST("units");
static const xmlChar *x_attribute_code = XMLSTRINGCONST("units-code");
static const xmlChar *x_attribute_text = XMLSTRINGCONST("text");

@implementation MHVDisplayValue

- (instancetype)initWithValue:(double)doubleValue andUnits:(NSString *)unitValue
{
    MHVCHECK_STRING(unitValue);

    self = [super init];
    if (self)
    {
        _value = doubleValue;
        _units = unitValue;
    }

    return self;
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN;

    MHVVALIDATE_STRING(self.units, MHVClientError_InvalidDisplayValue);
    MHVVALIDATE_STRINGOPTIONAL(self.unitsCode, MHVClientError_InvalidDisplayValue);
    MHVVALIDATE_STRINGOPTIONAL(self.text, MHVClientError_InvalidDisplayValue)

    MHVVALIDATE_SUCCESS;
}

- (void)serializeAttributes:(XWriter *)writer
{
    [writer writeAttributeXmlName:x_attribute_text value:self.text];
    [writer writeAttributeXmlName:x_attribute_units value:self.units];
    [writer writeAttributeXmlName:x_attribute_code value:self.unitsCode];
}

- (void)serialize:(XWriter *)writer
{
    [writer writeDouble:self.value];
}

- (void)deserializeAttributes:(XReader *)reader
{
    self.text = [reader readAttributeWithXmlName:x_attribute_text];
    self.units = [reader readAttributeWithXmlName:x_attribute_units];
    self.unitsCode = [reader readAttributeWithXmlName:x_attribute_code];
}

- (void)deserialize:(XReader *)reader
{
    self.value = [reader readDouble];
}

@end

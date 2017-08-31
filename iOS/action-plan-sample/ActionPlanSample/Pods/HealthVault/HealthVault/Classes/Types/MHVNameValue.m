//
// MHVNameValue.m
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
#import "MHVNameValue.h"

static NSString *const c_element_name = @"name";
static NSString *const c_element_value = @"value";

@implementation MHVNameValue

- (double)measurementValue
{
    return (self.value) ? self.value.value : NAN;
}

- (void)setMeasurementValue:(double)measurementValue
{
    if (!self.value)
    {
        self.value = [[MHVMeasurement alloc] init];
    }
    
    self.value.value = measurementValue;
}

- (instancetype)initWithName:(MHVCodedValue *)name andValue:(MHVMeasurement *)value
{
    MHVCHECK_NOTNULL(name);
    MHVCHECK_NOTNULL(value);
    
    self = [super init];
    if (self)
    {
        _name = name;
        _value = value;
    }
    
    return self;
}

+ (MHVNameValue *)fromName:(MHVCodedValue *)name andValue:(MHVMeasurement *)value
{
    return [[MHVNameValue alloc] initWithName:name andValue:value];
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN;
    
    MHVVALIDATE(self.name, MHVClientError_InvalidNameValue);
    MHVVALIDATE(self.value, MHVClientError_InvalidNameValue);
    
    MHVVALIDATE_SUCCESS;
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_name content:self.name];
    [writer writeElement:c_element_value content:self.value];
}

- (void)deserialize:(XReader *)reader
{
    self.name = [reader readElement:c_element_name asClass:[MHVCodedValue class]];
    self.value = [reader readElement:c_element_value asClass:[MHVMeasurement class]];
}

@end


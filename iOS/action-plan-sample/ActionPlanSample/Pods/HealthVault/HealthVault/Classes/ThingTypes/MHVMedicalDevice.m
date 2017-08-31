//
//  MHVMedicalDevice.m
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

#import "MHVMedicalDevice.h"

static NSString *const c_typeid = @"ef9cf8d5-6c0b-4292-997f-4047240bc7be";
static NSString *const c_typename = @"device";

static NSString *const c_element_when = @"when";
static NSString *const c_element_device_name = @"device-name";
static NSString *const c_element_vendor = @"vendor";
static NSString *const c_element_model = @"model";
static NSString *const c_element_serial_number = @"serial-number";
static NSString *const c_element_anatomic_site = @"anatomic-site";
static NSString *const c_element_description = @"description";

@implementation MHVMedicalDevice

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_when content:self.when];
    [writer writeElement:c_element_device_name value:self.deviceName];
    [writer writeElement:c_element_vendor content:self.vendor];
    [writer writeElement:c_element_model value:self.model];
    [writer writeElement:c_element_serial_number value:self.serialNumber];
    [writer writeElement:c_element_anatomic_site value:self.anatomicSite];
    [writer writeElement:c_element_description value:self.descriptionText];
}

- (void)deserialize:(XReader *)reader
{
    self.when = [reader readElement:c_element_when asClass:[MHVDateTime class]];
    self.deviceName = [reader readStringElement:c_element_device_name];
    self.vendor = [reader readElement:c_element_vendor asClass:[MHVPerson class]];
    self.model = [reader readStringElement:c_element_model];
    self.serialNumber = [reader readStringElement:c_element_serial_number];
    self.anatomicSite = [reader readStringElement:c_element_anatomic_site];
    self.descriptionText = [reader readStringElement:c_element_description];
}

+ (NSString *)typeID
{
    return c_typeid;
}

+ (NSString *)XRootElement
{
    return c_typename;
}

@end

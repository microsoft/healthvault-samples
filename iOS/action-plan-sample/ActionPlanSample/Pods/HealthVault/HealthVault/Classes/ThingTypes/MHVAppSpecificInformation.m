//
// MHVAppSpecificInformation.m
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


#import "MHVAppSpecificInformation.h"

static NSString *const c_typeid = @"a5033c9d-08cf-4204-9bd3-cb412ce39fc0";
static NSString *const c_typename = @"app-specific";

static NSString *const c_element_format_appid = @"format-appid";
static NSString *const c_element_format_tag = @"format-tag";
static NSString *const c_element_when = @"when";
static NSString *const c_element_summary = @"summary";
static NSString *const c_element_any = @"Any";

@implementation MHVAppSpecificInformation

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_format_appid value:self.formatAppId];
    [writer writeElement:c_element_format_tag value:self.formatTag];
    [writer writeElement:c_element_when content:self.when];
    [writer writeElement:c_element_summary value:self.summary];
    [writer writeElement:c_element_any value:self.any];
}

- (void)deserialize:(XReader *)reader
{
    self.formatAppId = [reader readStringElement:c_element_format_appid];
    self.formatTag = [reader readStringElement:c_element_format_tag];
    self.when = [reader readElement:c_element_when asClass:[MHVDateTime class]];
    self.summary = [reader readStringElement:c_element_summary];
    self.any = [reader readStringElement:c_element_any];
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

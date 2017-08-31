//
// MHVAppSpecificInformation.h
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

#import "MHVThing.h"

@interface MHVAppSpecificInformation : MHVThingDataTyped

// -------------------------
//
// Data
//
// -------------------------
//
// (Required) The unique application identifier issued to the application that "owns" this format by Microsoft HealthVault.
//
@property (readwrite, nonatomic, strong) NSString *formatAppId;
//
// (Required) A unique tag that identifies the 'subtype' of the thing.
//
@property (readwrite, nonatomic, strong) NSString *formatTag;
//
// (Optional) The date and time of the thing.
//
@property (readwrite, nonatomic, strong) MHVDateTime *when;
//
// (Required) A descriptive display text for this thing.
//
@property (readwrite, nonatomic, strong) NSString *summary;
//
// (Optional) Application specific data in XML form.
//
@property (readwrite, nonatomic, strong) NSString *any;
@end

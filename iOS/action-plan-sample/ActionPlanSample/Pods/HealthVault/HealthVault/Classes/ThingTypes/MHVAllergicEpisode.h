//
// MHVAllergicEpisode.h
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

#import "MHVTypes.h"

@interface MHVAllergicEpisode : MHVThingDataTyped

// -------------------------
//
// Data
//
// -------------------------
//
// (Required) The date and time the episode occurred.
//
@property (readwrite, nonatomic, strong) MHVDateTime *when;
//
// (Required) The name of the allergy.
//
@property (readwrite, nonatomic, strong) MHVCodableValue *name;
//
// (Optional) The description of the symptoms of this allergic reaction.
//
@property (readwrite, nonatomic, strong) MHVCodableValue *reaction;
//
// (Optional) A description of the treatment taken for this allergic reaction.
//
@property (readwrite, nonatomic, strong) MHVCodableValue *treatment;

@end

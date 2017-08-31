//
// MHVPeakFlow.h
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

#import <Foundation/Foundation.h>
#import "MHVTypes.h"

@interface MHVPeakFlow : MHVThingDataTyped

//
// Required
//
@property (readwrite, nonatomic, strong) MHVApproxDateTime *when;
//
// (Optional) liters/second
//
@property (readwrite, nonatomic, strong) MHVFlowValue *peakExpiratoryFlow;
//
// (Optiona) Volume in 1 second
//
@property (readwrite, nonatomic, strong) MHVVolumeValue *forcedExpiratoryVolume1;
//
// (Optional) Volume in 6 seconds
//
@property (readwrite, nonatomic, strong) MHVVolumeValue *forcedExpiratoryVolume6;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) MHVCodableValue *flags;

//
// Convenience
//
@property (readwrite, nonatomic, assign) double pefValue;

// -------------------------
//
// Initializers
//
// -------------------------
- (instancetype)initWithDate:(NSDate *)when;

+ (MHVThing *)newThing;


// -------------------------
//
// Text
//
// -------------------------
- (NSString *)toString;

// -------------------------
//
// Type information
//
// -------------------------
+ (NSString *)typeID;
+ (NSString *)XRootElement;

@end

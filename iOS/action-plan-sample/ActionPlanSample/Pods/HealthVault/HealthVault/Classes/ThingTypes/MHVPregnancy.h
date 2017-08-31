//
//  MHVPregnancy.h
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

#import "MHVThing.h"
#import "MHVApproxDate.h"
#import "MHVDelivery.h"

@interface MHVPregnancy : MHVThingDataTyped

//
// (Optional) The approximate due date.
//
@property (readwrite, nonatomic, strong) MHVApproxDate *dueDate;
//
// (Optional) The first day of the last menstrual cycle.
//
@property (readwrite, nonatomic, strong) MHVDate *lastMenstrualPeriod;
//
// (Optional) The method of conception.
//
@property (readwrite, nonatomic, strong) MHVCodableValue *conceptionMethod;
//
// (Optional) The number of fetuses.
//
@property (readwrite, nonatomic, strong) MHVNonNegativeInt *feteusCount;
//
// (Optional) Number of weeks of pregnancy at the time of delivery.
//
@property (readwrite, nonatomic, strong) MHVPositiveInt *gestationalAge;
//
// (Optional) Details about the resolution for each fetus.	
//
@property (readwrite, nonatomic, strong) NSArray<MHVDelivery *> *delivery;

@end

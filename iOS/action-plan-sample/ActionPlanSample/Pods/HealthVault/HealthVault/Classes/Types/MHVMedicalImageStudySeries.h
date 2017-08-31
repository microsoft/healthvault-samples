//
//  MHVMedicalImageStudySeries.h
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

#import "MHVType.h"
#import "MHVDateTime.h"
#import "MHVStringNZNW.h"
#import "MHVMedicalImageStudySeriesImage.h"
#import "MHVOrganization.h"

@interface MHVMedicalImageStudySeries : MHVType

@property (readwrite, nonatomic, strong) MHVDateTime *acquisitionDatetime;
@property (readwrite, nonatomic, strong) MHVStringNZNW *descriptionText;
@property (readwrite, nonatomic, strong) NSArray<MHVMedicalImageStudySeriesImage *> *images;
@property (readwrite, nonatomic, strong) MHVOrganization *institutionName;
@property (readwrite, nonatomic, strong) MHVCodableValue *modality;
@property (readwrite, nonatomic, strong) MHVCodableValue *bodyPart;
@property (readwrite, nonatomic, strong) MHVStringNZNW *previewBlobName;
@property (readwrite, nonatomic, strong) MHVStringNZNW *seriesInstanceUid;

@end


//
//  MHVMedicalImageStudy.h
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
#import "MHVStringNZNW.h"
#import "MHVMedicalImageStudySeries.h"
#import "MHVPerson.h"

@interface MHVMedicalImageStudy : MHVThingDataTyped

//
// (Required) The date and time the study was created.
//
@property (readwrite, nonatomic, strong) MHVDateTime *when;
//
// (Optional) The name of the patient as contained in the medical image.
//
@property (readwrite, nonatomic, strong) MHVStringNZNW *patientName;
//
// (Optional) A description of the study.
//
@property (readwrite, nonatomic, strong) MHVStringNZNW *descriptionText;
//
// (Required) A collection of series.
//
@property (readwrite, nonatomic, strong) NSArray<MHVMedicalImageStudySeries *> *series;
//
// (Optional) The reason for the study.
//
@property (readwrite, nonatomic, strong) MHVCodableValue *reason;
//
// (Optional) The name of the blob holding a smaller version of the image suitable for web viewing or email.
//
@property (readwrite, nonatomic, strong) MHVStringNZNW *previewBlobName;
//
// (Optional) The important images in the study.
//
@property (readwrite, nonatomic, strong) NSArray<MHVMedicalImageStudySeriesImage *> *keyImages;
//
// (Optional) The study instance UID.
//
@property (readwrite, nonatomic, strong) MHVStringNZNW *studyInstanceUid;
//
// (Optional) The physician who ordered the study.
//
@property (readwrite, nonatomic, strong) MHVPerson *referringPhysician;
//
// (Optional) The radiology information service generated number that identifies the order for the study.
//
@property (readwrite, nonatomic, strong) MHVStringNZNW *accessionNumber;

@end

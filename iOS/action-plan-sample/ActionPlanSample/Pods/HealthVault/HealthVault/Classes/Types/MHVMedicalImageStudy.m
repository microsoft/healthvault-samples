//
//  MHVMedicalImageStudy.m
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

#import "MHVMedicalImageStudy.h"

static NSString *const c_typeid = @"cdfc0a9b-6d3b-4d16-afa8-02b86d621a8d";
static NSString *const c_typename = @"medical-image-study";

static NSString *const c_element_when = @"when";
static NSString *const c_element_patient_name = @"patient-name";
static NSString *const c_element_description = @"description";
static NSString *const c_element_series = @"series";
static NSString *const c_element_reason = @"reason";
static NSString *const c_element_preview_blob_name = @"preview-blob-name";
static NSString *const c_element_key_images = @"key-images";
static NSString *const c_element_study_instance_uid = @"study-instance-uid";
static NSString *const c_element_referring_physician = @"referring-physician";
static NSString *const c_element_accession_number = @"accession-number";

@implementation MHVMedicalImageStudy

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_when content:self.when];
    [writer writeElement:c_element_patient_name content:self.patientName];
    [writer writeElement:c_element_description content:self.descriptionText];
    [writer writeElementArray:c_element_series elements:self.series];
    [writer writeElement:c_element_reason content:self.reason];
    [writer writeElement:c_element_preview_blob_name content:self.previewBlobName];
    [writer writeElementArray:c_element_key_images elements:self.keyImages];
    [writer writeElement:c_element_study_instance_uid content:self.studyInstanceUid];
    [writer writeElement:c_element_referring_physician content:self.referringPhysician];
    [writer writeElement:c_element_accession_number content:self.accessionNumber];
}

- (void)deserialize:(XReader *)reader
{
    self.when = [reader readElement:c_element_when asClass:[MHVDateTime class]];
    self.patientName = [reader readElement:c_element_patient_name asClass:[MHVStringNZNW class]];
    self.descriptionText = [reader readElement:c_element_description asClass:[MHVStringNZNW class]];
    self.series = [reader readElementArray:c_element_series asClass:[MHVMedicalImageStudySeries class] andArrayClass:[NSMutableArray class]];
    self.reason = [reader readElement:c_element_reason asClass:[MHVCodableValue class]];
    self.previewBlobName = [reader readElement:c_element_preview_blob_name asClass:[MHVStringNZNW class]];
    self.keyImages = [reader readElementArray:c_element_key_images asClass:[MHVMedicalImageStudySeriesImage class] andArrayClass:[NSMutableArray class]];
    self.studyInstanceUid = [reader readElement:c_element_study_instance_uid asClass:[MHVStringNZNW class]];
    self.referringPhysician = [reader readElement:c_element_referring_physician asClass:[MHVPerson class]];
    self.accessionNumber = [reader readElement:c_element_accession_number asClass:[MHVStringNZNW class]];
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

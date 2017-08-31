//
//  MHVMedicalImageStudySeries.m
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

#import "MHVMedicalImageStudySeries.h"

static NSString *const c_element_acquisition_datetime = @"acquisition-datetime";
static NSString *const c_element_description = @"description";
static NSString *const c_element_images = @"images";
static NSString *const c_element_institution_name = @"institution-name";
static NSString *const c_element_modality = @"modality";
static NSString *const c_element_body_part = @"body-part";
static NSString *const c_element_preview_blob_name = @"preview-blob-name";
static NSString *const c_element_series_instance_uid = @"series-instance-uid";

@implementation MHVMedicalImageStudySeries

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_acquisition_datetime content:self.acquisitionDatetime];
    [writer writeElement:c_element_description content:self.descriptionText];
    [writer writeElementArray:c_element_images elements:self.images];
    [writer writeElement:c_element_institution_name content:self.institutionName];
    [writer writeElement:c_element_modality content:self.modality];
    [writer writeElement:c_element_body_part content:self.bodyPart];
    [writer writeElement:c_element_preview_blob_name content:self.previewBlobName];
    [writer writeElement:c_element_series_instance_uid content:self.seriesInstanceUid];
}

- (void)deserialize:(XReader *)reader
{
    self.acquisitionDatetime = [reader readElement:c_element_acquisition_datetime asClass:[MHVDateTime class]];
    self.descriptionText = [reader readElement:c_element_description asClass:[MHVStringNZNW class]];
    self.images = [reader readElementArray:c_element_images asClass:[MHVMedicalImageStudySeriesImage class] andArrayClass:[NSMutableArray class]];
    self.institutionName = [reader readElement:c_element_institution_name asClass:[MHVOrganization class]];
    self.modality = [reader readElement:c_element_modality asClass:[MHVCodableValue class]];
    self.bodyPart = [reader readElement:c_element_body_part asClass:[MHVCodableValue class]];
    self.previewBlobName = [reader readElement:c_element_preview_blob_name asClass:[MHVStringNZNW class]];
    self.seriesInstanceUid = [reader readElement:c_element_series_instance_uid asClass:[MHVStringNZNW class]];
}

@end


//
//  MHVMedicalImageStudySeriesImage.m
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

#import "MHVMedicalImageStudySeriesImage.h"

static NSString *const c_element_image_blob_name = @"image-blob-name";
static NSString *const c_element_image_preview_blob_name = @"image-preview-blob-name";

@implementation MHVMedicalImageStudySeriesImage

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_image_blob_name content:self.imageBlobName];
    [writer writeElement:c_element_image_preview_blob_name content:self.imagePreviewBlobName];
}

- (void)deserialize:(XReader *)reader
{
    self.imageBlobName = [reader readElement:c_element_image_blob_name asClass:[MHVStringNZNW class]];
    self.imagePreviewBlobName = [reader readElement:c_element_image_preview_blob_name asClass:[MHVStringNZNW class]];
}

@end


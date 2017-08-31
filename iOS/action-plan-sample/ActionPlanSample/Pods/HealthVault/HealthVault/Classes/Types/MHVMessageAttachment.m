//
// MHVMessageAttachment.m
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

#import "MHVValidator.h"
#import "MHVMessageAttachment.h"

static const xmlChar *x_element_name = XMLSTRINGCONST("name");
static const xmlChar *x_element_blob = XMLSTRINGCONST("blob-name");
static const xmlChar *x_element_inline = XMLSTRINGCONST("inline-display");
static const xmlChar *x_element_contentid = XMLSTRINGCONST("content-id");

@implementation MHVMessageAttachment

- (instancetype)initWithName:(NSString *)name andBlobName:(NSString *)blobName
{
    MHVCHECK_STRING(name);
    MHVCHECK_STRING(blobName);

    self = [super init];
    if (self)
    {
        _name = name;
        _blobName = blobName;
        _isInline = FALSE;
        _contentID = nil;
    }

    return self;
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN;

    MHVVALIDATE_STRING(self.name, MHVClientError_InvalidMessageAttachment);
    MHVVALIDATE_STRING(self.blobName, MHVClientError_InvalidMessageAttachment);

    MHVVALIDATE_SUCCESS;
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementXmlName:x_element_name value:self.name];
    [writer writeElementXmlName:x_element_blob value:self.blobName];
    [writer writeElementXmlName:x_element_inline boolValue:self.isInline];
    [writer writeElementXmlName:x_element_contentid value:self.contentID];
}

- (void)deserialize:(XReader *)reader
{
    self.name = [reader readStringElementWithXmlName:x_element_name];
    self.blobName = [reader readStringElementWithXmlName:x_element_blob];
    self.isInline = [reader readBoolElementXmlName:x_element_inline];
    self.contentID = [reader readStringElementWithXmlName:x_element_contentid];
}

@end

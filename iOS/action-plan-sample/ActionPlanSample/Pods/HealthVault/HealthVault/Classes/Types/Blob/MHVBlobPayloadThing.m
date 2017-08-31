//
// MHVBlobPayloadThing.m
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

#import "MHVBlobPayloadThing.h"
#import "MHVValidator.h"

static NSString *const c_element_blobInfo = @"blob-info";
static NSString *const c_element_length = @"content-length";
static NSString *const c_element_blobUrl = @"blob-ref-url";
static NSString *const c_element_base64data = @"base64data";
static NSString *const c_element_legacyEncoding = @"legacy-content-encoding";
static NSString *const c_element_currentEncoding = @"current-content-encoding";

@interface MHVBlobPayloadThing ()

@property (nonatomic, strong) NSString *legacyEncoding;
@property (nonatomic, strong) NSString *encoding;
@property (nonatomic, strong) NSString *inlineDataString;

@end

@implementation MHVBlobPayloadThing

- (NSString *)name
{
    return (self.blobInfo) ? self.blobInfo.name : @"";
}

- (NSString *)contentType
{
    return (self.blobInfo) ? self.blobInfo.contentType : @"";
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _length = -1;
    }

    return self;
}

- (instancetype)initWithBlobName:(NSString *)name contentType:(NSString *)contentType length:(NSInteger)length andUrl:(NSString *)blobUrl
{
    MHVCHECK_STRING(blobUrl);

    self = [self init];
    if (self)
    {
        _blobInfo = [[MHVBlobInfo alloc] initWithName:name andContentType:contentType];
        MHVCHECK_NOTNULL(_blobInfo);

        _length = length;

        _blobUrl = blobUrl;
    }

    return self;
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN

    MHVVALIDATE(self.blobInfo, MHVClientError_InvalidBlobInfo);
    MHVVALIDATE_STRING(self.blobUrl, MHVClientError_InvalidBlobInfo);

    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_blobInfo content:self.blobInfo];
    [writer writeElement:c_element_length intValue:(int)self.length];
    [writer writeElement:c_element_base64data value:self.inlineDataString];
    [writer writeElement:c_element_blobUrl value:self.blobUrl];
    [writer writeElement:c_element_legacyEncoding value:self.legacyEncoding];
    [writer writeElement:c_element_currentEncoding value:self.encoding];
}

- (void)deserialize:(XReader *)reader
{
    self.blobInfo = [reader readElement:c_element_blobInfo asClass:[MHVBlobInfo class]];
    self.length = [reader readIntElement:c_element_length];
    self.inlineDataString = [reader readStringElement:c_element_base64data];
    self.blobUrl = [reader readStringElement:c_element_blobUrl];
    self.legacyEncoding = [reader readStringElement:c_element_legacyEncoding];
    self.encoding = [reader readStringElement:c_element_currentEncoding];
}

// Convert inlineData to and from base64 as the string is read or written by the serializer
- (void)setInlineDataString:(NSString *)inlineDataString
{
    if (inlineDataString)
    {
        self.inlineData = [[NSData alloc] initWithBase64EncodedString:inlineDataString options:kNilOptions];
        if (!self.inlineData)
        {
            MHVASSERT_MESSAGE(@"Could not convert Base64 encoded string to NSData");
        }
    }
    else
    {
        self.inlineData = nil;
    }
}

- (NSString *)inlineDataString
{
    return [self.inlineData base64EncodedStringWithOptions:kNilOptions];
}

@end


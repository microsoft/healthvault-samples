//
// MHVBlobInfo.m
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

#import "MHVBlobInfo.h"
#import "MHVValidator.h"

static NSString *const c_element_name = @"name";
static NSString *const c_element_contentType = @"content-type";

@interface MHVBlobInfo ()

@property (nonatomic, strong) MHVStringZ255 *nameValue;
@property (nonatomic, strong) MHVStringZ1024 *contentTypeValue;

@end

@implementation MHVBlobInfo

- (NSString *)name
{
    NSString *blobName = (_nameValue) ? _nameValue.value : nil;

    return (blobName) ? blobName : @"";
}

- (void)setName:(NSString *)name
{
    if (!_nameValue)
    {
        _nameValue = [[MHVStringZ255 alloc] init];
    }

    _nameValue.value = name;
}

- (NSString *)contentType
{
    return (_contentTypeValue) ? _contentTypeValue.value : nil;
}

- (void)setContentType:(NSString *)contentType
{
    if (!_contentTypeValue)
    {
        _contentTypeValue = [[MHVStringZ1024 alloc] init];
    }
    
    _contentTypeValue.value = contentType;
}

- (instancetype)initWithName:(NSString *)name andContentType:(NSString *)contentType
{
    self = [super init];
    if (self)
    {
        [self setName:name];
        [self setContentType:contentType];

        MHVCHECK_NOTNULL(_nameValue);
        MHVCHECK_NOTNULL(_contentTypeValue);
    }

    return self;
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN

    MHVVALIDATE_OPTIONAL(self.nameValue);
    MHVVALIDATE_OPTIONAL(self.contentTypeValue);

    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_name content:self.nameValue];
    [writer writeElement:c_element_contentType content:self.contentTypeValue];
}

- (void)deserialize:(XReader *)reader
{
    self.nameValue = [reader readElement:c_element_name asClass:[MHVStringZ255 class]];
    self.contentTypeValue = [reader readElement:c_element_contentType asClass:[MHVStringZ1024 class]];
}

@end

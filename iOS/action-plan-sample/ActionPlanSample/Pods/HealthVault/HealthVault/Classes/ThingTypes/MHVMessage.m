//
// MHVMessage.m
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
#import "MHVMessage.h"
#import "NSArray+Utils.h"

static NSString *const c_typeid = @"72dc49e1-1486-4634-b651-ef560ed051e5";
static NSString *const c_typename = @"message";

static const xmlChar *x_element_when = XMLSTRINGCONST("when");
static NSString *const c_element_headers = @"headers";
static const xmlChar *x_element_size = XMLSTRINGCONST("size");
static const xmlChar *x_element_summary = XMLSTRINGCONST("summary");
static const xmlChar *x_element_htmlBlob = XMLSTRINGCONST("html-blob-name");
static const xmlChar *x_element_textBlob = XMLSTRINGCONST("text-blob-name");
static NSString *const c_element_attachments = @"attachments";

@implementation MHVMessage

- (BOOL)hasHeaders
{
    return ![NSArray isNilOrEmpty:self.headers];
}

- (BOOL)hasAttachments
{
    return ![NSArray isNilOrEmpty:self.attachments];
}

- (BOOL)hasHtmlBody
{
    return self.htmlBlobName != nil && ![self.htmlBlobName isEqualToString:@""];
}

- (BOOL)hasTextBody
{
    return self.textBlobName != nil && ![self.textBlobName isEqualToString:@""];
}

- (NSString *)getFrom
{
    return [self getValueForHeader:@"From"];
}

- (NSString *)getTo
{
    return [self getValueForHeader:@"To"];
}

- (NSString *)getSubject
{
    return [self getValueForHeader:@"Subject"];
}

- (NSString *)getCC
{
    return [self getValueForHeader:@"CC"];
}

- (NSString *)getMessageDate
{
    return [self getValueForHeader:@"Date"];
}

- (NSString *)getValueForHeader:(NSString *)name
{
    if (!self.hasHeaders)
    {
        return nil;
    }
    
    for (MHVMessageHeaderThing *header in self.headers)
    {
        if ([header.name caseInsensitiveCompare:name] == NSOrderedSame)
        {
            return header.value;
        }
    }
    
    return @"";
}

- (NSDate *)getDate
{
    return [self.when toDate];
}

- (NSDate *)getDateForCalendar:(NSCalendar *)calendar
{
    return [self.when toDateForCalendar:calendar];
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN;

    MHVVALIDATE(self.when, MHVClientError_InvalidMessage);
    MHVVALIDATE_ARRAYOPTIONAL(self.headers, MHVClientError_InvalidMessage);
    MHVVALIDATE(self.size, MHVClientError_InvalidMessage);
    MHVVALIDATE_ARRAYOPTIONAL(self.attachments, MHVClientError_InvalidMessage);

    MHVVALIDATE_SUCCESS;
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementXmlName:x_element_when content:self.when];
    [writer writeElementArray:c_element_headers elements:self.headers];
    [writer writeElementXmlName:x_element_size content:self.size];
    [writer writeElementXmlName:x_element_summary value:self.summary];
    [writer writeElementXmlName:x_element_htmlBlob value:self.htmlBlobName];
    [writer writeElementXmlName:x_element_textBlob value:self.textBlobName];
    [writer writeElementArray:c_element_attachments elements:self.attachments];
}

- (void)deserialize:(XReader *)reader
{
    self.when = [reader readElementWithXmlName:x_element_when asClass:[MHVDateTime class]];
    self.headers = [reader readElementArray:c_element_headers
                                    asClass:[MHVMessageHeaderThing class]
                              andArrayClass:[NSMutableArray class]];
    self.size = [reader readElementWithXmlName:x_element_size asClass:[MHVPositiveInt class]];
    self.summary = [reader readStringElementWithXmlName:x_element_summary];
    self.htmlBlobName = [reader readStringElementWithXmlName:x_element_htmlBlob];
    self.textBlobName = [reader readStringElementWithXmlName:x_element_textBlob];
    self.attachments = [reader readElementArray:c_element_attachments
                                        asClass:[MHVMessageAttachment class]
                                  andArrayClass:[NSMutableArray class]];
}

+ (NSString *)typeID
{
    return c_typeid;
}

+ (NSString *)XRootElement
{
    return c_typename;
}

+ (MHVThing *)newThing
{
    return [[MHVThing alloc] initWithType:[MHVMessage typeID]];
}

- (NSString *)typeName
{
    return NSLocalizedString(@"Message", @"Message Type Name");
}

@end

//
// XString.m
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

#import "XString.h"
#import "MHVStringExtensions.h"
#import "MHVValidator.h"
#import <math.h>
#import <libxml/xmlreader.h>

@implementation NSString (XExtensions)

+ (NSString *)newFromXmlString:(xmlChar *)xmlString
{
    if (!xmlString)
    {
        return nil;
    }

    return [[NSString alloc] initWithCString:(char *)xmlString encoding:NSUTF8StringEncoding];
}

+ (NSString *)newFromConstXmlString:(const xmlChar *)xmlString
{
    return [NSString newFromXmlString:(xmlChar *)xmlString];
}

+ (NSString *)fromXmlString:(xmlChar *)xmlString
{
    if (!xmlString)
    {
        return nil;
    }

    return [NSString stringWithCString:(char *)xmlString encoding:NSUTF8StringEncoding];
}

+ (NSString *)fromConstXmlString:(const xmlChar *)xmlString
{
    if (!xmlString)
    {
        return nil;
    }

    return [NSString fromXmlString:(xmlChar *)xmlString];
}

+ (NSString *)fromXmlStringAndFreeXml:(xmlChar *)xmlString
{
    NSString *string = nil;

    if (xmlString)
    {
        string = [NSString fromXmlString:xmlString];
        xmlFree(xmlString);
    }

    return string;
}

- (xmlChar *)toXmlString
{
    return (xmlChar *)[self UTF8String];
}

- (const xmlChar *)toXmlStringConst
{
    return (const xmlChar *)[self UTF8String];
}

@end

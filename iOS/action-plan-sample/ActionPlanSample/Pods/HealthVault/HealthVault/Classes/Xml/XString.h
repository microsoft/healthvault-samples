//
// XString.h
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

#import <Foundation/Foundation.h>

typedef unsigned char xmlChar;

//
// Extensions to NSString for xmlChar* support
//
@interface NSString (XExtensions)

+ (NSString *)newFromXmlString:(xmlChar *)xmlString;
+ (NSString *)newFromConstXmlString:(const xmlChar *)xmlString;
+ (NSString *)fromXmlString:(xmlChar *)xmlString;
+ (NSString *)fromConstXmlString:(const xmlChar *)xmlString;
+ (NSString *)fromXmlStringAndFreeXml:(xmlChar *)xmlString;
- (xmlChar *)toXmlString;
- (const xmlChar *)toXmlStringConst;

@end

#define XMLSTRINGCONST(sz) (const xmlChar *)sz

//
// MHVStringExtensions.h
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

// ---------------------------------
//
// NSString
//
// ---------------------------------
@interface NSString (MHVNSStringExtensions)

+ (BOOL)isNilOrEmpty:(NSString *)string;
+ (NSString *)boolString:(BOOL)boolValue;

- (BOOL)isEmpty;
- (NSString *)trim;

- (BOOL)isEqualToStringCaseInsensitive:(NSString *)aString;

- (NSScanner *)newScanner;

- (NSUInteger)indexOfFirstChar:(unichar)ch;

- (BOOL)parseDouble:(double *)pValue;
- (BOOL)parseFloat:(float *)pValue;
- (BOOL)parseInt:(int *)pValue;

- (NSString *)urlEncode;

- (NSString *)toString;
- (NSString *)toStringWithFormat:(NSString *)format;
- (NSString *)capitalizedStringForSelectors;

@end

// ---------------------------------
//
// NSString
//
// ---------------------------------
@interface NSMutableString (MHVNSMutableStringExtensions)

- (void)clear;

- (BOOL)setStringAndVerify:(NSString *)aString;

- (void)appendNewLine;
- (void)appendNewLines:(int)count;
- (void)appendLines:(int)count, ...;
- (void)appendStrings:(NSArray *)strings;
- (void)appendStringAsLine:(NSString *)string;
- (void)appendStringsAsLines:(NSArray *)strings;

- (void)appendOptionalString:(NSString *)string;
- (void)appendOptionalString:(NSString *)string withSeparator:(NSString *)separator;
- (void)appendOptionalStringAsLine:(NSString *)string;

- (NSString *)trim;

- (void)appendXmlElementStart:(NSString *)tag;
- (void)appendXmlElementEnd:(NSString *)tag;
- (void)appendXmlElement:(NSString *)tag text:(NSString *)text;

@end

CFStringRef CreateHVUrlEncode(CFStringRef source);

//
// MHVStringExtensions.m
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

#import "MHVStringExtensions.h"
#import "MHVValidator.h"
#import "NSArray+Utils.h"


static NSString *kStringTrue = @"true";
static NSString *kStringFalse = @"false";

@implementation NSString (NVNSStringExtensions)

+ (BOOL)isNilOrEmpty:(NSString *)string
{
    return string == nil || string.length == 0;
}

+ (NSString*)boolString:(BOOL)boolValue
{
    return boolValue ? [kStringTrue copy] : [kStringFalse copy];
}

- (BOOL)isEmpty
{
    return self.length == 0;
}

- (NSUInteger)indexOfFirstChar:(unichar)ch
{
    for (NSUInteger i = 0, count = self.length; i < count; ++i)
    {
        if (ch == [self characterAtIndex:i])
        {
            return i;
        }
    }

    return NSNotFound;
}

- (BOOL)isEqualToStringCaseInsensitive:(NSString *)aString
{
    return [self caseInsensitiveCompare:aString] == NSOrderedSame;
}

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSScanner *)newScanner
{
    return [[NSScanner alloc] initWithString:self];
}

- (BOOL)parseFloat:(float *)pValue
{
    MHVCHECK_NOTNULL(pValue);

    NSScanner *scanner = [self newScanner];
    MHVCHECK_NOTNULL(scanner);

    BOOL result = [scanner scanFloat:pValue];

    return result;
}

- (BOOL)parseDouble:(double *)pValue
{
    MHVCHECK_NOTNULL(pValue);

    NSScanner *scanner = [self newScanner];
    MHVCHECK_NOTNULL(scanner);

    BOOL result = [scanner scanDouble:pValue];

    return result;
}

- (BOOL)parseInt:(int *)pValue
{
    MHVCHECK_NOTNULL(pValue);

    NSScanner *scanner = [self newScanner];
    MHVCHECK_NOTNULL(scanner);

    BOOL result = [scanner scanInt:pValue];
    return result;
}

- (NSString *)urlEncode
{
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)toString
{
    return self;
}

- (NSString *)toStringWithFormat:(NSString *)format
{
    return [NSString stringWithFormat:format, self];
}

- (NSString *)capitalizedStringForSelectors
{
    if ([self isEqualToString:@""])
    {
        return self;
    }
    NSRange rangeForFirstChar = NSMakeRange(0, 1);
    NSString *substringFirstChar = [self substringWithRange:rangeForFirstChar];
    
    return [self stringByReplacingCharactersInRange:rangeForFirstChar withString:[substringFirstChar uppercaseString]];
}

@end

@implementation NSMutableString (MHVNSMutableStringExtensions)

- (void)clear
{
    [self setString:@""];
}

- (BOOL)setStringAndVerify:(NSString *)aString
{
    [self setString:aString];
    return self.length == aString.length;
}

- (void)appendNewLine
{
    [self appendString:@"\r\n"];
}

- (void)appendNewLines:(int)count
{
    for (int i = 0; i < count; ++i)
    {
        [self appendNewLine];
    }
}

- (void)appendLines:(int)count, ...
{
    va_list args;
    va_start(args, count);

    for (int i = 0; i < count; ++i)
    {
        NSString *string = va_arg(args, NSString *);
        if (![NSString isNilOrEmpty:string])
        {
            [self appendString:string];
            [self appendNewLine];
        }
    }

    va_end(args);
}

- (void)appendStrings:(NSArray *)strings
{
    if ([NSArray isNilOrEmpty:strings])
    {
        return;
    }

    for (NSString *string in strings)
    {
        [self appendString:string];
    }
}

- (void)appendStringAsLine:(NSString *)string
{
    if (!string)
    {
        return;
    }

    [self appendString:string];
    [self appendNewLine];
}

- (void)appendStringsAsLines:(NSArray *)strings
{
    if ([NSArray isNilOrEmpty:strings])
    {
        return;
    }

    for (NSString *string in strings)
    {
        if (![NSString isNilOrEmpty:string])
        {
            [self appendString:string];
            [self appendNewLine];
        }
    }
}

- (void)appendOptionalString:(NSString *)string
{
    if (![NSString isNilOrEmpty:string])
    {
        [self appendString:string];
    }
}

- (void)appendOptionalString:(NSString *)string withSeparator:(NSString *)separator
{
    if (![NSString isNilOrEmpty:string])
    {
        if (self.length > 0)
        {
            [self appendString:separator];
        }

        [self appendString:string];
    }
}

- (void)appendOptionalStringAsLine:(NSString *)string
{
    if (![NSString isNilOrEmpty:string])
    {
        [self appendStringAsLine:string];
    }
}

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (void)appendXmlElementStart:(NSString *)tag
{
    [self appendString:@"<"];
    [self appendString:tag];
    [self appendString:@">"];
}

- (void)appendXmlElementEnd:(NSString *)tag
{
    [self appendString:@"</"];
    [self appendString:tag];
    [self appendString:@">"];
}

- (void)appendXmlElement:(NSString *)tag text:(NSString *)text
{
    [self appendXmlElementStart:tag];
    [self appendString:text];
    [self appendXmlElementEnd:tag];
}

@end

CFStringRef CreateHVUrlEncode(CFStringRef source)
{
    return CFURLCreateStringByAddingPercentEscapes(NULL, source,
                                                   NULL,
                                                   (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                   kCFStringEncodingUTF8);
}

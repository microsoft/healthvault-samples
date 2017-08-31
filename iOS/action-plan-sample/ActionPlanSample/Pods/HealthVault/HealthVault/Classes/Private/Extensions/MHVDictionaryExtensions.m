//
// MHVDictionaryExtensions.m
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

#import "MHVDictionaryExtensions.h"
#import "MHVValidator.h"
#import "MHVStringExtensions.h"
#import "NSDate+DataModel.h"
#import "MHVDateTimeBase.h"
#import "NSArray+Utils.h"
#import "MHVEnum.h"

@implementation NSDictionary (MHVDictionaryExtensions)

+ (BOOL)isNilOrEmpty:(NSDictionary *)dictionary
{
    return dictionary == nil || dictionary.count == 0;
}

+ (NSMutableDictionary *)dictionaryFromArgumentString:(NSString *)args
{
    if ([NSString isNilOrEmpty:args])
    {
        return nil;
    }

    NSArray *parts = [args componentsSeparatedByString:@"&"];
    if ([NSArray isNilOrEmpty:parts])
    {
        return nil;
    }

    NSMutableDictionary *nvPairs = [NSMutableDictionary dictionary];
    MHVCHECK_NOTNULL(nvPairs);

    for (NSUInteger i = 0, count = parts.count; i < count; ++i)
    {
        NSString *part = [parts objectAtIndex:i];
        if ([NSString isNilOrEmpty:part])
        {
            continue;
        }

        NSString *key = part;
        NSString *value = @"";

        NSUInteger nvSepPos = [part indexOfFirstChar:'='];
        if (nvSepPos != NSNotFound)
        {
            key = [part substringToIndex:nvSepPos];
            value = [part substringFromIndex:nvSepPos + 1]; // Handles the case where = is at the end of the string
        }

        [nvPairs setValue:value forKey:key];
    }

    return nvPairs;
}

- (NSString *)queryString
{
    if (self.allKeys.count == 0)
    {
        return @"";
    }
    
    NSMutableString *query = [[NSMutableString alloc] init];
    
    for (NSString *key in self.allKeys)
    {
        if (query.length > 0)
        {
            [query appendString:@"&"];
        }
        
        if ([self[key] isKindOfClass:[NSDate class]])
        {
            NSDateFormatter *formatter = [NSDateFormatter new];
            [formatter setDateFormat: kISODateWithTimeZoneFormatterString];
            NSString *strDate = [formatter stringFromDate: self[key]];
            [query appendFormat:@"%@=%@", key, [strDate urlEncode]];
        }
        else if ([self[key] isKindOfClass:[MHVEnum class]])
        {
            [query appendFormat:@"%@=%@", key, [self[key] stringValue]];
        }
        else
        {
            [query appendFormat:@"%@=%@", key, [[self[key] description] urlEncode]];
        }
    }
    return query;
}

@end

//
// NSArray+MHVEnum.m
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

#import "NSArray+MHVEnum.h"
#import "NSArray+Utils.h"
#import "MHVValidator.h"
#import "MHVEnum.h"

@implementation NSArray (MHVEnum)

- (NSString *)enumArrayToStringWithSeparator:(NSString *)separator
{
    MHVASSERT_PARAMETER(separator);
    MHVASSERT([self areAllObjectsOfClass:[MHVEnum class]])
    
    if (!separator || ![self areAllObjectsOfClass:[MHVEnum class]])
    {
        return nil;
    }
    
    //Build comma separated list of enum values
    NSMutableString *enumString = [NSMutableString new];
    for (MHVEnum *enumValue in self)
    {
        if (enumString.length > 0)
        {
            [enumString appendString:separator];
        }
        [enumString appendString:enumValue.stringValue];
    }
    
    return enumString;
}

@end

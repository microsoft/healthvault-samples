//
// NSString+DataModel.m
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

#import "NSString+DataModel.h"
#import "MHVValidator.h"

@implementation NSString (DataModel)

- (instancetype)initWithObject:(id)object objectParameters:(NSObject*)ignored
{
    if (!object || [object isKindOfClass:[NSNull class]])
    {
        return nil;
    }
    else if ([object isKindOfClass:[NSString class]])
    {
        self = [self initWithString:object];
    }
    else if ([object isKindOfClass:[NSNumber class]])
    {
        self = [self initWithString:[(NSNumber*)object stringValue]];
    }
    else
    {
        MHVASSERT_TRUE(NO, @"Unsupported class: %@", NSStringFromClass([object class]));
    }
    return self;
}

- (NSString*)jsonRepresentationWithObjectParameters:(NSObject*)ignored
{
    return [NSString stringWithFormat:@"\"%@\"", [self escapeJSON]];
}

- (NSString *)escapeJSON
{
    //Copied from JSONSerializer, should be the right characters...
    NSMutableString * output = [NSMutableString string];
    for (int i = 0; i < self.length; ++i)
    {
        unichar thisChar = [self characterAtIndex:i];
        
        if(thisChar == '"')
        {
            [output appendFormat:@"%@", @"\\\""];
        }
        else if(thisChar == '/')
        {
            [output appendFormat:@"%@", @"\\/"];
        }
        else if(thisChar == '\n')
        {
            [output appendFormat:@"%@", @"\\n"];
        }
        else if(thisChar == '\b')
        {
            [output appendFormat:@"%@", @"\\b"];
        }
        else if(thisChar == '\f')
        {
            [output appendFormat:@"%@", @"\\f"];
        }
        else if(thisChar == '\r')
        {
            [output appendFormat:@"%@", @"\\r"];
        }
        else if(thisChar == '\t')
        {
            [output appendFormat:@"%@", @"\\t"];
        }
        else if(thisChar == '\\')
        {
            [output appendFormat:@"%@", @"\\\\"];
        }
        else if(thisChar == 0x201c || thisChar == 0x201d)
        {
            [output appendFormat:@"%@", @"\""];
        }
        else if(thisChar <= 0x1f)
        {
            continue;
        }
        else
        {
            [output appendFormat:@"%C", thisChar];
        }
    }
    return output;
}

@end

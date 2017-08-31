//
// Validator.m
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
#import "MHVType.h"

static id<MHVEventLog> s_eventLog;

void MHVRegisterEventLog(id<MHVEventLog> log)
{
    s_eventLog = log;
}

void MHVLogEvent(NSString *message)
{
    if (s_eventLog)
    {
        @try
        {
            [s_eventLog writeMessage:message];
            NSLog(@"%@", message);
        }
        @catch (id exception)
        {
        }
    }
}

void MHVLogEventFromCode(NSString *message, const char *fileName, NSUInteger line)
{
    //
    // FileNames can have full paths with embedded names of developers!
    // Remove them before logging. We'll only log the actual file name
    //
    NSString *fileNameString = [NSString stringWithUTF8String:fileName];

    fileNameString = [fileNameString lastPathComponent];
    NSString *logLine = [NSString stringWithFormat:@"%@ file:%@ line:%lu",
                         message,
                         fileNameString,
                         (unsigned long)line];
    MHVLogEvent(logLine);
}

MHVClientResult* MHVValidateArray(NSArray *array, MHVClientResultCode error)
{
    MHVVALIDATE_BEGIN;
    
    MHVVALIDATE_PTR(array, error);
    
    Class hvClass = [MHVType class];
    Class stringClass = [NSString class];
    
    for (id obj in array)
    {
        MHVVALIDATE_PTR(obj, error);
        
        if ([obj isKindOfClass:hvClass])
        {
            MHVType *hvType = (MHVType *)obj;
            MHVCHECK_RESULT([hvType validate]);
        }
        else if ([obj isKindOfClass:stringClass])
        {
            MHVVALIDATE_STRING((NSString *)obj, error);
        }
    }
    
    MHVVALIDATE_SUCCESS;
}

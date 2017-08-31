//
//  MHVValidator.h
//
//  Copyright (c) 2017 Microsoft Corporation. All rights reserved.
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
#import <CoreFoundation/CoreFoundation.h>
#import "MHVClientResult.h"

//-----------------------------
//
// Basic Event Logging
//
//------------------------------
@protocol MHVEventLog <NSObject>

-(void) writeMessage:(NSString *) message;

@end

void MHVRegisterEventLog(id<MHVEventLog> log);
void MHVLogEvent(NSString* message);
void MHVLogEventFromCode(NSString* message, const char* fileName, NSUInteger line);

//-----------------------------
//
// Asserts, checks...
//
//------------------------------

#ifndef NOERRORLOG

#define MHVASSERT_PARAMETER(param) \
do \
{ \
    if (!(param)) \
    { \
        NSString *message = [NSString stringWithFormat:@"'%s' is a required parameter.", #param];\
        MHVASSERT_MESSAGE(message); \
    } \
}\
while(NO)

#define MHVASSERT_MESSAGE(message) MHVLogEventFromCode(message, __FILE__, __LINE__);
#define MHVASSERT(condition) if (!(condition)) { MHVASSERT_MESSAGE(@#condition)}

#define MHVASSERT_TRUE(condition, ...) if (!(condition)) { MHVASSERT_MESSAGE(@#condition)}

#else

#define MHVASSERT(condition) 
#define MHVASSERT_MESSAGE(message) 

#endif

#ifdef DEBUG

#define MHVASSERT_C(condition) assert(condition);

#else

#define MHVASSERT_C(condition)

#endif

#define MHVASSERT_NOTNULL(obj) MHVASSERT(obj != nil)
#define MHVASSERT_STRING(string) MHVASSERT(!(!string || [string isEqualToString:@""]))

#define MHVCHECK_TRUE(condition) if (!(condition)) \
                                { \
                                    MHVASSERT_MESSAGE(@#condition); \
                                    return 0; \
                                }
#define MHVCHECK_FALSE(condition) MHVCHECK_TRUE(!(condition))

#define MHVCHECK_NOTNULL(obj) MHVCHECK_TRUE(obj != nil)
#define MHVCHECK_SELF MHVCHECK_TRUE(self != nil) 
#define MHVCHECK_STRING(string) MHVCHECK_FALSE(!string || [string isEqualToString:@""])

#define MHVCHECK_OOM(obj) if (obj == nil) \
                         { \
                            return 0; \
                         }

#define MHVCHECK_SUCCESS(methodCall) if (!methodCall) { \
                                MHVASSERT_MESSAGE(@#methodCall); \
                                return 0; \
                            }

#define MHVCHECK_PTR(ptr) MHVASSERT_C(ptr); \
                         if (!ptr) \
                         {         \
                            return 0; \
                         }

//-----------------------
//
// Type validation
//
//-----------------------
#define MHVVALIDATE_BEGIN        MHVClientResult *hr = MHVERROR_UNKNOWN; 
#define MHVVALIDATE_SUCCESS      return MHVRESULT_SUCCESS;

#define MHVCHECK_RESULT(method)  hr = method; \
                                if (hr.isError) \
                                { \
                                    MHVASSERT_MESSAGE(@"Validation Failed"); \
                                    return hr; \
                                }

#define MHVVALIDATE(obj, error)      if (!obj) \
                                    { \
                                        hr = MHVMAKE_ERROR(error); \
                                        return hr; \
                                    } \
                                    MHVCHECK_RESULT([obj validate])

#define MHVVALIDATE_OPTIONAL(obj)    if (obj) \
                                    { \
                                        MHVCHECK_RESULT([obj validate]);\
                                    }

#define MHVVALIDATE_STRING(string, error)   if (!string) \
                                            { \
                                                hr = MHVMAKE_ERROR(error); \
                                                return hr; \
                                            }


#define MHVVALIDATE_PTR(ptr, error)     if (!ptr) \
                                        { \
                                            hr = MHVMAKE_ERROR(error); \
                                            return hr; \
                                        } \

#define MHVVALIDATE_STRINGOPTIONAL(string, error)

#define MHVVALIDATE_ARRAY(var, error) MHVCHECK_RESULT(MHVValidateArray(var, error));
#define MHVVALIDATE_ARRAYOPTIONAL(var, error) if (var) { MHVVALIDATE_ARRAY(var, error);}

#define MHVVALIDATE_TRUE(condition, error)   if (!condition) \
                                            { \
                                                hr = MHVMAKE_ERROR(error); \
                                                return hr; \
                                            } \

MHVClientResult* MHVValidateArray(NSArray *array, MHVClientResultCode error);


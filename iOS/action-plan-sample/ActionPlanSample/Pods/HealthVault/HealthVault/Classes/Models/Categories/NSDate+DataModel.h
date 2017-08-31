//
// NSDate+DataModel.h
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

@interface NSDate (DataModel)

- (instancetype)initWithObject:(id)object objectParameters:(NSDateFormatter*)formatter;
- (NSString*)jsonRepresentationWithObjectParameters:(NSObject*)parameters;

@end

// TODO: Remove these and use NSISO8601DateFormatter
static NSString *const kISOGenericDateFormatterString = @"yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'";
static NSString *const kISODateFormatterString = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
static NSString *const kISODateWithTimeZoneFormatterString = @"yyyy-MM-dd'T'HH:mm:ss.SSSSSZZZZZ";
static NSString *const kISOActivityHistoryDateFormatterString = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
static NSString *const kISOBirthDateFormatterString = @"yyyy-MM-dd'T'HH:mm:ssZZZZZ";
static NSString *const kLoggingDateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";

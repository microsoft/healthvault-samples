//
// XConverter.h
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
#import <CoreFoundation/CoreFoundation.h>

@interface XConverter : NSObject

- (BOOL)tryString:(NSString *)source toInt:(int *)result;
- (int)stringToInt:(NSString *)source;
- (BOOL)tryInt:(int)source toString:(NSString **)result;
- (NSString *)intToString:(int)source;

- (BOOL)tryString:(NSString *)source toFloat:(float *)result;
- (float)stringToFloat:(NSString *)source;
- (BOOL)tryFloat:(float)source toString:(NSString **)result;
- (NSString *)floatToString:(float)source;

//
// Try to parse the given Xml string into a double.
// Automatically takes care of trimming for leading/trailing spaces
//
- (BOOL)tryString:(NSString *)source toDouble:(double *)result;
- (double)stringToDouble:(NSString *)source;

- (BOOL)tryDouble:(double)source toString:(NSString **)result;
- (BOOL)tryDoubleRoundtrip:(double)source toString:(NSString **)result;
- (NSString *)doubleToString:(double)source;

- (BOOL)tryString:(NSString *)source toBool:(BOOL *)result;
- (BOOL)stringToBool:(NSString *)source;
- (NSString *)boolToString:(BOOL)source;

- (BOOL)tryString:(NSString *)source toDate:(NSDate **)result;
- (NSDate *)stringToDate:(NSString *)source;
- (BOOL)tryDate:(NSDate *)source toString:(NSString **)result;
- (NSString *)dateToString:(NSDate *)source;

- (NSUUID *)stringToUuid:(NSString *)source;
- (NSString *)uuidToString:(NSUUID *)guid;

@end

//
// MHVDate.h
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
#import "MHVType.h"
#import "MHVDay.h"
#import "MHVMonth.h"
#import "MHVYear.h"

@interface MHVDate : MHVType

// -------------------------
//
// Data
//
// -------------------------
@property (readwrite, nonatomic) int year;
@property (readwrite, nonatomic) int month;
@property (readwrite, nonatomic) int day;

@property (readonly, nonatomic, strong) MHVYear  *yearObject;
@property (readonly, nonatomic, strong) MHVMonth *monthObject;
@property (readonly, nonatomic, strong) MHVDay   *dayObject;

// -------------------------
//
// Initializers
//
// -------------------------
- (instancetype)initWithYear:(NSInteger)yearValue month:(NSInteger)monthValue day:(NSInteger)dayValue;
- (instancetype)initNow;
- (instancetype)initWithDate:(NSDate *)date;
- (instancetype)initWithComponents:(NSDateComponents *)components;

+ (MHVDate *)fromYear:(int)year month:(int)month day:(int)day;
+ (MHVDate *)fromDate:(NSDate *)date;
+ (MHVDate *)now;

// -------------------------
//
// Methods
//
// -------------------------
- (NSDateComponents *)toComponents;
- (NSDateComponents *)toComponentsForCalendar:(NSCalendar *)calendar;
- (BOOL)getComponents:(NSDateComponents *)components;
- (NSDate *)toDate;
- (NSDate *)toDateForCalendar:(NSCalendar *)calendar;

- (BOOL)setWithDate:(NSDate *)date;
- (BOOL)setWithComponents:(NSDateComponents *)components;

// -------------------------
//
// Text
//
// -------------------------
- (NSString *)toString;
- (NSString *)toStringWithFormat:(NSString *)format;

@end

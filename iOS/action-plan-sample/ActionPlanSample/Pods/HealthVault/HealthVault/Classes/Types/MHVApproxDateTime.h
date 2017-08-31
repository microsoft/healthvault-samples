//
// MHVApproxDateTime.h
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
#import "MHVDateTime.h"

// -------------------------
//
// Approximate Date & Time
// It is sometimes difficult to put a precise date & time on a health event.
// Only a textual description of time may be available:
// "as a child", "last year", "in high school"
//
// HealthVault approximate dates let you:
// - Use a precise date time, if you have it
// - If not, then you can use a "descriptive" representation
//
// -------------------------
@interface MHVApproxDateTime : MHVType

// -------------------------
//
// Data
//
// -------------------------
//
// CHOICE: you must specify either a descriptive OR a precise DateTime
// You CANNOT specify both.
//
@property (readwrite, nonatomic, strong) NSString *descriptive;
@property (readwrite, nonatomic, strong) MHVDateTime *dateTime;
//
// Convenience properties
//
@property (readonly, nonatomic) BOOL isStructured;

// -------------------------
//
// Initializers
//
// -------------------------
- (instancetype)initWithDescription:(NSString *)descr;
- (instancetype)initWithDate:(NSDate *)date;
- (instancetype)initWithDateTime:(MHVDateTime *)dateTime;
- (instancetype)initNow;

+ (MHVApproxDateTime *)fromDate:(NSDate *)date;
+ (MHVApproxDateTime *)fromDescription:(NSString *)descr;
+ (MHVApproxDateTime *)now;

// -------------------------
//
// Methods
//
// -------------------------
- (NSDate *)toDate;
- (NSDate *)toDateForCalendar:(NSCalendar *)calendar;

// -------------------------
//
// Text
//
// -------------------------
- (NSString *)toString;
- (NSString *)toStringWithFormat:(NSString *)format;


@end

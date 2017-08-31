//
// MHVContact.h
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

#import "MHVType.h"
#import "MHVAddress.h"
#import "MHVPhone.h"
#import "MHVEmail.h"

@interface MHVContact : MHVType

// -------------------------
//
// Data
//
// -------------------------
//
// (Optional)
//
@property (readwrite, nonatomic, strong) NSArray<MHVAddress *> *address;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) NSArray<MHVPhone *> *phone;
//
// (Optional)
//
@property (readwrite, nonatomic, strong) NSArray<MHVEmail *> *email;

//
// Convenience
//
@property (readonly, nonatomic) BOOL hasAddress;
@property (readonly, nonatomic) BOOL hasPhone;
@property (readonly, nonatomic) BOOL hasEmail;

@property (readonly, nonatomic, strong) MHVAddress *firstAddress;
@property (readonly, nonatomic, strong) MHVPhone *firstPhone;
@property (readonly, nonatomic, strong) MHVEmail *firstEmail;

// -------------------------
//
// Initializers
//
// -------------------------
- (instancetype)initWithPhone:(NSString *)phone;
- (instancetype)initWithEmail:(NSString *)email;
- (instancetype)initWithPhone:(NSString *)phone andEmail:(NSString *)email;

@end

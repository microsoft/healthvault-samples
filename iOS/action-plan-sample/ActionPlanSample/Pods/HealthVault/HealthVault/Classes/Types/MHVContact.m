//
// MHVContact.m
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

#import "MHVContact.h"
#import "MHVValidator.h"
#import "NSArray+Utils.h"

static NSString *const c_element_address = @"address";
static NSString *const c_element_phone = @"phone";
static NSString *const c_element_email = @"email";

@implementation MHVContact

- (BOOL)hasAddress
{
    return ![NSArray isNilOrEmpty:self.address];
}

- (NSArray<MHVAddress *> *)address
{
    if (!_address)
    {
        _address = @[];
    }
    
    return _address;
}

- (BOOL)hasPhone
{
    return ![NSArray isNilOrEmpty:self.phone];
}

- (NSArray<MHVPhone *> *)phone
{
    if (!_phone)
    {
        _phone = @[];
    }
    
    return _phone;
}

- (BOOL)hasEmail
{
    return ![NSArray isNilOrEmpty:self.email];
}

- (NSArray<MHVEmail *> *)email
{
    if (!_email)
    {
        _email = @[];
    }
    
    return _email;
}

- (MHVAddress *)firstAddress
{
    return (self.hasAddress) ? [self.address objectAtIndex:0] : nil;
}

- (MHVEmail *)firstEmail
{
    return (self.hasEmail) ? [self.email objectAtIndex:0] : nil;
}

- (MHVPhone *)firstPhone
{
    return (self.hasPhone) ? [self.phone objectAtIndex:0] : nil;
}

- (instancetype)initWithEmail:(NSString *)email
{
    return [self initWithPhone:nil andEmail:email];
}

- (instancetype)initWithPhone:(NSString *)phone
{
    return [self initWithPhone:phone andEmail:nil];
}

- (instancetype)initWithPhone:(NSString *)phone andEmail:(NSString *)email
{
    self = [super init];
    if (self)
    {
        if (phone)
        {
            MHVPhone *phoneObj = [[MHVPhone alloc] initWithNumber:phone];
            MHVCHECK_NOTNULL(phoneObj);
            
            self.phone = @[phoneObj];
            
            MHVCHECK_NOTNULL(self.phone);
        }
        
        if (email)
        {
            MHVEmail *emailObj = [[MHVEmail alloc] initWithEmailAddress:email];
            MHVCHECK_NOTNULL(emailObj);
            
            self.email = @[emailObj];
            
            MHVCHECK_NOTNULL(self.email);
        }
    }
    return self;
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN
    
    MHVVALIDATE_ARRAYOPTIONAL(self.address, MHVClientError_InvalidContact);
    MHVVALIDATE_ARRAYOPTIONAL(self.phone, MHVClientError_InvalidContact);
    MHVVALIDATE_ARRAYOPTIONAL(self.email, MHVClientError_InvalidContact);
    
    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementArray:c_element_address elements:self.address];
    [writer writeElementArray:c_element_phone elements:self.phone];
    [writer writeElementArray:c_element_email elements:self.email];
}

- (void)deserialize:(XReader *)reader
{
    self.address = [reader readElementArray:c_element_address
                                    asClass:[MHVAddress class]
                              andArrayClass:[NSMutableArray class]];
    self.phone = [reader readElementArray:c_element_phone
                                  asClass:[MHVPhone class]
                            andArrayClass:[NSMutableArray class]];
    self.email = [reader readElementArray:c_element_email
                                  asClass:[MHVEmail class]
                            andArrayClass:[NSMutableArray class]];
}

@end

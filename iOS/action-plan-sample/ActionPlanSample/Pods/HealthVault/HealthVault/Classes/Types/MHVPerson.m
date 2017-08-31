//
//  MHVPerson.m
//  MHVLib
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

#import "MHVValidator.h"
#import "MHVPerson.h"

static NSString* const c_element_name = @"name";
static NSString* const c_element_organization = @"organization";
static NSString* const c_element_training = @"professional-training";
static NSString* const c_element_identifier = @"id";
static NSString* const c_element_contact = @"contact";
static NSString* const c_element_type = @"type";

@implementation MHVPerson

-(instancetype)initWithName:(NSString *)name andEmail:(NSString *)email
{
    return [self initWithName:name phone:nil andEmail:email];
}

-(instancetype)initWithName:(NSString *)name andPhone:(NSString *)number
{
    return [self initWithName:name phone:number andEmail:nil];
}

-(instancetype)initWithName:(NSString *)name phone:(NSString *)number andEmail:(NSString *)email
{
    self = [super init];
    if (self)
    {
        _name = [[MHVName alloc] initWithFullName:name];
        MHVCHECK_NOTNULL(_name);
        
        _contact = [[MHVContact alloc] initWithPhone:number andEmail:email];
        MHVCHECK_NOTNULL(_contact);
    }
    return self;
}

-(instancetype)initWithFirstName:(NSString *)first lastName:(NSString *)last andEmail:(NSString *)email
{
    return [self initWithFirstName:first lastName:last phone:nil andEmail:email];
}

-(instancetype)initWithFirstName:(NSString *)first lastName:(NSString *)last andPhone:(NSString *)number
{
    return [self initWithFirstName:first lastName:last phone:number andEmail:nil];
}

-(instancetype)initWithFirstName:(NSString *)first lastName:(NSString *)last phone:(NSString *)phone andEmail:(NSString *)email
{
    self = [super init];
    if (self)
    {
        _name = [[MHVName alloc] initWithFirst:first andLastName:last];
        MHVCHECK_NOTNULL(_name);
        
        _contact = [[MHVContact alloc] initWithPhone:phone andEmail:email];
        MHVCHECK_NOTNULL(_contact);
    }
    return self;
}


-(NSString *)description
{
    return [self toString];
}

-(NSString *)toString
{
    return (self.name) ? [self.name toString] : @"";
}

+(MHVVocabularyIdentifier *)vocabForPersonType
{
    return [[MHVVocabularyIdentifier alloc] initWithFamily:c_hvFamily andName:@"person-types"];                
}

-(MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN
    
    MHVVALIDATE(self.name, MHVClientError_InvalidPerson);
    MHVVALIDATE_OPTIONAL(self.contact);
    
    MHVVALIDATE_SUCCESS
}

-(void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_name content:self.name];
    [writer writeElement:c_element_organization value:self.organization];
    [writer writeElement:c_element_training value:self.training];
    [writer writeElement:c_element_identifier value:self.identifier];
    [writer writeElement:c_element_contact content:self.contact];
    [writer writeElement:c_element_type content:self.type];
}

-(void)deserialize:(XReader *)reader
{
    self.name = [reader readElement:c_element_name asClass:[MHVName class]];
    self.organization = [reader readStringElement:c_element_organization];
    self.training = [reader readStringElement:c_element_training];
    self.identifier = [reader readStringElement:c_element_identifier];
    self.contact = [reader readElement:c_element_contact asClass:[MHVContact class]];
    self.type = [reader readElement:c_element_type asClass:[MHVCodableValue class]];
}

@end

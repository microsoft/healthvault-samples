//
// MHVQuestionAnswer.m
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
#import "MHVQuestionAnswer.h"
#import "NSArray+Utils.h"

static NSString *const c_typeid = @"55d33791-58de-4cae-8c78-819e12ba5059";
static NSString *const c_typename = @"question-answer";

static NSString *const c_element_when = @"when";
static NSString *const c_element_question = @"question";
static NSString *const c_element_choice = @"answer-choice";
static NSString *const c_element_answer = @"answer";

@implementation MHVQuestionAnswer

- (NSArray<MHVCodableValue *> *)answerChoices
{
    if (!_answerChoices)
    {
        _answerChoices = @[];
    }
    
    return _answerChoices;
}

- (NSArray<MHVCodableValue *> *)answers
{
    if (!_answers)
    {
        _answers = @[];
    }
    
    return _answers;
}

- (MHVCodableValue *)firstAnswer
{
    return (self.hasAnswers) ? [self.answers objectAtIndex:0] : nil;
}

- (BOOL)hasAnswerChoices
{
    return ![NSArray isNilOrEmpty:self.answerChoices];
}

- (BOOL)hasAnswers
{
    return ![NSArray isNilOrEmpty:self.answers];
}

- (instancetype)initWithQuestion:(NSString *)question andDate:(NSDate *)date
{
    return [self initWithQuestion:question answer:nil andDate:date];
}

- (instancetype)initWithQuestion:(NSString *)question answer:(NSString *)answer andDate:(NSDate *)date
{
    MHVCHECK_NOTNULL(question);
    MHVCHECK_NOTNULL(date);
    
    self = [super init];
    if (self)
    {
        _when = [[MHVDateTime alloc] initWithDate:date];
        MHVCHECK_NOTNULL(_when);
        
        _question = [[MHVCodableValue alloc] initWithText:question];
        MHVCHECK_NOTNULL(_question);
        
        if (answer)
        {
            MHVCodableValue *answerValue = [[MHVCodableValue alloc] initWithText:answer];
            MHVCHECK_NOTNULL(answerValue);
            
            _answers = @[answerValue];
            MHVCHECK_NOTNULL(_answers);
        }
    }
    
    return self;
}

- (NSDate *)getDate
{
    return [self.when toDate];
}

- (NSDate *)getDateForCalendar:(NSCalendar *)calendar
{
    return [self.when toDateForCalendar:calendar];
}

- (NSString *)description
{
    return [self toString];
}

- (NSString *)toString
{
    return [NSString stringWithFormat:@"%@ %@",
            self.question ? [self.question toString] : @"",
            self.firstAnswer ? [self.firstAnswer toString] : @""];
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN
    
    MHVVALIDATE(self.when, MHVClientError_InvalidQuestionAnswer);
    MHVVALIDATE(self.question, MHVClientError_InvalidQuestionAnswer);
    MHVVALIDATE_ARRAYOPTIONAL(self.answerChoices, MHVClientError_InvalidQuestionAnswer);
    MHVVALIDATE_ARRAYOPTIONAL(self.answers, MHVClientError_InvalidQuestionAnswer);
    
    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_when content:self.when];
    [writer writeElement:c_element_question content:self.question];
    [writer writeElementArray:c_element_choice elements:self.answerChoices];
    [writer writeElementArray:c_element_answer elements:self.answers];
}

- (void)deserialize:(XReader *)reader
{
    self.when = [reader readElement:c_element_when asClass:[MHVDateTime class]];
    self.question = [reader readElement:c_element_question asClass:[MHVCodableValue class]];
    self.answerChoices = [reader readElementArray:c_element_choice asClass:[MHVCodableValue class] andArrayClass:[NSMutableArray class]];
    self.answers = [reader readElementArray:c_element_answer asClass:[MHVCodableValue class] andArrayClass:[NSMutableArray class]];
}

+ (NSString *)typeID
{
    return c_typeid;
}

+ (NSString *)XRootElement
{
    return c_typename;
}

+ (MHVThing *)newThing
{
    return [[MHVThing alloc] initWithType:[MHVQuestionAnswer typeID]];
}

@end

//
//  MHVVocabularyKey.m
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

#import "MHVVocabularyKey.h"

static const xmlChar *x_element_code = XMLSTRINGCONST("code-value");
static const xmlChar *x_element_name = XMLSTRINGCONST("name");
static const xmlChar *x_element_family = XMLSTRINGCONST("family");
static const xmlChar *x_element_version = XMLSTRINGCONST("version");
static const xmlChar *x_element_description = XMLSTRINGCONST("description");

@implementation MHVVocabularyKey

- (instancetype) initWithName:(NSString*)name
                    andFamily:(NSString*)family
                   andVersion:(NSString*)version
                      andCode:(NSString*)code
{
    self = [super init];
    if (self)
    {
        self.name = name;
        self.family = family;
        self.version = version;
        self.code = code;
    }
    
    return self;
}

- (instancetype) initFromVocabulary:(MHVVocabularyCodeSet *)vocabulary
{
    return [self initWithName:vocabulary.name andFamily:vocabulary.family andVersion:vocabulary.version andCode:[vocabulary.vocabularyCodeItems lastObject].codeValue];
}


-(NSString *)toString
{
    return self.name;
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElementXmlName:x_element_name value:self.name];
    [writer writeElementXmlName:x_element_family value:self.family];
    [writer writeElementXmlName:x_element_version value:self.version];
    [writer writeElementXmlName:x_element_code value:self.code];
    
    // NOTE: We do not serialize the description field. It is optional
    // and only used for requests, not respones
}

- (void) deserialize:(XReader *)reader
{
    self.name = [reader readStringElementWithXmlName:x_element_name];
    self.family = [reader readStringElementWithXmlName:x_element_family];
    self.version = [reader readStringElementWithXmlName:x_element_version];
    self.code = [reader readStringElementWithXmlName:x_element_code];
    self.descriptionText = [reader readStringElementWithXmlName:x_element_description];
}

@end


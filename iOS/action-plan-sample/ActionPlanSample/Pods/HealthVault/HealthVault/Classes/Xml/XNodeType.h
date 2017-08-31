//
//  XNodeType.h
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

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, XNodeType)
{
    XUnknown = 0,
    XElement = 1,
    XAttribute = 2,
    XText = 3,
    XCDATA = 4,
    XEntityRef = 5,
    XEntityDeclaration = 6,
    XProcessingInstruction = 7,
    XComments = 8,
    XDocument = 9,
    XDocumentType = 10,
    XDocumentFragment = 11,
    XNotation = 12,
    XWhitespace = 13,
    XSignificantWhitespace = 14,
    XEndElement = 15,
    XEndEntity = 16,
    XmlDeclaration = 17
};

NSString* XNodeTypeToString(XNodeType type);
BOOL XIsTextualNodeType(XNodeType type);

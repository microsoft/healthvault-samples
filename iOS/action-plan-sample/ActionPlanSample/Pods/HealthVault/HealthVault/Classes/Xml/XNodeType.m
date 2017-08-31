//
//  XNodeType.m
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

#include "XNodeType.h"

NSString* XNodeTypeToString(XNodeType type)
{
    switch (type) 
    {
        case XElement:
            return @"Element";
            
        case XEndElement:
            return @"EndElement";
            
        case XAttribute:
            return @"Attribute";
            
        case XText:
            return @"Text";
            
        case XCDATA:
            return @"CDATA";
            
        case XSignificantWhitespace:
            return @"SWhitespace";
            
        case XWhitespace:
            return @"Whitespace";
            
        default:
            break;
    }
    
    return @"Unknown";
}

BOOL XIsTextualNodeType(XNodeType type)
{
    switch(type)
    {
        case XText:
        case XCDATA:
        case XAttribute:
            return TRUE;
            
        default:
            break;
    }
    
    return FALSE;
}

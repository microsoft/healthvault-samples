//
// XmlReader.m
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

#import <libxml/tree.h>
#import <libxml/xmlreader.h>
#import "MHVValidator.h"
#import "XReader.h"
#import "MHVLogger.h"

#define READER_TRUE 1
#define READER_FALSE 0
#define READER_FAIL -1


xmlTextReader *XAllocBufferReader(NSData *buffer)
{
    if (!buffer)
    {
        return nil;
    }

    return xmlReaderForMemory([buffer bytes], (int)[buffer length], nil, nil, 0);
}

xmlTextReader *XAllocStringReader(NSString *string)
{
    if (!string)
    {
        return nil;
    }

    return xmlReaderForDoc([string toXmlStringConst], nil, nil, 0);
}

xmlTextReader *XAllocFileReader(NSString *fileName)
{
    if (!fileName || [fileName isEqualToString:@""])
    {
        return nil;
    }

    return xmlNewTextReaderFilename([fileName UTF8String]); // further error checking delegated
}

@interface XReader ()

@property (readonly, nonatomic) xmlTextReader *reader;
@property (nonatomic, assign) XNodeType nodeType;
@property (nonatomic, strong) NSString *localName;
@property (nonatomic, strong) NSString *namespaceUri;
@property (nonatomic, strong) NSString *value;

@end

// ------------
//
// XReader
//
// ------------

@implementation XReader

//
// PROPERTIES
//

- (int)depth
{
    return xmlTextReaderDepth(self.reader);
}

- (XNodeType)nodeType
{
    if (_nodeType == XUnknown)
    {
        int type = xmlTextReaderNodeType(self.reader);
        if (type < 0)
        {
            MHVLOG(@"Could not find node type.");
        }

        _nodeType = (XNodeType)type;
    }

    return _nodeType;
}

- (NSString *)nodeTypeString
{
    return XNodeTypeToString(self.nodeType);
}

- (BOOL)isEmptyElement
{
    return xmlTextReaderIsEmptyElement(self.reader);
}

- (BOOL)hasEndTag
{
    return ![self isEmptyElement];
}

- (BOOL)isTextualNode
{
    return XIsTextualNodeType(self.nodeType);
}

- (const xmlChar *)name
{
    return xmlTextReaderConstName(self.reader);
}

- (NSString *)localName
{
    if (_localName == nil)
    {
        _localName = [NSString fromConstXmlString:xmlTextReaderConstLocalName(self.reader)];
    }

    return _localName;
}

- (const xmlChar *)localNameRaw
{
    return xmlTextReaderConstLocalName(self.reader);
}

- (const xmlChar *)prefix
{
    return xmlTextReaderConstPrefix(self.reader);
}

- (NSString *)namespaceUri
{
    if (_namespaceUri == nil)
    {
        _namespaceUri = [NSString fromConstXmlString:xmlTextReaderConstNamespaceUri(self.reader)];
    }

    return _namespaceUri;
}

- (const xmlChar *)namespaceUriRaw
{
    return xmlTextReaderConstNamespaceUri(self.reader);
}

- (BOOL)hasValue
{
    return [self isSuccess:xmlTextReaderHasValue(self.reader)];
}

- (NSString *)value
{
    if (_value == nil)
    {
        _value = [NSString fromConstXmlString:xmlTextReaderConstValue(self.reader)];
    }

    return _value;
}

- (const xmlChar *)valueRaw
{
    return xmlTextReaderConstValue(self.reader);
}

- (BOOL)hasAttributes
{
    return xmlTextReaderHasAttributes(self.reader);
}

- (int)attributeCount
{
    return xmlTextReaderAttributeCount(self.reader);
}

- (instancetype)initWithReader:(xmlTextReader *)reader
{
    return [self initWithReader:reader andConverter:nil];
}

- (instancetype)initWithReader:(xmlTextReader *)reader andConverter:(XConverter *)converter
{
    MHVCHECK_NOTNULL(reader);

    self = [super init];
    if (self)
    {
        if (converter)
        {
            _converter = converter;
        }
        else
        {
            _converter = [[XConverter alloc] init];
            MHVCHECK_NOTNULL(_converter);
        }
        
        _reader = reader;
    }
    return self;
}

- (instancetype)initFromMemory:(NSData *)buffer
{
    return [self initFromMemory:buffer withConverter:nil];
}

- (instancetype)initFromMemory:(NSData *)buffer withConverter:(XConverter *)converter
{
    return [self initWithCreatedReader:XAllocBufferReader(buffer) withConverter:converter];
}

- (instancetype)initFromString:(NSString *)string
{
    return [self initFromString:string withConverter:nil];
}

- (instancetype)initFromString:(NSString *)string withConverter:(XConverter *)converter
{
    return [self initWithCreatedReader:XAllocStringReader(string) withConverter:converter];
}

- (instancetype)initFromFile:(NSString *)fileName
{
    return [self initFromFile:fileName withConverter:nil];
}

- (instancetype)initFromFile:(NSString *)fileName withConverter:(XConverter *)converter
{
    return [self initWithCreatedReader:XAllocFileReader(fileName) withConverter:converter];
}

- (instancetype)init
{
    // This will force an error, since you shouldn't call init directly
    return [self initWithReader:nil];
}

- (void)dealloc
{
    [self close];
}

- (void)clear
{
    _nodeType = XUnknown;
    _localName = nil;
    _namespaceUri = nil;
    _value = nil;
}

- (NSString *)getAttribute:(NSString *)name
{
    MHVCHECK_STRING(name);

    xmlChar *xmlName = [name toXmlString];
    MHVCHECK_NOTNULL(xmlName);

    return [NSString fromXmlStringAndFreeXml:xmlTextReaderGetAttribute(self.reader, xmlName)];
}

- (NSString *)getAttributeAt:(int)index
{
    return [NSString fromXmlStringAndFreeXml:xmlTextReaderGetAttributeNo(self.reader, index)];
}

- (NSString *)getAttribute:(NSString *)name NS:(NSString *)ns
{
    MHVCHECK_STRING(name);
    MHVCHECK_STRING(ns);

    xmlChar *xmlName = [name toXmlString];
    xmlChar *xmlNs = [ns toXmlString];

    MHVCHECK_NOTNULL(xmlName);
    MHVCHECK_NOTNULL(xmlNs);

    return [NSString fromXmlStringAndFreeXml:xmlTextReaderGetAttributeNs(self.reader, xmlName, xmlNs)];
}

- (BOOL)moveToAttributeAt:(int)index
{
    [self clear];
    return [self isSuccess:xmlTextReaderMoveToAttributeNo(self.reader, index)];
}

- (BOOL)moveToAttribute:(NSString *)name
{
    MHVCHECK_STRING(name);

    [self clear];

    xmlChar *xmlName = [name toXmlString];
    MHVCHECK_NOTNULL(xmlName);

    return [self isSuccess:xmlTextReaderMoveToAttribute(self.reader, xmlName)];
}

- (BOOL)moveToAttributeWithXmlName:(const xmlChar *)xmlName
{
    [self clear];
    return [self isSuccess:xmlTextReaderMoveToAttribute(self.reader, xmlName)];
}

- (BOOL)moveToAttribute:(NSString *)name NS:(NSString *)ns
{
    MHVCHECK_STRING(name);
    MHVCHECK_STRING(ns);

    [self clear];

    xmlChar *xmlName = [name toXmlString];
    xmlChar *xmlNs = [ns toXmlString];

    MHVCHECK_NOTNULL(xmlName);
    MHVCHECK_NOTNULL(xmlNs);

    return [self isSuccess:xmlTextReaderMoveToAttributeNs(self.reader, xmlName, xmlNs)];
}

- (BOOL)moveToAttributeWithXmlName:(const xmlChar *)xmlName andXmlNs:(const xmlChar *)xmlNs
{
    [self clear];
    return [self isSuccess:xmlTextReaderMoveToAttributeNs(self.reader, xmlName, xmlNs)];
}

- (BOOL)moveToFirstAttribute
{
    [self clear];
    return [self isSuccess:xmlTextReaderMoveToFirstAttribute(self.reader)];
}

- (BOOL)moveToNextAttribute
{
    [self clear];
    return [self isSuccess:xmlTextReaderMoveToNextAttribute(self.reader)];
}

- (BOOL)isStartElement
{
    return [self moveToContent] == XElement;
}

- (BOOL)isStartElementWithName:(NSString *)name
{
    MHVCHECK_STRING(name);

    return [self isStartElement] && [name isEqualToString:self.localName];
}

- (BOOL)isStartElementWithName:(NSString *)name NS:(NSString *)ns
{
    MHVCHECK_STRING(name);
    MHVCHECK_STRING(ns);

    if (![self isStartElement])
    {
        return FALSE;
    }

    if (!self.localName || !self.namespaceUri)
    {
        return FALSE;
    }

    return ([name isEqualToString:self.localName]) && [ns isEqualToString:self.namespaceUri];
}

- (BOOL)isStartElementWithXmlName:(const xmlChar *)name
{
    MHVCHECK_NOTNULL(name);

    if (![self isStartElement])
    {
        return FALSE;
    }

    const xmlChar *rawName = self.localNameRaw;

    return rawName && xmlStrEqual(rawName, name);
}

- (XNodeType)moveToContent
{
    XNodeType type;

    BOOL loop = YES;

    while (loop)
    {
        loop = NO;
        type = self.nodeType;
        switch (type)
        {
            case XElement:
            case XText:
            case XCDATA:
            case XEntityRef:
            case XEntityDeclaration:
            case XEndElement:
            case XEndEntity:
                break;

            case XAttribute:
                [self moveToElement];
                break;

            default:
                if ([self read])
                {
                    loop = YES;
                }

                break;
        }
    }

    return type;
}

- (BOOL)moveToElement
{
    [self clear];
    return [self isSuccess:xmlTextReaderMoveToElement(self.reader)];
}

- (BOOL)moveToStartElement
{
    return [self moveToContent] == XElement;
}

- (BOOL)readStartElement
{
    [self ensureStartElement];

    BOOL hasEndTag = ![self isEmptyElement];

    [self read];

    return hasEndTag;
}

- (BOOL)readStartElementWithName:(NSString *)name
{
    if ([self isNilOrEmptyString:name])
    {
        MHVLOG(@"Cannot read the start element because the element name parameter is nil or empty.");
        return FALSE;
    }

    [self ensureStartElement];

    if (!self.localName || ![name isEqualToString:self.localName])
    {
        MHVLOG(@"Cannot read the start element because there is a mismatch between the local name (%@) and the name parameter (%@).", self.localName, name);
        return FALSE;
    }

    BOOL hasEndTag = ![self isEmptyElement];

    [self read];

    return hasEndTag;
}

- (BOOL)readStartElementWithName:(NSString *)name NS:(NSString *)ns
{
    if ([self isNilOrEmptyString:name] ||
        [self isNilOrEmptyString:ns])
    {
        MHVLOG(@"The name (%@) or namespace (%@) parameter is nil.", name, ns);
        return FALSE;
    }

    [self ensureStartElement];

    if (!self.localName || ![name isEqualToString:self.localName])
    {
        MHVLOG(@"Cannot read the start element because there is a mismatch between the local name (%@) and the name parameter (%@).", self.localName, name);
        return FALSE;
    }

    if (!self.namespaceUri || ![ns isEqualToString:self.namespaceUri])
    {
        MHVLOG(@"Cannot read the start element because there is a mismatch between the namespaceUri (%@) and the namespace parameter (%@).", self.namespaceUri, ns);
        return FALSE;
    }

    BOOL hasEndTag = ![self isEmptyElement];

    [self read];

    return hasEndTag;
}

- (BOOL)readStartElementWithXmlName:(const xmlChar *)xName
{
    if (!xName)
    {
        MHVLOG(@"Cannot read the start element because the element name parameter is nil.");
        return NO;
    }

    [self ensureStartElement];

    const xmlChar *rawName = self.localNameRaw;
    if (!rawName || !xmlStrEqual(rawName, xName))
    {
        MHVLOG(@"Cannot read the start element because there is a mismatch between the local name (%@) and the name parameter (%@).", [NSString newFromXmlString:(xmlChar *)rawName], [NSString newFromXmlString:(xmlChar *)xName]);
        return NO;
    }

    BOOL hasEndTag = ![self isEmptyElement];

    [self read];

    return hasEndTag;
}

- (void)readEndElement
{
    [self moveToContentType:XEndElement];
    [self read];
}

- (BOOL)read
{
    [self clear];
    return [self isSuccess:xmlTextReaderRead(self.reader)];
}

- (NSString *)readString
{
    [self moveToElement];
    if (![self isTextualNode])
    {
        MHVLOG(@"Cannot read the element into a string because the node is not text.");
        return nil;
    }

    NSString *string = [NSString fromXmlStringAndFreeXml:xmlTextReaderReadString(self.reader)];
    [self read];
    return string;
}

- (NSString *)readElementString
{
    [self ensureStartElement];

    if ([self isEmptyElement])
    {
        [self read];
        return @"";
    }

    [self read];
    NSString *str = [self readString];
    [self verifyNodeType:XEndElement];
    [self read];

    return str;
}

- (NSString *)readInnerXml
{
    return [NSString fromXmlStringAndFreeXml:xmlTextReaderReadInnerXml(self.reader)];
}

- (NSString *)readOuterXml
{
    return [NSString fromXmlStringAndFreeXml:xmlTextReaderReadOuterXml(self.reader)];
}

- (BOOL)skip
{
    [self clear];
    return [self isSuccess:xmlTextReaderNext(self.reader)];
}

#pragma mark - Internal methods

- (instancetype)initWithCreatedReader:(xmlTextReader *)reader
{
    return [self initWithCreatedReader:reader withConverter:nil];
}

- (instancetype)initWithCreatedReader:(xmlTextReader *)reader withConverter:(XConverter *)converter
{
    self = [self initWithReader:reader andConverter:converter];
    if (!self)
    {
        if (reader)
        {
            xmlFreeTextReader(reader);
        }

        return nil;
    }

    return self;
}

- (void)ensureStartElement
{
    if (![self moveToStartElement])
    {
        MHVLOG(@"Could not find start element.");
    }
}

- (void)moveToContentType:(XNodeType)type
{
    XNodeType nodeType = [self moveToContent];

    if (nodeType != type)
    {
        [self logInvalidNode:nodeType expectedType:type];
    }
}

- (void)verifyNodeType:(XNodeType)type
{
    if (self.nodeType != type)
    {
        [self logInvalidNode:self.nodeType expectedType:type];
    }
}

- (void)logInvalidNode:(XNodeType)type expectedType:(XNodeType)expected
{
    MHVLOG(@"%@ [Expected: %@]", XNodeTypeToString(type), XNodeTypeToString(expected));
}

- (void)close
{
    [self clear];
    if (self.reader)
    {
        xmlTextReaderClose(self.reader);
        xmlFreeTextReader(self.reader);
        _reader = nil;
    }
}

- (BOOL)isSuccess:(int)result
{
    return result == READER_TRUE;
}

- (BOOL)isNilOrEmptyString:(NSString *)string
{
    return !string || [string isEqualToString:@""];
}

@end

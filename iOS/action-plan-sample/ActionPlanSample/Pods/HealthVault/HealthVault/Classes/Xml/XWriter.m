//
// XWriter.m
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

#import <libxml/xmlwriter.h>
#import <libxml/xmlreader.h>
#import "MHVValidator.h"
#import "MHVStringExtensions.h"
#import "XWriter.h"

#define WRITER_ERROR -1


xmlBufferPtr XAllocBuffer(size_t size)
{
    xmlBufferPtr buffer;

    if (size == 0)
    {
        buffer = xmlBufferCreate();
    }
    else
    {
        buffer = xmlBufferCreateSize(size);
    }

    return buffer;
}

xmlTextWriterPtr XAllocTextWriter(xmlBufferPtr buffer)
{
    return xmlNewTextWriterMemory(buffer, 0);
}

xmlTextWriterPtr XAllocFileWriter(NSString *filePath)
{
    return xmlNewTextWriterFilename([filePath UTF8String], FALSE);
}

// ---------------------
//
// XWriter
//
// ---------------------
@interface XWriter ()

@property (readonly, nonatomic, assign) xmlTextWriterPtr writer;
@property (nonatomic, assign) xmlBufferPtr buffer;

@end

@implementation XWriter

- (instancetype)initWithWriter:(xmlTextWriterPtr)writer buffer:(xmlBufferPtr)buffer andConverter:(XConverter *)converter
{
    MHVCHECK_NOTNULL(writer);

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

        _writer = writer;
        _buffer = buffer;
    }

    return self;
}

- (instancetype)initWithWriter:(xmlTextWriterPtr)writer buffer:(xmlBufferPtr)buffer
{
    return [self initWithWriter:writer buffer:buffer andConverter:nil];
}

- (instancetype)initWithBufferSize:(size_t)size andConverter:(XConverter *)converter
{
    xmlBufferPtr buffer = NULL;
    xmlTextWriterPtr writer = NULL;

    buffer = XAllocBuffer(size);
    if (!buffer)
    {
        return nil;
    }

    writer = XAllocTextWriter(buffer);
    if (!writer)
    {
        return nil;
    }

    self = [self initWithWriter:writer buffer:buffer andConverter:converter];
    if (!self)
    {
        if (writer)
        {
            xmlFreeTextWriter(writer);
        }

        if (buffer)
        {
            xmlBufferFree(buffer);
        }

        return nil;
    }

    return self;
}

- (instancetype)initWithBufferSize:(size_t)size
{
    return [self initWithBufferSize:size andConverter:nil];
}

- (instancetype)initFromFile:(NSString *)filePath andConverter:(XConverter *)converter
{
    xmlTextWriterPtr writer = XAllocFileWriter(filePath);

    if (!writer)
    {
        return nil;
    }

    self = [self initWithWriter:writer buffer:NULL andConverter:converter];
    if (!self)
    {
        if (writer)
        {
            xmlFreeTextWriter(writer);
        }

        return nil;
    }

    return self;
}

- (instancetype)initFromFile:(NSString *)filePath
{
    return [self initFromFile:filePath andConverter:nil];
}

- (instancetype)init
{
    return [self initWithBufferSize:0];
}

- (void)dealloc
{
    if (_writer)
    {
        xmlFreeTextWriter(_writer);
        _writer = nil;
    }

    if (_buffer)
    {
        xmlBufferFree(_buffer);
        _buffer = nil;
    }
}

- (BOOL)flush
{
    return [self isSuccess:xmlTextWriterFlush(self.writer)];
}

- (BOOL)writeStartDocument
{
    return [self isSuccess:xmlTextWriterStartDocument(self.writer, nil, nil, nil)];
}

- (BOOL)writeEndDocument
{
    return [self isSuccess:xmlTextWriterEndDocument(self.writer)];
}

- (BOOL)writeAttribute:(NSString *)name value:(NSString *)value
{
    MHVCHECK_STRING(name);
    MHVCHECK_STRING(value);

    xmlChar *xmlName = [name toXmlString]; // autoreleased...
    xmlChar *xmlValue = [value toXmlString];

    MHVCHECK_NOTNULL(xmlName);
    MHVCHECK_NOTNULL(xmlValue);

    return [self isSuccess:xmlTextWriterWriteAttribute(self.writer, xmlName, xmlValue)];
}

- (BOOL)writeAttribute:(NSString *)name prefix:(NSString *)prefix NS:(NSString *)ns value:(NSString *)value
{
    MHVCHECK_STRING(name);
    MHVCHECK_STRING(prefix);
    MHVCHECK_STRING(ns);
    MHVCHECK_STRING(value);

    xmlChar *xmlName = [name toXmlString];
    xmlChar *xmlPrefix = [prefix toXmlString];
    xmlChar *xmlNs = [ns toXmlString];
    xmlChar *xmlValue = [value toXmlString];

    MHVCHECK_NOTNULL(xmlName);
    MHVCHECK_NOTNULL(xmlPrefix);
    MHVCHECK_NOTNULL(xmlNs);
    MHVCHECK_NOTNULL(xmlValue);

    return [self isSuccess:xmlTextWriterWriteAttributeNS(self.writer, xmlPrefix, xmlName, xmlNs, xmlValue)];
}

- (BOOL)writeAttributeXmlName:(const xmlChar *)xmlName value:(NSString *)value
{
    if (!value)
    {
        return NO;
    }

    xmlChar *xmlValue = [value toXmlString];
    return [self isSuccess:xmlTextWriterWriteAttribute(self.writer, xmlName, xmlValue)];
}

- (BOOL)writeAttributeXmlName:(const xmlChar *)xmlName prefix:(const xmlChar *)xmlPrefix NS:(const xmlChar *)xmlNs value:(NSString *)value
{
    xmlChar *xmlValue = [value toXmlString];

    return [self isSuccess:xmlTextWriterWriteAttributeNS(self.writer, xmlPrefix, xmlName, xmlNs, xmlValue)];
}

- (BOOL)writeStartElement:(NSString *)name
{
    MHVASSERT_STRING(name);

    xmlChar *xmlName = [name toXmlString];
    MHVCHECK_NOTNULL(xmlName);

    return [self isSuccess:xmlTextWriterStartElement(self.writer, xmlName)];
}

- (BOOL)writeStartElement:(NSString *)name prefix:(NSString *)prefix NS:(NSString *)ns
{
    MHVCHECK_STRING(name);
    MHVCHECK_STRING(prefix);
    MHVCHECK_STRING(ns);

    xmlChar *xmlName = [name toXmlString];
    xmlChar *xmlPrefix = [prefix toXmlString];
    xmlChar *xmlNs = [ns toXmlString];

    MHVCHECK_NOTNULL(xmlName);
    MHVCHECK_NOTNULL(xmlPrefix);
    MHVCHECK_NOTNULL(xmlNs);

    return [self isSuccess:xmlTextWriterStartElementNS(self.writer, xmlPrefix, xmlName, xmlNs)];
}

- (BOOL)writeStartElementXmlName:(const xmlChar *)xmlName
{
    return [self isSuccess:xmlTextWriterStartElement(self.writer, xmlName)];
}

- (BOOL)writeStartElementXmlName:(const xmlChar *)xmlName prefix:(const xmlChar *)xmlPrefix NS:(const xmlChar *)xmlNs
{
    return [self isSuccess:xmlTextWriterStartElementNS(self.writer, xmlPrefix, xmlName, xmlNs)];
}

- (BOOL)writeEndElement
{
    return [self isSuccess:xmlTextWriterEndElement(self.writer)];
}

- (BOOL)writeString:(NSString *)value
{
    MHVCHECK_STRING(value);

    xmlChar *xmlValue = [value toXmlString];
    MHVCHECK_NOTNULL(xmlValue);

    return [self isSuccess:xmlTextWriterWriteString(self.writer, xmlValue)];
}

- (BOOL)writeRaw:(NSString *)xml
{
    MHVCHECK_NOTNULL(xml);

    xmlChar *xmlValue = [xml toXmlString];
    MHVCHECK_NOTNULL(xmlValue);

    return [self isSuccess:xmlTextWriterWriteRaw(self.writer, xmlValue)];
}

- (xmlChar *)getXml
{
    [self flush];
    if (self.buffer == nil)
    {
        return nil;
    }

    return self.buffer->content;
}

- (size_t)getLength
{
    [self flush];
    if (self.buffer == nil)
    {
        return 0;
    }

    return self.buffer->use;
}

- (NSString *)newXmlString
{
    [self flush];

    return [[NSString alloc] initWithBytes:self.buffer->content length:self.buffer->use encoding:NSUTF8StringEncoding];
}

#pragma mark - Internal methods

- (BOOL)isSuccess:(int)result
{
    return result != WRITER_ERROR;
}

@end

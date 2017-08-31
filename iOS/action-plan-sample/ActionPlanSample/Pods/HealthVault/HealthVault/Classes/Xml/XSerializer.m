//
// XSerializer.m
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
#import "XSerializer.h"
#import "MHVLogger.h"
#import "NSArray+Utils.h"

@implementation XSerializer

+ (NSString *)serializeToString:(id)obj withRoot:(NSString *)root
{
    XWriter *writer = [[XWriter alloc] init];

    MHVCHECK_NOTNULL(writer);

    @try
    {
        if ([XSerializer serialize:obj withRoot:root toWriter:writer])
        {
            return [writer newXmlString];
        }
    }
    @finally
    {
        writer = nil;
    }

    return nil;
}

+ (BOOL)serialize:(id)obj withRoot:(NSString *)root toWriter:(XWriter *)writer
{
    MHVCHECK_NOTNULL(obj);
    MHVCHECK_STRING(root);
    MHVCHECK_NOTNULL(writer);
    MHVCHECK_SUCCESS([obj conformsToProtocol:@protocol(XSerializable)]);
    
    [writer writeElementRequired:root content:(id < XSerializable >)obj];
    
    return YES;
}

+ (BOOL)serialize:(id)obj withRoot:(NSString *)root toFilePath:(NSString *)filePath
{
    MHVCHECK_STRING(filePath);

    XWriter *writer = [[XWriter alloc] initFromFile:filePath];
    MHVCHECK_NOTNULL(writer);

    @try
    {
        return [XSerializer serialize:obj withRoot:root toWriter:writer];
    }
    @finally
    {
        writer = nil;
    }

    return FALSE;
}

+ (BOOL)secureSerialize:(id)obj withRoot:(NSString *)root toFilePath:(NSString *)filePath
{
    return [XSerializer secureSerialize:obj withRoot:root toFilePath:filePath withConverter:nil];
}

+ (BOOL)secureSerialize:(id)obj withRoot:(NSString *)root toFilePath:(NSString *)filePath withConverter:(XConverter *)converter
{
    XWriter *writer = [[XWriter alloc] initWithBufferSize:2048 andConverter:converter];

    MHVCHECK_NOTNULL(writer);

    NSData *rawData = nil;

    MHVCHECK_SUCCESS([XSerializer serialize:obj withRoot:root toWriter:writer]);
    
    rawData = [[NSData alloc] initWithBytesNoCopy:[writer getXml] length:[writer getLength] freeWhenDone:FALSE];
    MHVCHECK_NOTNULL(rawData);
    
    return [rawData writeToFile:filePath
                        options:NSDataWritingAtomic | NSDataWritingFileProtectionComplete
                          error:nil];
}

+ (BOOL)deserialize:(XReader *)reader withRoot:(NSString *)root into:(id)obj
{
    MHVCHECK_NOTNULL(reader);
    MHVCHECK_STRING(root);
    MHVCHECK_NOTNULL(obj);
    
    [reader readElementRequired:root intoObject:obj];
    return YES;
}

@end

@implementation NSObject (XSerializer)

- (NSString *)toXmlStringWithRoot:(NSString *)root
{
    MHVCHECK_STRING(root);

    return [XSerializer serializeToString:self withRoot:root];
}

+ (id)newFromString:(NSString *)xml withRoot:(NSString *)root asClass:(Class)classObj
{
    MHVCHECK_STRING(xml);

    XReader *reader = [[XReader alloc] initFromString:xml];
    MHVCHECK_NOTNULL(reader);

    return [NSObject newFromReader:reader withRoot:root asClass:classObj];
}

+ (id)newFromString:(NSString *)xml withRoot:(NSString *)root andElementName:(NSString *)name asClass:(Class)classObj andArrayClass:(Class)arrayClassObj
{
    MHVCHECK_STRING(xml);
    MHVCHECK_STRING(root);
    MHVCHECK_STRING(name);
    MHVCHECK_NOTNULL(classObj);
    MHVCHECK_NOTNULL(arrayClassObj);

    XReader *reader = [[XReader alloc] initFromString:xml];
    MHVCHECK_NOTNULL(reader);
    @try
    {
        return [reader readElementArray:root thingName:name asClass:classObj andArrayClass:arrayClassObj];
    }
    @finally
    {
        reader = nil;
    }

    return nil;
}

+ (id)newFromReader:(XReader *)reader withRoot:(NSString *)root asClass:(Class)classObj
{
    id obj = nil;

    MHVASSERT_NOTNULL(reader);
    MHVCHECK_STRING(root);
    MHVCHECK_NOTNULL(classObj);

    obj = [[classObj alloc] init]; // Ownership is passed to caller
    MHVCHECK_NOTNULL(obj);

    if ([XSerializer deserialize:reader withRoot:root into:obj])
    {
        return obj;
    }

    return nil;
}

+ (id)newFromFilePath:(NSString *)filePath withRoot:(NSString *)root asClass:(Class)classObj
{
    MHVCHECK_STRING(filePath);

#ifdef LOGXML
    NSString *rawXml = [[NSString alloc] initWithContentsOfFile:filePath usedEncoding:nil error:nil];
    NSLog(@"%@\r\n%@", filePath, rawXml);
    [rawXml release];
#endif

    XReader *reader = [[XReader alloc] initFromFile:filePath];
    MHVCHECK_NOTNULL(reader);

    return [NSObject newFromReader:reader withRoot:root asClass:classObj];
}

+ (id)newFromSecureFilePath:(NSString *)filePath withRoot:(NSString *)root asClass:(Class)classObj
{
    return [NSObject newFromSecureFilePath:filePath withRoot:root asClass:classObj withConverter:nil];
}

+ (id)newFromSecureFilePath:(NSString *)filePath withRoot:(NSString *)root asClass:(Class)classObj withConverter:(XConverter *)converter
{
    MHVCHECK_STRING(filePath);

    XReader *reader = nil;
    NSData *fileData = nil;

    fileData = [[NSData alloc] initWithContentsOfFile:filePath];
    if (!fileData)
    {
        return nil;
    }
    
    reader = [[XReader alloc] initFromMemory:fileData withConverter:converter];
    MHVCHECK_NOTNULL(reader);
    
    return [NSObject newFromReader:reader withRoot:root asClass:classObj];
}

+ (id)newFromFileUrl:(NSURL *)url withRoot:(NSString *)root asClass:(Class)classObj
{
    MHVCHECK_NOTNULL(url);

    return [NSObject newFromFilePath:url.path withRoot:root asClass:classObj];
}

+ (id)newFromResource:(NSString *)name withRoot:(NSString *)root asClass:(Class)classObj
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"xml"];

    if (!path || [path isEqualToString:@""])
    {
        return nil;
    }

    return [NSObject newFromFilePath:path withRoot:root asClass:classObj];
}

@end

@interface XReader ()

- (BOOL)isNilOrEmptyString:(NSString *)string;

@end

@implementation XReader (XSerializer)

- (NSString *)readValue
{
    if (!self.isTextualNode)
    {
        return nil;
    }

    NSString *value = self.value;
    [self read];
    return value;
}

- (NSString *)readValueEnsure
{
    if (!self.isTextualNode)
    {
        MHVLOG(@"Could not read value into a string because the current node is not textual.");
        return nil;
    }

    NSString *value = self.value;
    if (!value)
    {
        MHVLOG(@"Could not read value into a string because the value is nil.");
        return nil;
    }

    [self read];
    return value;
}

- (NSUUID *)readUuid
{
    return [self.converter stringToUuid:[self readValueEnsure]];
}

- (int)readInt
{
    return [self.converter stringToInt:[self readValueEnsure]];
}

- (float)readFloat
{
    return [self.converter stringToFloat:[self readValueEnsure]];
}

- (double)readDouble
{
    return [self.converter stringToDouble:[self readValueEnsure]];
}

- (BOOL)readBool
{
    return [self.converter stringToBool:[self readValueEnsure]];
}

- (NSDate *)readDate
{
    return [self.converter stringToDate:[self readValueEnsure]];
}

- (NSString *)readNextElement
{
    NSString *value = nil;

    if ([self readStartElement])
    {
        value = [self readValue];

        if (value != nil || self.nodeType == XEndElement)
        {
            [self readEndElement];
        }
    }

    return (value != nil) ? value : @"";
}

- (NSString *)readStringElementRequired:(NSString *)name
{
    NSString *value = nil;

    if ([self readStartElementWithName:name])
    {
        value = [self readValue];

        if (value != nil || self.nodeType == XEndElement)
        {
            [self readEndElement];
        }
    }

    return (value != nil) ? value : @"";
}

- (NSString *)readStringElement:(NSString *)name
{
    if ([self isStartElementWithName:name])
    {
        return [self readNextElement];
    }

    return nil;
}

- (NSDate *)readNextDate
{
    NSString *string = [self readNextElement];

    if ([self isNilOrEmptyString:string])
    {
        return nil;
    }

    return [self.converter stringToDate:string];
}

- (NSDate *)readDateElement:(NSString *)name
{
    NSString *string = [self readStringElement:name];

    if ([self isNilOrEmptyString:string])
    {
        return nil;
    }

    return [self.converter stringToDate:string];
}

- (int)readNextInt
{
    NSString *string = [self readNextElement];

    if ([self isNilOrEmptyString:string])
    {
        return 0;
    }

    return [self.converter stringToInt:string];
}

- (int)readIntElement:(NSString *)name
{
    NSString *string = [self readStringElement:name];

    if ([self isNilOrEmptyString:string])
    {
        return 0;
    }

    return [self.converter stringToInt:string];
}

- (BOOL)readIntElement:(NSString *)name into:(NSInteger *)value
{
    if ([self isStartElementWithName:name])
    {
        *value = [self readIntElement:name];
        return TRUE;
    }

    return FALSE;
}

- (double)readNextDouble
{
    NSString *string = [self readNextElement];

    if ([self isNilOrEmptyString:string])
    {
        return 0.0;
    }

    return [self.converter stringToDouble:string];
}

- (double)readDoubleElement:(NSString *)name
{
    NSString *string = [self readStringElement:name];

    if ([self isNilOrEmptyString:string])
    {
        return 0.0;
    }

    return [self.converter stringToDouble:string];
}

- (BOOL)readDoubleElement:(NSString *)name into:(double *)value
{
    if ([self isStartElementWithName:name])
    {
        *value = [self readDoubleElement:name];
        return TRUE;
    }

    return FALSE;
}

- (BOOL)readNextBool
{
    NSString *string = [self readNextElement];

    if ([self isNilOrEmptyString:string])
    {
        return 0;
    }

    return [self.converter stringToBool:string];
}

- (BOOL)readBoolElement:(NSString *)name
{
    NSString *string = [self readStringElement:name];

    if ([self isNilOrEmptyString:string])
    {
        return 0;
    }

    return [self.converter stringToBool:string];
}

- (BOOL)readBoolElement:(NSString *)name into:(BOOL *)value
{
    if ([self isStartElementWithName:name])
    {
        *value = [self readBoolElement:name];
        return TRUE;
    }

    return FALSE;
}

- (void)readElementContentIntoObject:(id<XSerializable>)content
{
    if (content == nil)
    {
        MHVLOG(@"Content is nil");
        return;
    }

    //
    // Deserialize any attributes
    //
    [content deserializeAttributes:self];
    //
    // Now read the element contents, if any
    //
    int currentDepth = self.depth;
    if ([self readStartElement])
    {
        //
        // Has content and a distrinct end tag
        //
        [content deserialize:self];
        //
        // We may not have consumed all things...
        // So skip any that were not
        //
        while (self.depth > currentDepth && [self read])
        {
        }
        //
        // Read last element
        //
        [self readEndElement];
    }
}

- (id)readElementRequired:(NSString *)name asClass:(Class)classObj
{
    id obj = [[classObj alloc] init];

    MHVCHECK_OOM(obj);

    [self readElementRequired:name intoObject:obj];
    return obj;
}

- (void)readElementRequired:(NSString *)name intoObject:(id<XSerializable>)content
{
    if (![self isStartElementWithName:name])
    {
        MHVLOG(@"Cannot read the start element because there is a mismatch between the local name (%@) and the name parameter (%@).", self.localName, name);
        return;
    }

    [self readElementContentIntoObject:content];
}

- (id)readElement:(NSString *)name asClass:(Class)classObj
{
    if ([self isStartElementWithName:name])
    {
        id obj = [[classObj alloc] init];
        MHVCHECK_OOM(obj);

        [self readElementContentIntoObject:obj];

        return obj;
    }

    return nil;
}

- (NSString *)readElementRaw:(NSString *)name
{
    if ([self isStartElementWithName:name])
    {
        NSString *xml = [self readOuterXml];

        [self skipSingleElement:name];

        return xml;
    }

    return nil;
}

- (NSMutableArray *)readElementArray:(NSString *)name asClass:(Class)classObj;
{
    return [self readElementArray:name asClass:classObj andArrayClass:[NSMutableArray class]];
}

- (NSMutableArray *)readElementArray:(NSString *)name asClass:(Class)classObj andArrayClass:(Class)arrayClassObj
{
    const xmlChar *xName = [name toXmlString];

    MHVCHECK_OOM(xName);
    
    if (arrayClassObj == [NSArray class])
    {
        MHVASSERT_MESSAGE(@"Expected NSMutableArray class");
        arrayClassObj = [NSMutableArray class];
    }

    return [self readElementArrayWithXmlName:xName asClass:classObj andArrayClass:arrayClassObj];
}

- (NSMutableArray *)readElementArray:(NSString *)name thingName:(NSString *)thingName asClass:(Class)classObj andArrayClass:(Class)arrayClassObj
{
    NSMutableArray *array = nil;

    if ([self readStartElementWithName:name])
    {
        array = [self readElementArray:thingName asClass:classObj andArrayClass:arrayClassObj];
        [self readEndElement];
    }

    return array;
}

- (NSArray<NSString *> *)readStringElementArray:(NSString *)name
{
    NSMutableArray<NSString *> *elements = nil;

    while ([self isStartElementWithName:name])
    {
        if (elements == nil)
        {
            elements = [[NSMutableArray alloc] init];
            MHVCHECK_OOM(elements);
        }

        [elements addObject:[self readStringElementRequired:name]];
    }

    return elements;
}

- (NSMutableArray<NSUUID *> *)readUUIDElementArray:(NSString *)name
{
    NSMutableArray<NSUUID *> *elements = nil;
    while ([self isStartElementWithName:name])
    {
        if (elements == nil)
        {
            elements = [[NSMutableArray<NSUUID *> alloc] init];
            MHVCHECK_OOM(elements);
        }

        [elements addObject:[[NSUUID alloc] initWithUUIDString:[self readStringElement:name]]];
    }

    return elements;
}

- (NSMutableArray *)readRawElementArray:(NSString *)name
{
    NSMutableArray *elements = nil;
    NSString *xml = nil;

    if ([self isStartElementWithName:name])
    {
        while ((xml = [self readElementRaw:name]))
        {
            if (!elements)
            {
                elements = [[NSMutableArray alloc] init];
            }

            [elements addObject:xml];
        }
    }

    return elements;
}

- (NSString *)readAttribute:(NSString *)name
{
    if (![self moveToAttribute:name])
    {
        return nil;
    }

    NSString *value = self.value;

    [self moveToElement];

    return value;
}

- (BOOL)readIntAttribute:(NSString *)name intValue:(int *)value
{
    if (!self.hasAttributes || ![self moveToAttribute:name])
    {
        return FALSE;
    }

    NSString *string = self.value;
    *value = [self.converter stringToInt:string];

    [self moveToElement];

    return TRUE;
}

- (BOOL)readBoolAttribute:(NSString *)name boolValue:(BOOL *)value
{
    if (!self.hasAttributes || ![self moveToAttribute:name])
    {
        return FALSE;
    }

    NSString *string = self.value;
    *value = [self.converter stringToBool:string];

    [self moveToElement];

    return TRUE;
}

- (BOOL)readDoubleAttribute:(NSString *)name doubleValue:(double *)value
{
    if (!self.hasAttributes || ![self moveToAttribute:name])
    {
        return FALSE;
    }

    NSString *string = self.value;
    *value = [self.converter stringToDouble:string];

    [self moveToElement];

    return TRUE;
}

- (BOOL)readFloatAttribute:(NSString *)name floatValue:(float *)value
{
    if (!self.hasAttributes || ![self moveToAttribute:name])
    {
        return FALSE;
    }

    NSString *string = self.value;
    *value = [self.converter stringToFloat:string];

    [self moveToElement];

    return TRUE;
}

- (BOOL)readUntilNodeType:(XNodeType)type
{
    while ([self read])
    {
        if (self.nodeType == type)
        {
            return TRUE;
        }
    }

    return FALSE;
}

- (BOOL)skipElement:(NSString *)name
{
    while ([self isStartElementWithName:name])
    {
        [self skipSingleElement];
    }

    return TRUE;
}

- (BOOL)skipSingleElement
{
    int currentDepth = [self depth];

    if ([self readStartElement])
    {
        // A non-empty element
        while (self.depth > currentDepth)
        {
            if (![self read])
            {
                return FALSE;
            }
        }
        [self readEndElement];
    }

    return TRUE;
}

- (BOOL)skipSingleElement:(NSString *)name
{
    if ([self isStartElementWithName:name])
    {
        return [self skipSingleElement];
    }

    return TRUE;
}

- (BOOL)skipToElement:(NSString *)name
{
    while ([self isStartElement])
    {
        if ([name isEqualToString:self.localName])
        {
            return TRUE;
        }

        if (![self skipElement:self.localName])
        {
            break;
        }
    }

    return FALSE;
}

- (id)readElementRequiredWithXmlName:(const xmlChar *)xName asClass:(Class)classObj
{
    id obj = [[classObj alloc] init];

    MHVCHECK_OOM(obj);

    [self readElementRequiredWithXmlName:xName intoObject:obj];
    return obj;
}

- (void)readElementRequiredWithXmlName:(const xmlChar *)xName intoObject:(id<XSerializable>)content
{
    if (![self isStartElementWithXmlName:xName])
    {
        MHVLOG(@"The start element (%@) does not match the name (%@).", self.localName,  [NSString newFromXmlString:(xmlChar *)xName]);
        return;
    }

    return [self readElementContentIntoObject:content];
}

- (id)readElementWithXmlName:(const xmlChar *)xmlName asClass:(Class)classObj
{
    if ([self isStartElementWithXmlName:xmlName])
    {
        id obj = [[classObj alloc] init];
        MHVCHECK_OOM(obj);

        [self readElementContentIntoObject:obj];

        return obj;
    }

    return nil;
}

- (NSString *)readStringElementWithXmlName:(const xmlChar *)xmlName
{
    if ([self isStartElementWithXmlName:xmlName])
    {
        return [self readNextElement];
    }

    return nil;
}

- (NSDate *)readDateElementXmlName:(const xmlChar *)xmlName
{
    NSString *string = [self readStringElementWithXmlName:xmlName];

    if ([self isNilOrEmptyString:string])
    {
        return nil;
    }

    return [self.converter stringToDate:string];
}

- (int)readIntElementXmlName:(const xmlChar *)xmlName
{
    NSString *string = [self readStringElementWithXmlName:xmlName];

    if ([self isNilOrEmptyString:string])
    {
        return 0;
    }

    return [self.converter stringToInt:string];
}

- (BOOL)readIntElementXmlName:(const xmlChar *)xmlName into:(int *)value
{
    if ([self isStartElementWithXmlName:xmlName])
    {
        *value = [self readIntElementXmlName:xmlName];
        return TRUE;
    }

    return FALSE;
}

- (double)readDoubleElementXmlName:(const xmlChar *)xmlName
{
    NSString *string = [self readStringElementWithXmlName:xmlName];

    if ([self isNilOrEmptyString:string])
    {
        return 0.0;
    }

    return [self.converter stringToDouble:string];
}

- (BOOL)readDoubleElementXmlName:(const xmlChar *)xmlName into:(double *)value
{
    if ([self isStartElementWithXmlName:xmlName])
    {
        *value = [self readDoubleElementXmlName:xmlName];
        return TRUE;
    }

    return FALSE;
}

- (BOOL)readBoolElementXmlName:(const xmlChar *)xmlName
{
    NSString *string = [self readStringElementWithXmlName:xmlName];

    if ([self isNilOrEmptyString:string])
    {
        return 0;
    }

    return [self.converter stringToBool:string];
}

- (BOOL)readBoolElementXmlName:(const xmlChar *)xmlName into:(BOOL *)value
{
    if ([self isStartElementWithXmlName:xmlName])
    {
        *value = [self readBoolElementXmlName:xmlName];
        return TRUE;
    }

    return FALSE;
}

- (NSString *)readAttributeWithXmlName:(const xmlChar *)xmlName
{
    if (![self moveToAttributeWithXmlName:xmlName])
    {
        return nil;
    }

    NSString *value = self.value;

    [self moveToElement];

    return value;
}

- (NSString *)readElementRawWithXmlName:(const xmlChar *)xmlName
{
    if ([self isStartElementWithXmlName:xmlName])
    {
        NSString *xml = [self readOuterXml];

        [self skipSingleElementWithXmlName:xmlName];

        return xml;
    }

    return nil;
}

- (NSMutableArray *)readElementArrayWithXmlName:(const xmlChar *)xName asClass:(Class)classObj
{
    return [self readElementArrayWithXmlName:xName asClass:classObj andArrayClass:[NSMutableArray class]];
}

- (NSMutableArray *)readElementArrayWithXmlName:(const xmlChar *)xName asClass:(Class)classObj andArrayClass:(Class)arrayClassObj
{
    NSMutableArray *elements = nil;

    while ([self isStartElementWithXmlName:xName])
    {
        if (elements == nil)
        {
            elements = [[arrayClassObj alloc] init];
            MHVCHECK_OOM(elements);
        }

        [elements addObject:[self readElementRequiredWithXmlName:xName asClass:classObj]];
    }

    return elements;
}

- (NSMutableArray *)readElementArrayWithXmlName:(const xmlChar *)xName thingName:(const xmlChar *)thingName asClass:(Class)classObj andArrayClass:(Class)arrayClassObj
{
    NSMutableArray *array = nil;

    if ([self readStartElementWithXmlName:xName])
    {
        array = [self readElementArrayWithXmlName:thingName asClass:classObj andArrayClass:arrayClassObj];
        [self readEndElement];
    }

    return array;
}

- (BOOL)skipElementWithXmlName:(const xmlChar *)xmlName
{
    while ([self isStartElementWithXmlName:xmlName])
    {
        [self skipSingleElement];
    }

    return TRUE;
}

- (BOOL)skipSingleElementWithXmlName:(const xmlChar *)xmlName
{
    if ([self isStartElementWithXmlName:xmlName])
    {
        return [self skipSingleElement];
    }

    return TRUE;
}

@end

void logWriterError(void)
{
    MHVLOG(@"An unknown error has occured while attempting to serialize an object.");
}

@implementation XWriter (XSerializer)

- (void)writeUuid:(NSUUID *)uuid;
{
    [self writeText:[self.converter uuidToString:uuid]];
}

- (void)writeInt:(int)value
{
    [self writeText:[self.converter intToString:value]];
}

- (void)writeFloat:(float)value
{
    [self writeText:[self.converter floatToString:value]];
}

- (void)writeDouble:(double)value
{
    [self writeText:[self.converter doubleToString:value]];
}

- (void)writeBool:(BOOL)value
{
    [self writeText:[self.converter boolToString:value]];
}

- (void)writeDate:(NSDate *)value
{
    [self writeText:[self.converter dateToString:value]];
}

- (void)writeEmptyElement:(NSString *)name
{
    MHVCHECK_XWRITE([self writeStartElement:name]);
    MHVCHECK_XWRITE([self writeEndElement]);
}

- (void)writeElementRequired:(NSString *)name content:(id<XSerializable>)content
{
    if (!content)
    {
        MHVLOG(@"Failed to write element (%@) because the content is nil.", name);
    }

    MHVCHECK_XWRITE([self writeStartElement:name]);
    {
        [content serializeAttributes:self];
        [content serialize:self];
    }
    MHVCHECK_XWRITE([self writeEndElement]);
}

- (void)writeElementRequired:(NSString *)name value:(NSString *)value
{
    if (!value)
    {
        MHVLOG(@"Not writing because value is nil");
        return;
    }

    MHVCHECK_XWRITE([self writeStartElement:name]);
    {
        [self writeText:value];
    }
    MHVCHECK_XWRITE([self writeEndElement]);
}

- (void)writeElementArrayRequired:(NSString *)name elements:(NSArray *)array
{
    if ([NSArray isNilOrEmpty:array])
    {
        MHVLOG(@"Failed to write element array (%@) because the required array is nil", name);
    }

    for (id obj in array)
    {
        [self writeElement:name object:obj];
    }
}

- (void)writeElement:(NSString *)name content:(id<XSerializable>)content
{
    if (content == nil)
    {
        return;
    }

    [self writeElementRequired:name content:content];
}

- (void)writeElement:(NSString *)name value:(NSString *)value
{
    if (!value)
    {
        return;
    }

    [self writeElementRequired:name value:value];
}

- (void)writeElementArray:(NSString *)name elements:(NSArray *)array
{
    if ([NSArray isNilOrEmpty:array])
    {
        return;
    }

    [self writeElementArrayRequired:name elements:array];
}

- (void)writeElementArray:(NSString *)name thingName:(NSString *)thingName elements:(NSArray *)array
{
    if ([NSArray isNilOrEmpty:array])
    {
        return;
    }

    MHVCHECK_XWRITE([self writeStartElement:name]);
    {
        [self writeElementArray:thingName elements:array];
    }
    MHVCHECK_XWRITE([self writeEndElement]);
}

- (void)writeRawElementArray:(NSString *)name elements:(NSArray *)array
{
    if ([NSArray isNilOrEmpty:array])
    {
        return;
    }

    for (NSString *xml in array)
    {
        MHVCHECK_XWRITE([self writeRaw:xml]);
    }
}

- (void)writeElement:(NSString *)name intValue:(int)value
{
    MHVCHECK_XWRITE([self writeStartElement:name]);
    {
        [self writeInt:value];
    }
    MHVCHECK_XWRITE([self writeEndElement]);
}

- (void)writeElement:(NSString *)name doubleValue:(double)value
{
    MHVCHECK_XWRITE([self writeStartElement:name]);
    {
        [self writeDouble:value];
    }
    MHVCHECK_XWRITE([self writeEndElement]);
}

- (void)writeElement:(id)name dateValue:(NSDate *)value
{
    if (value == nil)
    {
        return;
    }

    MHVCHECK_XWRITE([self writeStartElement:name]);
    {
        [self writeDate:value];
    }
    MHVCHECK_XWRITE([self writeEndElement]);
}

- (void)writeElement:(NSString *)name boolValue:(BOOL)value
{
    MHVCHECK_XWRITE([self writeStartElement:name]);
    {
        [self writeBool:value];
    }
    MHVCHECK_XWRITE([self writeEndElement]);
}

- (void)writeElement:(NSString *)name object:(id)value
{
    if ([value conformsToProtocol:@protocol(XSerializable)])
    {
        [self writeElement:name content:(id < XSerializable >)value];
    }
    else if ([value isKindOfClass:[NSString class]])
    {
        [self writeElement:name value:(NSString *)value];
    }
    else
    {
        NSString *description = [value description];
        [self writeElement:name value:description];
    }
}

- (void)writeAttribute:(NSString *)name intValue:(int)value
{
    [self writeAttribute:name value:[self.converter intToString:value]];
}

- (void)writeText:(NSString *)value
{
    if ([self isNilOrEmptyString:value])
    {
        return;
    }

    MHVCHECK_XWRITE([self writeString:value]);
}

- (void)writeElementXmlName:(const xmlChar *)xmlName content:(id<XSerializable>)content
{
    if (content == nil)
    {
        return;
    }

    MHVCHECK_XWRITE([self writeStartElementXmlName:xmlName]);
    {
        [content serializeAttributes:self];
        [content serialize:self];
    }
    MHVCHECK_XWRITE([self writeEndElement]);
}

- (void)writeElementXmlName:(const xmlChar *)xmlName value:(NSString *)value
{
    if (!value)
    {
        return;
    }

    MHVCHECK_XWRITE([self writeStartElementXmlName:xmlName]);
    {
        [self writeText:value];
    }
    MHVCHECK_XWRITE([self writeEndElement]);
}

- (void)writeElementXmlName:(const xmlChar *)xmlName doubleValue:(double)value
{
    MHVCHECK_XWRITE([self writeStartElementXmlName:xmlName]);
    {
        [self writeDouble:value];
    }
    MHVCHECK_XWRITE([self writeEndElement]);
}

- (void)writeElementXmlName:(const xmlChar *)xmlName dateValue:(NSDate *)value
{
    if (!value)
    {
        return;
    }

    MHVCHECK_XWRITE([self writeStartElementXmlName:xmlName]);
    {
        [self writeDate:value];
    }
    MHVCHECK_XWRITE([self writeEndElement]);
}

- (void)writeElementXmlName:(const xmlChar *)xmlName intValue:(int)value
{
    MHVCHECK_XWRITE([self writeStartElementXmlName:xmlName]);
    {
        [self writeInt:value];
    }
    MHVCHECK_XWRITE([self writeEndElement]);
}

- (void)writeElementXmlName:(const xmlChar *)xmlName boolValue:(BOOL)value
{
    MHVCHECK_XWRITE([self writeStartElementXmlName:xmlName]);
    {
        [self writeBool:value];
    }
    MHVCHECK_XWRITE([self writeEndElement]);
}

#pragma mark - Helpers

- (BOOL)isNilOrEmptyString:(NSString *)string
{
    return !string || [string isEqualToString:@""];
}

@end

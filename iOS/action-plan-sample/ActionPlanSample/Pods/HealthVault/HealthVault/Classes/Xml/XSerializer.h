//
// XSerializable.h
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

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import "XReader.h"
#import "XWriter.h"

@protocol XSerializable <NSObject>

- (void)deserialize:(XReader *)reader;
- (void)deserializeAttributes:(XReader *)reader;

- (void)serialize:(XWriter *)writer;
- (void)serializeAttributes:(XWriter *)writer;

@end

@interface XSerializer : NSObject

+ (NSString *)serializeToString:(id)obj withRoot:(NSString *)root;
+ (BOOL)serialize:(id)obj withRoot:(NSString *)root toWriter:(XWriter *)writer;
+ (BOOL)serialize:(id)obj withRoot:(NSString *)root toFilePath:(NSString *)filePath;
+ (BOOL)secureSerialize:(id)obj withRoot:(NSString *)root toFilePath:(NSString *)filePath;
+ (BOOL)secureSerialize:(id)obj withRoot:(NSString *)root toFilePath:(NSString *)filePath withConverter:(XConverter *)converter;

+ (BOOL)deserialize:(XReader *)reader withRoot:(NSString *)root into:(id)obj;

@end

@interface NSObject (XSerializer)

- (NSString *)toXmlStringWithRoot:(NSString *)root;

+ (id)newFromString:(NSString *)xml withRoot:(NSString *)root asClass:(Class)classObj;
+ (id)newFromString:(NSString *)xml withRoot:(NSString *)root andElementName:(NSString *)name asClass:(Class)classObj andArrayClass:(Class)arrayClassObj;
+ (id)newFromReader:(XReader *)reader withRoot:(NSString *)root asClass:(Class)classObj;
+ (id)newFromFilePath:(NSString *)filePath withRoot:(NSString *)root asClass:(Class)classObj;
+ (id)newFromSecureFilePath:(NSString *)filePath withRoot:(NSString *)root asClass:(Class)classObj;
+ (id)newFromSecureFilePath:(NSString *)filePath withRoot:(NSString *)root asClass:(Class)classObj withConverter:(XConverter *)converter;

+ (id)newFromFileUrl:(NSURL *)url withRoot:(NSString *)root asClass:(Class)classObj;
+ (id)newFromResource:(NSString *)name withRoot:(NSString *)root asClass:(Class)classObj;


@end

//
// Deserialization methods for XmlReader
//
@interface XReader (XSerializer)

- (NSString *)readValue;
- (NSString *)readValueEnsure;

- (NSUUID *)readUuid;
- (int)readInt;
- (double)readDouble;
- (float)readFloat;
- (BOOL)readBool;
- (NSDate *)readDate;

- (NSString *)readNextElement;
- (NSString *)readStringElementRequired:(NSString *)name;
- (NSString *)readStringElement:(NSString *)name;

- (NSDate *)readNextDate;
- (NSDate *)readDateElement:(NSString *)name;

- (int)readNextInt;
- (int)readIntElement:(NSString *)name;
- (BOOL)readIntElement:(NSString *)name into:(NSInteger *)value;

- (double)readNextDouble;
- (double)readDoubleElement:(NSString *)name;
- (BOOL)readDoubleElement:(NSString *)name into:(double *)value;

- (BOOL)readNextBool;
- (BOOL)readBoolElement:(NSString *)name;
- (BOOL)readBoolElement:(NSString *)name into:(BOOL *)value;

- (void)readElementContentIntoObject:(id<XSerializable>)content;

- (id)readElementRequired:(NSString *)name asClass:(Class)classObj;
- (void)readElementRequired:(NSString *)name intoObject:(id<XSerializable>)content;

- (id)readElement:(NSString *)name asClass:(Class)classObj;

- (NSString *)readElementRaw:(NSString *)name;

- (NSMutableArray *)readElementArray:(NSString *)name asClass:(Class)classObj;
- (NSMutableArray *)readElementArray:(NSString *)name asClass:(Class)classObj andArrayClass:(Class)arrayClassObj;
- (NSMutableArray *)readElementArray:(NSString *)name thingName:(NSString *)thingName asClass:(Class)classObj andArrayClass:(Class)arrayClassObj;

- (NSArray<NSString *> *)readStringElementArray:(NSString *)name;
- (NSMutableArray<NSUUID *> *)readUUIDElementArray:(NSString *)name;

- (NSMutableArray *)readRawElementArray:(NSString *)name;

- (NSString *)readAttribute:(NSString *)name;
- (BOOL)readIntAttribute:(NSString *)name intValue:(int *)value;
- (BOOL)readBoolAttribute:(NSString *)name boolValue:(BOOL *)value;
- (BOOL)readDoubleAttribute:(NSString *)name doubleValue:(double *)value;
- (BOOL)readFloatAttribute:(NSString *)name floatValue:(float *)value;

- (BOOL)readUntilNodeType:(XNodeType)type;
- (BOOL)skipElement:(NSString *)name;
- (BOOL)skipSingleElement;
- (BOOL)skipSingleElement:(NSString *)name;
- (BOOL)skipToElement:(NSString *)name;

//
// These are noticeably faster for lots of things in a lop, as they do fewer string allocations
// There are now xmlChar* equivalents of most useful methods from above
//
- (id)readElementRequiredWithXmlName:(const xmlChar *)xName asClass:(Class)classObj;
- (void)readElementRequiredWithXmlName:(const xmlChar *)xName intoObject:(id<XSerializable>)content;
- (id)readElementWithXmlName:(const xmlChar *)xmlName asClass:(Class)classObj;
- (NSString *)readStringElementWithXmlName:(const xmlChar *)xmlName;

- (NSDate *)readDateElementXmlName:(const xmlChar *)xmlName;
- (double)readDoubleElementXmlName:(const xmlChar *)xmlName;
- (BOOL)readDoubleElementXmlName:(const xmlChar *)xmlName into:(double *)value;
- (int)readIntElementXmlName:(const xmlChar *)xmlName;
- (BOOL)readIntElementXmlName:(const xmlChar *)xmlName into:(int *)value;
- (BOOL)readBoolElementXmlName:(const xmlChar *)xmlName;
- (BOOL)readBoolElementXmlName:(const xmlChar *)xmlName into:(BOOL *)value;

- (NSMutableArray *)readElementArrayWithXmlName:(const xmlChar *)xName asClass:(Class)classObj;
- (NSMutableArray *)readElementArrayWithXmlName:(const xmlChar *)xName asClass:(Class)classObj andArrayClass:(Class)arrayClassObj;
- (NSMutableArray *)readElementArrayWithXmlName:(const xmlChar *)xName thingName:(const xmlChar *)thingName asClass:(Class)classObj andArrayClass:(Class)arrayClassObj;

- (NSString *)readAttributeWithXmlName:(const xmlChar *)xmlName;
- (NSString *)readElementRawWithXmlName:(const xmlChar *)xmlName;

- (BOOL)skipElementWithXmlName:(const xmlChar *)xmlName;
- (BOOL)skipSingleElementWithXmlName:(const xmlChar *)xmlName;

@end

//
// Serialization methods for XWriter
//
@interface XWriter (XSerializer)

- (void)writeUuid:(NSUUID *)uuid;
- (void)writeInt:(int)value;
- (void)writeDouble:(double)value;
- (void)writeFloat:(float)value;
- (void)writeBool:(BOOL)value;
- (void)writeDate:(NSDate *)value;

- (void)writeEmptyElement:(NSString *)name;
- (void)writeElementRequired:(NSString *)name content:(id<XSerializable>)content;
- (void)writeElementArrayRequired:(NSString *)name elements:(NSArray *)array;
- (void)writeElementRequired:(NSString *)name value:(NSString *)value;

- (void)writeElement:(NSString *)name value:(NSString *)value;
- (void)writeElement:(NSString *)name content:(id<XSerializable>)content;
- (void)writeElement:(NSString *)name intValue:(int)value;
- (void)writeElement:(NSString *)name doubleValue:(double)value;
- (void)writeElement:(NSString *)name dateValue:(NSDate *)value;
- (void)writeElement:(NSString *)name boolValue:(BOOL)value;
//
// If value conforms to XSerializable, calls writeElementRequired:content
// If NSString, writes out raw string as element content
// Else calls value.description and writes that
//
- (void)writeElement:(NSString *)name object:(id)value;

- (void)writeElementArray:(NSString *)name elements:(NSArray *)array;
- (void)writeElementArray:(NSString *)name thingName:(NSString *)thingName elements:(NSArray *)array;
- (void)writeRawElementArray:(NSString *)name elements:(NSArray *)array;

- (void)writeAttribute:(NSString *)name intValue:(int)value;
- (void)writeText:(NSString *)value;

- (void)writeElementXmlName:(const xmlChar *)xmlName content:(id<XSerializable>)content;
- (void)writeElementXmlName:(const xmlChar *)xmlName value:(NSString *)value;
- (void)writeElementXmlName:(const xmlChar *)xmlName intValue:(int)value;
- (void)writeElementXmlName:(const xmlChar *)xmlName doubleValue:(double)value;
- (void)writeElementXmlName:(const xmlChar *)xmlName dateValue:(NSDate *)value;
- (void)writeElementXmlName:(const xmlChar *)xmlName boolValue:(BOOL)value;

@end

void logWriterError(void);

#define MHVCHECK_XWRITE(condition) \
    if (!(condition)) \
    { \
        logWriterError(); \
    }

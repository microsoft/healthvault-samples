//
// MHVThing.h
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
#import "MHVType.h"
#import "MHVThingKey.h"
#import "MHVThingType.h"
#import "MHVThingState.h"
#import "MHVAudit.h"
#import "MHVThingData.h"
#import "MHVBlobPayload.h"
#import "MHVBlobSource.h"
#import "MHVApproxDateTime.h"

@class MHVRecordReference;

enum MHVThingFlags
{
    MHVThingFlagNone = 0x00,
    MHVThingFlagPersonal = 0x01,      // Thing is only accessible to custodians
    MHVThingFlagDownVersioned = 0x02, // Thing converted from a newer format to an older format [cannot update]
    MHVThingFlagUpVersioned = 0x04,   // Thing converted from an older format to a new format [can update]
    MHVThingFlagImmutable = 0x10      // Thing is locked and cannot be modified, except for updated-end-date
};

// -------------------------
//
// A single Thing ("thing") in a record
// Each thing has:
// - Key and Version
// - Metadata, such as creation dates
// - Xml Data
// - Typed data [e.g. Medication, Allergy, Exercise etc.] with associated MHV Schemas
// - Common data [Related Things, Notes, tags, extensions...]
// - Blob Data
// - A collection of named blob streams.
//
// -------------------------
@interface MHVThing : MHVType

// -------------------------
//
// Data
//
// -------------------------

//
// (Optional) The key for this thing (id + version)
// All existing things that have been successfully committed to HealthVault
// will always have a key.
//
@property (readwrite, nonatomic, strong) MHVThingKey *key;

@property (readwrite, nonatomic, strong) MHVThingType *type;

@property (readwrite, nonatomic) MHVThingState state;
//
// (Optional) See MHVThingFlags enumeration...
//
@property (readwrite, nonatomic) int flags;
//
//
// The effective date impacts the default sort order of returned results
//
@property (readwrite, nonatomic, strong) NSDate *effectiveDate;

@property (readwrite, nonatomic, strong) MHVAudit *created;
@property (readwrite, nonatomic, strong) MHVAudit *updated;
//
// (Optional) Structured data for this thing. May be null if you did not
// ask for Core data (see MHVThingSection) when you issued a query for things
//
@property (readwrite, nonatomic, strong) MHVThingData *data;
//
// (Optional) Information about unstructured blob streams associated with this thing
// May be null if you did not ask for Blob information (see MHVThingSectionBlob)
//
@property (readwrite, nonatomic, strong) MHVBlobPayload *blobs;

// (Optional) RAW Xml - see HealthVault Thing schema
@property (readwrite, nonatomic, strong) NSString *effectivePermissionsXml;

// (Optional) Tags associated with this thing
@property (readwrite, nonatomic, strong) MHVStringZ512 *tags;

// (Optional) Signature. Raw Xml
@property (readwrite, nonatomic, strong) NSString *signatureInfoXml;

// (Optional) Some things are immutable (locked). Users an still update the "effective"
// end date of some thing - such as the date they stopped taking a medication
@property (readwrite, nonatomic, strong) MHVConstrainedXmlDate *updatedEndDate;

// -----------------------
//
// Convenience Properties
//
// ------------------------
@property (readonly, nonatomic, strong) NSString *thingID;
@property (readonly, nonatomic, strong) NSString *typeID;
//
// (Optional) All things can have arbitrary notes...
// References data.common.note
//
@property (readwrite, nonatomic, strong) NSString *note;

//
// Convenience
//
@property (readonly, nonatomic) BOOL hasKey;
@property (readonly, nonatomic) BOOL hasTypeInfo;
@property (readonly, nonatomic) BOOL hasData;
@property (readonly, nonatomic) BOOL hasTypedData;
@property (readonly, nonatomic) BOOL hasCommonData;
@property (readonly, nonatomic) BOOL hasBlobData;
@property (readonly, nonatomic) BOOL isReadOnly;
@property (readonly, nonatomic) BOOL hasUpdatedEndDate;

// -------------------------
//
// Initializers
//
// -------------------------

- (instancetype)initWithType:(NSString *)typeID;
- (instancetype)initWithTypedData:(MHVThingDataTyped *)data;
- (instancetype)initWithTypedDataClassName:(NSString *)name;
- (instancetype)initWithTypedDataClass:(Class)cls;

// -------------------------
//
// Serialization
//
// -------------------------
- (NSString *)toXmlString;
+ (MHVThing *)newFromXmlString:(NSString *)xml;

// -------------------------
//
// Methods
//
// -------------------------
//
// Does a SHALLOW CLONE.
// You get a new MHVThing but pointed at all the same internal objects
//
- (MHVThing *)shallowClone;
//
// Sometimes you will take an existing thing object, edit it inline and them PUT it back to HealthVault
// Call this to clear fields that are typically set by the MHV service
// - EffectiveDate, UpdateDate, etc...
//
// NOTE: if you call MHVRecordReference::update, this method will get called automatically
//
- (void)prepareForUpdate;
//
// After this call, if you put the thing into HealthVault, you will add a new thing
//
- (void)prepareForNew;

- (BOOL)setKeyToNew;
- (BOOL)ensureKey;
- (BOOL)ensureEffectiveDate;

- (BOOL)removeEndDate;
- (BOOL)updateEndDate:(NSDate *)date;
- (BOOL)updateEndDateWithApproxDate:(MHVApproxDateTime *)date;

- (NSDate *)getDate;

- (BOOL)isVersion:(NSString *)version;
- (BOOL)isType:(NSString *)typeID;

@end


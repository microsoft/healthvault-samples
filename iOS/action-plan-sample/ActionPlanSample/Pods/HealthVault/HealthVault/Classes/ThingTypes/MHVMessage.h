//
// MHVMessage.h
// MHVLib
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
#import "MHVTypes.h"

@interface MHVMessage : MHVThingDataTyped

@property (readwrite, nonatomic, strong) MHVDateTime *when;
@property (readwrite, nonatomic, strong) NSArray<MHVMessageHeaderThing *> *headers;
@property (readwrite, nonatomic, strong) MHVPositiveInt *size;
@property (readwrite, nonatomic, strong) NSString *summary;
@property (readwrite, nonatomic, strong) NSString *htmlBlobName;
@property (readwrite, nonatomic, strong) NSString *textBlobName;
@property (readwrite, nonatomic, strong) NSArray<MHVMessageAttachment *> *attachments;

@property (readonly, nonatomic) BOOL hasHeaders;
@property (readonly, nonatomic) BOOL hasAttachments;
@property (readonly, nonatomic) BOOL hasHtmlBody;
@property (readonly, nonatomic) BOOL hasTextBody;

- (NSString *)getFrom;
- (NSString *)getTo;
- (NSString *)getCC;
- (NSString *)getSubject;
- (NSString *)getMessageDate;
- (NSString *)getValueForHeader:(NSString *)name;

// -------------------------
//
// Type Information
//
// -------------------------
+ (NSString *)typeID;
+ (NSString *)XRootElement;

@end

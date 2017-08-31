//
// MHVFile.m
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
//

#import "MHVFile.h"
#import "MHVValidator.h"
#import "MHVBlob.h"
#import "MHVCodableValue.h"

static NSString *const c_typeid = @"bd0403c5-4ae2-4b0e-a8db-1888678e4528";
static NSString *const c_typename = @"file";

static NSString *const c_element_name = @"name";
static NSString *const c_element_size = @"size";
static NSString *const c_element_contentType = @"content-type";

@interface MHVFile ()

@property (nonatomic, strong) MHVString255 *nameValue;

@end

@implementation MHVFile

- (NSString *)name
{
    return (self.nameValue) ? self.nameValue.value : nil;
}

- (void)setName:(NSString *)name
{
    if (!self.nameValue)
    {
        self.nameValue = [[MHVString255 alloc] init];
    }
    
    self.nameValue.value = name;
}

- (NSString *)toString
{
    return self.name;
}

- (NSString *)description
{
    return [self toString];
}

- (NSString *)sizeAsString
{
    if (self.size < 1024)
    {
        return [NSString localizedStringWithFormat:@"%d %@", (int)self.size, NSLocalizedString(@"bytes", @"Size in bytes")];
    }
    
    if (self.size < (1024 * 1024))
    {
        return [NSString localizedStringWithFormat:@"%.1f %@", ((double)self.size) / 1024, NSLocalizedString(@"KB", @"Size in KB")];
    }
    
    return [NSString localizedStringWithFormat:@"%.1f %@", ((double)self.size) / (1024 * 1024), NSLocalizedString(@"MB", @"Size in MB")];
}

- (MHVClientResult *)validate
{
    MHVVALIDATE_BEGIN
    
    MHVVALIDATE(self.nameValue, MHVClientError_InvalidFile);
    MHVVALIDATE(self.contentType, MHVClientError_InvalidFile);
    
    MHVVALIDATE_SUCCESS
}

- (void)serialize:(XWriter *)writer
{
    [writer writeElement:c_element_name content:self.nameValue];
    [writer writeElement:c_element_size intValue:(int)self.size];
    [writer writeElement:c_element_contentType content:self.contentType];
}

- (void)deserialize:(XReader *)reader
{
    self.nameValue = [reader readElement:c_element_name asClass:[MHVString255 class]];
    self.size = [reader readIntElement:c_element_size];
    self.contentType = [reader readElement:c_element_contentType asClass:[MHVCodableValue class]];
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
    return [[MHVThing alloc] initWithType:[MHVFile typeID]];
}

+ (MHVThing *)newThingWithName:(NSString *)name andContentType:(NSString *)contentType
{
    MHVThing *thing = [self newThing];
    
    if (!thing)
    {
        return nil;
    }
    
    MHVFile *file = (MHVFile *)thing.data.typed;
    file.name = name;
    file.contentType = [MHVCodableValue fromText:contentType];
    
    return thing;
}

@end

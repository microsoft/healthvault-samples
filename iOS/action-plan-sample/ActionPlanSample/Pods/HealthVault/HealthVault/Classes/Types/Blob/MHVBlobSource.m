//
// MHVBlobSource.m
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

#import "MHVBlobSource.h"
#import "MHVValidator.h"

// ------------------------------
//
// MHVBlobMemorySource
//
// ------------------------------
@interface MHVBlobMemorySource ()

@property (nonatomic, strong) NSData *source;

@end

@implementation MHVBlobMemorySource

- (NSUInteger)length
{
    return self.source.length;
}

- (instancetype)init
{
    return [self initWithData:nil];
}

- (instancetype)initWithData:(NSData *)data
{
    MHVCHECK_NOTNULL(data);

    self = [super init];
    if (self)
    {
        _source = data;
    }

    return self;
}

- (NSData *)readStartAt:(NSInteger)offset chunkSize:(NSInteger)chunkSize
{
    NSRange range = NSMakeRange(offset, chunkSize);

    return [self.source subdataWithRange:range];
}

@end

// ------------------------------
//
// MHVBlobFileHandleSource
//
// ------------------------------
@interface MHVBlobFileHandleSource ()

@property (nonatomic, strong) NSFileHandle *file;
@property (nonatomic, assign) long size;

@end

@implementation MHVBlobFileHandleSource

- (NSUInteger)length
{
    return self.size;
}

- (instancetype)init
{
    return [self initWithFilePath:nil];
}

- (instancetype)initWithFilePath:(NSString *)filePath
{
    MHVCHECK_NOTNULL(filePath);

    self = [super init];
    if (self)
    {
        _file = [NSFileHandle fileHandleForReadingAtPath:filePath];
        MHVCHECK_NOTNULL(_file);

        _size = (long)[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil].fileSize;
    }

    return self;
}

- (void)dealloc
{
    [self.file closeFile];
}

- (NSData *)readStartAt:(NSInteger)offset chunkSize:(NSInteger)chunkSize
{
    [self.file seekToFileOffset:offset];
    return [self.file readDataOfLength:chunkSize];
}

@end

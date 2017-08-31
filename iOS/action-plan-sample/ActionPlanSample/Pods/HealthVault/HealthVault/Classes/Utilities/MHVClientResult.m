//
// MHVClientResult.m
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

#import "MHVClientResult.h"
#import "MHVValidator.h"

static MHVClientResult *s_success = nil;
static MHVClientResult *s_unknownError = nil;

@interface MHVClientResult ()

@property (readwrite, nonatomic) MHVClientResultCode error;
@property (readwrite, nonatomic) const char *fileName;
@property (readwrite, nonatomic) int lineNumber;

@end

@implementation MHVClientResult

- (BOOL)isSuccess
{
    return self.error == MHVClientResult_Success;
}

- (BOOL)isError
{
    return self.error != MHVClientResult_Success;
}

+ (void)initialize
{
    s_success = [[MHVClientResult alloc] initWithCode:MHVClientResult_Success];
    s_unknownError = [[MHVClientResult alloc] initWithCode:MHVClientError_Unknown];
}

- (instancetype)init
{
    return [self initWithCode:MHVClientError_Unknown];
}

- (instancetype)initWithCode:(MHVClientResultCode)code
{
    return [self initWithCode:code fileName:"" lineNumber:0];
}

- (instancetype)initWithCode:(MHVClientResultCode)code fileName:(const char *)fileName lineNumber:(int)line
{
    self = [super init];
    if (self)
    {
        _error = code;
        _fileName = fileName;
        _lineNumber = line;
    }
    return self;
}

- (NSString *)description
{
    if (self.isError)
    {
        return [NSString stringWithFormat:@"ClientError:%li file:%s line:%li", (long)self.error, self.fileName, (long)self.lineNumber];
    }

    return [super description];
}

+ (MHVClientResult *)unknownError
{
    return s_unknownError;
}

+ (MHVClientResult *)success
{
    return s_success;
}

+ (MHVClientResult *)fromCode:(MHVClientResultCode)code
{
    return [[MHVClientResult alloc] initWithCode:code];
}

+ (MHVClientResult *)fromCode:(MHVClientResultCode)code fileName:(const char *)fileName lineNumber:(int)line
{
    return [[MHVClientResult alloc] initWithCode:code fileName:fileName lineNumber:line];
}

@end

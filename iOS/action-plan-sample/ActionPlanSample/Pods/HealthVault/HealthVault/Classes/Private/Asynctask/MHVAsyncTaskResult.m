//
//  MHVAsyncTaskResult.m
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
//

#import "MHVAsyncTaskResult.h"

@implementation MHVAsyncTaskResult

- (instancetype)initWithError:(NSError *)error
{
    if (self = [super init])
    {
        _error = error;
    }
    
    return self;
}

- (instancetype)initWithResult:(id)result
{
    if (self = [super init])
    {
        _result = result;
    }
    
    return self;
}

+ (instancetype)withError:(NSError *)error
{
    return [[self alloc] initWithError:error];
}

+ (instancetype)withResult:(id)result
{
    return [[self alloc] initWithResult:result];
}

@end

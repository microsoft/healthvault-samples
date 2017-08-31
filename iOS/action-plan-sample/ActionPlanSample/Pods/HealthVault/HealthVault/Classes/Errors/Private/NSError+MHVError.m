//
//  NSError+MHVError.m
//  MHVLib
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

#import "NSError+MHVError.h"
#import "MHVErrorConstants.h"

@implementation NSError (MHVError)

+ (NSError *)MVHInvalidParameter
{
    return [NSError errorWithDomain:kMHVErrorDomain
                               code:MHVErrorTypeRequiredParameter
                           userInfo:@{
                                      NSLocalizedFailureReasonErrorKey : @"Missing required parameter."
                                      }];
}

+ (NSError *)MVHInvalidParameter:(NSString *)message
{
    return [NSError errorWithDomain:kMHVErrorDomain
                               code:MHVErrorTypeRequiredParameter
                           userInfo:@{
                                      NSLocalizedFailureReasonErrorKey : message ?: @"Missing required parameter."
                                      }];
}

+ (NSError *)MVHRequiredParameterIsNil
{
    return [NSError errorWithDomain:kMHVErrorDomain
                               code:MHVErrorTypeRequiredParameter
                           userInfo:@{
                                      NSLocalizedFailureReasonErrorKey : @"One or more required parameters is nil."
                                      }];
}

+ (NSError *)MHVOperationCannotBePerformed
{
    return [NSError errorWithDomain:kMHVErrorDomain
                               code:MHVErrorTypeOperationCannotBePerformed
                           userInfo:@{
                                      NSLocalizedFailureReasonErrorKey : @"The operation cannot be performed at this time."
                                      }];
}

+ (NSError *)MHVAuthorizationInProgress
{
    return [NSError errorWithDomain:kMHVErrorDomain
                               code:MHVErrorTypeAuthorizationInProgress
                           userInfo:@{
                                      NSLocalizedFailureReasonErrorKey : @"Another authentication operation is currently in progress."
                                      }];
}

+ (NSError *)MHVIOError
{
    return [NSError errorWithDomain:kMHVErrorDomain
                               code:MHVErrorTypeIOError
                           userInfo:@{
                                      NSLocalizedFailureReasonErrorKey : @"An IO Failure occured."
                                      }];
}

+ (NSError *)MHVUnauthorizedError
{
    return [NSError errorWithDomain:kMHVErrorDomain
                               code:MHVErrorTypeUnauthorized
                           userInfo:@{
                                      NSLocalizedFailureReasonErrorKey : @"The session authorization is invalid or expired."
                                      }];
}

+ (NSError *)MHVOperationCancelled
{
    return [NSError errorWithDomain:kMHVErrorDomain
                               code:MHVErrorTypeOperationCancelled
                           userInfo:@{
                                      NSLocalizedFailureReasonErrorKey : @"The operation has been cancelled."
                                      }];
}

+ (NSError *)MHVUnknownError
{
    return [NSError errorWithDomain:kMHVErrorDomain
                               code:MHVErrorTypeUnknown
                           userInfo:@{
                                      NSLocalizedFailureReasonErrorKey : @"An unknown error occured."
                                      }];
}

+ (NSError *)MHVNotFound
{
    return [NSError errorWithDomain:kMHVErrorDomain
                               code:MHVErrorTypeNotFound
                           userInfo:@{
                                      NSLocalizedFailureReasonErrorKey : @"The specified resource could not be found."
                                      }];
}

+ (NSError *)MHVNetworkError
{
    return [NSError errorWithDomain:kMHVErrorDomain
                               code:MHVErrorTypeNetworkError
                           userInfo:@{
                                      NSLocalizedFailureReasonErrorKey : @"An error occurred with the network operation."
                                      }];
}

+ (NSError *)MHVInvalidThingQuery
{
    return [NSError errorWithDomain:kMHVErrorDomain
                               code:MHVErrorTypeInvalidThingQuery
                           userInfo:@{
                                      NSLocalizedFailureReasonErrorKey : @"The MHVThingQuery is in an invalid state."
                                      }];
}

+ (NSError *)MHVCacheNotReady
{
    return [NSError errorWithDomain:kMHVErrorDomain
                               code:MHVErrorTypeCacheNotReady
                           userInfo:@{
                                      NSLocalizedFailureReasonErrorKey : @"The Cache has not been synced for this record."
                                      }];
}

+ (NSError *)MHVCacheDeleted
{
    return [NSError errorWithDomain:kMHVErrorDomain
                               code:MHVErrorTypeCacheDeleted
                           userInfo:@{
                                      NSLocalizedFailureReasonErrorKey : @"The Cache database has been deleted."
                                      }];
}

+ (NSError *)MHVCacheError:(NSString *)errorDescription
{
    return [NSError errorWithDomain:kMHVErrorDomain
                               code:MHVErrorTypeCacheError
                           userInfo:@{
                                      NSLocalizedFailureReasonErrorKey : errorDescription ? errorDescription : @"Cache database error"
                                      }];
}

+ (NSError *)error:(NSError *)error withDescription:(NSString *)description
{
    if (!error)
    {
        return nil;
    }
    
    if (!description)
    {
        return error;
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:error.userInfo];
    
    [userInfo setObject:description forKey:NSLocalizedDescriptionKey];
    
    return [NSError errorWithDomain:error.domain
                               code:error.code
                           userInfo:userInfo];
}

@end

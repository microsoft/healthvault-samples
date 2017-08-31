//
// MHVRemoteMonitoringClient.m
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

#import <Foundation/Foundation.h>
#import "MHVValidator.h"
#import "MHVRemoteMonitoringClient.h"
#import "MHVJsonSerializer.h"
#import "MHVConnectionProtocol.h"
#import "MHVRestRequest.h"
#import "MHVServiceResponse.h"
#import "MHVConnectionFactory.h"
#import "MHVConnection.h"

@interface MHVRemoteMonitoringClient ()

@property (nonatomic, weak) id<MHVConnectionProtocol>     connection;

@end

@implementation MHVRemoteMonitoringClient

- (instancetype)initWithConnection:(id<MHVConnectionProtocol>)connection
{
    MHVASSERT_PARAMETER(connection);
    
    self = [super init];
    if (self)
    {
        _connection = connection;
    }
    
    return self;
}

- (void)requestWithPath:(NSString *_Nonnull)path
             httpMethod:(NSString *_Nonnull)httpMethod
             pathParams:(NSDictionary<NSString *, NSString *> *_Nullable)pathParams
            queryParams:(NSDictionary<NSString *, NSString *> *_Nullable)queryParams
                   body:(NSData *_Nullable)body
            resultClass:(Class)resultClass
             completion:(void(^_Nullable)(id _Nullable output, NSError *_Nullable error))completion
{
    MHVASSERT_PARAMETER(path);
    MHVASSERT_PARAMETER(httpMethod);
    
    path = [self updatePath:path pathParams:pathParams];
    
    MHVRestRequest *restRequest = [[MHVRestRequest alloc] initWithPath:path
                                                            httpMethod:httpMethod
                                                            pathParams:pathParams
                                                           queryParams:queryParams
                                                                  body:body
                                                           isAnonymous:NO];
    
    [self.connection executeHttpServiceOperation:restRequest
                                      completion:^(MHVServiceResponse *_Nullable response, NSError *_Nullable error)
     {
         if (error)
         {
             if (completion)
             {
                 completion(nil, error);
             }
         }
         else
         {
             if (completion)
             {
                 id result = [MHVJsonSerializer deserialize:[[NSString alloc] initWithData:response.responseData encoding:NSUTF8StringEncoding]
                                                    toClass:[resultClass class]
                                                shouldCache:YES];
                 
                 completion(result, nil);
             }
         }
     }];
}

- (void)requestWithPath:(NSString *)path
             httpMethod:(NSString *)httpMethod
             pathParams:(NSDictionary<NSString *, NSString *> *_Nullable)pathParams
            queryParams:(NSDictionary<NSString *, NSString *> *_Nullable)queryParams
                   body:(NSData *_Nullable)body
             completion:(void(^_Nullable)(NSError *_Nullable error))completion;
{
    MHVASSERT_PARAMETER(path);
    MHVASSERT_PARAMETER(httpMethod);
    
    path = [self updatePath:path pathParams:pathParams];
    
    MHVRestRequest *restRequest = [[MHVRestRequest alloc] initWithPath:path
                                                            httpMethod:httpMethod
                                                            pathParams:pathParams
                                                           queryParams:queryParams
                                                                  body:body
                                                           isAnonymous:NO];
    
    [self.connection executeHttpServiceOperation:restRequest
                                      completion:^(MHVServiceResponse *_Nullable response, NSError *_Nullable error)
     {
         if (completion)
         {
             completion(error);
         }
     }];
}


- (NSString *)updatePath:(NSString *)path
             pathParams:(NSDictionary<NSString *, NSString *> *_Nullable)pathParams
{
    if (pathParams != nil)
    {
        NSMutableString *queryPath = [path mutableCopy];
        
        [pathParams enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL *_Nonnull stop)
         {
             [queryPath replaceCharactersInRange:[queryPath rangeOfString:[NSString stringWithFormat:@"{%@}", key]] withString:obj];
         }];
        
        path = queryPath;
    }
    
    return path;
}

@end;

//
// MHVHttpService.m
// MHVLib
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

#import "MHVHttpService.h"
#import "MHVHttpServiceResponse.h"
#import "MHVLogger.h"
#import "MHVBlobSource.h"
#import "MHVValidator.h"
#import "MHVHttpTask.h"
#import "MHVConfiguration.h"
#import "NSError+MHVError.h"

@interface MHVHttpService () <NSURLSessionDelegate>

@property (nonatomic, strong) NSURLSession *urlSession;
@property (nonatomic, strong) NSOperationQueue *certificateCheckQueue;

@property (nonatomic, assign) NSInteger requestCount;

@end

@implementation MHVHttpService

- (instancetype)initWithConfiguration:(MHVConfiguration *)configuration
{
    MHVASSERT_PARAMETER(configuration);

    self = [super init];
    if (self)
    {
        NSURLSessionConfiguration *urlSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        if (configuration)
        {
            urlSessionConfiguration.timeoutIntervalForRequest = configuration.requestTimeoutDuration;
        }
        
        _urlSession = [NSURLSession sessionWithConfiguration:urlSessionConfiguration
                                                    delegate:self
                                               delegateQueue:nil];
        
        _certificateCheckQueue = [[NSOperationQueue alloc] init];
    }
    
    return self;
}

- (instancetype)initWithURLSession:(NSURLSession *)urlSession
{
    MHVASSERT_PARAMETER(urlSession);
    
    self = [super init];
    if (self)
    {
        _urlSession = urlSession;
        
        _certificateCheckQueue = [[NSOperationQueue alloc] init];
    }
    
    return self;
}

- (id<MHVHttpTaskProtocol>)sendRequestForURL:(NSURL *)url
                                        body:(NSData *_Nullable)body
                                  completion:(MHVHttpServiceCompletion)completion
{
    return [self sendRequestForURL:url httpMethod:nil body:body headers:nil completion:completion];
}

- (id<MHVHttpTaskProtocol>)sendRequestForURL:(NSURL *)url
                                  httpMethod:(NSString *_Nullable)httpMethod
                                        body:(NSData *_Nullable)body
                                     headers:(NSDictionary<NSString *, NSString *> *_Nullable)headers
                                  completion:(MHVHttpServiceCompletion)completion
{
    MHVASSERT_PARAMETER(url);
    MHVASSERT([url.scheme isEqualToString:@"https"]);
    
    if (!url)
    {
        if (completion)
        {
            completion(nil, [NSError MVHInvalidParameter]);
        }
        return nil;
    }
    
    NSMutableURLRequest *request = [[self requestWithUrl:url body:body] mutableCopy];
    
    for (NSString *key in headers.allKeys)
    {
        [request setValue:headers[key] forHTTPHeaderField:key];
    }
    
    if (httpMethod)
    {
        request.HTTPMethod = httpMethod;
    }
    
    NSInteger currentRequest = (++self.requestCount);
    NSDate *startDate = [NSDate date];
    
    
    MHVLOG(@"Begin request #%li", (long)currentRequest);
    
    NSURLSessionTask *task = [self.urlSession dataTaskWithRequest:(NSURLRequest *)request
                                                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                              {
                                  NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
                                  
                                  MHVLOG(@"Response for #%li has status code: %li (%0.4f seconds)",
                                                 (long)currentRequest, (long)statusCode, [[NSDate date] timeIntervalSinceDate:startDate]);
                                  
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
                                          completion([self responseFromData:data urlResponse:response], nil);
                                      }
                                  }
                              }];
    
    [task resume];
    return [[MHVHttpTask alloc] initWithURLSessionTask:task];
}

- (id<MHVHttpTaskProtocol>)downloadFileWithUrl:(NSURL *)url
                                    toFilePath:(NSString *)path
                                    completion:(MHVHttpServiceFileDownloadCompletion)completion
{
    MHVASSERT_PARAMETER(url);
    MHVASSERT_PARAMETER(path);
    
    if (!url || !path)
    {
        if (completion)
        {
            completion([NSError MVHInvalidParameter]);
        }
        return nil;
    }
    
    NSURLRequest *request = [self requestWithUrl:url body:nil];
    
    NSURLSessionTask *task = [self.urlSession downloadTaskWithRequest:request
                                                    completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error)
                              {
                                  if (error)
                                  {
                                      if (completion)
                                      {
                                          completion(error);
                                      }
                                      return;
                                  }
                                  
                                  //Remove if a file already exists at the target location
                                  [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
                                  
                                  NSError *fileError;
                                  if (![[NSFileManager defaultManager] copyItemAtURL:location toURL:[NSURL fileURLWithPath:path] error:&fileError])
                                  {
                                      if (completion)
                                      {
                                          completion(fileError);
                                      }
                                  }
                                  else
                                  {
                                      [[NSFileManager defaultManager] setAttributes:@{
                                                                                      NSFileProtectionKey : NSFileProtectionCompleteUntilFirstUserAuthentication
                                                                                      }
                                                                       ofItemAtPath:path
                                                                              error:nil];
                                      if (completion)
                                      {
                                          completion(nil);
                                      }
                                  }
                              }];
    
    [task resume];
    return [[MHVHttpTask alloc] initWithURLSessionTask:task];
}

- (id<MHVHttpTaskProtocol>)downloadDataWithUrl:(NSURL *)url
                                    completion:(MHVHttpServiceCompletion)completion
{
    MHVASSERT_PARAMETER(url);

    if (!url)
    {
        if (completion)
        {
            completion(nil, [NSError MVHInvalidParameter]);
        }
        return nil;
    }

    NSURLRequest *request = [self requestWithUrl:url body:nil];
    
    NSURLSessionTask *task = [self.urlSession downloadTaskWithRequest:request
                                                    completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error)
                              {
                                  if (error)
                                  {
                                      completion(nil, error);
                                      return;
                                  }
                                  else
                                  {
                                      NSData *data = [NSData dataWithContentsOfURL:location];
                                      completion([self responseFromData:data urlResponse:response], nil);
                                  }
                              }];
    
    [task resume];
    return [[MHVHttpTask alloc] initWithURLSessionTask:task];
}

- (id<MHVHttpTaskProtocol>)uploadBlobSource:(id<MHVBlobSourceProtocol>)blobSource
                                      toUrl:(NSURL *)url
                                  chunkSize:(NSUInteger)chunkSize
                                 completion:(MHVHttpServiceCompletion)completion
{
    return [self uploadBlobSource:blobSource
                            toUrl:url
                      chunkOffset:0
                        chunkSize:chunkSize
                         httpTask:[[MHVHttpTask alloc] initWithURLSessionTask:nil totalSize:blobSource.length]
                       completion:completion];
}

- (id<MHVHttpTaskProtocol>)uploadBlobSource:(id<MHVBlobSourceProtocol>)blobSource
                                      toUrl:(NSURL *)url
                                chunkOffset:(NSUInteger)chunkOffset
                                  chunkSize:(NSUInteger)chunkSize
                                   httpTask:(MHVHttpTask *)httpTask
                                 completion:(MHVHttpServiceCompletion)completion
{
    MHVASSERT_PARAMETER(blobSource);
    MHVASSERT_PARAMETER(url);
    MHVASSERT([url.scheme isEqualToString:@"https"]);
    MHVASSERT(chunkSize != 0);
    
    if (!blobSource || !url || chunkSize == 0)
    {
        if (completion)
        {
            completion(nil, [NSError MVHInvalidParameter]);
        }
        return nil;
    }
    
    NSUInteger thisChunkSize = MIN(chunkSize, (blobSource.length - chunkOffset));
    
    NSData *data = [blobSource readStartAt:chunkOffset chunkSize:thisChunkSize];
    
    NSURLRequest *request = [self requestWithUrl:url
                                            data:data
                                     chunkOffset:chunkOffset
                                       totalSize:blobSource.length];
    
    MHVLOG(@"Blob upload chunk at offset %li", (long)chunkOffset);
    NSDate *startDate = [NSDate date];
    NSURLSessionTask *task = [self.urlSession dataTaskWithRequest:(NSURLRequest *)request
                                                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                              {
                                  if (!error)
                                  {
                                      MHVLOG(@"Blob upload chunk size %li in %0.4f seconds", (long)thisChunkSize, [[NSDate date] timeIntervalSinceDate:startDate]);
                                  }
                                  
                                  if (!error && chunkOffset + thisChunkSize < blobSource.length)
                                  {
                                      //Update offset and call this method again to send the next chunk
                                      [self uploadBlobSource:blobSource
                                                       toUrl:url
                                                 chunkOffset:chunkOffset + thisChunkSize
                                                   chunkSize:chunkSize
                                                    httpTask:httpTask
                                                  completion:completion];
                                      return;
                                  }
                                  else
                                  {
                                      if (error)
                                      {
                                          MHVLOG(@"Blob upload error: %@", error.localizedDescription);
                                          
                                          if (completion)
                                          {
                                              completion(nil, error);
                                          }
                                      }
                                      else
                                      {
                                          MHVLOG(@"Blob upload complete");
                                          
                                          if (completion)
                                          {
                                              completion([self responseFromData:data urlResponse:response], nil);
                                          }
                                      }
                                  }
                              }];
    
    [task resume];
    [httpTask addTask:task];
    
    return httpTask;
}

#pragma mark - Internal methods

- (NSURLRequest *)requestWithUrl:(NSURL *)url
                            body:(NSData *)body
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    
    if (body)
    {
        request.HTTPMethod = @"POST";
        request.HTTPBody = body;
        
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)body.length] forHTTPHeaderField:@"Content-Length"];
    }
    
    return request;
}

- (NSURLRequest *)requestWithUrl:(NSURL *)url
                            data:(NSData *)data
                     chunkOffset:(NSUInteger)chunkOffset
                       totalSize:(NSUInteger)totalSize
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    request.HTTPMethod = @"POST";
    request.HTTPBody = data;
    
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    
    NSString *contentRange = [NSString stringWithFormat:@"bytes %lu-%lu/*", (unsigned long)chunkOffset, (unsigned long)chunkOffset + data.length - 1];
    [request setValue:contentRange forHTTPHeaderField:@"Content-Range"];
    
    //Last chunk, add the "complete" header
    if (chunkOffset + data.length == totalSize)
    {
        [request setValue:@"1" forHTTPHeaderField:@"x-hv-blob-complete"];
    }
    
    return request;
}

- (MHVHttpServiceResponse *)responseFromData:(NSData *)data urlResponse:(NSURLResponse *)response
{
    NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
    
    return [[MHVHttpServiceResponse alloc] initWithResponseData:data
                                                     statusCode:statusCode];
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *_Nullable credential))completionHandler
{
    // Check if certificate chain is valid or returns an error (SecTrustEvaluate is syncronous, so perform check on a Queue)
    [self.certificateCheckQueue addOperationWithBlock:^
     {
         SecTrustResultType result;
         SecTrustEvaluate([challenge.protectionSpace serverTrust], &result);
         
         // Unspecified is a valid certificate, but not specifically accepted in the keychain (iOS's normal response)
         if (result == kSecTrustResultUnspecified ||
             result == kSecTrustResultProceed)
         {
             completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
         }
         else
         {
             MHVLOG(@"SecTrustEvaluate failed %li", (long)result);
             
             completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
         }
     }];
}

@end

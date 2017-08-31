//
// MHVHttpTask.m
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


#import "MHVHttpTask.h"

static NSString *kCountOfBytesReceivedKeyPath = @"countOfBytesReceived";
static NSString *kCountOfBytesSentKeyPath = @"countOfBytesSent";
static NSString *kProgressKeyPath = @"progress";

@interface MHVHttpTask ()

@property (nonatomic, assign) double progress;
@property (nonatomic, strong) NSNumber *totalSize;

//A Blob upload can have several tasks, as it is uploaded in chunks. Array for all tasks
@property (nonatomic, strong) NSMutableArray<NSURLSessionTask *> *tasks;

@end

@implementation MHVHttpTask

- (instancetype)initWithURLSessionTask:(NSURLSessionTask *_Nullable)task
{
    return [self initWithURLSessionTask:task totalSize:0];
}

- (instancetype)initWithURLSessionTask:(NSURLSessionTask *_Nullable)task totalSize:(NSUInteger)totalSize
{
    self = [super init];
    if (self)
    {
        _tasks = [NSMutableArray new];
        
        if (totalSize != 0)
        {
            _totalSize = @(totalSize);
        }
        
        [self addTask:task];
    }
    return self;
}

- (void)dealloc
{
    for (NSURLSessionTask *task in self.tasks)
    {
        [self stopObserving:task];
    }
}

- (void)addTask:(NSURLSessionTask *)task
{
    if (!task)
    {
        return;
    }
    
    [self startObserving:task];

    [self.tasks addObject:task];
    
    [self updateProgress];
}

- (void)cancel
{
    for (NSURLSessionTask *task in self.tasks)
    {
        [task cancel];
    }
}

- (void)updateProgress
{
    double countOfBytesReceived = 0;
    double countOfBytesSent = 0;
    double countOfBytesExpectedToSend = 0;
    double countOfBytesExpectedToReceive = 0;

    for (NSURLSessionTask *task in self.tasks)
    {
        countOfBytesReceived += task.countOfBytesReceived;
        countOfBytesSent += task.countOfBytesSent;
        countOfBytesExpectedToSend += task.countOfBytesExpectedToSend;
        countOfBytesExpectedToReceive += task.countOfBytesExpectedToReceive;
    }
    
    double progress = 0.0;
    
    if (self.totalSize)
    {
        progress = countOfBytesSent / [self.totalSize doubleValue];
    }
    else if (countOfBytesExpectedToSend > 0 || countOfBytesExpectedToReceive > 0)
    {
        progress = (countOfBytesReceived + countOfBytesSent) / (countOfBytesExpectedToSend + countOfBytesExpectedToReceive);
    }

    if (progress < 0.0)
    {
        progress = 0.0;
    }
    else if (progress > 1.0)
    {
        progress = 1.0;
    }
    
    self.progress = progress;
}

#pragma mark - KVO

- (void)startObserving:(NSURLSessionTask *)task
{
    if (task)
    {
        [task addObserver:self forKeyPath:kCountOfBytesReceivedKeyPath options:kNilOptions context:nil];
        [task addObserver:self forKeyPath:kCountOfBytesSentKeyPath options:kNilOptions context:nil];
    }
}

- (void)stopObserving:(NSURLSessionTask *)task
{
    if (task)
    {
        [task removeObserver:self forKeyPath:kCountOfBytesReceivedKeyPath];
        [task removeObserver:self forKeyPath:kCountOfBytesSentKeyPath];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:kCountOfBytesReceivedKeyPath] ||
        [keyPath isEqualToString:kCountOfBytesSentKeyPath])
    {
        [self updateProgress];
    }
}

@end

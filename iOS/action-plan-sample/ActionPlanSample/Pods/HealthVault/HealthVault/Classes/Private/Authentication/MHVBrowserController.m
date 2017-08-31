//
// MHVBrowserController.m
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

#import "MHVBrowserController.h"
#import "MHVValidator.h"
#import "MHVBrowserAuthBrokerProtocol.h"
#import "MHVViewExtensions.h"
#import <WebKit/WebKit.h>

#define RGBColor(r, g, b) [UIColor colorWithRed:r / 255.0 green: g / 255.0 blue: b / 255.0 alpha : 1]
#define MHVCOLOR RGBColor(0, 130, 114)

static NSString *kLoadingKeyPath = @"loading";
static CGFloat kAnimationTime = 0.15;


@interface MHVBrowserController ()

@property (nonatomic, weak) id<MHVBrowserAuthBrokerProtocol> authBroker;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end

@implementation MHVBrowserController

- (instancetype)initWithAuthBroker:(id<MHVBrowserAuthBrokerProtocol>)authBroker
{
    self = [super init];
    if (self)
    {
        _authBroker = authBroker;
        
        MHVASSERT_TRUE(_authBroker.startUrl);
    }

    return self;
}

- (void)dealloc
{
    [self stopObserving];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    [self createBrowser];
    [self addCancelButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.authBroker.startUrl)
    {
        [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:self.authBroker.startUrl]];
    }
    else
    {
        MHVASSERT_MESSAGE(@"authBroker startUrl is nil");
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.webView stopLoading];
}

- (void)createBrowser
{
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.websiteDataStore = [WKWebsiteDataStore nonPersistentDataStore];
    configuration.dataDetectorTypes = WKDataDetectorTypeNone;

    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    self.webView.navigationDelegate = self.authBroker;
    self.webView.opaque = NO;
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.webView];
    
    [self.view addConstraints:[self.webView constraintsToFillView:self.view]];

    [self startObserving];
}

- (void)addCancelButton
{
    self.navigationItem.hidesBackButton = YES;

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(cancelButtonPressed:)];
    self.navigationItem.leftBarButtonItem.tintColor = MHVCOLOR;
}

- (void)cancelButtonPressed:(id)sender
{
    [self.authBroker userCancelled];
}

#pragma mark - Activity spinner

- (void)showActivitySpinner
{
    if (!self.activityView)
    {
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.activityView.color = MHVCOLOR;
        self.activityView.translatesAutoresizingMaskIntoConstraints = NO;
        self.activityView.hidesWhenStopped = YES;

        [self.view addSubview:self.activityView];
        [self.view addConstraints:[self.activityView constraintsToCenterInView:self.view]];
    }

    [self.activityView startAnimating];
}

- (void)hideActivitySpinner
{
    if (self.activityView)
    {
        [self.activityView stopAnimating];
    }
}

#pragma mark - KVO on webView.loading to show spinner

- (void)startObserving
{
    if (self.webView)
    {
        [self.webView addObserver:self forKeyPath:kLoadingKeyPath options:kNilOptions context:nil];
    }
}

- (void)stopObserving
{
    if (self.webView)
    {
        [self.webView removeObserver:self forKeyPath:kLoadingKeyPath];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == self.webView && [keyPath isEqual:kLoadingKeyPath])
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^
        {
            if (self.webView.loading)
            {
                self.webView.userInteractionEnabled = NO;
                [UIView animateWithDuration:kAnimationTime animations:^
                {
                    self.webView.alpha = 0.0;
                }];
                
                [self showActivitySpinner];
            }
            else
            {
                self.webView.userInteractionEnabled = YES;
                [UIView animateWithDuration:kAnimationTime animations:^
                 {
                     self.webView.alpha = 1.0;
                 }];
                
                [self hideActivitySpinner];
            }
        }];
    }
}

@end

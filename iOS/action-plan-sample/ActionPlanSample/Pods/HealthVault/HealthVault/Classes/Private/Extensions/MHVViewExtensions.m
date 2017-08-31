//
// MHVViewExtensions.h
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

#import "MHVViewExtensions.h"

@implementation UIView (MHVViewExtensions)

- (NSArray<NSLayoutConstraint *> *)constraintsToFillView:(UIView *)fillView
{
    return @[
             [NSLayoutConstraint constraintWithItem:self
                                          attribute:NSLayoutAttributeBottom
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:fillView
                                          attribute:NSLayoutAttributeBottom
                                         multiplier:1
                                           constant:0],
             [NSLayoutConstraint constraintWithItem:self
                                          attribute:NSLayoutAttributeTop
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:fillView
                                          attribute:NSLayoutAttributeTop
                                         multiplier:1
                                           constant:0],
             [NSLayoutConstraint constraintWithItem:self
                                          attribute:NSLayoutAttributeLeft
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:fillView
                                          attribute:NSLayoutAttributeLeft
                                         multiplier:1
                                           constant:0],
             [NSLayoutConstraint constraintWithItem:self
                                          attribute:NSLayoutAttributeRight
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:fillView
                                          attribute:NSLayoutAttributeRight
                                         multiplier:1
                                           constant:0]
             ];
}

- (NSArray<NSLayoutConstraint *> *)constraintsToCenterInView:(UIView *)centerInView
{
    return @[
             [NSLayoutConstraint constraintWithItem:self
                                          attribute:NSLayoutAttributeCenterX
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:centerInView
                                          attribute:NSLayoutAttributeCenterX
                                         multiplier:1
                                           constant:0],
             [NSLayoutConstraint constraintWithItem:self
                                          attribute:NSLayoutAttributeCenterY
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:centerInView
                                          attribute:NSLayoutAttributeCenterY
                                         multiplier:1
                                           constant:0]
             ];
}

@end

//
//  MHVItemTypePropertyConverterProtocol.h
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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MHVItemTypePropertyConverterProtocol <NSObject>

/**
 Converts a value to different units. The conversion formula is determined by the implementation of the MHVItemTypePropertyConverterProtocol and the parameters with which it was constructed.

 @param doubleValue The value to be converted.
 @return the converted value.
 */
- (double)convertDoubleValue:(double)doubleValue;

@end

NS_ASSUME_NONNULL_END

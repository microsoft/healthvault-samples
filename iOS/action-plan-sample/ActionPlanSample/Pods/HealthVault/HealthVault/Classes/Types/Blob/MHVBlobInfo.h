//
// MHVBlobInfo.h
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
#import "MHVBaseTypes.h"

@interface MHVBlobInfo : MHVType

// -------------------------
//
// Data
//
// -------------------------
//
// (Optional). Most blobs are named (like named streams).
// However, you can have a 'default' blob with no name (empty string)
//
@property (readwrite, nonatomic, strong) NSString *name;
//
// (Optional) MIME type for this blob
//
@property (readwrite, nonatomic, strong) NSString *contentType;

// -------------------------
//
// Initializers
//
// -------------------------
- (instancetype)initWithName:(NSString *)name andContentType:(NSString *)contentType;

@end

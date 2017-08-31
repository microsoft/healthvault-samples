//
// NSArray+MHVThingQuery.h
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

#import <Foundation/Foundation.h>
@class MHVThingQuery;

@interface NSArray (MHVThingQuery)

/**
 Returns a query contained in the collection with the given name or nil if no queries are found with the name.
 Should only be used with arrays with objects of type MHVThingQuery
 
 @param name NSString the name of the query. *Case Sensitive.
 @return MHVThingQuery the thing query with the given name.
 */
- (MHVThingQuery *)queryWithName:(NSString *)name;

/**
 Returns the index of the MHVThingQuery with the given name or NSNotFound if no queries are found with the name.
 Should only be used with arrays with objects of type MHVThingQuery
 
 @param name NSString the name of the query. *Case Sensitive.
 @return NSUInteger the index of the thing query with the given name.
 */
- (NSUInteger)indexOfQueryWithName:(NSString *)name;

@end

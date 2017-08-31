//
//  MHVKeychainServiceProtocol.h
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

@protocol XSerializable;

NS_ASSUME_NONNULL_BEGIN

@protocol MHVKeychainServiceProtocol <NSObject>


/**
 Fetches a string value stored in the keychain.

 @param key The key the string is stored under.
 @return The string value or nil if the no string could be found for the given key.
 */
- (NSString *_Nullable)stringForKey:(NSString *)key;

/**
 Saves a string value to the keychain.

 @param string The string to be saved. If nil is passed as the string parameter, the string for key will be deleted.
 @param key The key used to save the string value under.
 @return YES if the save is successful NO if the save fails.
 */
- (BOOL)setString:(NSString *_Nullable)string forKey:(NSString *)key;

/**
 Fetches a XSerializable object stored in the keychain.
 
 @param key The key the string is stored under.
 @return The string value or nil if the no string could be found for the given key.
 */
- (BOOL)setXMLObject:(id<XSerializable>)obj forKey:(NSString *)key;

/**
 Saves an XSerializable object to the keychain.
 
 @param key The key used to save the object value under.
 @return YES if the save is successful NO if the save fails.
 */
- (id<XSerializable> _Nullable)xmlObjectForKey:(NSString *)key;

/**
 Deletes a string or object value from the keychain for a given key
 
 @param key The key the string value to be deleted is saved under.
 @return YES if the delete is successful, or the key is not found, NO if the delete fails.
 */
- (BOOL)removeObjectForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END

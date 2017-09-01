//
// MHVKeychainService.m
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

#import "MHVKeychainService.h"
#import "MHVValidator.h"
#import "MHVStringExtensions.h"
#import <Security/Security.h>
#import "XSerializer.h"

static NSString *const kKeychainRoot = @"root";
static NSString *const kKeychainService = @"HealthVault";
static NSString *const kAppReinstallCheck = @"AppReinstallCheck";

@implementation MHVKeychainService

#pragma mark - Public

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self checkForAppReinstall];
    }
    return self;
}

- (NSString *)stringForKey:(NSString *)key
{
    NSDictionary *dictionary = [self getAttributesForKey:key];
    
    NSString *cls = [dictionary objectForKey:(__bridge id)kSecAttrDescription];
    
    NSData *data = [dictionary objectForKey:(__bridge id)kSecValueData];
    
    if (!data || data.length == 0 || NSClassFromString(cls) != [NSString class])
    {
        return nil;
    }
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (BOOL)setString:(NSString *)string forKey:(NSString *)key
{
    MHVASSERT_PARAMETER(key);
    
    if (!key)
    {
        return NO;
    }
    
    if ([NSString isNilOrEmpty:string])
    {
        return [self removeObjectForKey:key];
    }
    
    return [self setString:string class:[NSString class] forKey:key];
}

- (BOOL)setXMLObject:(id<XSerializable>)obj forKey:(NSString *)key
{
    MHVASSERT_PARAMETER(key);
    
    if (!key)
    {
        return NO;
    }
    
    NSString *string = [XSerializer serializeToString:obj withRoot:kKeychainRoot];
    
    if (!string)
    {
        return [self removeObjectForKey:key];
    }
    
    return [self setString:string class:[obj class] forKey:key];
    
    return YES;
}

- (id<XSerializable>)xmlObjectForKey:(NSString *)key
{
    MHVASSERT_PARAMETER(key);
    
    if (!key)
    {
        return nil;
    }
    
    NSDictionary *dictionary = [self getAttributesForKey:key];
    
    NSString *cls = [dictionary objectForKey:(__bridge id)kSecAttrDescription];
    
    NSData *data = [dictionary objectForKey:(__bridge id)kSecValueData];
    
    NSString *xml = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if ([NSString isNilOrEmpty:xml] || [NSString isNilOrEmpty:cls])
    {
        return nil;
    }
    
    return (id<XSerializable>)[XSerializer newFromString:xml withRoot:kKeychainRoot asClass:NSClassFromString(cls)];
}

- (BOOL)removeObjectForKey:(NSString *)key
{
    MHVASSERT_PARAMETER(key);
    
    if (!key)
    {
        return NO;
    }
    
    NSMutableDictionary *query = [self queryForKey:key];
    
    if (!query)
    {
        return NO;
    }
    
    OSStatus error = SecItemDelete((CFDictionaryRef)query);
    
    return error == errSecSuccess || error == errSecItemNotFound;
}

#pragma mark - Private

- (BOOL)dataExistsForKey:(NSString *)key
{
    NSDictionary *dictionary = [self getAttributesForKey:key];
    
    return [dictionary objectForKey:(__bridge id)kSecValueData] != nil;
}

- (BOOL)setString:(NSString *)string class:(Class)cls forKey:(NSString *)key
{
    NSMutableDictionary *query = [self queryForKey:key];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *update = [self attributesForKey:key class:cls];
    
    if (!query || !data || !update)
    {
        return NO;
    }
    
    [update setObject:data forKey:(__bridge id)kSecValueData];
    [update setObject:(__bridge id)kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly forKey:(id) kSecAttrAccessible];
    
    OSStatus error = 0;
    if ([self dataExistsForKey:key])
    {
        // Update existing
        error = SecItemUpdate((CFDictionaryRef)query, (CFDictionaryRef)update);
    }
    else
    {
        [update setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
        error = SecItemAdd((CFDictionaryRef)update, NULL);
    }
    
    return error == errSecSuccess;
}

- (NSMutableDictionary *)attributesForKey:(NSString *)key class:(Class)cls
{
    MHVASSERT_PARAMETER(key);
    
    if (!key)
    {
        return nil;
    }

    NSMutableDictionary *attrib = [NSMutableDictionary new];
    
    [attrib setObject:key forKey:(__bridge id)kSecAttrGeneric];
    [attrib setObject:key forKey:(__bridge id)kSecAttrAccount];
    [attrib setObject:kKeychainService forKey:(__bridge id)kSecAttrService];
    
    if (cls)
    {
        [attrib setObject:NSStringFromClass(cls) forKey:(__bridge id)kSecAttrDescription];
    }

    return attrib;
}

- (NSMutableDictionary *)queryForKey:(NSString *)key
{
    NSMutableDictionary *query = [self attributesForKey:key class:nil];

    if (!query)
    {
        return nil;
    }

    [query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];

    return query;
}

- (NSDictionary *)runQuery:(NSMutableDictionary *)query
{
    MHVASSERT_PARAMETER(query);
    
    if (!query)
    {
        return nil;
    }

    [query setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    [query setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [query setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnAttributes];

    CFTypeRef result = nil;
    
    if (SecItemCopyMatching((CFDictionaryRef)query, &result) == errSecSuccess)
    {
        return (NSDictionary *)CFBridgingRelease(result);
    }

    return nil;
}

- (NSDictionary *)getAttributesForKey:(NSString *)key
{
    NSMutableDictionary *query = [self queryForKey:key];

    if (!query)
    {
        return nil;
    }

    return [self runQuery:query];
}

- (void)checkForAppReinstall
{
    // Check for sentinal values; if user defaults is not set and keychain value exists, the app was deleted and reinstalled.
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kAppReinstallCheck] &&
        [self stringForKey:kAppReinstallCheck])
    {
        [self resetKeychain];
    }

    // Add sentinel values
    [self setString:@"installed" forKey:kAppReinstallCheck];
    [[NSUserDefaults standardUserDefaults] setObject:@"installed" forKey:kAppReinstallCheck];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)resetKeychain
{
    //Delete everything in the keychain for HealthVault
    NSDictionary *dictionary = @{
                                 (__bridge id)kSecAttrService : kKeychainService,
                                 (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                                 };

    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)dictionary);
    if (status != errSecSuccess)
    {
        NSLog(@"Error deleting keychain object: %i", (int)status);
    }
}

@end

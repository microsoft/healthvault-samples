//
// MHVEnum.m
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

#import "MHVEnum.h"

static NSString *kEnumNSCodingKey = @"value";


@interface MHVEnum ()

@property (nonatomic, strong) NSString  *string;
@property (nonatomic, assign) NSInteger integer;

@end


@implementation MHVEnum

- (instancetype)initWithString:(NSString *)string
{
    //Nil for enum is converted to Unknown
    if (string == nil)
    {
        string = @"Unknown";
    }
    
    self = [super init];
    if (self)
    {
        NSNumber *value = [self.enumMap objectForKey:string];
        
        if (!value)
        {
            value = [self.aliasMap objectForKey:string];
        }
        
        // Value should be a number, but swagger code generation can't do incrementing numbers, so lookup index of string
        if ([value isKindOfClass:[NSString class]])
        {
            NSUInteger index = [self.enumMap.allKeys indexOfObject:string];
            // +1 since 0 is used for Undefined
            value = index == NSNotFound ? nil : @(index + 1);
        }
        
        if (!value)
        {
            _string = kEnumUndefined;
            _integer = 0;
        }
        else
        {
            _string = string;
            _integer = value.integerValue;
        }
    }
    
    return self;
}

- (instancetype)initWithCaseInsensitiveString:(NSString *)string
{
    NSAssert(string, @"string must not be nil");
    
    self = [super init];
    if (self)
    {
        for (NSString *key in self.enumMap.allKeys)
        {
            if ([key compare:string options:NSCaseInsensitiveSearch] == NSOrderedSame)
            {
                _string = key;
                _integer = self.enumMap[key].integerValue;
                
                return self;
            }
        }

        for (NSString *key in self.aliasMap.allKeys)
        {
            if ([key compare:string options:NSCaseInsensitiveSearch] == NSOrderedSame)
            {
                //use initWithInteger, since want string from enumMap and not aliasMap
                return [self initWithInteger:self.aliasMap[key].integerValue];
            }
        }

        _string = kEnumUndefined;
        _integer = 0;
    }
    
    return self;
}

- (instancetype)initWithInteger:(NSInteger)integer
{
    self = [super init];
    if (self)
    {
        for (NSString *key in self.enumMap)
        {
            NSNumber *value = [self.enumMap objectForKey:key];
            
            if ([value isKindOfClass:[NSString class]])
            {
                // Value should be a number, but swagger code generation can't do incrementing numbers, so set as in index
                [self setValueByIndex:integer];
                return self;
            }
            
            if (value.integerValue == integer)
            {
                _integer = integer;
                _string = key;
            }
        }
    
        if (!_string)
        {
            _string = kEnumUndefined;
            _integer = 0;
        }
    }
    
    return self;
}

- (void)setValueByIndex:(NSInteger)index
{
    // -1 since 0 is used for Undefined
    NSInteger enumIndex = index - 1;
    NSString *key = (enumIndex >= 0 && enumIndex < self.enumMap.allKeys.count) ? self.enumMap.allKeys[enumIndex] : nil;
    if (key)
    {
        _string = (NSString *)self.enumMap[key];
        _integer = index;
    }
    else
    {
        _string = kEnumUndefined;
        _integer = 0;
    }
}

- (instancetype)initWithObject:(id)object
{
    if (!object || [object isKindOfClass:[NSNull class]])
    {
        return nil;
    }
    else if ([object isKindOfClass:[NSString class]])
    {
        return [self initWithString:object];
    }
    else if ([object isKindOfClass:[NSNumber class]])
    {
        NSNumber *numberObject = (NSNumber*)object;
        return [self initWithInteger:numberObject.integerValue];
    }
    else if ([object isMemberOfClass:[self class]])
    {
        MHVEnum *enumObject = (MHVEnum*)object;
        self = [self initWithInteger:enumObject.integerValue];
        if (self)
        {
        }
        return self;
    }
    NSAssert(NO, @"Unsupported class: %@", NSStringFromClass([object class]));
    return nil;
}

#pragma mark - DataModels

- (instancetype)initWithObject:(id)object objectParameters:(id)ignored
{
    return [self initWithObject:object];
}

- (NSString *)jsonRepresentationWithObjectParameters:(NSObject*)format
{
    //Can mark exceptions with kEnumSerializeAsNumber
    if (format && [format isKindOfClass:[NSString class]])
    {
        if ([(NSString *)format isEqualToString:kEnumSerializeAsNumber])
        {
            return [NSString stringWithFormat:@"%li", (long)[self integerValue]];
        }
    }
    
    //Default is to always serialize to string.
    return [NSString stringWithFormat:@"\"%@\"", [self stringValue]];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    id enumCopy = [[self.class alloc] initWithString:self.string];
    return enumCopy;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:_integer forKey:kEnumNSCodingKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self initWithInteger:[aDecoder decodeIntegerForKey:kEnumNSCodingKey]];
    if (self)
    {
    }
    return self;
}

- (NSDictionary<NSString *, NSNumber *> *)enumMap
{
    return nil;
}

- (NSDictionary<NSString *, NSNumber *> *)aliasMap
{
    return nil;
}

+ (MHVEnum *)undefined
{
    return [[MHVEnum alloc] initWithString:kEnumUndefined];
}

+ (MHVEnum *)fromString:(NSString *)string
{
    [NSException raise:@"NoImplementationException" format:@"The child class must override %@.", NSStringFromSelector(_cmd)];
    return nil;
}

+ (MHVEnum *)fromInteger:(NSInteger)integer
{
    [NSException raise:@"NoImplementationException" format:@"The child class must override %@.", NSStringFromSelector(_cmd)];
    return nil;
}

- (NSString *)stringValue
{
    return _string;
}

- (NSInteger)integerValue
{
    return _integer;
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[self class]])
    {
        return NO;
    }
    
    return [self isEqualToEnum:object];
}

- (BOOL)isEqualToEnum:(MHVEnum *)object
{
    if (![object.stringValue isEqualToString:self.string])
    {
        return NO;
    }
    
    if (object.integerValue != self.integerValue)
    {
        return NO;
    }
    
    return YES;
}

- (NSUInteger)hash
{
    return self.string.hash ^ self.integer ^ [NSStringFromClass([self class]) hash];
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"%@: %li = %@", NSStringFromClass([self class]), (long)self.integerValue, self.stringValue];
}

@end

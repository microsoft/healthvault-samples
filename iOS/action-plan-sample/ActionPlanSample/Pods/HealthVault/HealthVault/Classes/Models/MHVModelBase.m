//
// MHVModelBase.m
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

#import "MHVModelBase.h"
#import <objc/runtime.h>
#import "MHVStringExtensions.h"
#import "MHVEnum.h"
#import "MHVJsonSerializer.h"
#import "NSDictionary+DataModel.h"
#import "NSArray+Utils.h"
#import "MHVValidator.h"

static NSString *kDataModelObjectParametersKey = @"DataModelObjectParametersKey";
static NSString *kDataModelNameMapKey = @"DataModelNameMapKey";
static NSString *kClassPrefix = @"MHV";

Class classFromProperty(objc_property_t property);

@implementation MHVModelBase

#pragma mark - DataModel v2

+ (NSDictionary *)objectParametersMap
{
    /*
     //NOTE: Subclasses should implement like this to add to parent dictionaries.
     //NOTE: Types won't change, so subclasses should treat objectParametersMap as singleton to save recalculating
     
     static dispatch_once_t once;
     static NSMutableDictionary *types = nil;
     dispatch_once(&once, ^{
     types = [[super objectParametersMap] mutableCopy];
     [types addEntriesFromDictionary:@{
     @"sequences" : [MHVBikeEventSequence class]
     }];
     });
     return types;
     */
    
    return @{};
}

+ (NSDictionary *)propertyNameMap
{
    //NOTE: Subclasses should be like above to add to parent dictionaries.
    return @{};
}

+ (BOOL)shouldValidateProperties
{
    return NO;
}

#pragma mark - Deserializing

- (instancetype)initWithJson:(NSString *)json
{
    return [MHVJsonSerializer deserialize:json toClass:[self class] shouldCache:YES];
}

- (instancetype)initWithObject:(id)object objectParameters:(NSObject *)ignored
{
    //id as parameter type rather than NSDictionary to support NSNull.
    if ([object isKindOfClass:[NSNull class]])
    {
        return nil;
    }
    
    //TODO: Could also add NSArray, to return an array of [self class] object types
    MHVASSERT_TRUE([object isKindOfClass:[NSDictionary class]], @"Expecting a NSDictionary");
    MHVASSERT_TRUE([[self class] conformsToProtocol:@protocol(MHVDataModelProtocol)], @"%@ must conform to MHVDataModelProtocol", NSStringFromClass([self class]));
    
    self = [super init];
    if (self)
    {
        [MHVModelBase setProperties:(id<MHVDataModelProtocol>)self fromDictionary:object];
    }
    return self;
}

+ (void)setProperties:(NSObject<MHVDataModelProtocol> *)object fromDictionary:(NSDictionary *)dictionary
{
    if (![dictionary isKindOfClass:[NSDictionary class]])
    {
        MHVASSERT_TRUE(NO, @"Deserialization error. Attempting to parse %@ into %@ object.", NSStringFromClass([dictionary class]), NSStringFromClass([object class]));
        
        return;
    }
    
#if DEBUG
    if ([[object class] shouldValidateProperties])
    {
        [object validatePropertiesForDictionary:dictionary];
    }
#endif
    
    //Need Mutable copy, so can save itemName to ItemName mappings & not recalculate each time (a big speed improvement)
    //Store as associated object so all the adjusting isn't visible externally
    NSMutableDictionary *propertyNamesCache = objc_getAssociatedObject([object class], (__bridge const void *)(kDataModelNameMapKey));
    NSMutableDictionary *propertyParametersCache = objc_getAssociatedObject([object class], (__bridge const void *)(kDataModelObjectParametersKey));
    
    //If not set, it's the first time an object of this class has been used, so have to call class methods to build the dictionaries
    if (!propertyNamesCache)
    {
        propertyNamesCache = [[[object class] propertyNameMap] mutableCopy];
        objc_setAssociatedObject([object class], (__bridge const void *)(kDataModelNameMapKey),
                                 propertyNamesCache, OBJC_ASSOCIATION_RETAIN);
        
        [object validatePropertyNameMap:propertyNamesCache];
    }
    if (!propertyParametersCache)
    {
        propertyParametersCache = [[[object class] objectParametersMap] mutableCopy];
        objc_setAssociatedObject([object class], (__bridge const void *)(kDataModelObjectParametersKey),
                                 propertyParametersCache, OBJC_ASSOCIATION_RETAIN);
    }
    
    Class currentClass = [object class];
    
    //Need to iterate up through superclasses
    while (currentClass && currentClass != [NSObject class])
    {
        unsigned count;
        objc_property_t *properties = class_copyPropertyList(currentClass, &count);
        for (int i = 0; i < count; i++)
        {
            //Can't assign to read only properties
            char *readOnly = property_copyAttributeValue(properties[i], "R");
            if(readOnly)
            {
                free(readOnly);
                continue;
            }
            free(readOnly);
            
            const char *cPropertyName = property_getName(properties[i]);
            NSString *propertyName = [NSString stringWithUTF8String:cPropertyName];
            NSString *propertyNameInDictionary = propertyName;
            
            @synchronized (propertyNamesCache)
            {
                if (propertyNamesCache[propertyName])
                {
                    propertyNameInDictionary = propertyNamesCache[propertyName];
                }
                else
                {
                    //Check if either case matches exactly, or try Uppercased
                    if (dictionary[propertyName])
                    {
                        propertyNameInDictionary = propertyName;
                        propertyNamesCache[propertyName] = propertyName;
                    }
                    else
                    {
                        //Check to map Json names to property names with different casing
                        //Old band cloud used "PropertyName", newer APIs can use "propertyName".
                        //Make sure key is found in the dictionary before adding to propertyNames cache
                        NSString *capitalizedPropertyName = [propertyName capitalizedStringForSelectors];
                        if (dictionary[capitalizedPropertyName])
                        {
                            propertyNameInDictionary = capitalizedPropertyName;
                            propertyNamesCache[propertyName] = capitalizedPropertyName;
                        }
                    }
                }
            }
            
            if (propertyName)
            {
                //Make sure there is a setter for this property
                NSString *propertySetter = objc_getAssociatedObject(currentClass, cPropertyName);
                if (!propertySetter)
                {
                    //To not have to recalculate each time, store as associatedObject, repeating this stringWithFormat was a slower point
                    propertySetter = [NSString stringWithFormat:@"set%@:", [propertyName capitalizedStringForSelectors]];
                    objc_setAssociatedObject(currentClass, cPropertyName,
                                             propertySetter, OBJC_ASSOCIATION_RETAIN);
                }
                
                if ([object respondsToSelector:NSSelectorFromString(propertySetter)])
                {
                    Class propertyClass = [MHVModelBase classFromProperty:properties[i]];
                    
                    if (dictionary[propertyNameInDictionary])
                    {
                        if (propertyClass)
                        {
                            id value = nil;

                            //objectParameters is array object type, or date formatter
                            id objectParameters = propertyParametersCache[propertyName];
                            
                            //Not actually using this for anything yet, but could be useful...
                            //Try to predict the array object type from the property name.  mapPoints -> MHVMapPoint
                            if (propertyClass == [NSArray class] && !objectParameters)
                            {
                                objectParameters = [MHVModelBase predictObjectClassFromPropertyName:propertyName];

                                @synchronized (propertyParametersCache)
                                {
                                    if (!objectParameters)
                                    {
                                        objectParameters = [NSString class];
                                    }

                                    propertyParametersCache[propertyName] = objectParameters;
                                }
                            }

                            //All property type classes must implement, objectParameters ignored except for arrays and dates
                            value = [[propertyClass alloc] initWithObject:dictionary[propertyNameInDictionary]
                                                         objectParameters:objectParameters];
                            if (value)
                            {
                                [object setValue:value forKey:propertyName];
                            }
                        }
                        else
                        {
                            // for base types (int, long, etc)
                            [object setValue:dictionary[propertyNameInDictionary] forKey:propertyName];
                        }
                    }
                    else if ([propertyClass isSubclassOfClass:[MHVEnum class]])
                    {
                        // Enums should have "Unknown" if not included in the JSON
                        id value = [[propertyClass alloc] initWithObject:@"Unknown"
                                                        objectParameters:nil];
                        if (value)
                        {
                            [object setValue:value forKey:propertyName];
                        }
                    }
                }
#if DEBUG
                else
                {
                    //See if non-NSNull value with a different case for property name
                    for (NSString *key in dictionary.allKeys)
                    {
                        if (![dictionary[key] isKindOfClass:[NSNull class]] &&
                            [key.lowercaseString isEqualToString:propertyNameInDictionary.lowercaseString])
                        {
                            MHVASSERT_TRUE(NO, @"Property to JSON Casing Mismatch?  %@ vs %@", key, propertyNameInDictionary);
                        }
                    }
                }
#endif
            }
        }
        
        free(properties);
        
        //Need to go up through superclasses to get all the properties
        currentClass = [currentClass superclass];
    }
}

+ (Class)predictObjectClassFromPropertyName:(NSString *)name
{
    //Predict the class from the name.  For NSArray *insightClassTypes;  guess KHRInsightClassTypes and KHRInsightClassType
    NSString *predicted = [NSString stringWithFormat:@"%@%@%@",
                           kClassPrefix,
                           [[name substringToIndex:1] uppercaseString],
                           [name substringFromIndex:1]];
    
    if (NSClassFromString(predicted))
    {
        return NSClassFromString(predicted);
    }
    
    //Remove "s" in case it's plural, to try KHRInsightClassType
    if ([name hasSuffix:@"s"])
    {
        NSString *singular = [name substringToIndex:name.length - 1];
        
        predicted = [NSString stringWithFormat:@"%@%@%@",
                     kClassPrefix,
                     [[singular substringToIndex:1] uppercaseString],
                     [singular substringFromIndex:1]];
        
        if (NSClassFromString(predicted))
        {
            return NSClassFromString(predicted);
        }
    }
    
    return nil;
}

- (void)mergeWithDataModel:(MHVModelBase*)dataModel
{
    MHVASSERT([self class] == [dataModel class]);
    
    Class currentClass = [self class];
    
    while (currentClass && currentClass != [NSObject class])
    {
        unsigned count;
        objc_property_t *properties = class_copyPropertyList(currentClass, &count);
        for (int i = 0; i < count; i++)
        {
            //Can't assign to read only properties
            char *readOnly = property_copyAttributeValue(properties[i], "R");
            if(readOnly)
            {
                free(readOnly);
                continue;
            }
            free(readOnly);
            
            const char *cPropertyName = property_getName(properties[i]);
            NSString *propertyName = [NSString stringWithUTF8String:cPropertyName];
            
            //Make sure there is a setter for this property
            NSString *propertySetter = objc_getAssociatedObject(currentClass, cPropertyName);
            if (!propertySetter)
            {
                //To not have to recalculate each time, store as associatedObject, repeating this stringWithFormat was a slower point
                propertySetter = [NSString stringWithFormat:@"set%@:", [propertyName capitalizedStringForSelectors]];
                objc_setAssociatedObject(currentClass, cPropertyName,
                                         propertySetter, OBJC_ASSOCIATION_RETAIN);
            }
            
            if ([self respondsToSelector:NSSelectorFromString(propertySetter)])
            {
                id object = [dataModel valueForKey:propertyName];
                id currentValue = [self valueForKey:propertyName];
                if (object)
                {
                    if (currentValue)
                    {
                        //Has a current value, need to combine items of the two objects for a number of types
                        if ([object isKindOfClass:[NSDictionary class]])
                        {
                            //Dictionary, merge them together
                            NSDictionary *objectDictionary = (NSDictionary *)object;
                            NSDictionary *currentDictionary = (NSDictionary *)currentValue;
                            
                            [self setValue:[currentDictionary dictionaryByAddingEntriesFromDictionary:objectDictionary]
                                    forKey:propertyName];
                        }
                        else if ([object isKindOfClass:[NSArray class]])
                        {
                            //Add new objects to the end of the current array
                            NSArray *objectArray = (NSArray *)object;
                            NSArray *currentArray = (NSArray *)currentValue;
                            
                            [self setValue:[currentArray arrayByAddingObjectsFromArray:objectArray]
                                    forKey:propertyName];
                        }
                        else if ([object isKindOfClass:[NSSet class]])
                        {
                            //Add new objects to the current set
                            NSSet *objectSet = (NSSet *)object;
                            NSSet *currentSet = (NSSet *)currentValue;
                            
                            [self setValue:[currentSet setByAddingObjectsFromSet:objectSet]
                                    forKey:propertyName];
                        }
                        else if ([object isKindOfClass:[MHVModelBase class]])
                        {
                            //Another data model, merge its properties
                            [currentValue mergeWithDataModel:object];
                        }
                        else
                        {
                            //No special cases, set to the new value
                            [self setValue:object forKey:propertyName];
                        }
                    }
                    else
                    {
                        //No current value and do have object, set to the new value
                        [self setValue:object forKey:propertyName];
                    }
                }
            }
        }
        
        free(properties);
        
        //Need to go up through superclasses to get all the properties
        currentClass = [currentClass superclass];
    }
}

+ (Class)classFromProperty:(objc_property_t)property
{
    //To not have to recalculate each time, store as associatedObject, a big speed improvement
    const char *attributes = property_getAttributes(property);
    Class propertyClass = objc_getAssociatedObject([self class], attributes);
    if (propertyClass)
    {
        return propertyClass;
    }
    
    NSString *typeString = [NSString stringWithUTF8String:attributes];
    if ([typeString hasPrefix:@"T@"] && typeString.length > 4)
    {
        typeString = [[typeString componentsSeparatedByString:@","] objectAtIndex:0];
        NSString *propertyType = [typeString substringWithRange:NSMakeRange(3, typeString.length-4)];
        propertyType = [[propertyType componentsSeparatedByString:@"<"] objectAtIndex:0];
        propertyClass = NSClassFromString(propertyType);
        
        objc_setAssociatedObject([self class], attributes,
                                 propertyClass, OBJC_ASSOCIATION_RETAIN);
        
        return propertyClass;
    }
    
    return nil;
}

#pragma mark - Serializing

- (NSString *)jsonRepresentation
{
    return [self jsonRepresentationWithObjectParameters:nil];
}

- (NSString *)jsonRepresentationWithObjectParameters:(NSObject *)ignored
{
    NSMutableDictionary *propertyNameMap = objc_getAssociatedObject([self class], (__bridge const void *)(kDataModelNameMapKey));
    NSMutableDictionary *propertyTypeMap = objc_getAssociatedObject([self class], (__bridge const void *)(kDataModelObjectParametersKey));
    
    if (!propertyNameMap) {
        propertyNameMap = [[[self class] propertyNameMap] mutableCopy];
        objc_setAssociatedObject([self class], (__bridge const void *)(kDataModelNameMapKey),
                                 propertyNameMap, OBJC_ASSOCIATION_RETAIN);
    }
    if (!propertyTypeMap)
    {
        propertyTypeMap = [[[self class] objectParametersMap] mutableCopy];
        objc_setAssociatedObject([self class], (__bridge const void *)(kDataModelObjectParametersKey),
                                 propertyTypeMap, OBJC_ASSOCIATION_RETAIN);
    }
    
    NSMutableString *json = [NSMutableString new];
    
    Class currentClass = [self class];
    
    while (currentClass && currentClass != [NSObject class])
    {
        unsigned count;
        objc_property_t *properties = class_copyPropertyList(currentClass, &count);
        for (int i = 0; i < count; i++)
        {
            //Can't assign to read only properties
            char *readOnly = property_copyAttributeValue(properties[i], "R");
            if(readOnly)
            {
                free(readOnly);
                continue;
            }
            free(readOnly);
            
            const char *cPropertyName = property_getName(properties[i]);
            NSString *propertyName = [NSString stringWithUTF8String:cPropertyName];
            NSString *propertyNameInDictionary;
            
            if (propertyNameMap[propertyName])
            {
                propertyNameInDictionary = propertyNameMap[propertyName];
            }
            else
            {
                //Need to still map Json names to property names for different casing
                //Convert propertyName to PropertyName & add to propertyNameMap dictionary
                propertyNameInDictionary = [NSString stringWithFormat:@"%@%@",
                                            [[propertyName substringToIndex:1] uppercaseString],
                                            [propertyName substringFromIndex:1]];
                @synchronized (propertyNameMap)
                {
                    propertyNameMap[propertyName] = propertyNameInDictionary;
                }
            }
            
            //Don't include if property name begins or ends with Private, or in "skip" list (such as array of UIImages for Feedback)
            if (propertyName &&
                ![propertyName hasPrefix:@"private"] &&
                ![propertyName hasSuffix:@"Private"] &&
                ![propertyName hasSuffix:@"NoSerialize"])
            {
                id value = [self valueForKey:propertyName];
                if (value)
                {
                    if ([value respondsToSelector:@selector(jsonRepresentationWithObjectParameters:)])
                    {
                        [json appendString:(json.length > 0 ? @", " : @"{ ")];
                        
                        [json appendFormat:@"\"%@\": %@", propertyNameInDictionary, [value jsonRepresentationWithObjectParameters:propertyTypeMap[propertyName]]];
                    }
                    else
                    {
                        MHVLogEvent([NSString stringWithFormat:@"Skipping serializing %@.%@", NSStringFromClass([self class]), propertyName]);
                    }
                }
            }
        }
        
        free(properties);
        
        //Need to go up through superclasses to get all the properties
        currentClass = [currentClass superclass];
    }
    
    [json appendString:(json.length > 0 ? @"}" : @"{}")];
    
    return json;
}

#pragma mark - NSCoding

+ (NSArray*)hadIncorrectPropertyMapping
{
    //Hacky, to not assert for properties that had the wrong type in the JSON serializer & got persisted wrong.
    //KHRGolfTee that was wrong for 6+ months, so need to silently migrate
    return @[];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        Class currentClass = [self class];
        while (currentClass && [currentClass conformsToProtocol:@protocol(NSCoding)])
        {
            unsigned count;
            objc_property_t *properties = class_copyPropertyList(currentClass, &count);
            for (int i = 0; i < count; i++)
            {
                // can't assign to read only properties
                char *readOnly = property_copyAttributeValue(properties[i], "R");
                if(readOnly)
                {
                    free(readOnly);
                    continue;
                }
                free(readOnly);
                
                const char *cPropertyName = property_getName(properties[i]);
                NSString *propertyName = [NSString stringWithUTF8String:cPropertyName];
                
                if (propertyName)
                {
                    //Make sure there is a setter for this property
                    NSString *propertySetter = objc_getAssociatedObject(currentClass, cPropertyName);
                    if (!propertySetter)
                    {
                        //To not have to recalculate each time, store as associatedObject, repeating this stringWithFormat was a slower point
                        propertySetter = [NSString stringWithFormat:@"set%@%@:",
                                          [[propertyName substringToIndex:1] uppercaseString],
                                          [propertyName substringFromIndex:1]];
                        objc_setAssociatedObject(currentClass, cPropertyName,
                                                 propertySetter, OBJC_ASSOCIATION_RETAIN);
                    }
                    
                    if ([self respondsToSelector:NSSelectorFromString(propertySetter)])
                    {
                        id value = [aDecoder decodeObjectForKey:propertyName];
                        Class propertyClass = classFromProperty(properties[i]);
                        if ([propertyClass isSubclassOfClass:[MHVEnum class]] && ![[value class] isSubclassOfClass:[MHVEnum class]])
                        {
                            if ([value isKindOfClass:[NSNumber class]]) {
                                value = [[propertyClass alloc] initWithInteger:((NSNumber*)value).integerValue];
                            }
                            else if ([value isKindOfClass:[NSString class]])
                            {
                                value = [[propertyClass alloc] initWithString:value];
                            }
                            else
                            {
                                // We want to handle any unwanted value for MHVDynamicEnum which should either string or number in order to avoid crashes.
                                value = nil;
                            }
                        }
                        
                        if ([[currentClass hadIncorrectPropertyMapping] containsObject:propertyName])
                        {
                            //Hacky, to not assert for properties that had the wrong type in the JSON serializer & got persisted wrong.
                            //GolfTee that was wrong for 6+ months, so need to silently migrate
                        }
                        else if ([propertyClass isSubclassOfClass:[NSNumber class]] && [value isKindOfClass:[NSString class]])
                        {
                            //Convert string value to number to avoid asserts on that type of mismatch
                            [self setValue:@([value doubleValue]) forKey:propertyName];
                        }
                        else
                        {
                            MHVASSERT_TRUE(!value || propertyClass == [NSDate class] || [value isKindOfClass:propertyClass],
                                      @"Incorrect property type in %@.%@ - %@ vs %@",
                                      NSStringFromClass([self class]), propertyName, NSStringFromClass(propertyClass), NSStringFromClass([value class]));
                        }
                        [self setValue:value forKey:propertyName];
                    }
                    else
                    {
                        //Assert so can find in debug builds, but be sure to not fail in releases
#if DEBUG
                        MHVASSERT_TRUE(NO, @"Couldn't restore value for %@.%@", NSStringFromClass([self class]), propertyName);
#else
                        NSString *message = [NSString stringWithFormat:@"Couldn't restore value for %@.%@", NSStringFromClass([self class]), propertyName];
                        MHVASSERT_MESSAGE(message);
#endif
                    }
                }
            }
            
            free(properties);
            currentClass = [currentClass superclass];
        }
    }
    
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    Class currentClass = [self class];
    while (currentClass && [currentClass conformsToProtocol:@protocol(NSCoding)])
    {
        unsigned count;
        objc_property_t *properties = class_copyPropertyList(currentClass, &count);
        
        for (int i = 0; i < count; i++)
        {
            // don't encode readonly properties because we can't assign them on a new instance anyways
            char *readOnly = property_copyAttributeValue(properties[i], "R");
            if(readOnly)
            {
                free(readOnly);
                continue;
            }
            
            free(readOnly);
            NSString *propertyName = [NSString stringWithUTF8String:property_getName(properties[i])];
            char *type = property_copyAttributeValue(properties[i], "T");
            if(type && type[0] == '@')
            {
                id objectToEncode = [self valueForKey:propertyName];
                if([objectToEncode conformsToProtocol:@protocol(NSCoding)])
                {
                    [aCoder encodeObject:objectToEncode forKey:propertyName];
                }
            }
            free(type);
        }
        
        free(properties);
        currentClass = [currentClass superclass];
    }
}


#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    id theCopy = [[[self class] allocWithZone:zone] init];
    
    //Loop up through all the superclasses, copying all their properties
    Class currentClass = [self class];
    
    //Stop when it gets to NSObject or another class that doesn't do NSCopying; trying to copy its properties didn't work.
    while (currentClass && [currentClass conformsToProtocol:@protocol(NSCopying)])
    {
        unsigned count;
        objc_property_t *properties = class_copyPropertyList(currentClass, &count);
        for (int i = 0; i < count; i++)
        {
            const char *cPropertyName = property_getName(properties[i]);
            NSString *propertyName = [NSString stringWithUTF8String:cPropertyName];
            NSString *propertySetter = objc_getAssociatedObject(currentClass, cPropertyName);
            if (!propertySetter)
            {
                //To not have to recalculate each time, store as associatedObject, repeating this stringWithFormat was a slower point
                propertySetter = [NSString stringWithFormat:@"set%@%@:",
                                  [[propertyName substringToIndex:1] uppercaseString],
                                  [propertyName substringFromIndex:1]];
                objc_setAssociatedObject(currentClass, cPropertyName,
                                         propertySetter, OBJC_ASSOCIATION_RETAIN);
            }
            
            id value = [self valueForKey:propertyName];
            
            //Crashed on readonly property (eventNameForGeneralDisplay for me), make sure there's a setter
            //Might be missing some values, but better than crashing
            if (value && [theCopy respondsToSelector:NSSelectorFromString(propertySetter)])
            {
                if ([value isKindOfClass:[NSArray class]])
                {
                    //Array, copy items into new array
                    NSMutableArray *arrayCopy = [NSMutableArray new];
                    for (id item in (NSArray*)value)
                    {
                        if ([[item class] conformsToProtocol:@protocol(NSCopying)])
                        {
                            [arrayCopy addObject:[item copy]];
                        }
                        else
                        {
                            [arrayCopy addObject:item];
                        }
                    }
                    [theCopy setValue:arrayCopy forKey:propertyName];
                }
                else if ([[value class] conformsToProtocol:@protocol(NSCopying)])
                {
                    [theCopy setValue:[value copy] forKey:propertyName];
                }
                else
                {
                    [theCopy setValue:value forKey:propertyName];
                }
            }
        }
        
        free(properties);
        
        currentClass = [currentClass superclass];
    }
    
    return theCopy;
}

- (BOOL)isEqual:(MHVModelBase *)object
{
    if (self == object)
    {
        return YES;
    }
    
    //Check all property values to see if they are equal
    //Different object types, not equal
    if ([self class] != [object class])
    {
        return NO;
    }
    
    //Loop up through all the superclasses, checking all their properties
    Class currentClass = [self class];
    
    while (currentClass && [currentClass conformsToProtocol:@protocol(NSCoding)])
    {
        unsigned count;
        objc_property_t *properties = class_copyPropertyList(currentClass, &count);
        
        for (int i = 0; i < count; i++)
        {
            NSString *propertyName = [NSString stringWithUTF8String:property_getName(properties[i])];
            
            char *type = property_copyAttributeValue(properties[i], "T");
            NSString *typeString = [NSString stringWithUTF8String:type];
            free(type);

            NSString *propertySetter = [NSString stringWithFormat:@"set%@%@:",
                                        [[propertyName substringToIndex:1] uppercaseString],
                                        [propertyName substringFromIndex:1]];

            //Only check properties with a setter
            if ([self respondsToSelector:NSSelectorFromString(propertySetter)] &&
                typeString.length > 0 && [typeString characterAtIndex:0] == '@')
            {
                id selfValue = [self valueForKey:propertyName];
                id objectValue = [object valueForKey:propertyName];

                BOOL areEqualValues = YES;

                if (selfValue == objectValue)
                {
                    //Same, or both nil, they're equal
                    areEqualValues = YES;
                }
                else if ((!selfValue && objectValue) || (selfValue && !objectValue))
                {
                    //Only one property set, not equal
                    areEqualValues = NO;
                }
                else if (selfValue && objectValue)
                {
                    //Use compare if available since works better for strings and dates
                    if ([selfValue respondsToSelector:@selector(compare:)])
                    {
                        areEqualValues = ([selfValue compare:objectValue] == NSOrderedSame);
                    }
                    else if ([selfValue respondsToSelector:@selector(isEqual:)])
                    {
                        areEqualValues = [selfValue isEqual:objectValue];
                    }
                    else
                    {
                        MHVASSERT_TRUE(NO, @"Values don't conform to isEqual: or compare: methods");
                        areEqualValues = NO;
                    }
                }

                if (!areEqualValues)
                {
                    MHVLogEvent([NSString stringWithFormat:@"%@ not equal for property %@ (%@ vs %@)",
                                 NSStringFromClass([self class]),
                                 propertyName,
                                 selfValue,
                                 objectValue]);
                    free(properties);
                    return NO;
                }
            }
        }
        free(properties);
        
        currentClass = [currentClass superclass];
    }
    
    return YES;
}

#pragma mark - Validating

- (void)validatePropertiesForDictionary:(NSDictionary *)dictionary
{
    //For performance, only do validating in debug builds
#if DEBUG
    NSMutableDictionary *validateDictionary = [dictionary mutableCopy];
    
    //Remove properties this class supports
    NSArray *properties = [self settableProperties];
    [validateDictionary removeObjectsForKeys:properties];
    
    //Remove automatically case converted properties ("name" in properties to "Name" from cloud)
    properties = [properties convertAll:^NSString *(NSString *string)
                  {
                      return [string capitalizedStringForSelectors];
                  }];
    [validateDictionary removeObjectsForKeys:properties];
    
    //Remove special name mappings ("id" from cloud to "identifier" in properties)
    NSDictionary *nameMap = [[self class] propertyNameMap];
    [validateDictionary removeObjectsForKeys:nameMap.allValues];
    
    //See if there are any leftover items in the dictionary
    if (validateDictionary.allKeys.count > 0)
    {
        NSMutableString *missing = [NSMutableString new];
        for (NSString *key in validateDictionary.allKeys)
        {
            [missing appendFormat:(missing.length == 0 ? @" %@" : @", %@"), key];
        }
        
        MHVASSERT_TRUE(NO, @"Missing properties for %@: %@", NSStringFromClass([self class]), missing);
    }
#endif
}

- (void)validatePropertyNameMap:(NSDictionary<NSString *, NSString *> *)nameMap
{
#if DEBUG
    if (!nameMap)
    {
        return;
    }
    
    //Make sure keys and values are NSStrings
    for (id key in nameMap.allKeys)
    {
        MHVASSERT_TRUE([key isKindOfClass:[NSString class]], @"Keys should all be NSStrings, %@ - propertyNameMap", NSStringFromClass([self class]));
        MHVASSERT_TRUE([nameMap[key] isKindOfClass:[NSString class]], @"Values should all be NSStrings, %@ - propertyNameMap", NSStringFromClass([self class]));
    }
#endif
}

#pragma mark - Helpers

- (NSString *)debugDescription
{
    NSMutableString *result = [[NSMutableString alloc] initWithFormat:@"%@\n", NSStringFromClass([self class])];
    
    for (NSString *property in [self settableProperties])
    {
        [result appendFormat:@"%@ = %@\n", property, [self valueForKey:property]];
    }
    return result;
}

- (NSArray<NSString *> *)settableProperties
{
    NSMutableArray *result = [NSMutableArray new];
    
    //Loop up through all the superclasses, checking all their properties
    Class currentClass = [self class];
    
    while (currentClass && [currentClass conformsToProtocol:@protocol(NSCoding)])
    {
        unsigned count;
        objc_property_t *properties = class_copyPropertyList(currentClass, &count);
        
        for (int i = 0; i < count; i++)
        {
            NSString *propertyName = [NSString stringWithUTF8String:property_getName(properties[i])];
            
            char *type = property_copyAttributeValue(properties[i], "T");
            NSString *typeString = [NSString stringWithUTF8String:type];
            free(type);
            
            NSString *propertySetter = [NSString stringWithFormat:@"set%@%@:",
                                        [[propertyName substringToIndex:1] uppercaseString],
                                        [propertyName substringFromIndex:1]];
            
            //Only properties with a setter
            if ([self respondsToSelector:NSSelectorFromString(propertySetter)] &&
                typeString.length > 0 && [typeString characterAtIndex:0] == '@')
            {
                [result addObject:propertyName];
            }
        }
        free(properties);
        
        currentClass = [currentClass superclass];
    }
    
    return result;
}

Class classFromProperty(objc_property_t property)
{
    const char *type = property_getAttributes(property);
    
    //Cached since a property string will always parse to the same class
    Class propertyClass = objc_getAssociatedObject([MHVModelBase class], type);
    if (propertyClass)
    {
        return propertyClass;
    }
    
    NSString *typeString = [NSString stringWithUTF8String:type];
    if ([typeString hasPrefix:@"T@"] && typeString.length > 4)
    {
        typeString = [[typeString componentsSeparatedByString:@","] objectAtIndex:0];
        NSString *propertyType = [typeString substringWithRange:NSMakeRange(3, typeString.length-4)];
        
        propertyClass = NSClassFromString(propertyType);
        
        objc_setAssociatedObject([MHVModelBase class], type,
                                 propertyClass, OBJC_ASSOCIATION_RETAIN);
        
        return propertyClass;
    }
    
    return nil;
}


@end

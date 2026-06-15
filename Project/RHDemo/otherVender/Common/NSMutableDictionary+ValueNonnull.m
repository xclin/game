//
//  NSMutableDictionary+ValueNonnull.m
//  Translate
//
//  Created by Hunz on 2020/7/24.
//  Copyright © 2020 wuwh. All rights reserved.
//

#import "NSMutableDictionary+ValueNonnull.h"

@implementation NSMutableDictionary (ValueNonnull)

- (void)setSafeValue:(id)value forKey:(NSString *)key {
    if (value == nil) {
        value = @"";
    }
    [self setValue:value forKey:key];
}

- (id)jsonObjectForKey:(NSString *)aKey {
    id obj = [self objectForKey:aKey];
    if ([obj isKindOfClass:[NSNull class]]) {
        return nil;
    } else {
        return obj;
    }
}

- (NSNumber *)jsonNumberForKey:(NSString *)aKey {
    id obj = [self jsonObjectForKey:aKey];
    if (obj == nil || ![obj isKindOfClass:[NSNumber class]] ) {
        return @(0);
    }
    return obj;
}

- (NSString *)jsonNSStringForKey:(NSString *)aKey {
    id obj = [self jsonObjectForKey:aKey];
    if (obj == nil || ![obj isKindOfClass:[NSString class]] ) {
        return @"";
    }
    return obj;
}

- (NSArray *)jsonArrayForKey:(NSString *)aKey {
    id obj = [self jsonObjectForKey:aKey];
    if (obj == nil || ![obj isKindOfClass:[NSArray class]] ) {
        return @[];
    }
    return obj;
}

- (NSDictionary *)jsonDictionaryForKey:(NSString *)aKey {
    id obj = [self jsonObjectForKey:aKey];
    if (obj == nil || ![obj isKindOfClass:[NSDictionary class]] ) {
        return @{};
    }
    return obj;
}


@end

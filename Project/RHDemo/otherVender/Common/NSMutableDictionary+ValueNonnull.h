//
//  NSMutableDictionary+ValueNonnull.h
//  Translate
//
//  Created by Hunz on 2020/7/24.
//  Copyright © 2020 wuwh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary (ValueNonnull)

- (void)setSafeValue:(nullable id)value forKey:(NSString *)key;

- (NSNumber *)jsonNumberForKey:(NSString *)aKey;
- (NSString *)jsonNSStringForKey:(NSString *)aKey;
- (NSArray *)jsonArrayForKey:(NSString *)aKey;
- (NSDictionary *)jsonDictionaryForKey:(NSString *)aKey;

@end

NS_ASSUME_NONNULL_END

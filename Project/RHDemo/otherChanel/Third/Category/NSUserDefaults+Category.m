//
//  NSUserDefaults+Category.m
//  FrameWork
//
//  Created by lonnie on 2017/5/3.
//  Copyright © 2017年 fanyue. All rights reserved.
//

#import "NSUserDefaults+Category.h"

@implementation NSUserDefaults (Category)
/**
 *  保存
 *
 *  @param object 保存对象
 *  @param field  key
 */
+ (void) reserveNSUserDefault:(id)object field:(NSString *)field {
    NSDictionary * dic = (NSDictionary *)object;
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:field];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/**
 *  取出
 *
 *  @param field key
 *
 *  @return 取出的对象
 */
+ (id) takeoutNSUserDefault:(NSString *)field {
    return [[NSUserDefaults standardUserDefaults] objectForKey:field];
}
/**
 *  移除
 *
 *  @param field key
 */
+ (void) removeNSUserDefault:(NSString *)field {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:field];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
@end

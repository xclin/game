//
//  NSUserDefaults+Category.h
//  FrameWork
//
//  Created by lonnie on 2017/5/3.
//  Copyright © 2017年 fanyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Category)
#pragma mark - 保存和取出UserDefault
/**
 *  保存
 *
 *  @param object 存进去的对象
 *  @param field  key
 */
+(void)reserveNSUserDefault:(id)object field:(NSString*)field;
/**
 *  取出
 *
 *  @param field key
 *
 *  @return 取出的对象
 */
+(id)takeoutNSUserDefault:(NSString*)field;
/**
 *  移除
 *
 *  @param field key
 *
 */
+(void)removeNSUserDefault:(NSString*)field;
@end

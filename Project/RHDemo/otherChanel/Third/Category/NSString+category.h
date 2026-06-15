//
//  NSString+category.h
//  Framework_0903
//
//  Created by fanyue on 16/9/5.
//  Copyright © 2016年 fanyue. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSString (category)
- (NSString*)valueAt:(NSString*)msg;
#pragma mark -


/// 纯字母
- (BOOL) isAllLetter;


/// 纯数字
- (BOOL) isAllNumber;

/// 纯特殊字符
-(BOOL)isAllCharacter;
/**
 *  判断是否为空
 *  @return 是否
 */
- (BOOL)isValidString;
/**
 *  手机号码验证
 *  @return 是否
 */
- (BOOL)isValidMobile;
/**
 *  邮箱验证
 *  @return 是否
 */
- (BOOL)isValidEmail;

/**
 身份证验证

 @return 是否
 */
- (BOOL) isValidChineseIDNumber;
/**
 *  正则判断
 *
 *  @param regex  正则
 *
 *  @return 是否成功
 */
- (BOOL) isRegularWithRegex:(NSString *)regex;
#pragma mark --- 获取随机密码
/**
 *  随机获取密码
 *
 *  @param num 密码长度
 *
 *  @return 密码
 */

+ (NSString *)getRandomPassword:(int)num;
+ (NSString *)getRandomidfv:(int)num;
@end

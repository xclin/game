//
//  NSString+category.m
//  Framework_0903
//
//  Created by fanyue on 16/9/5.
//  Copyright © 2016年 fanyue. All rights reserved.
//

#import "NSString+category.h"
#import <UIKit/UIKit.h>
@implementation NSString (category)
- (NSString*)valueAt:(NSString*)msg {
    NSString * string = [NSString stringWithFormat:@"参数异常,%@",msg];
    NSAssert(self != nil && self.length > 0, string);
    return self;
}

//纯字母
- (BOOL) isAllLetter{

     NSString *regex =@"[A-Za-z]+";

    NSPredicate*predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];

    BOOL returnRes = [predicate evaluateWithObject:self];
    return returnRes; 
}


//纯数字
- (BOOL) isAllNumber{
    if (self.length == 0) {
        return NO;
    }
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}

//纯特殊字符
-(BOOL)isAllCharacter{
    NSString *regex = @"[~`!@#$%^&*()_+-=[]|{};':\",./<>?]{,}/";//规定的特殊字符，可以自己随意添加
    //计算字符串长度
    NSInteger str_length = [self length];
    NSInteger allIndex = 0;
    for (int i = 0; i<str_length; i++) {
        //取出i
        NSString *subStr = [self substringWithRange:NSMakeRange(i, 1)];
        if([regex rangeOfString:subStr].location != NSNotFound){  //存在
            allIndex++;
        }
    }
    if (str_length == allIndex) {
        //纯特殊字符
        return YES;
    } else{
        //非纯特殊字符
        return NO;
    }
}


#pragma mark - 格式判断
/**
 *  判断是否为空
 *  @return 是否
 */
- (BOOL)isValidString{
    return self.length != 0;
}
/**
 *  手机号码验证
 *  @return 是否
 */
- (BOOL)isValidMobile {
    //手机号以13，15，18开头，八个\d数字字符
    NSString * phoneRegex = @"^1[0|1|2|3|4|5|6|7|8|9][0-9]\\d{8}$";
    return [self isRegularWithRegex:phoneRegex];
}
/**
 *  邮箱验证
 *  @return 是否
 */
- (BOOL)isValidEmail {
    NSString * emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self isRegularWithRegex:emailRegex];
}
/**
 *  正则判断
 *
 *  @param regex  正则
 *
 *  @return 是否成功
 */
- (BOOL) isRegularWithRegex:(NSString *)regex {
    NSPredicate * regularPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [regularPred evaluateWithObject:self];
}

- (BOOL) isValidChineseIDNumber {
    if (self.length <= 0)
    {
        return NO;
    }
    NSString *regex2 = @"^(\\d{15}$|^\\d{18}$|^\\d{17}(\\d|X|x))$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:self];
}

#pragma mark --- 获取随机密码
/**
 *  随机获取密码
 *
 *  @param num 密码长度
 *
 *  @return 密码
 */
+ (NSString *)getRandomPassword:(int)num {
    NSArray * array = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",
                        @"8",@"9"];
    long int pwdLength = [array count];
    int count = 0;
    NSMutableString * pwdString = [[NSMutableString alloc]init];
    while (count < pwdLength && count <num) {
        int value = (arc4random() % pwdLength) + 0;
        if (value < pwdLength) {
            [pwdString appendString:array[value]];
            count++;
        }
    }
    return (NSString *)pwdString;
}
+ (NSString *)getRandomidfv:(int)num {
    NSArray * array = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",
                        @"8",@"9"];
    long int pwdLength = [array count];
    int count = 0;
    NSMutableString * pwdString = [[NSMutableString alloc]init];
    while (count <num) {
        int value = (arc4random() % pwdLength) + 0;
        if (value < pwdLength) {
            [pwdString appendString:array[value]];
            count++;
        }
    }
    return (NSString *)pwdString;
}
@end

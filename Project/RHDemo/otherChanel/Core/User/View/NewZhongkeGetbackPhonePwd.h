//
//  NewZhongkeGetbackPhonePwd.h
//  FYAppStoreDemo
//
//  Created by xiaocong lin on 2021/1/23.
//  Copyright © 2021 fanyue. All rights reserved.
//

#import "ZhongkeView.h"

@interface NewZhongkeGetbackPhonePwd : ZhongkeView
@property (nonatomic,copy) void (^getPhoneCodeCallBlock)(NSString * phone); //获取验证码block
@property (nonatomic,copy) void (^ resetPwdCallBlock) (NSString * phoneCode,NSString * pwd);
@end

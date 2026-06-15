//
//  VerifyIDCardView.h
//  FYAppStoreDemo
//
//  Created by 凡跃 on 2018/6/4.
//  Copyright © 2018年 fanyue. All rights reserved.
//

#import "BaseView.h"

@interface VerifyIDCardView : BaseView

@property (nonatomic, copy) void(^verifyBlock)(NSString *realName, NSString *idcard, NSString *token); //用户注册账号

@end

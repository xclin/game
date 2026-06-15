//
//  NewZhongkeLoginMainView.h
//  GameSDK
//
//  Created by xiaocong lin on 2021/1/19.
//  Copyright © 2021 lonnie. All rights reserved.
//

//手机验证码登录
#import <UIKit/UIKit.h>
#import "ZhongkeView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NewZhongkePhoneLoginView : ZhongkeView

@property (nonatomic,strong) UIView *verticalView;
@property (nonatomic,strong) UILabel *phoneLocalLbl;
@property (nonatomic,strong) BaseButton *pwdLoginBtn;
@property (nonatomic,strong) BaseButton *registerBtn;
@property (nonatomic,strong) BaseButton *agreedBtnKey;
@property (nonatomic, copy) void(^getPhoneCodeCallBlock)(NSString *phone); //获取验证码block
@property (nonatomic,copy)  void (^PhoneLoginCallBlock)( NSString * _Nullable phone,NSString * _Nullable phoneCode);
@property (nonatomic,copy)  void (^goPwdLoginCallBack)();//密码登录
@property (nonatomic,copy) void (^goRegisterCallBack)();//注册账号

@end

NS_ASSUME_NONNULL_END

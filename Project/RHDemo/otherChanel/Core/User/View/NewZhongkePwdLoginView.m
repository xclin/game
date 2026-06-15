//
//  NewZhongkePwdLoginView.m
//  FYAppStoreDemo
//
//  Created by xiaocong lin on 2021/1/22.
//  Copyright © 2021 fanyue. All rights reserved.
//

#import "NewZhongkePwdLoginView.h"

@implementation NewZhongkePwdLoginView

- (void)setupUI{
    self.titleLbl.hidden = YES;
    [self addSubview:self.pwdLoginBtn];
//    [self addSubview:self.agreedBtn];
    [self addSubview:self.getPwdtipsLbl];
    self.LogingTypeLbl.hidden = NO;
    self.backBtn.hidden = NO;
    [self.loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
    self.LogingTypeLbl.text = @"密码登录";
    [self.backForCodeView addSubview:self.eyesBtn];
    [self.backForPhoneView addSubview:self.downBtn];
    
//    NSString *str =@"我已阅读并同意用户协议 和 隐私政策";
//
//    //文本点击回调
//    __weak typeof(self)weakSelf = self;
//    self.hahalabel.tapBlock = ^(NSString *string) {
//        NSLog(@" -- %@ --",string);
//        if (weakSelf.userProCallBlock) {
//            weakSelf.userProCallBlock(string);
//        }
//
//    };
//
//    //设置需要点击的字符串，并配置此字符串的样式及位置
//    IXAttributeModel    * model = [IXAttributeModel new];
//    model.range = [str rangeOfString:@"用户协议"];
//    model.string = @"用户协议";
//    model.attributeDic = @{NSForegroundColorAttributeName : rgba(252, 197, 105, 1)};
//
//    IXAttributeModel    * model1 = [IXAttributeModel new];
//    model1.range = [str rangeOfString:@"隐私政策"];
//    model1.string = @"隐私政策";
//    model1.attributeDic = @{NSForegroundColorAttributeName : rgba(252, 197, 105, 1)};
//
//    //label内容赋值
//    [self.hahalabel setText:str attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:font(13)}
//             tapStringArray:@[model,model1]];
    
    [self updateFrame];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRotateNewZhongkePhoneLoginView:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
    
    

    
    
    
}


- (void)updateFrame{
    
    UIInterfaceOrientation sataus=[UIApplication sharedApplication].statusBarOrientation;
    if (sataus == UIInterfaceOrientationPortrait || sataus == UIInterfaceOrientationPortraitUpsideDown) {//竖屏
        
        self.titleLbl.frame =CGRectMake(0, SCREEN_FIT(80),ZKUserViewWidth, SCREEN_FIT(25));
        self.backBtn.frame = CGRectMake(SCREEN_FIT(10), SCREEN_FIT(45), SCREEN_FIT(30), SCREEN_FIT(30));
        
        self.LogingTypeLbl.frame = CGRectMake(SCREEN_FIT(60), SCREEN_FIT(45), ZKUserViewWidth-SCREEN_FIT(120), SCREEN_FIT(30));
        
        self.backForPhoneView.frame = CGRectMake(SCREEN_FIT(30), CGRectGetMaxY(self.LogingTypeLbl.frame)+SCREEN_FIT(60), ZKUserViewWidth-SCREEN_FIT(60), SCREEN_FIT(50));
        
        self.phoneTxtF.frame = CGRectMake(SCREEN_FIT(10), SCREEN_FIT(5), CGRectGetWidth(self.backForPhoneView.frame)-SCREEN_FIT(50), SCREEN_FIT(40));
        
        self.downBtn.frame= CGRectMake(CGRectGetMaxX(self.phoneTxtF.frame)+SCREEN_FIT(5), SCREEN_FIT(20),SCREEN_FIT(20), SCREEN_FIT(10));
        
        
        self.backForCodeView.frame = CGRectMake(CGRectGetMinX(self.backForPhoneView.frame), CGRectGetMaxY(self.backForPhoneView.frame)+SCREEN_FIT(20), CGRectGetWidth(self.backForPhoneView.frame),SCREEN_FIT(50));
        
        self.phoneCodeTxtF.frame = CGRectMake(CGRectGetMinX(self.phoneTxtF.frame), SCREEN_FIT(5), CGRectGetWidth(self.phoneTxtF.frame), SCREEN_FIT(40));
        
        self.eyesBtn.frame= CGRectMake(CGRectGetMaxX(self.phoneCodeTxtF.frame)+SCREEN_FIT(5), SCREEN_FIT(20),SCREEN_FIT(20), SCREEN_FIT(10));
        
        
        self.agreedBtn.frame =CGRectMake(CGRectGetMinX(self.backForCodeView.frame),CGRectGetMaxY(self.backForCodeView.frame)+SCREEN_FIT(10),SCREEN_FIT(20), SCREEN_FIT(20));
        
        self.hahalabel.frame = CGRectMake(CGRectGetMaxX(self.agreedBtn.frame)+SCREEN_FIT(5), CGRectGetMaxY(self.backForCodeView.frame)+SCREEN_FIT(10), ZKUserViewWidth-SCREEN_FIT(40), SCREEN_FIT(20));
        
        self.loginBtn.frame = CGRectMake(CGRectGetMinX(self.backForPhoneView.frame),(windowHeight-SCREEN_FIT(50))/2, CGRectGetWidth(self.backForCodeView.frame),SCREEN_FIT(50));
        
         self.pwdLoginBtn.frame = CGRectMake(ZKUserViewWidth-SCREEN_FIT(30)-SCREEN_FIT(70), CGRectGetMaxY(self.loginBtn.frame)+SCREEN_FIT(10), SCREEN_FIT(70),SCREEN_FIT(30));
              
              self.getPwdtipsLbl.frame=CGRectMake(CGRectGetMinX(self.pwdLoginBtn.frame)-SCREEN_FIT(70), CGRectGetMaxY(self.loginBtn.frame)+SCREEN_FIT(10), SCREEN_FIT(70),SCREEN_FIT(30));
    
        
    }else{//横版  未知
        self.titleLbl.frame =CGRectMake(0, SCREEN_FIT(45),ZKUserViewWidth, SCREEN_FIT(25));
        self.backBtn.frame = CGRectMake(SCREEN_FIT(10), SCREEN_FIT(30), SCREEN_FIT(30), SCREEN_FIT(30));
        
        self.LogingTypeLbl.frame = CGRectMake(SCREEN_FIT(60), SCREEN_FIT(30), ZKUserViewWidth-SCREEN_FIT(120), SCREEN_FIT(30));
        
        self.backForPhoneView.frame = CGRectMake(SCREEN_FIT(30), CGRectGetMaxY(self.LogingTypeLbl.frame)+SCREEN_FIT(30), ZKUserViewWidth-SCREEN_FIT(60), SCREEN_FIT(45));
        
        self.phoneTxtF.frame = CGRectMake(SCREEN_FIT(2.5), SCREEN_FIT(0), CGRectGetWidth(self.backForPhoneView.frame)-SCREEN_FIT(50), SCREEN_FIT(45));
        
        self.downBtn.frame= CGRectMake(CGRectGetMaxX(self.phoneTxtF.frame)+SCREEN_FIT(5), SCREEN_FIT(20),SCREEN_FIT(20), SCREEN_FIT(10));
        
        
        self.backForCodeView.frame = CGRectMake(CGRectGetMinX(self.backForPhoneView.frame), CGRectGetMaxY(self.backForPhoneView.frame)+SCREEN_FIT(15), CGRectGetWidth(self.backForPhoneView.frame),SCREEN_FIT(45));
        
        self.phoneCodeTxtF.frame = CGRectMake(CGRectGetMinX(self.phoneTxtF.frame), SCREEN_FIT(0), CGRectGetWidth(self.phoneTxtF.frame), SCREEN_FIT(45));
        
        self.eyesBtn.frame= CGRectMake(CGRectGetMaxX(self.phoneCodeTxtF.frame)+SCREEN_FIT(5), SCREEN_FIT(20),SCREEN_FIT(20), SCREEN_FIT(10));
        
        
        self.agreedBtn.frame =CGRectMake(CGRectGetMinX(self.backForCodeView.frame),CGRectGetMaxY(self.backForCodeView.frame)+SCREEN_FIT(10),SCREEN_FIT(20), SCREEN_FIT(20));
        
        self.hahalabel.frame = CGRectMake(CGRectGetMaxX(self.agreedBtn.frame)+SCREEN_FIT(5), CGRectGetMaxY(self.backForCodeView.frame)+SCREEN_FIT(10), ZKUserViewWidth-SCREEN_FIT(40), SCREEN_FIT(20));
        
        self.loginBtn.frame = CGRectMake(CGRectGetMinX(self.backForPhoneView.frame),CGRectGetMaxY(self.agreedBtn.frame)+SCREEN_FIT(15), CGRectGetWidth(self.backForCodeView.frame),SCREEN_FIT(45));
        
         self.pwdLoginBtn.frame = CGRectMake(ZKUserViewWidth-SCREEN_FIT(30)-SCREEN_FIT(70), CGRectGetMaxY(self.loginBtn.frame)+SCREEN_FIT(10), SCREEN_FIT(70),SCREEN_FIT(30));
        
        self.getPwdtipsLbl.frame=CGRectMake(CGRectGetMinX(self.pwdLoginBtn.frame)-SCREEN_FIT(70), CGRectGetMaxY(self.loginBtn.frame)+SCREEN_FIT(10), SCREEN_FIT(70),SCREEN_FIT(30));
        
        
        
    }
    
}



- (BaseButton *)eyesBtn{
    if (!_eyesBtn) {
        _eyesBtn = [BaseButton new];
        [_eyesBtn addTarget:self action:@selector(eyeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_eyesBtn setBackgroundImage:[UIImage imageNamed:@"FYSDK_Resourcres.bundle/closeesey"] forState:UIControlStateNormal];
    }
    return _eyesBtn;
}

- (BaseButton *)downBtn{
    if (!_downBtn) {
        _downBtn = [BaseButton new];
        [_downBtn setBackgroundColor:[UIColor clearColor]];
        [_downBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_downBtn setBackgroundImage:[UIImage imageNamed:@"FYSDK_Resourcres.bundle/down"] forState:UIControlStateNormal];
    }
    return _downBtn;
}

- (BaseButton *)pwdLoginBtn{
    if (!_pwdLoginBtn) {
        
        _pwdLoginBtn = [BaseButton new];
        [_pwdLoginBtn setTitle:@"找回密码" forState:UIControlStateNormal];
        _pwdLoginBtn.titleLabel.font = font(15);
        [_pwdLoginBtn setTitleColor:rgba(252, 197, 105, 1) forState:UIControlStateNormal];
        [_pwdLoginBtn setBackgroundColor:[UIColor clearColor]];
        _pwdLoginBtn.layer.cornerRadius = SCREEN_FIT(5);
        _pwdLoginBtn.layer.masksToBounds = YES;
        _pwdLoginBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_pwdLoginBtn addTarget:self action:@selector(goGetBackPwd) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _pwdLoginBtn;
}


- (BaseButton *)agreedBtn{
    if (!_agreedBtn) {
        _agreedBtn = [BaseButton new];
        [_agreedBtn setBackgroundImage:[UIImage imageNamed:@"FYSDK_Resourcres.bundle/for_true"] forState:UIControlStateSelected];
        [_agreedBtn setBackgroundImage:[UIImage imageNamed:@"FYSDK_Resourcres.bundle/for_false"] forState:UIControlStateNormal];
        _agreedBtn.layer.cornerRadius = SCREEN_FIT(10);
        _agreedBtn.selected = YES;
        _agreedBtn.layer.masksToBounds = YES;
        [_agreedBtn addTarget:self action:@selector(agreedBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreedBtn;
}


- (UILabel *)getPwdtipsLbl{
    if (!_getPwdtipsLbl) {
        _getPwdtipsLbl = [UILabel new];
        _getPwdtipsLbl.text = @"忘记了？";
        _getPwdtipsLbl.textColor = [UIColor whiteColor];
        _getPwdtipsLbl.textAlignment = NSTextAlignmentRight;
        _getPwdtipsLbl.font =font(15);
    }
    return _getPwdtipsLbl;
}



//delegate
- (void)yb_attributeTapReturnString:(NSString *)string range:(NSRange)range index:(NSInteger)index{
    
    
}



- (void)eyeBtnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.phoneCodeTxtF.secureTextEntry = sender.selected;
    
}



- (void)changeRotateNewZhongkePhoneLoginView:(NSNotification*)noti {
    [self updateFrame];
    
}


- (void)agreedBtnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
}


- (void)goGetBackPwd{
    if (self.getBackPwdCallBlock) {
        self.phoneCodeTxtF.text= @"";
        self.phoneTxtF.text = @"";
        self.getBackPwdCallBlock();
    }
}


//登录
- (void)loginBtnAction{
    if (self.LoginCallBlock) {
        self.LoginCallBlock([self.phoneTxtF.text stringByReplacingOccurrencesOfString:@" " withString:@""], [self.phoneCodeTxtF.text stringByReplacingOccurrencesOfString:@" " withString:@""]);
    }
    
}
@end

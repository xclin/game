//
//  NewZhongkeGetbackPwdView.m
//  FYAppStoreDemo
//
//  Created by xiaocong lin on 2021/1/23.
//  Copyright © 2021 fanyue. All rights reserved.
//

#import "NewZhongkeGetbackPwdView.h"

@implementation NewZhongkeGetbackPwdView

- (void)setupUI{
    self.titleLbl.hidden = YES;
    self.LogingTypeLbl.text = @"找回密码";
    self.backBtn.hidden = NO;
    self.LogingTypeLbl.hidden = NO;
    self.agreementLbl.text = @"如果已经绑定手机，可通过短信验证码找回密码";
    [self.loginBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [self updateFrame];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRotateNewZhongkePhoneLoginView:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
}


- (void)updateFrame{
    UIInterfaceOrientation sataus=[UIApplication sharedApplication].statusBarOrientation;
       if (sataus == UIInterfaceOrientationPortrait || sataus == UIInterfaceOrientationPortraitUpsideDown) {//竖屏
        self.titleLbl.frame =CGRectMake(0, SCREEN_FIT(80),ZKUserViewWidth, SCREEN_FIT(25));
        self.backBtn.frame = CGRectMake(SCREEN_FIT(10), SCREEN_FIT(45), SCREEN_FIT(30), SCREEN_FIT(30));
        self.LogingTypeLbl.frame = CGRectMake(SCREEN_FIT(60), SCREEN_FIT(45), ZKUserViewWidth-SCREEN_FIT(120), SCREEN_FIT(30));
        self.agreementLbl.frame = CGRectMake(SCREEN_FIT(30), CGRectGetMaxY(self.LogingTypeLbl.frame)+SCREEN_FIT(70), ZKUserViewWidth-SCREEN_FIT(40), SCREEN_FIT(20));
        self.backForPhoneView.frame = CGRectMake(CGRectGetMinX(self.agreementLbl.frame), CGRectGetMaxY(self.agreementLbl.frame)+SCREEN_FIT(20), ZKUserViewWidth-SCREEN_FIT(60), SCREEN_FIT(50));
        self.phoneTxtF.frame = CGRectMake(SCREEN_FIT(10), SCREEN_FIT(5), CGRectGetWidth(self.backForPhoneView.frame)-SCREEN_FIT(50), SCREEN_FIT(40));
        self.loginBtn.frame = CGRectMake(CGRectGetMinX(self.backForPhoneView.frame), (windowHeight-SCREEN_FIT(50))/2, CGRectGetWidth(self.backForPhoneView.frame),SCREEN_FIT(50));
    }else {//横版  未知
        self.titleLbl.frame =CGRectMake(0, SCREEN_FIT(45),ZKUserViewWidth, SCREEN_FIT(25));
        self.backBtn.frame = CGRectMake(SCREEN_FIT(10), SCREEN_FIT(30), SCREEN_FIT(30), SCREEN_FIT(30));
        self.LogingTypeLbl.frame = CGRectMake(SCREEN_FIT(60), SCREEN_FIT(30), ZKUserViewWidth-SCREEN_FIT(120), SCREEN_FIT(30));
        self.agreementLbl.frame = CGRectMake(SCREEN_FIT(30), CGRectGetMaxY(self.LogingTypeLbl.frame)+SCREEN_FIT(40), ZKUserViewWidth-SCREEN_FIT(40), SCREEN_FIT(20));
        self.backForPhoneView.frame = CGRectMake(CGRectGetMinX(self.agreementLbl.frame), CGRectGetMaxY(self.agreementLbl.frame)+SCREEN_FIT(20), ZKUserViewWidth-SCREEN_FIT(60), SCREEN_FIT(50));
        self.phoneTxtF.frame = CGRectMake(SCREEN_FIT(10), SCREEN_FIT(5), CGRectGetWidth(self.backForPhoneView.frame)-SCREEN_FIT(50), SCREEN_FIT(40));
        
        self.loginBtn.frame = CGRectMake(CGRectGetMinX(self.backForPhoneView.frame),windowHeight-SCREEN_FIT(80), CGRectGetWidth(self.backForPhoneView.frame),SCREEN_FIT(45));
    }
    
}




- (void)changeRotateNewZhongkePhoneLoginView:(NSNotification*)noti {
    [self updateFrame];
    
}


- (void)loginBtnAction{
    
    if ([self.phoneTxtF.text stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0) {
        
        [[RemindView share] show:@"请输入账号" time:2.0];
        return;
    }
    
    if (self.nextCallBlock) {
        self.nextCallBlock([self.phoneTxtF.text stringByReplacingOccurrencesOfString:@" " withString:@""]);
        self.phoneTxtF.text = @"";
    }
    
}


- (void)backBtnAction{
    if (self.backBlock) {
        self.phoneTxtF.text = @"";
        self.backBlock();
    }
}

@end

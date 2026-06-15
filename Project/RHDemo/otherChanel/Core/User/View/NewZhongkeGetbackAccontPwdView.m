//
//  NewZhongkeGetbackAccontPwdView.m
//  FYAppStoreDemo
//
//  Created by xiaocong lin on 2021/1/23.
//  Copyright © 2021 fanyue. All rights reserved.
//

#import "NewZhongkeGetbackAccontPwdView.h"

@implementation NewZhongkeGetbackAccontPwdView

- (void)setupUI{
    self.titleLbl.hidden = YES;
    self.LogingTypeLbl.text = @"找回密码";
    self.backBtn.hidden = NO;
    self.LogingTypeLbl.hidden = NO;
    [self.loginBtn setTitle:@"客服电话:400-068-7000" forState:UIControlStateNormal];
    [self.backForCodeView addSubview:self.nameLbl];
    [self.backForCodeView addSubview:self.LineLbl];
    [self.backForCodeView addSubview:self.tipsLbl];
    [self updateFrame];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRotateNewZhongkePhoneLoginView:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
}


- (void)updateFrame{
    
    UIInterfaceOrientation sataus=[UIApplication sharedApplication].statusBarOrientation;
    if (sataus == UIInterfaceOrientationPortrait || sataus == UIInterfaceOrientationPortraitUpsideDown) {//竖屏
         self.titleLbl.frame =CGRectMake(0, SCREEN_FIT(80),ZKUserViewWidth, SCREEN_FIT(25));
        self.LogingTypeLbl.frame = CGRectMake(SCREEN_FIT(60), SCREEN_FIT(45), ZKUserViewWidth-SCREEN_FIT(120), SCREEN_FIT(30));
        self.backBtn.frame = CGRectMake(SCREEN_FIT(10), SCREEN_FIT(45), SCREEN_FIT(30), SCREEN_FIT(30));
        
        self.backForCodeView.frame = CGRectMake(SCREEN_FIT(30), CGRectGetMaxY(self.backBtn.frame)+SCREEN_FIT(120), ZKUserViewWidth-SCREEN_FIT(60),SCREEN_FIT(100));
        
        self.nameLbl.frame = CGRectMake(0,SCREEN_FIT(20), CGRectGetWidth(self.backForCodeView.frame), SCREEN_FIT(30));
        
        self.LineLbl.frame =CGRectMake(SCREEN_FIT(20),CGRectGetMaxY(self.nameLbl.frame)+SCREEN_FIT(5), CGRectGetWidth(self.backForCodeView.frame)-SCREEN_FIT(40), 1);
        
        self.tipsLbl.frame = CGRectMake(SCREEN_FIT(20), CGRectGetMaxY(self.LineLbl.frame)+SCREEN_FIT(10), CGRectGetWidth(self.backForCodeView.frame)-SCREEN_FIT(40), SCREEN_FIT(15));
        
        
        self.loginBtn.frame = CGRectMake(CGRectGetMinX(self.backForCodeView.frame), (windowHeight-SCREEN_FIT(50))/2, CGRectGetWidth(self.backForCodeView.frame),SCREEN_FIT(50));
        
        
        
    }else{//横版  未知
     self.titleLbl.frame =CGRectMake(0, SCREEN_FIT(45),ZKUserViewWidth, SCREEN_FIT(25));
            self.LogingTypeLbl.frame = CGRectMake(SCREEN_FIT(60), SCREEN_FIT(45), ZKUserViewWidth-SCREEN_FIT(120), SCREEN_FIT(30));
            self.backBtn.frame = CGRectMake(SCREEN_FIT(10), SCREEN_FIT(45), SCREEN_FIT(30), SCREEN_FIT(30));
            
            self.backForCodeView.frame = CGRectMake(SCREEN_FIT(30), CGRectGetMaxY(self.backBtn.frame)+SCREEN_FIT(30), ZKUserViewWidth-SCREEN_FIT(60),SCREEN_FIT(100));
            
            self.nameLbl.frame = CGRectMake(0,SCREEN_FIT(20), CGRectGetWidth(self.backForCodeView.frame), SCREEN_FIT(30));
            
            self.LineLbl.frame =CGRectMake(SCREEN_FIT(20),CGRectGetMaxY(self.nameLbl.frame)+SCREEN_FIT(5), CGRectGetWidth(self.backForCodeView.frame)-SCREEN_FIT(40), 1);
            
            self.tipsLbl.frame = CGRectMake(SCREEN_FIT(20), CGRectGetMaxY(self.LineLbl.frame)+SCREEN_FIT(10), CGRectGetWidth(self.backForCodeView.frame)-SCREEN_FIT(40), SCREEN_FIT(15));
            
            self.loginBtn.frame = CGRectMake(CGRectGetMinX(self.backForCodeView.frame),windowHeight-SCREEN_FIT(120), CGRectGetWidth(self.backForCodeView.frame),SCREEN_FIT(45));
            
        
    }
    
}


- (UILabel *)nameLbl{
    if (!_nameLbl) {
        _nameLbl = [UILabel new];
        _nameLbl.text = @"尊敬的玩家:wgog 您好";
        _nameLbl.textColor = [UIColor whiteColor];
        _nameLbl.textAlignment = NSTextAlignmentCenter;
        _nameLbl.font =font(17);
    }
    return _nameLbl;
}

- (UILabel *)LineLbl{
    if (!_LineLbl) {
        _LineLbl = [UILabel new];
        _LineLbl.backgroundColor = rgba(88, 88, 88, 1);
    }
    return _LineLbl;
}

- (UILabel *)tipsLbl{
    if (!_tipsLbl) {
        _tipsLbl = [UILabel new];
        _tipsLbl.text = @"该账号未绑定手机，您可以联系人工客服找回密码";
        _tipsLbl.textColor = [UIColor whiteColor];
        _tipsLbl.textAlignment = NSTextAlignmentCenter;
        _tipsLbl.font =font(11);
    }
    return _tipsLbl;
}

//delegate
- (void)yb_attributeTapReturnString:(NSString *)string range:(NSRange)range index:(NSInteger)index{
    NSString *message = [NSString stringWithFormat:@"点击了“%@”字符\nrange: %@\nindex: %ld",string,NSStringFromRange(range),index];
    WKAlertShow(message, @"取消");
}


//登录
- (void)loginBtnAction{
    
    
}

- (void)changeRotateNewZhongkePhoneLoginView:(NSNotification*)noti {
    [self updateFrame];
    
}


- (void)backBtnAction{
    if (self.backBlock) {
        self.phoneCodeTxtF.text= @"";
        self.phoneTxtF.text = @"";
        self.backBlock();
    }
}

@end

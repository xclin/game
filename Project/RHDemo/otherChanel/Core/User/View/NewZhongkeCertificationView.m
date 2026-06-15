//
//  NewZhongkeCertificationView.m
//  FYAppStoreDemo
//
//  Created by xiaocong lin on 2021/1/23.
//  Copyright © 2021 fanyue. All rights reserved.
//

#import "NewZhongkeCertificationView.h"
#import "SDKCommonMethod.h"
@implementation NewZhongkeCertificationView


- (void)setupUI{
    self.titleLbl.hidden = YES;
    self.LogingTypeLbl.text = @"实名认证";
    self.agreementLbl.text = @"根据国家法律规定，需要进行实名认证";
    self.agreementLbl.font = font(14);
    self.backBtn.hidden = NO;
    self.LogingTypeLbl.hidden = NO;
    self.phoneCodeTxtF.placeholder = @" 输入身份证号码";
    self.phoneTxtF.placeholder = @" 输入真实姓名";
    [self.loginBtn setTitle:@"确认提交" forState:UIControlStateNormal];
    [self.backBtn setImage:[UIImage imageNamed:@"FYSDK_Resourcres.bundle/close-white"] forState:UIControlStateNormal];
    [self addSubview:self.nameLbl];
    [self addSubview:self.LineLbl];
    [self addSubview:self.tipsLbl];
    [self updateFrame];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRotateNewZhongkePhoneLoginView:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
}


- (void)updateFrame{
    
    UIInterfaceOrientation sataus=[UIApplication sharedApplication].statusBarOrientation;
    if (sataus == UIInterfaceOrientationPortrait || sataus == UIInterfaceOrientationPortraitUpsideDown) {//竖屏
        self.LogingTypeLbl.frame = CGRectMake(SCREEN_FIT(60), SCREEN_FIT(40), ZKUserViewWidth-SCREEN_FIT(120), SCREEN_FIT(30));
        self.backBtn.frame = CGRectMake(SCREEN_FIT(10), SCREEN_FIT(40), SCREEN_FIT(30), SCREEN_FIT(30));
        
        self.agreementLbl.frame = CGRectMake(SCREEN_FIT(30), CGRectGetMaxY(self.LogingTypeLbl.frame)+SCREEN_FIT(40), ZKUserViewWidth-SCREEN_FIT(40), SCREEN_FIT(20));
        
        
        self.backForPhoneView.frame = CGRectMake(SCREEN_FIT(30), CGRectGetMaxY(self.agreementLbl.frame)+SCREEN_FIT(10), ZKUserViewWidth-SCREEN_FIT(60), SCREEN_FIT(50));
        self.phoneTxtF.frame = CGRectMake(SCREEN_FIT(10), SCREEN_FIT(5), CGRectGetWidth(self.backForPhoneView.frame)-SCREEN_FIT(20), SCREEN_FIT(40));
        
        
        self.backForCodeView.frame = CGRectMake(SCREEN_FIT(30), CGRectGetMaxY(self.backForPhoneView.frame)+SCREEN_FIT(20), CGRectGetWidth(self.backForPhoneView.frame),SCREEN_FIT(50));
        
        self.phoneCodeTxtF.frame = CGRectMake(SCREEN_FIT(10), SCREEN_FIT(5), CGRectGetWidth(self.backForCodeView.frame)-SCREEN_FIT(20), SCREEN_FIT(40));
        
        
        self.nameLbl.frame = CGRectMake(CGRectGetMinX(self.backForCodeView.frame),CGRectGetMaxY(self.backForCodeView.frame)+SCREEN_FIT(10), CGRectGetWidth(self.backForCodeView.frame), SCREEN_FIT(25));
        
        self.LineLbl.frame =CGRectMake(CGRectGetMinX(self.nameLbl.frame),CGRectGetMaxY(self.nameLbl.frame), CGRectGetWidth(self.backForCodeView.frame), SCREEN_FIT(25));
        
        self.tipsLbl.frame = CGRectMake(CGRectGetMinX(self.nameLbl.frame), CGRectGetMaxY(self.LineLbl.frame), CGRectGetWidth(self.backForCodeView.frame), SCREEN_FIT(50));
        
        self.loginBtn.frame = CGRectMake(CGRectGetMinX(self.backForCodeView.frame),CGRectGetMaxY(self.tipsLbl.frame)+SCREEN_FIT(20), CGRectGetWidth(self.backForCodeView.frame),SCREEN_FIT(50));
        self.nameLbl.font =font(13);
        self.LineLbl.font =font(13);
        self.tipsLbl.font =font(13);
    }else {//横版  未知
        self.LogingTypeLbl.frame = CGRectMake(SCREEN_FIT(60), SCREEN_FIT(20), ZKUserViewWidth-SCREEN_FIT(120), SCREEN_FIT(30));
        self.backBtn.frame = CGRectMake(SCREEN_FIT(10), SCREEN_FIT(20), SCREEN_FIT(30), SCREEN_FIT(30));
        
        self.agreementLbl.frame = CGRectMake(SCREEN_FIT(30), CGRectGetMaxY(self.LogingTypeLbl.frame)+SCREEN_FIT(10), ZKUserViewWidth-SCREEN_FIT(40), SCREEN_FIT(15));
        
        self.backForPhoneView.frame = CGRectMake(SCREEN_FIT(30), CGRectGetMaxY(self.agreementLbl.frame)+SCREEN_FIT(10), ZKUserViewWidth-SCREEN_FIT(60), SCREEN_FIT(45));
        self.phoneTxtF.frame = CGRectMake(SCREEN_FIT(10), SCREEN_FIT(2.5), CGRectGetWidth(self.backForPhoneView.frame)-SCREEN_FIT(20), SCREEN_FIT(40));
        
        
        self.backForCodeView.frame = CGRectMake(SCREEN_FIT(30), CGRectGetMaxY(self.backForPhoneView.frame)+SCREEN_FIT(10), CGRectGetWidth(self.backForPhoneView.frame),SCREEN_FIT(45));
        
        self.phoneCodeTxtF.frame = CGRectMake(SCREEN_FIT(10), SCREEN_FIT(2.5), CGRectGetWidth(self.backForCodeView.frame)-SCREEN_FIT(20), SCREEN_FIT(40));
        
        
        self.nameLbl.frame = CGRectMake(CGRectGetMinX(self.backForCodeView.frame),CGRectGetMaxY(self.backForCodeView.frame)+SCREEN_FIT(5), CGRectGetWidth(self.backForCodeView.frame), SCREEN_FIT(15));
        
        self.LineLbl.frame =CGRectMake(CGRectGetMinX(self.nameLbl.frame),CGRectGetMaxY(self.nameLbl.frame)+SCREEN_FIT(3), CGRectGetWidth(self.backForCodeView.frame), SCREEN_FIT(15));
        
        self.tipsLbl.frame = CGRectMake(CGRectGetMinX(self.nameLbl.frame), CGRectGetMaxY(self.LineLbl.frame)+SCREEN_FIT(3), CGRectGetWidth(self.backForCodeView.frame), SCREEN_FIT(40));
        
        self.nameLbl.font =font(11);
        self.LineLbl.font =font(11);
        self.tipsLbl.font =font(11);
        self.loginBtn.frame = CGRectMake(CGRectGetMinX(self.backForCodeView.frame),windowHeight-SCREEN_FIT(60), CGRectGetWidth(self.backForCodeView.frame),SCREEN_FIT(45));

    }
    
}


- (UILabel *)nameLbl{
    if (!_nameLbl) {
        _nameLbl = [UILabel new];
        _nameLbl.text = @"1、姓名、身份证、手机号需同一个人";
        _nameLbl.textColor = [UIColor whiteColor];
        _nameLbl.textAlignment = NSTextAlignmentLeft;
        _nameLbl.font =font(13);
    }
    return _nameLbl;
}

- (UILabel *)LineLbl{
    if (!_LineLbl) {
        _LineLbl = [UILabel new];
        _LineLbl.text = @"2、实名认证通过之后，不可更改";
        _LineLbl.textColor = [UIColor whiteColor];
        _LineLbl.textAlignment = NSTextAlignmentLeft;
        _LineLbl.font =font(13);
    }
    return _LineLbl;
}

- (UILabel *)tipsLbl{
    if (!_tipsLbl) {
        _tipsLbl = [UILabel new];
        _tipsLbl.text = @"3、应国家未成年人防沉迷政策需求，将限制未成年人每日游戏时间、充值等，详细请查看《防沉迷政策》";
        _tipsLbl.textColor = [UIColor whiteColor];
        _tipsLbl.textAlignment = NSTextAlignmentLeft;
        _tipsLbl.numberOfLines = 0;
        _tipsLbl.font =font(13);
    }
    return _tipsLbl;
}

//delegate
- (void)yb_attributeTapReturnString:(NSString *)string range:(NSRange)range index:(NSInteger)index{
    NSString *message = [NSString stringWithFormat:@"点击了“%@”字符\nrange: %@\nindex: %ld",string,NSStringFromRange(range),index];
    WKAlertShow(message, @"取消");
}

//获取验证码
- (void)getPhoneCodeBtnAction{
    
    
}

//登录
- (void)loginBtnAction{
    
    if (self.userCertifiCallBlock) {
        self.userCertifiCallBlock([self.phoneTxtF.text stringByReplacingOccurrencesOfString:@" " withString:@""], [self.phoneCodeTxtF.text stringByReplacingOccurrencesOfString:@" " withString:@""],[SDKCommonMethod shared].uToken);
    }
    
}

- (void)changeRotateNewZhongkePhoneLoginView:(NSNotification*)noti {
    [self updateFrame];
    
}


@end

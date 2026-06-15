//
//  NewZhongkeRegister.m
//  GameSDK
//
//  Created by xiaocong lin on 2021/1/23.
//  Copyright © 2021 lonnie. All rights reserved.
//

#import "NewZhongkeRegisterView.h"
#import "NewZhongkePwdWarningView.h"
@interface NewZhongkeRegisterView ()

@end

@implementation NewZhongkeRegisterView

- (void)setupUI{
    self.titleLbl.hidden = YES;
    [self addSubview:self.agreedBtnregit];
    self.LogingTypeLbl.text = @"注册账号";
    [self.loginBtn setTitle:@"确认注册" forState:UIControlStateNormal];
    self.backBtn.hidden = NO;
    self.LogingTypeLbl.hidden = NO;
    [self updateFrame];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRotateNewZhongkePhoneLoginView:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
    //富文本点击
    //需要点击的字符相同
    
    
    NSString *str =@"我已阅读并同意用户协议和隐私政策";
    
    //文本点击回调
      __weak typeof(self)weakSelf = self;
    self.hahalabel.tapBlock = ^(NSString *string) {
        NSLog(@" -- %@ --",string);
        if (weakSelf.userProCallBlock) {
            weakSelf.userProCallBlock(string);
        }
        
    };
    
    //设置需要点击的字符串，并配置此字符串的样式及位置
    IXAttributeModel    * model = [IXAttributeModel new];
    model.range = [str rangeOfString:@"用户协议"];
    model.string = @"用户协议";
    model.attributeDic = @{NSForegroundColorAttributeName : rgba(252, 197, 105, 1)};
    
    IXAttributeModel    * model1 = [IXAttributeModel new];
    model1.range = [str rangeOfString:@"隐私政策"];
    model1.string = @"隐私政策";
    model1.attributeDic = @{NSForegroundColorAttributeName : rgba(252, 197, 105, 1)};
    
    //label内容赋值
    [self.hahalabel setText:str attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:font(13)}
             tapStringArray:@[model,model1]];
    
}




- (void)updateFrame{
    
    UIInterfaceOrientation sataus=[UIApplication sharedApplication].statusBarOrientation;
    if (sataus == UIInterfaceOrientationPortrait || sataus == UIInterfaceOrientationPortraitUpsideDown) {//竖屏
        self.titleLbl.frame =CGRectMake(0, SCREEN_FIT(80),ZKUserViewWidth, SCREEN_FIT(25));
        
        self.backBtn.frame = CGRectMake(SCREEN_FIT(10), SCREEN_FIT(45), SCREEN_FIT(30), SCREEN_FIT(30));
        
        self.LogingTypeLbl.frame = CGRectMake(SCREEN_FIT(60), SCREEN_FIT(45), ZKUserViewWidth-SCREEN_FIT(120), SCREEN_FIT(30));
        
        self.backForPhoneView.frame = CGRectMake(SCREEN_FIT(30), CGRectGetMaxY(self.LogingTypeLbl.frame)+SCREEN_FIT(60), ZKUserViewWidth-SCREEN_FIT(60), SCREEN_FIT(50));
        
        self.phoneTxtF.frame = CGRectMake(SCREEN_FIT(10), SCREEN_FIT(5), CGRectGetWidth(self.backForPhoneView.frame)-SCREEN_FIT(50), SCREEN_FIT(40));
        
        
        self.backForCodeView.frame = CGRectMake(CGRectGetMinX(self.backForPhoneView.frame), CGRectGetMaxY(self.backForPhoneView.frame)+SCREEN_FIT(20), CGRectGetWidth(self.backForPhoneView.frame),SCREEN_FIT(50));
        
        self.phoneCodeTxtF.frame = CGRectMake(CGRectGetMinX(self.phoneTxtF.frame), SCREEN_FIT(5), CGRectGetWidth(self.phoneTxtF.frame), SCREEN_FIT(40));
        
        self.agreedBtnregit.frame =CGRectMake(CGRectGetMinX(self.backForCodeView.frame),CGRectGetMaxY(self.backForCodeView.frame)+SCREEN_FIT(10),SCREEN_FIT(20), SCREEN_FIT(20));
        
        self.hahalabel.frame = CGRectMake(CGRectGetMaxX(self.agreedBtnregit.frame)+SCREEN_FIT(5), CGRectGetMaxY(self.backForCodeView.frame)+SCREEN_FIT(10), ZKUserViewWidth-SCREEN_FIT(40), SCREEN_FIT(20));
        
        
        
        self.loginBtn.frame = CGRectMake(CGRectGetMinX(self.backForPhoneView.frame),(windowHeight-SCREEN_FIT(50))/2, CGRectGetWidth(self.backForCodeView.frame),SCREEN_FIT(50));
        
        
        
    }else{
        self.titleLbl.frame =CGRectMake(0, SCREEN_FIT(45),ZKUserViewWidth, SCREEN_FIT(25));
        self.backBtn.frame = CGRectMake(SCREEN_FIT(10), SCREEN_FIT(30), SCREEN_FIT(30), SCREEN_FIT(30));
        
        self.LogingTypeLbl.frame = CGRectMake(SCREEN_FIT(60), SCREEN_FIT(30), ZKUserViewWidth-SCREEN_FIT(120), SCREEN_FIT(30));
        
        self.backForPhoneView.frame = CGRectMake(SCREEN_FIT(30), CGRectGetMaxY(self.LogingTypeLbl.frame)+SCREEN_FIT(30), ZKUserViewWidth-SCREEN_FIT(60), SCREEN_FIT(50));
        
        self.phoneTxtF.frame = CGRectMake(SCREEN_FIT(10), SCREEN_FIT(5), CGRectGetWidth(self.backForPhoneView.frame)-SCREEN_FIT(50), SCREEN_FIT(40));
        
        self.backForCodeView.frame = CGRectMake(CGRectGetMinX(self.backForPhoneView.frame), CGRectGetMaxY(self.backForPhoneView.frame)+SCREEN_FIT(20), CGRectGetWidth(self.backForPhoneView.frame),SCREEN_FIT(50));
        
        self.phoneCodeTxtF.frame = CGRectMake(CGRectGetMinX(self.phoneTxtF.frame), SCREEN_FIT(5), CGRectGetWidth(self.phoneTxtF.frame), SCREEN_FIT(40));
        
        
        self.agreedBtnregit.frame =CGRectMake(CGRectGetMinX(self.backForCodeView.frame),CGRectGetMaxY(self.backForCodeView.frame)+SCREEN_FIT(10),SCREEN_FIT(20), SCREEN_FIT(20));
        
        self.hahalabel.frame = CGRectMake(CGRectGetMaxX(self.agreedBtnregit.frame)+SCREEN_FIT(5), CGRectGetMaxY(self.backForCodeView.frame)+SCREEN_FIT(10), ZKUserViewWidth-SCREEN_FIT(40), SCREEN_FIT(20));
        
        self.loginBtn.frame = CGRectMake(CGRectGetMinX(self.backForPhoneView.frame), windowHeight-SCREEN_FIT(80), CGRectGetWidth(self.backForCodeView.frame),SCREEN_FIT(45));
    }
    
}

- (BaseButton *)agreedBtnregit{
    if (!_agreedBtnregit) {
        _agreedBtnregit = [BaseButton new];
        [_agreedBtnregit setBackgroundImage:[UIImage imageNamed:@"FYSDK_Resourcres.bundle/for_false"] forState:UIControlStateNormal];
        _agreedBtnregit.layer.cornerRadius = SCREEN_FIT(10);
        _agreedBtnregit.layer.masksToBounds = YES;
//        _agreedBtn.selected = YES;
        [_agreedBtnregit setAdjustsImageWhenHighlighted:NO];
        [_agreedBtnregit addTarget:self action:@selector(agreedBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreedBtnregit;
}


//注册
- (void)loginBtnAction{
    
    if (!self.agreedBtnregit.selected) {
        [[RemindView share] show:@"请勾选协议" time:2.0];
        return;
    }
    
    if (self.phoneTxtF.text.length == 0 ) {
          [[RemindView share] show:@"请输入用户名" time:2.0];
         return;
    }
    
    if (self.phoneCodeTxtF.text.length < 6) {
          [[RemindView share] show:@"请输入不少于六位密码" time:2.0];
         return;
    }
    
    if([self.phoneCodeTxtF.text isAllLetter] || [self.phoneCodeTxtF.text isAllNumber] || [self.phoneCodeTxtF.text isAllCharacter]) {
        [self warnBlockView];
        return;
    }else{
        if (self.registerCallBlock) {
            self.registerCallBlock([self.phoneTxtF.text stringByReplacingOccurrencesOfString:@" " withString:@""], [self.phoneCodeTxtF.text stringByReplacingOccurrencesOfString:@" " withString:@""]);
        }
    }
    
    
}

- (void)warnBlockView{
    if (self.registerErrorCallBlock) {
         self.registerErrorCallBlock([self.phoneTxtF.text stringByReplacingOccurrencesOfString:@" " withString:@""], [self.phoneCodeTxtF.text stringByReplacingOccurrencesOfString:@" " withString:@""]);
    }

    
}

- (void)changeRotateNewZhongkePhoneLoginView:(NSNotification*)noti {
    [self updateFrame];
    
}

- (void)backBtnAction{
    if (self.backBlock) {
        self.agreedBtnregit.selected = NO;
        [self.agreedBtnregit setBackgroundImage:[UIImage imageNamed:@"FYSDK_Resourcres.bundle/for_false"] forState:UIControlStateNormal];
        self.phoneCodeTxtF.text= @"";
        self.phoneTxtF.text = @"";
        self.backBlock();
    }
}


- (void)agreedBtnAction:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.agreedBtnregit setBackgroundImage:[UIImage imageNamed:@"FYSDK_Resourcres.bundle/for_true"] forState:UIControlStateNormal];
    }else{
        
        [self.agreedBtnregit setBackgroundImage:[UIImage imageNamed:@"FYSDK_Resourcres.bundle/for_false"] forState:UIControlStateNormal];
    }
    
}



@end

//
//  NewZhongkeGetbackPhonePwd.m
//  FYAppStoreDemo
//
//  Created by xiaocong lin on 2021/1/23.
//  Copyright © 2021 fanyue. All rights reserved.
//

#import "NewZhongkeGetbackPhonePwd.h"
#import "TempUserMessage.h"


@interface NewZhongkeGetbackPhonePwd ()
@property (nonatomic,strong) NSTimer *timer;//定时器
@property (nonatomic,assign) NSInteger second;//倒计时的时间

@end

@implementation NewZhongkeGetbackPhonePwd


- (void)setupUI{
    self.titleLbl.hidden = YES;
    self.LogingTypeLbl.text = @"找回密码";
    self.agreementLbl.text = [NSString stringWithFormat:@"正在设置账号: %@ 的密码",COMMONMETHOD.phone];//@" 135 3947 6494 ";
    self.backBtn.hidden = NO;
    self.LogingTypeLbl.hidden = NO;
    [self.loginBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    self.phoneCodeTxtF.placeholder = @" 输入验证码";
     self.phoneTxtF.placeholder = @" 输入新密码";
    [self updateFrame];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRotateNewZhongkePhoneLoginView:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
}


- (void)updateFrame{
    
    UIInterfaceOrientation sataus=[UIApplication sharedApplication].statusBarOrientation;
    if (sataus == UIInterfaceOrientationPortrait || sataus == UIInterfaceOrientationPortraitUpsideDown) {//竖屏
         self.titleLbl.frame =CGRectMake(0, SCREEN_FIT(80),ZKUserViewWidth, SCREEN_FIT(25));
        self.LogingTypeLbl.frame = CGRectMake(SCREEN_FIT(60), SCREEN_FIT(45), ZKUserViewWidth-SCREEN_FIT(120), SCREEN_FIT(30));
        self.backBtn.frame = CGRectMake(SCREEN_FIT(10), SCREEN_FIT(45), SCREEN_FIT(30), SCREEN_FIT(30));
        
        self.agreementLbl.frame = CGRectMake(SCREEN_FIT(30), CGRectGetMaxY(self.backBtn.frame)+SCREEN_FIT(50), ZKUserViewWidth-SCREEN_FIT(40), SCREEN_FIT(20));
        
        
        self.backForCodeView.frame = CGRectMake(CGRectGetMinX(self.agreementLbl.frame), CGRectGetMaxY(self.agreementLbl.frame)+SCREEN_FIT(20), ZKUserViewWidth-SCREEN_FIT(60),SCREEN_FIT(50));
        
        
        self.phoneCodeTxtF.frame = CGRectMake(SCREEN_FIT(10), SCREEN_FIT(5), CGRectGetWidth(self.backForCodeView.frame)-SCREEN_FIT(120), SCREEN_FIT(40));

        self.getPhoneCodeBtn.frame =CGRectMake(CGRectGetMaxX(self.phoneCodeTxtF.frame)+SCREEN_FIT(20), SCREEN_FIT(10),SCREEN_FIT(70), SCREEN_FIT(30));
        

    
        self.backForPhoneView.frame = CGRectMake(SCREEN_FIT(30), CGRectGetMaxY(self.backForCodeView.frame)+SCREEN_FIT(20), ZKUserViewWidth-SCREEN_FIT(60), SCREEN_FIT(50));
        
        self.phoneTxtF.frame = CGRectMake(SCREEN_FIT(10), SCREEN_FIT(5), CGRectGetWidth(self.backForPhoneView.frame)-SCREEN_FIT(20), SCREEN_FIT(40));
        
        self.loginBtn.frame = CGRectMake(CGRectGetMinX(self.backForPhoneView.frame), (windowHeight-SCREEN_FIT(50))/2, CGRectGetWidth(self.backForCodeView.frame),SCREEN_FIT(50));
        
        
        
    }else {//横版  未知
         self.titleLbl.frame =CGRectMake(0, SCREEN_FIT(45),ZKUserViewWidth, SCREEN_FIT(25));
            self.LogingTypeLbl.frame = CGRectMake(SCREEN_FIT(60), SCREEN_FIT(45), ZKUserViewWidth-SCREEN_FIT(120), SCREEN_FIT(30));
            self.backBtn.frame = CGRectMake(SCREEN_FIT(10), SCREEN_FIT(45), SCREEN_FIT(30), SCREEN_FIT(30));
            
            self.agreementLbl.frame = CGRectMake(SCREEN_FIT(30), CGRectGetMaxY(self.backBtn.frame)+SCREEN_FIT(20), ZKUserViewWidth-SCREEN_FIT(40), SCREEN_FIT(20));
            
            
            self.backForCodeView.frame = CGRectMake(CGRectGetMinX(self.agreementLbl.frame), CGRectGetMaxY(self.agreementLbl.frame)+SCREEN_FIT(15), ZKUserViewWidth-SCREEN_FIT(60),SCREEN_FIT(45));
            
            
            self.phoneCodeTxtF.frame = CGRectMake(SCREEN_FIT(10), SCREEN_FIT(2.5), CGRectGetWidth(self.backForCodeView.frame)-SCREEN_FIT(120), SCREEN_FIT(40));

        self.getPhoneCodeBtn.frame =CGRectMake(CGRectGetMaxX(self.phoneCodeTxtF.frame)+SCREEN_FIT(12.5), SCREEN_FIT(10),SCREEN_FIT(70), SCREEN_FIT(30));
            

        
            self.backForPhoneView.frame = CGRectMake(SCREEN_FIT(30), CGRectGetMaxY(self.backForCodeView.frame)+SCREEN_FIT(15), ZKUserViewWidth-SCREEN_FIT(60), SCREEN_FIT(45));
            
        self.phoneTxtF.frame = CGRectMake(SCREEN_FIT(10), SCREEN_FIT(2.5), CGRectGetWidth(self.backForPhoneView.frame)-SCREEN_FIT(20), SCREEN_FIT(40));
            
            self.loginBtn.frame = CGRectMake(CGRectGetMinX(self.backForPhoneView.frame),windowHeight-SCREEN_FIT(80), CGRectGetWidth(self.backForCodeView.frame),SCREEN_FIT(45));
            
        
    }
    
}



//delegate
- (void)yb_attributeTapReturnString:(NSString *)string range:(NSRange)range index:(NSInteger)index{
   
}

//获取验证码
- (void)getPhoneCodeBtnAction{
    
    self.getPhoneCodeBtn.enabled  = NO;
    if (self.getPhoneCodeCallBlock) {
        
        self.getPhoneCodeCallBlock(COMMONMETHOD.phone);
        // 设置倒计时的总时间
        
        self.second = 60;
        
        // 创建计时器
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
        
    }
}

//修改密码
- (void)loginBtnAction{
    
    if (self.resetPwdCallBlock) {
        self.resetPwdCallBlock([self.phoneCodeTxtF.text stringByReplacingOccurrencesOfString:@" " withString:@""], [self.phoneTxtF.text stringByReplacingOccurrencesOfString:@" " withString:@""]);
    }
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


#pragma mark 定时器调用的方法

- (void)changeTime{
    self.second --;
    [self.getPhoneCodeBtn setTitle:[NSString stringWithFormat:@"%@ s",@(self.second)] forState:UIControlStateNormal];
    //如果时间到了 0 秒, 把定时器取消掉
    if (self.second == -1) {
        //释放定时器
        [self.timer invalidate];
        //把定时器设置成空.不然不起作用.
        self.timer = nil;
        //把修改的验证码按钮调整为初始状态
        self.getPhoneCodeBtn.enabled  = YES;
        [self.getPhoneCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}
@end

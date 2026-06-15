//
//  NewZhongkeLoginMainView.m
//  GameSDK
//
//  Created by xiaocong lin on 2021/1/19.
//  Copyright © 2021 lonnie. All rights reserved.
//

#import "NewZhongkePhoneLoginView.h"
#import "RemindView.h"
#import "TempUserMessage.h"

@interface NewZhongkePhoneLoginView ()
@property (nonatomic,strong) NSTimer *timer;//定时器
@property (nonatomic,assign) NSInteger second;//倒计时的时间

@end

@implementation NewZhongkePhoneLoginView

- (void)setupUI{
    [self.backForPhoneView addSubview:self.verticalView];
    
    [self.backForPhoneView addSubview:self.phoneLocalLbl];
    [self addSubview:self.agreedBtnKey];
    [self addSubview:self.pwdLoginBtn];
//    [self addSubview:self.registerBtn];

    [self.loginBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    
    self.phoneCodeTxtF.placeholder = @" 输入验证码";
    
    [self updateFrame];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRotateNewZhongkePhoneLoginView:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
    
    NSString *strp =@"请阅读游戏用户协议 和 隐私政策";
        //文本点击回调
    __block typeof (self) bSelf = self;

        self.hahalabel.tapBlock = ^(NSString *string) {
            NSLog(@"----------%@",string);
            if (bSelf.userProCallBlock) {
                bSelf.userProCallBlock(string);
            }
        };
        
    IXAttributeModel    * model3 = [IXAttributeModel new];
    model3.range = [strp rangeOfString:@"用户协议"];
    model3.string = @"用户协议";
    model3.attributeDic = @{NSForegroundColorAttributeName : rgba(252, 197, 105, 1)};
        
        IXAttributeModel    * model4 = [IXAttributeModel new];
    model4.range = [strp rangeOfString:@"隐私政策"];
    model4.string = @"隐私政策";
    model4.attributeDic = @{NSForegroundColorAttributeName : rgba(252, 197, 105, 1)};
        
        //label内容赋值
    [self.hahalabel setText:strp attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:15]}
                 tapStringArray:@[model3,model4]];

    
    
}

- (void)updateFrame{
    UIInterfaceOrientation sataus=[UIApplication sharedApplication].statusBarOrientation;
    if (sataus == UIInterfaceOrientationPortrait || sataus == UIInterfaceOrientationPortraitUpsideDown) {//竖屏
         self.backBtn.frame = CGRectMake(SCREEN_FIT(10), SCREEN_FIT(30), SCREEN_FIT(30), SCREEN_FIT(30));
        self.titleLbl.frame =CGRectMake(0, SCREEN_FIT(80),ZKUserViewWidth, SCREEN_FIT(25));
        
        self.agreedBtnKey.frame =CGRectMake(SCREEN_FIT(30),CGRectGetMaxY(self.titleLbl.frame)+SCREEN_FIT(50),SCREEN_FIT(20), SCREEN_FIT(20));
  
        self.hahalabel.frame = CGRectMake(CGRectGetMaxX(self.agreedBtnKey.frame)+SCREEN_FIT(10), CGRectGetMaxY(self.titleLbl.frame)+SCREEN_FIT(45), ZKUserViewWidth-SCREEN_FIT(30), SCREEN_FIT(30));
        
        self.backForPhoneView.frame = CGRectMake(CGRectGetMinX(self.agreedBtnKey.frame), CGRectGetMaxY(self.hahalabel.frame)+SCREEN_FIT(10), ZKUserViewWidth-SCREEN_FIT(60), SCREEN_FIT(50));
        
        self.phoneLocalLbl.frame = CGRectMake(SCREEN_FIT(15), 0, SCREEN_FIT(60), SCREEN_FIT(50));
        
        self.verticalView.frame =CGRectMake(CGRectGetMaxX(self.phoneLocalLbl.frame)+SCREEN_FIT(5), SCREEN_FIT(20), 1, SCREEN_FIT(10));
        
        self.phoneTxtF.frame = CGRectMake(CGRectGetMaxX(self.verticalView.frame)+SCREEN_FIT(10), SCREEN_FIT(5), CGRectGetWidth(self.backForPhoneView.frame)-(CGRectGetMaxX(self.verticalView.frame)+SCREEN_FIT(10)), SCREEN_FIT(40));
        
        
        self.backForCodeView.frame = CGRectMake(CGRectGetMinX(self.backForPhoneView.frame), CGRectGetMaxY(self.backForPhoneView.frame)+SCREEN_FIT(10), CGRectGetWidth(self.backForPhoneView.frame),SCREEN_FIT(50));
        
        
        self.getPhoneCodeBtn.frame =CGRectMake(SCREEN_FIT(15), SCREEN_FIT(10),SCREEN_FIT(70), SCREEN_FIT(30));
        
        self.phoneCodeTxtF.frame = CGRectMake(CGRectGetMinX(self.phoneTxtF.frame), SCREEN_FIT(7.5), CGRectGetWidth(self.phoneTxtF.frame), SCREEN_FIT(35));
        
        self.loginBtn.frame = CGRectMake(CGRectGetMinX(self.backForCodeView.frame),(windowHeight-SCREEN_FIT(50))/2, CGRectGetWidth(self.backForCodeView.frame),SCREEN_FIT(50));
        
        
        self.pwdLoginBtn.frame = CGRectMake(CGRectGetMinX(self.loginBtn.frame), CGRectGetMaxY(self.loginBtn.frame)+SCREEN_FIT(10), SCREEN_FIT(100),SCREEN_FIT(30));
        
        self.registerBtn.frame = CGRectMake(CGRectGetWidth(self.loginBtn.frame)-SCREEN_FIT(100), CGRectGetMaxY(self.loginBtn.frame)+SCREEN_FIT(10), SCREEN_FIT(100),SCREEN_FIT(30));
        
    }else{
         self.backBtn.frame = CGRectMake(SCREEN_FIT(10), SCREEN_FIT(20), SCREEN_FIT(30), SCREEN_FIT(30));
        self.titleLbl.frame =CGRectMake(0, SCREEN_FIT(45),ZKUserViewWidth, SCREEN_FIT(25));
        
        self.agreedBtnKey.frame =CGRectMake(SCREEN_FIT(30),CGRectGetMidY(self.titleLbl.frame)+SCREEN_FIT(30),SCREEN_FIT(20), SCREEN_FIT(20));
        
        self.hahalabel.frame = CGRectMake(CGRectGetMaxX(self.agreedBtnKey.frame)+SCREEN_FIT(10), CGRectGetMidY(self.titleLbl.frame)+SCREEN_FIT(25), ZKUserViewWidth-SCREEN_FIT(30), SCREEN_FIT(30));
        
        
        
        self.backForPhoneView.frame = CGRectMake(CGRectGetMinX(self.agreedBtnKey.frame), CGRectGetMaxY(self.hahalabel.frame)+SCREEN_FIT(10), ZKUserViewWidth-SCREEN_FIT(60), SCREEN_FIT(45));
        
        self.phoneLocalLbl.frame = CGRectMake(SCREEN_FIT(15), 0, SCREEN_FIT(60), SCREEN_FIT(50));
        
        self.verticalView.frame =CGRectMake(CGRectGetMaxX(self.phoneLocalLbl.frame)+SCREEN_FIT(5), SCREEN_FIT(20), 1, SCREEN_FIT(10));
        
        self.phoneTxtF.frame = CGRectMake(CGRectGetMaxX(self.verticalView.frame)+SCREEN_FIT(10), SCREEN_FIT(5), CGRectGetWidth(self.backForPhoneView.frame)-(CGRectGetMaxX(self.verticalView.frame)+SCREEN_FIT(10)), SCREEN_FIT(40));
        
        
        self.backForCodeView.frame = CGRectMake(CGRectGetMinX(self.backForPhoneView.frame), CGRectGetMaxY(self.backForPhoneView.frame)+SCREEN_FIT(10), CGRectGetWidth(self.backForPhoneView.frame),SCREEN_FIT(45));
        
        
        self.getPhoneCodeBtn.frame =CGRectMake(SCREEN_FIT(10), SCREEN_FIT(10),SCREEN_FIT(70), SCREEN_FIT(30));
        
        self.phoneCodeTxtF.frame = CGRectMake(CGRectGetMinX(self.phoneTxtF.frame), SCREEN_FIT(5), CGRectGetWidth(self.phoneTxtF.frame), SCREEN_FIT(35));
        
        
        self.loginBtn.frame = CGRectMake(CGRectGetMinX(self.backForCodeView.frame),windowHeight-SCREEN_FIT(100), CGRectGetWidth(self.backForCodeView.frame),SCREEN_FIT(45));
        
        
        
        self.pwdLoginBtn.frame = CGRectMake(CGRectGetMinX(self.loginBtn.frame), CGRectGetMaxY(self.loginBtn.frame)+SCREEN_FIT(10), SCREEN_FIT(100),SCREEN_FIT(30));
        
        self.registerBtn.frame = CGRectMake(CGRectGetWidth(self.loginBtn.frame)-SCREEN_FIT(100), CGRectGetMaxY(self.loginBtn.frame)+SCREEN_FIT(10), SCREEN_FIT(100),SCREEN_FIT(30));
        
        
    }
    
    
}

- (BaseButton *)agreedBtnKey{
    if (!_agreedBtnKey) {
        _agreedBtnKey = [BaseButton new];
        [_agreedBtnKey setBackgroundImage:[UIImage imageNamed:@"FYSDK_Resourcres.bundle/for_false"] forState:UIControlStateNormal];
        _agreedBtnKey.layer.cornerRadius = SCREEN_FIT(10);
        _agreedBtnKey.layer.masksToBounds = YES;
        [_agreedBtnKey setAdjustsImageWhenHighlighted:NO];
        [_agreedBtnKey addTarget:self action:@selector(agreedBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreedBtnKey;
}


- (UIView *)verticalView{
    if (!_verticalView) {
        _verticalView = [UIView new];
        _verticalView.backgroundColor = rgba(255, 255, 255, 1);
    }
    return _verticalView;
}


- (BaseButton *)pwdLoginBtn{
    if (!_pwdLoginBtn) {
        _pwdLoginBtn = [BaseButton new];
        [_pwdLoginBtn setTitle:@"密码登录" forState:UIControlStateNormal];
        _pwdLoginBtn.titleLabel.font = font(15);
        [_pwdLoginBtn setTitleColor:rgba(252, 197, 105, 1) forState:UIControlStateNormal];
        [_pwdLoginBtn setBackgroundColor:[UIColor clearColor]];
        _pwdLoginBtn.layer.cornerRadius = SCREEN_FIT(5);
        _pwdLoginBtn.layer.masksToBounds = YES;
        _pwdLoginBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_pwdLoginBtn addTarget:self action:@selector(loginPwdBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _pwdLoginBtn;
}


- (BaseButton *)registerBtn{
    if (!_registerBtn) {
        _registerBtn = [BaseButton new];
        [_registerBtn setTitle:@"注册账号" forState:UIControlStateNormal];
        _registerBtn.titleLabel.font = font(15);
        [_registerBtn setTitleColor:rgba(252, 197, 105, 1) forState:UIControlStateNormal];
        [_registerBtn setBackgroundColor:[UIColor clearColor]];
        _registerBtn.layer.cornerRadius = SCREEN_FIT(5);
        _registerBtn.layer.masksToBounds = YES;
        _registerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_registerBtn addTarget:self action:@selector(loginRegBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _registerBtn;
}
- (UILabel *)phoneLocalLbl{
    if (!_phoneLocalLbl) {
        _phoneLocalLbl = [UILabel new];
        _phoneLocalLbl.text = @"中国+ 86";
        _phoneLocalLbl.textColor = rgba(255, 255, 255, 1);
        _phoneLocalLbl.textAlignment = NSTextAlignmentLeft;
        _phoneLocalLbl.font = font(12);
        _phoneLocalLbl.backgroundColor = [UIColor clearColor];
    }
    return _phoneLocalLbl;
}



//获取验证码
- (void)getPhoneCodeBtnAction{
    if (![self.phoneTxtF.text isValidMobile]) {
        [[RemindView share] show:@"请输入手机号" time:2.0];
    return;
    }
    self.getPhoneCodeBtn.enabled  = NO;
    if (self.getPhoneCodeCallBlock) {
        
        self.getPhoneCodeCallBlock(self.phoneTxtF.text);
        // 设置倒计时的总时间
        
        self.second = 60;
        
        // 创建计时器
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
        
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

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}



//登录
- (void)loginBtnAction{

    
    if (!self.agreedBtnKey.selected) {
        [[RemindView share] show:@"请勾选协议" time:2.0];
        return;
    }
    
    if (self.phoneTxtF.text.length == 0 && self.phoneCodeTxtF.text.length == 0) {
        [[RemindView share] show:@"请输入手机号或者验证码" time:2.0];
        return;
    }
    
    if (self.phoneCodeTxtF.text.length != 4) {
        [[RemindView share] show:@"请输入4位验证码" time:2.0];

        return;
    }
    
    
    if (![self validateNumber:self.phoneCodeTxtF.text]) {
        [[RemindView share] show:@"验证码请输入数字" time:2.0];

        return;
    }
    
    if (self.PhoneLoginCallBlock) {
        self.PhoneLoginCallBlock(self.phoneTxtF.text,self.phoneCodeTxtF.text);
        
    }
}

- (void)agreedBtnAction:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.agreedBtnKey setBackgroundImage:[UIImage imageNamed:@"FYSDK_Resourcres.bundle/for_true"] forState:UIControlStateNormal];
    }else{
        
        [self.agreedBtnKey setBackgroundImage:[UIImage imageNamed:@"FYSDK_Resourcres.bundle/for_false"] forState:UIControlStateNormal];
    }
    
}

- (void)backBtnAction{
    if (self.backBlock) {
        self.agreedBtnKey.selected = NO;
        [self.agreedBtnKey setBackgroundImage:[UIImage imageNamed:@"FYSDK_Resourcres.bundle/for_false"] forState:UIControlStateNormal];
        self.phoneCodeTxtF.text= @"";
        self.phoneTxtF.text = @"";
        self.backBlock();
    }
}


- (void)changeRotateNewZhongkePhoneLoginView:(NSNotification*)noti {

    
    [self updateFrame];
    
}


- (void)loginPwdBtnAction{
    
    if (self.goPwdLoginCallBack) {
        self.goPwdLoginCallBack();
    }
    
}

- (void)loginRegBtnAction{
    if (self.goRegisterCallBack) {
        self.goRegisterCallBack();
    }
    
}
@end

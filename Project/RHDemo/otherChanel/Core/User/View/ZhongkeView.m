
#import "VersionAllMethod.h"
#import "sdkInitModel.h"
#import "VerifyIDCardView.h"
#import "ZhongkeView.h"

@implementation ZhongkeView


- (instancetype) init {
    self = [super init];
    if (self) {
        [self setupUI];
        self.frame = CGRectMake(windowWidth-ZKUserViewWidth, 0, ZKUserViewWidth, windowHeight);
        self.backgroundColor =  rgba(0, 0, 0, 0.8);
        [self addSubview:self.titleLbl];
        [self addSubview:self.hahalabel];
        [self addSubview:self.agreementLbl];
        [self addSubview:self.backBtn];
        [self addSubview:self.LogingTypeLbl];
        [self addSubview:self.loginBtn];
        [self addSubview:self.backForCodeView];
        [self addSubview:self.backForPhoneView];
        [self.backForPhoneView addSubview:self.phoneTxtF];
        [self.backForCodeView addSubview:self.phoneCodeTxtF];
        [self.backForCodeView addSubview:self.getPhoneCodeBtn];
        [self updateBaseFrame];
    }
    return self;
}


- (void) setupUI {
    
    NSLog(@"ZhongkeView--setupUI");
}


- (BaseLabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [BaseLabel new];
        _titleLbl.text = @"欢迎进入HapiHapi";
        _titleLbl.frame =CGRectMake(0, SCREEN_FIT(45),ZKUserViewWidth, SCREEN_FIT(25));
        _titleLbl.textAlignment =NSTextAlignmentCenter;
        _titleLbl.textColor =rgba(252, 197, 105, 1);
        _titleLbl.font = font(23);
        
    }
    return _titleLbl;
}


- (IXAttributeTapLabel *)hahalabel{
    if (!_hahalabel) {
        _hahalabel = [IXAttributeTapLabel new];
        _hahalabel.backgroundColor = [UIColor clearColor];
        _hahalabel.numberOfLines = 0;
    }
    
   return _hahalabel;
}



- (BaseButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [BaseButton new];
        _backBtn.titleLabel.font = font(20);
        [_backBtn setImage:[UIImage imageNamed:@"FYSDK_Resourcres.bundle/left-with"] forState:UIControlStateNormal];
        [_backBtn setBackgroundColor:rgba(0, 0, 0, 0.2)];
        _backBtn.layer.cornerRadius = SCREEN_FIT(15);
        _backBtn.layer.masksToBounds = YES;
        _backBtn.hidden = YES;
        [_backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _backBtn;
}

- (BaseLabel *)LogingTypeLbl{
    if (!_LogingTypeLbl) {
        _LogingTypeLbl = [BaseLabel new];
        _LogingTypeLbl.text = @"";
        _LogingTypeLbl.frame =CGRectMake(0, SCREEN_FIT(45),ZKUserViewWidth, SCREEN_FIT(25));
        _LogingTypeLbl.textAlignment =NSTextAlignmentCenter;
        _LogingTypeLbl.textColor =rgba(252, 197, 105, 1);
        _LogingTypeLbl.font = font(23);
        
    }
    return _LogingTypeLbl;
}



- (BaseButton *)getPhoneCodeBtn{
    if (!_getPhoneCodeBtn) {
        _getPhoneCodeBtn = [BaseButton new];
        [_getPhoneCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _getPhoneCodeBtn.titleLabel.font = font(11);
        [_getPhoneCodeBtn setTitleColor:rgba(0, 0, 0, 1) forState:UIControlStateNormal];
        [_getPhoneCodeBtn setBackgroundColor:rgba(252, 197, 105, 1)];
        _getPhoneCodeBtn.layer.cornerRadius = SCREEN_FIT(5);
        _getPhoneCodeBtn.layer.masksToBounds = YES;
        [_getPhoneCodeBtn addTarget:self action:@selector(getPhoneCodeBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _getPhoneCodeBtn;
}

- (BaseButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [BaseButton new];
        [_loginBtn setTitle:@"立即注册" forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = font(20);
        [_loginBtn setTitleColor:rgba(116, 58, 7, 1) forState:UIControlStateNormal];
        [_loginBtn setBackgroundColor:rgba(252, 197, 105, 1)];
        _loginBtn.layer.cornerRadius = SCREEN_FIT(5);
        _loginBtn.layer.masksToBounds = YES;
        [_loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (UIView *)backForCodeView{
    if (!_backForCodeView) {
        _backForCodeView = [UIView new];
        _backForCodeView.backgroundColor =  rgba(0, 0, 0, 0.4);
        _backForCodeView.layer.cornerRadius = 5;
        _backForCodeView.layer.masksToBounds = YES;
    }
    return _backForCodeView;
}

- (UIView *)backForPhoneView{
    if (!_backForPhoneView) {
        _backForPhoneView = [UIView new];
        _backForPhoneView.backgroundColor = rgba(0, 0, 0, 0.4);
        _backForPhoneView.layer.cornerRadius = 5;
        _backForPhoneView.layer.masksToBounds = YES;
    }
    return _backForPhoneView;
    
}

- (UITextField *)phoneTxtF{
    if (!_phoneTxtF) {
        _phoneTxtF = [UITextField new];
        _phoneTxtF.placeholder = @"输入手机号";
        _phoneTxtF.delegate = self;
        [_phoneTxtF setAttributedText:UITextAutocapitalizationTypeNone];
        _phoneTxtF.font = font(15);
        _phoneTxtF.textColor = rgba(255, 255, 255, 1);
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"输入手机号" attributes:
                                          @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                            NSFontAttributeName:_phoneTxtF.font
                                          }];
        _phoneTxtF.attributedPlaceholder = attrString;
    }
    return _phoneTxtF;
    
}

- (UITextField *)phoneCodeTxtF{
    if (!_phoneCodeTxtF) {
        _phoneCodeTxtF = [UITextField new];
        _phoneCodeTxtF.backgroundColor = [UIColor clearColor];
        _phoneCodeTxtF.delegate = self;
        _phoneCodeTxtF.placeholder = @" 输入密码";
        _phoneCodeTxtF.font = font(15);
        _phoneCodeTxtF.textColor = rgba(255, 255, 255, 1);
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@" 输入密码" attributes:
                                          @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                            NSFontAttributeName:_phoneCodeTxtF.font
                                          }];
        _phoneCodeTxtF.attributedPlaceholder = attrString;
        
        
        
    }
    return _phoneCodeTxtF;
    
}


- (UILabel *)agreementLbl{
    if (!_agreementLbl) {
        _agreementLbl = [UILabel new];
        _agreementLbl.text = @"";
        _agreementLbl.textColor = [UIColor whiteColor];
        _agreementLbl.textAlignment = NSTextAlignmentLeft;
        _agreementLbl.font =font(13);
    }
    return _agreementLbl;
}


- (void)cancelAction {
    PostCancelNotification()
    if (_cancleBlock) {
        _cancleBlock();
    }
}



- (CGRect)setSameFrameButY:(CGRect)frame Y:(CGFloat)Y{
    CGRect newFrame = frame;
    newFrame.origin.y = Y;
    return newFrame;
    
}

- (void) updateBaseFrame{
    

    
    
}

//登录
- (void)loginBtnAction{
    
    
}


- (void)backBtnAction{
    
    if (self.backBlock) {
        self.phoneCodeTxtF.text= @"";
        self.phoneTxtF.text = @"";

        self.backBlock();
    }
}

- (void)getPhoneCodeBtnAction{
    
    
}
- (void) backAction{
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self endEditing:YES];
}
@end

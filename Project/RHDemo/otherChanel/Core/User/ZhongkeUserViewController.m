
#import "ZhongkeUserViewController.h"
#import "Masonry.h"
#import "YYKit.h"
#import "WTMGlyphGestureRecognizer.h"
#import "gameVersionAlertView.h"
#import "RemindView.h"
#import "VerifyIDCardSystem.h"
#import <SafariServices/SafariServices.h>
#import "NewZhongkePhoneLoginView.h"
#import "NewZhongkePwdLoginView.h"
#import "NewZhongkeRegisterView.h"
#import "NewZhongkeGetbackPwdView.h"
#import "NewZhongkeGetbackPhonePwd.h"
#import "NewZhongkeGetbackAccontPwdView.h"
#import "NewZhongkeCertificationView.h"
#import "NewZhongKeHistoryAccountView.h"
#import "NewZhongkePwdWarningView.h"
#import "newZhongkeGameProtocolView.h"
#import "NewZhongKePayView.h"
#import "UserDataModel.h"
#import "NewZhongkeWebSuspenView.h"
#import "NewZhongkeNoticeView.h"
#import "ZhongkeAccountAlertView.h"
#import "NewZhongKeViewForSupen.h"
#import "NewZhongKeplayTimeView.h"
@interface ZhongkeUserViewController ()<SFSafariViewControllerDelegate>
@property (nonatomic, strong) BaseButton *backgroundButton;
@property (nonatomic,strong)  BaseButton *btnChangeSide;
@property (nonatomic, strong) UIView * moveView;
@property (nonatomic, strong) UIImageView * bgImageview;
@property (nonatomic, strong) NewZhongkePhoneLoginView *newZhongkePhoneLoginView;
@property (nonatomic, strong) NewZhongkePwdLoginView *newzhongkePwdLoginView;
@property (nonatomic, strong) NewZhongkeRegisterView *neZhongkeRegisterView;
@property (nonatomic, strong) NewZhongkeGetbackPwdView *neewZhongkeGetbackPwdView;
@property (nonatomic, strong) NewZhongkeGetbackPhonePwd *neewZhongkeGetbackPhonePwd;
@property (nonatomic, strong) NewZhongkeGetbackAccontPwdView *neewZhongkeGetbackAccontPwdView;
@property (nonatomic, strong) NewZhongkeCertificationView *neewZhongkeCertificationView;
@property (nonatomic, strong) NewZhongKeHistoryAccountView *neewZhongKeHistoryAccountView;
@property (nonatomic, strong) newZhongkeGameProtocolView *zhongkeGameProtocolView;
@property (nonatomic, strong) NewZhongkeNoticeView *zhongkeNoticeView;
@property (nonatomic, strong) NewZhongKePayView *zhongKePayView;
@property (nonatomic, strong) gameVersionAlertView *gameVersionView;
@property (nonatomic, strong) NewZhongKeViewForSupen *zewZhongKeViewForSupen;
@property (nonatomic, strong) NewZhongKeplayTimeView *playTimeLimitView;


@property (nonatomic,assign) BOOL   isshowKeyboard;
@end

@implementation ZhongkeUserViewController
- (void)dealloc {
    DEBUGMSG(@"ZhongkeUserViewController dealloc");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    setVIEWPATH(@"");
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasHiden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cancel)
                                                 name:CancelNoticationName object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRotateChild:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
    
    NSLog(@"ZKUserViewWidth--%f",ZKUserViewWidth);
    
    AddRecognizeStarGestureRecognizer(self.view, ^{})
    
    
}

- (BaseButton *)backgroundButton{
    if (!_backgroundButton) {
        _backgroundButton = [BaseButton new];
        _backgroundButton.backgroundColor = [UIColor clearColor];
        _backgroundButton.userInteractionEnabled = YES;
        [_backgroundButton addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backgroundButton;
}

- (BaseButton *)btnChangeSide{
    if (!_btnChangeSide) {
        _btnChangeSide = [BaseButton new];
        _btnChangeSide.backgroundColor = [UIColor clearColor];
        [_btnChangeSide setBackgroundImage:[UIImage imageNamed:@"FYSDK_Resourcres.bundle/turn_left"]  forState:UIControlStateNormal];
        [_btnChangeSide addTarget:self action:@selector(sideChange:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnChangeSide;
}

- (UIImageView *)bgImageview{
    if (!_bgImageview) {
        _bgImageview = [[UIImageView alloc]init];
        _bgImageview.image = [UIImage imageNamed:@"FYSDK_Resourcres.bundle/ditu"];
    }
    return _bgImageview;
}

#pragma mark - 初始化视图
- (void)setupUI {
    
    //    [self.view addSubview:self.bgImageview];
    //    [self.bgImageview mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.width.height.equalTo(self.view);
    //        make.centerX.equalTo(self.view.mas_centerX);
    //        make.centerY.equalTo(self.view.mas_centerY);
    //    }];
    
    
    [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.and.bottom.equalTo(@0);
    }];
    [self.view addSubview:self.backgroundButton];
    
    [self.backgroundButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.view);
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
    
    
    [self.backgroundButton addSubview:self.btnChangeSide];
    [self updatebtnChangeSideFrame];
    
    
}


#pragma mark  中科--
//验证码登录
- (NewZhongkePhoneLoginView *)newZhongkePhoneLoginView{
    
    if (!_newZhongkePhoneLoginView) {
        _newZhongkePhoneLoginView = [NewZhongkePhoneLoginView new];
    }
    return _newZhongkePhoneLoginView;
}



//密码登录

- (NewZhongkePwdLoginView *)newzhongkePwdLoginView{
    
    if (!_newzhongkePwdLoginView) {
        _newzhongkePwdLoginView = [NewZhongkePwdLoginView new];
    }
    return _newzhongkePwdLoginView;
}

//找回密码
- (NewZhongkeGetbackPwdView *)neewZhongkeGetbackPwdView{
    
    if (!_neewZhongkeGetbackPwdView) {
        _neewZhongkeGetbackPwdView = [NewZhongkeGetbackPwdView new];
    }
    return _neewZhongkeGetbackPwdView;
}

//弹出公告
- (NewZhongkeNoticeView *)zhongkeNoticeView{
    
    if (!_zhongkeNoticeView) {
        _zhongkeNoticeView = [NewZhongkeNoticeView new];
    }
    return _zhongkeNoticeView;
}


//悬浮窗

- (NewZhongKeViewForSupen *)zewZhongKeViewForSupen{
    
    
    if (!_zewZhongKeViewForSupen) {
        _zewZhongKeViewForSupen = [NewZhongKeViewForSupen new];
    }
    return _zewZhongKeViewForSupen;
}

//找回手机密码
- (NewZhongkeGetbackPhonePwd *)neewZhongkeGetbackPhonePwd{
    
    if (!_neewZhongkeGetbackPhonePwd) {
        _neewZhongkeGetbackPhonePwd = [NewZhongkeGetbackPhonePwd new];
    }
    return _neewZhongkeGetbackPhonePwd;
}

//找回账号密码

- (NewZhongkeGetbackAccontPwdView *)neewZhongkeGetbackAccontPwdView{
    
    if (!_neewZhongkeGetbackAccontPwdView) {
        _neewZhongkeGetbackAccontPwdView = [NewZhongkeGetbackAccontPwdView new];
    }
    return _neewZhongkeGetbackAccontPwdView;
}


//注册账号

- (NewZhongkeRegisterView *)neZhongkeRegisterView{
    
    if (!_neZhongkeRegisterView) {
        _neZhongkeRegisterView = [NewZhongkeRegisterView new];
    }
    return _neZhongkeRegisterView;
}

//实名认证
- (NewZhongkeCertificationView *)neewZhongkeCertificationView{
    
    if (!_neewZhongkeCertificationView) {
        _neewZhongkeCertificationView = [NewZhongkeCertificationView new];
    }
    return _neewZhongkeCertificationView;
}

//切换账号
- (NewZhongKeHistoryAccountView *)neewZhongKeHistoryAccountView{
    
    if (!_neewZhongKeHistoryAccountView) {
        _neewZhongKeHistoryAccountView = [NewZhongKeHistoryAccountView new];
    }
    return _neewZhongKeHistoryAccountView;
}

//用户协议
- (newZhongkeGameProtocolView *)zhongkeGameProtocolView{
    
    if (!_zhongkeGameProtocolView) {
        _zhongkeGameProtocolView = [newZhongkeGameProtocolView new];
    }
    return _zhongkeGameProtocolView;
}

//支付
- (NewZhongKePayView *)zhongKePayView{
    
    if (!_zhongKePayView) {
        _zhongKePayView = [NewZhongKePayView new];
    }
    return _zhongKePayView;
}

#pragma mark 手机验证码登录
- (void)setUpnewZhongkePhoneLoginView{
    
    //记录界面轨迹
    NSString *p = [NSString stringWithFormat:@"%@,1",getVIEWPATH];
    setVIEWPATH(p);
    
    
    [self.view addSubview:self.newZhongkePhoneLoginView];
    if (self.btnChangeSide.selected) {
        [self setViewframeToLeftSide:self.newZhongkePhoneLoginView];
        [self animationMoveViewToLeft:self.newZhongkePhoneLoginView];
    }else{
        [self setViewframeToRightSide:self.newZhongkePhoneLoginView];
        [self animationMoveViewToRight:self.newZhongkePhoneLoginView];
    }
    //获取验证码
    __block typeof (self) bSelf = self;
    UserDataController * dc = [[UserDataController alloc]init];
    
    self.newzhongkePwdLoginView.backBlock = ^{
        
    };
    
    //获取验证码
    
    self.newZhongkePhoneLoginView.getPhoneCodeCallBlock = ^(NSString *phone) {
        [dc getPhoneCode:phone andSuccess:^(int code, NSString *msg, id object) {
            if (code == 0) {
                [[RemindView share] show:@"验证码发送成功，请注意查收" time:2.0];
                setSENDPHONE(phone);
                
            }else{
                [[RemindView share] show:msg time:2.0];
            }
        } andFailure:^(int code, NSString *msg) {
            
            [[RemindView share] show:msg time:2.0];
        }];
    };
    
    
    self.newZhongkePhoneLoginView.PhoneLoginCallBlock = ^(NSString * _Nullable phone, NSString * _Nullable phoneCode) {
        [SDKCommonMethod shared].phone =phone;
        
        COMMONMETHOD.userType = @"2";
        //根据手机号、验证码获取登录token
        [dc getLoginTokenByPhone:phone codeNum:phoneCode andSuccess:^(int code, NSString *msg, id object) {
            //登录
            
            [dc loginWithToken:object[@"data"][@"access_token"] uid:object[@"data"][@"uid"] PassWord:object[@"data"][@"password_plaintext"] sub_uid:@"" andSuccess:^(int code, NSString *msg, id object) {
                if (code == 0) {
                    if (COMMONMETHOD.password_plaintext.length > 0) {
                        ZhongkeAccountAlertView *view = [[ZhongkeAccountAlertView alloc]init];
                        view.submitBtnBlock = ^{
                            [dc saveScreenshotWithUserName:COMMONMETHOD.userName andPassWork:COMMONMETHOD.password_plaintext];
                        };
                        [view show];
                    }
                    
                    [bSelf cancel];
                    
                    [bSelf animationRemoveView:bSelf.newZhongkePhoneLoginView];
                    
                    [[VerifyIDCardSystem shared] showCertificationViewIfNeeded];
                }else{
                    
                    [[RemindView share] show:msg time:2.0];
                }
                
            } andFailure:^(int code, NSString *msg) {
                [[RemindView share] show:msg time:2.0];
            }];
            
        } andFailure:^(int code, NSString *msg) {
            
            [[RemindView share] show:msg time:2.0];
        }];
    };
    
    
    //注册账号
    self.newZhongkePhoneLoginView.goRegisterCallBack = ^{
        [bSelf animationRemoveView:bSelf.newZhongkePhoneLoginView];
        [bSelf setUpnewZhongkeRegisterView];
    };
    
    
    //密码登录
    self.newZhongkePhoneLoginView.goPwdLoginCallBack = ^{
        [bSelf animationRemoveView:bSelf.newZhongkePhoneLoginView];
        [bSelf setUpnewzhongkePwdLoginView];
    };
    
    self.newZhongkePhoneLoginView.backBlock = ^{
        [bSelf animationRemoveView:bSelf.newZhongkePhoneLoginView];
        [bSelf setupneewZhongKeHistoryAccountView];
    };
    
    self.newZhongkePhoneLoginView.userProCallBlock = ^(NSString * _Nonnull proStr) {
        [bSelf animationRemoveView:bSelf.newZhongkePhoneLoginView];
        [bSelf setupnewZhongkeGameProtocolView:proStr withTypeView:@"PhoneLoginView"];
    };
}


#pragma mark 账号、密码登录
- (void)setUpnewzhongkePwdLoginView{
    //记录界面轨迹
    NSString *p = [NSString stringWithFormat:@"%@,5",getVIEWPATH];
    setVIEWPATH(p);
    
    [self.view addSubview:self.newzhongkePwdLoginView];
    
    if (self.btnChangeSide.selected) {
        [self setViewframeToLeftSide:self.newzhongkePwdLoginView];
        [self animationMoveViewToLeft:self.newzhongkePwdLoginView];
    }else{
        [self setViewframeToRightSide:self.newzhongkePwdLoginView];
        [self animationMoveViewToRight:self.newzhongkePwdLoginView];
    }
    
    
    __block typeof (self) bSelf = self;
    UserDataController * dc = [[UserDataController alloc]init];
    
    
    //登录
    self.newzhongkePwdLoginView.LoginCallBlock = ^(NSString * _Nullable name, NSString * _Nullable pwd) {
        //获取登录token
        COMMONMETHOD.userName = name;
        COMMONMETHOD.password = pwd;
        [dc getLoginTokenByUserName:name PassWord:pwd Success:^(int code, NSString *msg, id object) {
            COMMONMETHOD.userType = @"1";
            [dc loginWithToken:object[@"data"][@"access_token"] uid:object[@"data"][@"uid"] PassWord:@"" sub_uid:@"" andSuccess:^(int code, NSString *msg, id object) {
                
                if (code == 0) {
                    [bSelf cancel];
                    [bSelf animationRemoveView:bSelf.newzhongkePwdLoginView];
                    [[VerifyIDCardSystem shared] showCertificationViewIfNeeded];
                    
                }else{
                    
                    [[RemindView share] show:msg time:2.0];
                }
                
            } andFailure:^(int code, NSString *msg) {
                [[RemindView share] show:msg time:2.0];
            }];
            
        } Failure:^(int code, NSString *msg) {
            [[RemindView share] show:msg time:2.0];
        }];
        
        
    };
    
    
    //找回密码
    self.newzhongkePwdLoginView.getBackPwdCallBlock = ^{
        [bSelf animationRemoveView:bSelf.newzhongkePwdLoginView];
        [bSelf setUpneewZhongkeGetbackPwdView];
    };
    
    self.newzhongkePwdLoginView.backBlock = ^{
        [bSelf animationRemoveView:bSelf.newzhongkePwdLoginView];
        [bSelf setUpnewZhongkePhoneLoginView];
    };
    
    self.newzhongkePwdLoginView.userProCallBlock = ^(NSString *proStr) {
        [bSelf animationRemoveView:bSelf.newzhongkePwdLoginView];
        [bSelf setupnewZhongkeGameProtocolView:proStr withTypeView:@"PwdLoginView"];
    };
}


#pragma mark   用户 注册
- (void)setUpnewZhongkeRegisterView{
    //记录界面轨迹
    NSString *p = [NSString stringWithFormat:@"%@,6",getVIEWPATH];
    setVIEWPATH(p);
    [self.view addSubview:self.neZhongkeRegisterView];
    
    if (self.btnChangeSide.selected) {
        [self setViewframeToLeftSide:self.neZhongkeRegisterView];
        [self animationMoveViewToLeft:self.neZhongkeRegisterView];
    }else{
        [self setViewframeToRightSide:self.neZhongkeRegisterView];
        [self animationMoveViewToRight:self.neZhongkeRegisterView];
    }
    __block typeof (self) bSelf = self;
    
    self.neZhongkeRegisterView.backBlock = ^{
        [bSelf animationRemoveView:bSelf.neZhongkeRegisterView];
        [bSelf setUpnewZhongkePhoneLoginView];
    };
    
    UserDataController * dc = [[UserDataController alloc]init];
    self.neZhongkeRegisterView.registerCallBlock = ^(NSString * _Nullable userName, NSString * _Nullable pwd) {
        
        [dc checkUserName:userName andSuccess:^(int code, NSString *msg, id object) {
            [dc registeredUserName:userName andPassWord:pwd andSuccess:^(int code, NSString *msg, id object) {
                if (code == 0) {
                    //登录
                    COMMONMETHOD.userType = @"1";
                    [dc loginWithToken:object[@"data"][@"access_token"] uid:[NSString stringWithFormat:@"%@",object[@"data"][@"uid"]] PassWord:@"" sub_uid:@"" andSuccess:^(int code, NSString *msg, id object) {
                        if (code == 0) {
                            [bSelf cancel];
                            [bSelf animationRemoveView:bSelf.neZhongkeRegisterView];
                            [[VerifyIDCardSystem shared] showCertificationViewIfNeeded];
                        }else{
                            
                            [[RemindView share] show:msg time:2.0];
                        }
                    } andFailure:^(int code, NSString *msg) {
                        [[RemindView share] show:msg time:2.0];
                    }];
                    
                }else{
                    [[RemindView share] show:msg time:2.0];
                }
            } andFailure:^(int code, NSString *msg) {
                [[RemindView share] show:msg time:2.0];
            }];
        } andFailure:^(int code, NSString *msg) {
            [[RemindView share] show:msg time:2.0];
        }];
        
    };
    
    self.neZhongkeRegisterView.registerErrorCallBlock = ^(NSString * _Nullable userName, NSString * _Nullable pwd) {
        NewZhongkePwdWarningView *warnView = [[NewZhongkePwdWarningView alloc]init];
        [bSelf.view addSubview:warnView];
        warnView.sureCallBlock = ^{
            [dc registeredUserName:userName andPassWord:pwd andSuccess:^(int code, NSString *msg, id object) {
                if (code == 0) {
                    //登录
                    [dc loginWithToken:object[@"data"][@"access_token"] uid:object[@"data"][@"uid"] PassWord:@"" sub_uid:@"" andSuccess:^(int code, NSString *msg, id object) {
                        if (code == 0) {
                            [bSelf cancel];
                            [bSelf animationRemoveView:bSelf.neZhongkeRegisterView];
                            [[VerifyIDCardSystem shared] showCertificationViewIfNeeded];
                        }else{
                            [[RemindView share] show:msg time:2.0];
                        }
                    } andFailure:^(int code, NSString *msg) {
                        [[RemindView share] show:msg time:2.0];
                    }];
                }else{
                    [[RemindView share] show:msg time:2.0];
                }
            } andFailure:^(int code, NSString *msg) {
                [[RemindView share] show:msg time:2.0];
            }];
        };
    };
    
    self.neZhongkeRegisterView.userProCallBlock = ^(NSString * _Nonnull proStr) {
        [bSelf animationRemoveView:bSelf.neZhongkeRegisterView];
        [bSelf setupnewZhongkeGameProtocolView:proStr withTypeView:@"RegisterView"];
    };
}

#pragma mark  找回密码
- (void)setUpneewZhongkeGetbackPwdView{
    
    [self.view addSubview:self.neewZhongkeGetbackPwdView];
    
    if (self.btnChangeSide.selected) {
        [self setViewframeToLeftSide:self.neewZhongkeGetbackPwdView];
        [self animationMoveViewToLeft:self.neewZhongkeGetbackPwdView];
    }else{
        [self setViewframeToRightSide:self.neewZhongkeGetbackPwdView];
        [self animationMoveViewToRight:self.neewZhongkeGetbackPwdView];
    }
    
    __block typeof (self) bSelf = self;
    
    self.neewZhongkeGetbackPwdView.backBlock = ^{
        
        [bSelf animationRemoveView:bSelf.neewZhongkeGetbackPwdView];
        [bSelf setUpnewzhongkePwdLoginView];
    };
    
    UserDataController * dc = [[UserDataController alloc]init];
    self.neewZhongkeGetbackPwdView.nextCallBlock = ^(NSString * _Nullable userAccount) {
        [dc getUserInfoByName:userAccount andSuccess:^(int code, NSString *msg, id object) {
            if (code == 0) {
                [bSelf animationRemoveView:bSelf.neewZhongkeGetbackPwdView];
                NSLog(@"object--%@",object);
                if ([NSString stringWithFormat:@"%@",object[@"data"][@"phone"]].length > 0) {
                    COMMONMETHOD.phone =object[@"data"][@"phone"];
                    [bSelf setUpneewZhongkeGetbackPhonePwd];
                    
                }else{
                    
                    [bSelf setUpneewZhongkeGetbackAccontPwdView];
                }
                
                COMMONMETHOD.uid =[NSString stringWithFormat:@"%@",object[@"data"][@"uid"]] ;
                
            }
        } andFailure:^(int code, NSString *msg) {
            if (code == -2) {
                [TempUserMessage share].account = userAccount;
                [bSelf animationRemoveView:bSelf.neewZhongkeGetbackPwdView];
                [bSelf setUpneewZhongkeGetbackAccontPwdView];
            }else
                [[RemindView share] show:msg time:2.0];
        }];
        
    };
    
}

#pragma mark 通过手机号码找回密码-
- (void)setUpneewZhongkeGetbackPhonePwd{
    
    //记录界面轨迹
    NSString *p = [NSString stringWithFormat:@"%@,10",getVIEWPATH];
    setVIEWPATH(p);
    
    
    [self.view addSubview:self.neewZhongkeGetbackPhonePwd];
    
    if (self.btnChangeSide.selected) {
        [self setViewframeToLeftSide:self.neewZhongkeGetbackPhonePwd];
        [self animationMoveViewToLeft:self.neewZhongkeGetbackPhonePwd];
    }else{
        [self setViewframeToRightSide:self.neewZhongkeGetbackPhonePwd];
        [self animationMoveViewToRight:self.neewZhongkeGetbackPhonePwd];
    }
    
    __block typeof (self) bSelf = self;
    
    self.neewZhongkeGetbackPhonePwd.backBlock = ^{
        
        [bSelf animationRemoveView:bSelf.neewZhongkeGetbackPhonePwd];
        [bSelf setUpneewZhongkeGetbackPwdView];
    };
    
    UserDataController * dc = [[UserDataController alloc]init];
    
    self.neewZhongkeGetbackPhonePwd.getPhoneCodeCallBlock = ^(NSString *phone) {
        
        [dc getPhoneByUid:COMMONMETHOD.uid andSuccess:^(int code, NSString *msg, id object) {
            if (code == 0) {
                [[RemindView share] show:@"验证码发送成功，请注意查收" time:2.0];
            }else
                [[RemindView share] show:msg time:2.0];
        } andFailure:^(int code, NSString *msg) {
            [[RemindView share] show:msg time:2.0];
        }];
        
    };
    
    //确认修改
    self.neewZhongkeGetbackPhonePwd.resetPwdCallBlock = ^(NSString * _Nullable phoneCode, NSString * _Nullable pwd) {
        //重置密码
        [dc resetNewPassword:COMMONMETHOD.phone num: phoneCode password:pwd andSuccess:^(int code, NSString *msg, id object) {
            if (code == 0) {
                [bSelf animationRemoveView:bSelf.neewZhongkeGetbackPhonePwd];
                [bSelf setUpnewzhongkePwdLoginView];
                [[RemindView share] show:msg time:2.0];
            }
            
        } andFailure:^(int code, NSString *msg) {
            
            [[RemindView share] show:msg time:2.0];
        }];
        
    };
    
}

#pragma mark 找回密码-客服
- (void)setUpneewZhongkeGetbackAccontPwdView{
    //记录界面轨迹
    NSString *p = [NSString stringWithFormat:@"%@,8",getVIEWPATH];
    setVIEWPATH(p);
    
    [self.view addSubview:self.neewZhongkeGetbackAccontPwdView];
    
    
    if (self.btnChangeSide.selected) {
        [self setViewframeToLeftSide:self.neewZhongkeGetbackAccontPwdView];
        [self animationMoveViewToLeft:self.neewZhongkeGetbackAccontPwdView];
    }else{
        [self setViewframeToRightSide:self.neewZhongkeGetbackAccontPwdView];
        [self animationMoveViewToRight:self.neewZhongkeGetbackAccontPwdView];
    }
    __block typeof (self) bSelf = self;
    
    self.neewZhongkeGetbackAccontPwdView.backBlock = ^{
        
        [bSelf animationRemoveView:bSelf.neewZhongkeGetbackAccontPwdView];
        [bSelf cancel];
    };
}

#pragma mark  用户协议
- (void)setupnewZhongkeGameProtocolView:(NSString *)postr withTypeView:(NSString *)strType{
    //记录界面轨迹
    self.zhongkeGameProtocolView.proStr = postr;
    if ([postr isEqualToString:@"用户协议"]) {
        self.zhongkeGameProtocolView.loadUrlStr = [sdkInitModel share].userPrivacy;
    }else{
        self.zhongkeGameProtocolView.loadUrlStr = [sdkInitModel share].privacy;
    }
    
    [self.view addSubview:self.zhongkeGameProtocolView];
    
    if (self.btnChangeSide.selected) {
        [self setViewframeToLeftSide:self.zhongkeGameProtocolView];
        [self animationMoveViewToLeft:self.zhongkeGameProtocolView];
    }else{
        [self setViewframeToRightSide:self.zhongkeGameProtocolView];
        [self animationMoveViewToRight:self.zhongkeGameProtocolView];
    }
    [self.zhongkeGameProtocolView loadRequestUrl];
    __block typeof (self) bSelf = self;
    self.zhongkeGameProtocolView.backBlock = ^{
        [bSelf animationRemoveView:bSelf.zhongkeGameProtocolView];
        if ([strType isEqualToString:@"PhoneLoginView"]) {
            [bSelf setUpnewZhongkePhoneLoginView];
        }else if([strType isEqualToString:@"PwdLoginView"]){
            [bSelf setUpnewzhongkePwdLoginView];
        }
        else {
            [bSelf setUpnewZhongkeRegisterView];
            
        }
        
    };
}

#pragma mark 公告
- (void)setupzhongkeNoticeView{
    [self.view addSubview:self.zhongkeNoticeView];
    if (self.btnChangeSide.selected) {
        [self setViewframeToLeftSide:self.zhongkeNoticeView];
        [self animationMoveViewToLeft:self.zhongkeNoticeView];
    }else{
        [self setViewframeToRightSide:self.zhongkeNoticeView];
        [self animationMoveViewToRight:self.zhongkeNoticeView];
    }
    
    __block typeof (self) bSelf = self;
    self.zhongkeNoticeView.goBackBlock = ^(NSString *type){
        if ([type isEqualToString:@"2"]) {
            [bSelf cancel];
        }else{
            [bSelf animationRemoveView:bSelf.zhongkeNoticeView];
            if ([NSUserDefaults takeoutNSUserDefault:LASTLOGINUID]) {
                NSArray *array = [UserDataModel selectUserAccount:[NSUserDefaults takeoutNSUserDefault:LASTLOGINUID]];
                if (array.count>0) {
                    [bSelf setupneewZhongKeHistoryAccountView];
                }else{
                    [bSelf setUpnewZhongkePhoneLoginView];
                }
            }else {
                [bSelf setUpnewZhongkePhoneLoginView];
            }
        }
    };
}

#pragma mark 实名认证
- (void)setUpneewZhongkeCertificationView{
    
    __block typeof (self) bSelf = self;
    [self.view addSubview:self.neewZhongkeCertificationView];
    
    if (self.btnChangeSide.selected) {
        [self setViewframeToLeftSide:self.neewZhongkeCertificationView];
        [self animationMoveViewToLeft:self.neewZhongkeCertificationView];
    }else{
        [self setViewframeToRightSide:self.neewZhongkeCertificationView];
        [self animationMoveViewToRight:self.neewZhongkeCertificationView];
    }
    
    self.neewZhongkeCertificationView.userCertifiCallBlock = ^(NSString * _Nullable UserName, NSString * _Nullable idcard,NSString *_Nullable token) {
        
        [[VerifyIDCardSystem shared] certificateWithRealName:UserName IDNum:idcard complete:^(BOOL succeed, NSString *message) {
            if (succeed) {
                [SDKCommonMethod shared].userHaveVerId = YES;
                [TempUserMessage share].idcard = idcard;
                
                [bSelf animationRemoveView:bSelf.neewZhongkeCertificationView];
                if ([sdkInitModel share].afterlogin.count > 0) {//弹出登录后的公告
                    [bSelf setupzhongkeNoticeView];
                }else{
                    [bSelf cancel];
                }
            }else{
                if ([message isEqualToString:@"用户已实名，暂不支持修改"]) {
                    [SDKCommonMethod shared].userHaveVerId = YES;
                    [TempUserMessage share].idcard = idcard;
                    
                    if ([sdkInitModel share].afterlogin.count > 0) {//弹出登录后的公告
                        [bSelf setupzhongkeNoticeView];
                    }else{
                        [bSelf cancel];
                    }
                }
                
            }
        }];
    };
    
    self.neewZhongkeCertificationView.backBlock = ^{
        [bSelf cancel];
    };
}


//支付
- (void)setupneewZhongKePayView:(NSString *)urlStr{
    
    __block typeof (self) bSelf = self;
    [self.view addSubview:self.zhongKePayView];
    self.zhongKePayView.urlStr = urlStr;
    
    if (self.btnChangeSide.selected) {
        [self setViewframeToLeftSide:self.zhongKePayView];
        [self animationMoveViewToLeft:self.zhongKePayView];
    }else{
        [self setViewframeToRightSide:self.zhongKePayView];
        [self animationMoveViewToRight:self.zhongKePayView];
    }
    
    
    self.zhongKePayView.backBlock = ^{
        [bSelf cancel];
    };
}


- (NewZhongKeplayTimeView *)playTimeLimitView{
    if (!_playTimeLimitView) {
        _playTimeLimitView = [NewZhongKeplayTimeView new];
    }
    
    return _playTimeLimitView;
}

//防沉迷
- (void)setupplayTimeLimitView:(NSString *)showTisStr{
    
    [self.view addSubview:self.playTimeLimitView];
    if (self.btnChangeSide.selected) {
        [self setViewframeToLeftSide:self.playTimeLimitView];
        [self animationMoveViewToLeft:self.playTimeLimitView];
    }else{
        [self setViewframeToRightSide:self.playTimeLimitView];
        [self animationMoveViewToRight:self.playTimeLimitView];
    }
    self.playTimeLimitView.contentview.text = showTisStr?showTisStr:@"根据防沉迷规定，除每周五、六、日的20点至21点外，其它时间未成年人不能进入游戏";
    
    self.playTimeLimitView.submitBtnBlock = ^{
        exit(0);
    };
}


#pragma mark 历史账号登录界面
- (void)setupneewZhongKeHistoryAccountView{
    //记录界面轨迹
    NSString *p = [NSString stringWithFormat:@"%@,1",getVIEWPATH];
    setVIEWPATH(p);
    [self.view addSubview:self.neewZhongKeHistoryAccountView];
    if (self.btnChangeSide.selected) {
        [self setViewframeToLeftSide:self.neewZhongKeHistoryAccountView];
        [self animationMoveViewToLeft:self.neewZhongKeHistoryAccountView];
    }else{
        [self setViewframeToRightSide:self.neewZhongKeHistoryAccountView];
        [self animationMoveViewToRight:self.neewZhongKeHistoryAccountView];
    }
    
    
    __block typeof (self) bSelf = self;
    self.neewZhongKeHistoryAccountView.otherLoginCallBlock = ^{
        [bSelf animationRemoveView:bSelf.neewZhongKeHistoryAccountView];
        [bSelf setUpnewZhongkePhoneLoginView];
        bSelf.newZhongkePhoneLoginView.backBtn.hidden = NO;
        
    };
    
    UserDataController * dc = [[UserDataController alloc]init];
    self.neewZhongKeHistoryAccountView.loginCallBlock = ^(NSString * _Nullable uid,NSString * _Nullable userName, NSString * _Nullable pwd, NSString * _Nullable token, NSString * _Nonnull sub_uid) {
        
        NSArray *array = [UserDataModel selectUserAccount:uid];
        UserModel *userAccount = nil;
        if (array.count>0) {
            userAccount = array[0];
        }
        COMMONMETHOD.uid = [NSString stringWithFormat:@"%@",userAccount.uid];
        COMMONMETHOD.userName = userAccount.userName;
        COMMONMETHOD.password = userAccount.passWord;
        COMMONMETHOD.access_token =userAccount.access_token;
        COMMONMETHOD.sub_uid = userAccount.sub_uid;
        COMMONMETHOD.refresh_token = userAccount.refresh_token;
        
        //刷新token未过期
        if([SDKCommonMethod returnRefreshTokenDeadLine:[NSUserDefaults takeoutNSUserDefault:LASTLOGINUID]]){
            //登录token未过期
            if([SDKCommonMethod returnExpiresinDeadLine:[NSUserDefaults takeoutNSUserDefault:LASTLOGINUID]]){
                //小于any小时
                
                NSLog(@"--access_token-%@----uid--%@,sub_%@,pwd--%@",token,uid,sub_uid,pwd);
                [dc loginFast:uid andPassWord:pwd userToken:token childUserId:sub_uid andSuccess:^(int code, NSString *msg, id object) {
                    if (code == 0) {
                        
                        [bSelf cancel];
                        [bSelf animationRemoveView:bSelf.neewZhongKeHistoryAccountView];
                        [[VerifyIDCardSystem shared] showCertificationViewIfNeeded];
                    }
                    
                } andFailure:^(int code, NSString *msg) {
                    
                    if (code == -1001){//授权未通过，请重新登录
                        [[RemindView share] show:msg time:2.0];
                        [bSelf animationRemoveView:bSelf.neewZhongKeHistoryAccountView];
                        [bSelf setUpnewZhongkePhoneLoginView];
                        bSelf.newZhongkePhoneLoginView.backBtn.hidden = YES;
                        
                    }else{
                        [[RemindView share] show:msg time:2.0];
                        
                    }
                    
                }];
            }else{//过期了
                [bSelf zhongKeHistoryAccountRefreshTokenWhenLogin:dc];
            }
        }else{//过期则需要通过手机验证码或账号密码获取 token
            [bSelf animationRemoveView:bSelf.neewZhongKeHistoryAccountView];
            [bSelf setUpnewZhongkePhoneLoginView];
            bSelf.newZhongkePhoneLoginView.backBtn.hidden = YES;
        }
        
    };
    
}

- (void)zhongKeHistoryAccountRefreshTokenWhenLogin:(UserDataController *)userData{
    __block typeof (self) bSelf = self;
    requestRefreshTokenModel *model = [[requestRefreshTokenModel alloc]initRequestRefreshTokenModel:COMMONMETHOD.uid sub_uid:COMMONMETHOD.sub_uid refresh_token:COMMONMETHOD.refresh_token];
    NSLog(@"COMMONMETHOD.refresh_token--%@",COMMONMETHOD.refresh_token);
    [sdkRequestManager startRequestWithModel:model succeedBlock:^(id responseObject) {
        ResponseModel * model = [ResponseModel modelWithJSON:responseObject];
        if (model.code == 0) {
            
            COMMONMETHOD.refresh_token =responseObject[@"data"][@"refresh_token"];
            COMMONMETHOD.access_token =responseObject[@"data"][@"access_token"];
            
            [UserDataModel updateUserAccesstokenByuid:COMMONMETHOD.uid access_token:responseObject[@"data"][@"access_token"] refresh_token:responseObject[@"data"][@"refresh_token"] expires_in:[NSString stringWithFormat:@"%d",[responseObject[@"data"][@"expires_in"] intValue] + [[SDKCommonMethod getTimeStamp] intValue]] refresh_token_expires_in:[NSString stringWithFormat:@"%d",[responseObject[@"data"][@"refresh_token_expires_in"] intValue] + [[SDKCommonMethod getTimeStamp] intValue]]];
            
            [userData loginFast:COMMONMETHOD.uid andPassWord:COMMONMETHOD.password userToken:responseObject[@"data"][@"access_token"] childUserId:COMMONMETHOD.sub_uid andSuccess:^(int code, NSString *msg, id object) {
                if (code == 0) {
                    [bSelf cancel];
                    [bSelf animationRemoveView:bSelf.neewZhongKeHistoryAccountView];
                    [[VerifyIDCardSystem shared] showCertificationViewIfNeeded];
                }else{
                    [[RemindView share] show:msg time:2.0];
                }
            } andFailure:^(int code, NSString *msg) {
                
                if (code == -6){
                    
                    [[RemindView share] show:msg time:2.0];
                }else
                    [[RemindView share] show:msg time:2.0];
            }];
        }else{
            [[RemindView share] show:responseObject[@"msg"] time:2.0];
            
        }
    }];
}



- (void)setupWebSupenView:(NSString *)urlStr{
    __block typeof (self) bSelf = self;
    
    [self.view addSubview:self.zewZhongKeViewForSupen];
    if (self.btnChangeSide.selected) {
        [self setViewframeToLeftSide:self.zewZhongKeViewForSupen];
        [self animationMoveViewToLeft:self.zewZhongKeViewForSupen];
    }else{
        [self setViewframeToRightSide:self.zewZhongKeViewForSupen];
        [self animationMoveViewToRight:self.zewZhongKeViewForSupen];
    }
    
    [self.zewZhongKeViewForSupen reloadAtUrl:urlStr];
    self.zewZhongKeViewForSupen.backBlock = ^{
        [bSelf cancel];
    };
    
}

- (gameVersionAlertView *)gameVersionView{
    
    if (!_gameVersionView) {
        _gameVersionView = [[gameVersionAlertView alloc]init];
    }
    return _gameVersionView;
    
}


#pragma mark 强更新
- (void)setupgameVersionAlertView{
    
    [self.view addSubview:self.gameVersionView];
    
    if (self.btnChangeSide.selected) {
        [self setViewframeToLeftSide:self.gameVersionView];
        [self animationMoveViewToLeft:self.gameVersionView];
    }else{
        [self setViewframeToRightSide:self.gameVersionView];
        [self animationMoveViewToRight:self.gameVersionView];
    }
    NSString *landing_url =  INITCONFIGURE.landing_url?INITCONFIGURE.landing_url:@"https://hahhaha.com" ;
    //跳转到其他窗口
    self.gameVersionView.submitBtnBlock = ^(NSString * _Nonnull phone) {
        NSLog(@"landing_url---%@",landing_url);
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:landing_url]];
    };
    
}





#pragma mark 视图开始出现时候 动画移动视图到右边、左边
- (void)animationMoveViewToRight:(UIView*)view {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    view.alpha = 1;
    _moveView = view;
    __block typeof (ZhongkeUserViewController*) bSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [bSelf moveViewToright:view];
        
        if(bSelf.view.subviews.lastObject != view) {
            [bSelf.view insertSubview:view aboveSubview:bSelf.view.subviews.lastObject];
        }
        [UIView animateWithDuration:0.25 animations:^{
            [bSelf.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    });
    
}

- (void)animationMoveViewToLeft:(UIView*)view {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    view.alpha = 1;
    _moveView = view;
    __block typeof (ZhongkeUserViewController*) bSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [bSelf moveViewToleft:view];
        
        if(bSelf.view.subviews.lastObject != view) {
            [bSelf.view insertSubview:view aboveSubview:bSelf.view.subviews.lastObject];
        }
        [UIView animateWithDuration:0.25 animations:^{
            [bSelf.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    });
}

#pragma mark 动画移除
- (void)animationRemoveView:(UIView*)view {
    [self.view endEditing:YES];
    __block typeof (ZhongkeUserViewController*) bSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.0 animations:^{
            [bSelf.view layoutIfNeeded];
            view.alpha = 0;
            [view removeFromSuperview];
        } completion:^(BOOL finished) {
        }];
    });
}


#pragma mark --- 自动布局
- (void)setViewframeToLeftSide:(UIView *)view {
    UIInterfaceOrientation sataus=[UIApplication sharedApplication].statusBarOrientation;
    [view mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(ZKUserViewWidth);
        make.left.mas_equalTo(@0);
        
        
        if (sataus == UIInterfaceOrientationPortrait || sataus == UIInterfaceOrientationPortraitUpsideDown) {//竖屏
            make.height.mas_equalTo(ZKUserViewHeight);
            make.bottom.mas_equalTo(0);
        }else{
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(windowHeight);
        }
        
        
        
        
    }];
}

- (void)setViewframeToRightSide:(UIView *)view {
    UIInterfaceOrientation sataus=[UIApplication sharedApplication].statusBarOrientation;
    [view mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(ZKUserViewWidth);
        make.right.mas_equalTo(@0);
        if (sataus == UIInterfaceOrientationPortrait || sataus == UIInterfaceOrientationPortraitUpsideDown) {//竖屏
            make.height.mas_equalTo(ZKUserViewHeight);
            make.bottom.mas_equalTo(0);
        }else{
            make.height.mas_equalTo(windowHeight);
            make.centerY.mas_equalTo(0);
        }
        
    }];
}



#pragma mark 视图左右移动
- (void)moveViewToright:(UIView *)view {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = CGRectMake(windowWidth-ZKUserViewWidth, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
        view.frame = frame;
        [view setFrame:frame];
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)moveViewToleft:(UIView *)view {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = CGRectMake(0, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
        view.frame = frame;
        [view setFrame:frame];
    } completion:^(BOOL finished) {
        
    }];
    
    
}


#pragma mark - Action

- (void)clickAction {
    [self.view endEditing:YES];
    
    NSLog(@"touchesBegan--touchesBegan");
    if ([self.moveView isMemberOfClass:[NewZhongKePayView class]]) {
        [self cancel];
        [[NewZhongkeWebSuspenView shared] showSuspension];
    }else if([self.moveView isMemberOfClass:[NewZhongKeViewForSupen class]]){
        [self.zewZhongKeViewForSupen dismissAction];
    }
    
}

- (void)sideChange:(UIButton *)sender{
    
    sender.selected =!sender.selected;
    if (sender.selected) {//移到左边
        [self moveViewToleft:self.moveView];
    }else{//在右边
        [self moveViewToright:self.moveView];
    }
    
    [self updatebtnChangeSideFrame];
    
    if ([self.moveView isMemberOfClass:[NewZhongKeViewForSupen class]]) {
        [self.zewZhongKeViewForSupen btnChangeViewFrame:sender];
    }
}

#pragma mark - NSNotification

- (void)keyboardWasShown:(NSNotification*)notification {
    
    if (self.isshowKeyboard) {
        return;
    }
    self.self.isshowKeyboard = YES;
    float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect frame = CGRectMake(self.moveView.frame.origin.x, self.moveView.frame.origin.y-90, self.moveView.frame.size.width, self.moveView.frame.size.height);
    [UIView animateWithDuration:animationDuration animations:^{
        self.moveView.frame = frame;
        [self.moveView setFrame:frame];
    } completion:^(BOOL finished) {
        
    }];
    
    
}

- (void)keyboardWasHiden:(NSNotification*)notification {
    self.self.isshowKeyboard = NO;
    float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect frame = CGRectMake(self.moveView.frame.origin.x, self.moveView.frame.origin.y+90, self.moveView.frame.size.width, self.moveView.frame.size.height);
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.moveView.frame = frame;
        [self.moveView setFrame:frame];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)cancel {
    //标识SDK关闭
    COMMONMETHOD.recordShowSDK = 0;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.view removeFromSuperview];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil;
    if(error != NULL){
        msg = @"保存图片失败";
    } else {
        msg = @"账号密码已保存至相册";
        UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:@"提示框" message:msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *pickAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [actionSheetController addAction:pickAction];
        [self presentViewController:actionSheetController animated:YES completion:nil];
    }
}

- (void)changeRotateChild:(NSNotification*)noti {
    
    UIInterfaceOrientation sataus=[UIApplication sharedApplication].statusBarOrientation;
    [_moveView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ZKUserViewWidth);
        if (self.btnChangeSide.selected) {
            if (sataus == UIInterfaceOrientationPortrait || sataus == UIInterfaceOrientationPortraitUpsideDown) {//竖屏
                make.height.mas_equalTo(ZKUserViewHeight);
                make.bottom.mas_equalTo(0);
            }else{
                make.height.mas_equalTo(windowHeight);
                make.centerY.mas_equalTo(0);
            }
            make.left.mas_equalTo(@0);
        }else{
            if (sataus == UIInterfaceOrientationPortrait || sataus == UIInterfaceOrientationPortraitUpsideDown) {//竖屏
                make.height.mas_equalTo(ZKUserViewHeight);
                make.bottom.mas_equalTo(0);
            }else{
                make.height.mas_equalTo(windowHeight);
                make.centerY.mas_equalTo(0);
            }
            make.right.mas_equalTo(@0);
        }
        
        
    }];
    [self updatebtnChangeSideFrame];
}

- (void)updatebtnChangeSideFrame{
    
    UIInterfaceOrientation sataus=[UIApplication sharedApplication].statusBarOrientation;
    
    if (self.btnChangeSide.selected) {//移到左边
        
        if (sataus == UIInterfaceOrientationPortrait || sataus == UIInterfaceOrientationPortraitUpsideDown) {//竖屏
            self.btnChangeSide.frame  = CGRectMake(windowWidth-SCREEN_FIT(30), (windowHeight-SCREEN_FIT(40))/2, SCREEN_FIT(30), SCREEN_FIT(40));
        }else{
            self.btnChangeSide.frame  = CGRectMake(windowWidth-SCREEN_FIT(50)-SCREEN_FIT(30), (windowHeight-SCREEN_FIT(40))/2, SCREEN_FIT(30), SCREEN_FIT(40));
        }
        [self.btnChangeSide setBackgroundImage:[UIImage imageNamed:@"FYSDK_Resourcres.bundle/turn_right"]  forState:UIControlStateNormal];
    }else{//在右边
        
        if (sataus == UIInterfaceOrientationPortrait || sataus == UIInterfaceOrientationPortraitUpsideDown) {//竖屏
            self.btnChangeSide.frame  = CGRectMake(SCREEN_FIT(0), (windowHeight-SCREEN_FIT(40))/2, SCREEN_FIT(30), SCREEN_FIT(40));
        }else{
            self.btnChangeSide.frame  = CGRectMake(SCREEN_FIT(30), (windowHeight-SCREEN_FIT(40))/2, SCREEN_FIT(30), SCREEN_FIT(40));
        }
        [self.btnChangeSide setBackgroundImage:[UIImage imageNamed:@"FYSDK_Resourcres.bundle/turn_left"]  forState:UIControlStateNormal];
    }
    
    
}

@end

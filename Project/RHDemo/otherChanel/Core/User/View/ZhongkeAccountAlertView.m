

#import "ZhongkeAccountAlertView.h"
#import "BaseView.h"
#import "ZhongkeView.h"
@interface ZhongkeAccountAlertView ()
@property (nonatomic,strong) UIButton *submitBtn;
@property (nonatomic,strong)  UILabel   *TitleLbl;
@property (nonatomic,strong)  UILabel   *tipsLbl;
@property (nonatomic,strong)  UILabel   *userNameLbl;
@property (nonatomic,strong)  UILabel   *PwdLbl;
@end


@implementation ZhongkeAccountAlertView

- (instancetype) init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake((windowWidth-SCREEN_FIT(300))/2, (windowHeight-SCREEN_FIT(180))/2, SCREEN_FIT(300), SCREEN_FIT(230));
        self.backgroundColor =  [UIColor whiteColor];
        [self addSubview:self.TitleLbl];
        [self addSubview:self.tipsLbl];
        [self addSubview:self.submitBtn];
        [self addSubview:self.userNameLbl];
        [self addSubview:self.PwdLbl];
        self.layer.cornerRadius= 10;
        self.layer.masksToBounds = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRotateNewZhongkeView:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
        [self updateFrame];
    }
    return self;
}



- (UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [UIButton new];
        [_submitBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:rgba(116, 58, 7, 1) forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:SCREEN_FIT(20)];
        _submitBtn.backgroundColor = rgba(252, 197, 105, 1);
        _submitBtn.layer.cornerRadius = 5;
        _submitBtn.layer.masksToBounds = YES;
        [_submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(submitBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}


- (UILabel *)TitleLbl{
    if (!_TitleLbl) {
        _TitleLbl = [UILabel new];
        _TitleLbl.font = [UIFont systemFontOfSize:18.0f];
         _TitleLbl.textColor = [UIColor blackColor];
        _TitleLbl.textAlignment = NSTextAlignmentCenter;
        _TitleLbl.text = @"注册成功";
    }
    
    return _TitleLbl;
}

- (UILabel *)tipsLbl{
    if (!_tipsLbl) {
        _tipsLbl = [UILabel new];
        _tipsLbl.font = [UIFont systemFontOfSize:16.0f];
         _tipsLbl.textColor = [UIColor blackColor];
        _tipsLbl.numberOfLines = 0;
        _tipsLbl.textAlignment = NSTextAlignmentLeft;
        _tipsLbl.text = @"已为您分配专属账号密码，请妥善保管！";
    }
    
    return _tipsLbl;
}


- (UILabel *)userNameLbl{
    if (!_userNameLbl) {
        _userNameLbl = [UILabel new];
        _userNameLbl.font = [UIFont systemFontOfSize:15.0f];
         _userNameLbl.textColor = [UIColor blackColor];
        _userNameLbl.textAlignment = NSTextAlignmentLeft;
        _userNameLbl.text = [NSString stringWithFormat:@"账 号 : %@",COMMONMETHOD.userName];
    }
    
    return _userNameLbl;
}

- (UILabel *)PwdLbl{
    if (!_PwdLbl) {
        _PwdLbl = [UILabel new];
        _PwdLbl.font = [UIFont systemFontOfSize:15.0f];
         _PwdLbl.textColor = [UIColor blackColor];
        _PwdLbl.textAlignment = NSTextAlignmentLeft;
        _PwdLbl.text = [NSString stringWithFormat:@"密 码: %@",COMMONMETHOD.password_plaintext];
    }
    return _PwdLbl;
}



- (void)submitBtnAction{
    if (self.submitBtnBlock) {
        self.submitBtnBlock();
        [self hide];
    }
}

- (void)updateFrame{
    self.TitleLbl.frame = CGRectMake(0, SCREEN_FIT(10), SCREEN_FIT(300), SCREEN_FIT(30));
    self.tipsLbl.frame =CGRectMake(SCREEN_FIT(20), CGRectGetMaxY(self.TitleLbl.frame)+SCREEN_FIT(10), SCREEN_FIT(260), SCREEN_FIT(40));
    
    self.userNameLbl.frame = CGRectMake(SCREEN_FIT(20), CGRectGetMaxY(self.tipsLbl.frame)+SCREEN_FIT(10), SCREEN_FIT(120), SCREEN_FIT(30));
    self.PwdLbl.frame = CGRectMake(CGRectGetMaxX(self.userNameLbl.frame)+SCREEN_FIT(20),  CGRectGetMaxY(self.tipsLbl.frame)+SCREEN_FIT(10), SCREEN_FIT(120), SCREEN_FIT(30));
    self.submitBtn.frame = CGRectMake(SCREEN_FIT(20), SCREEN_FIT(150), SCREEN_FIT(260), SCREEN_FIT(50));
    
}


- (void)show{
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
    self.alpha = 0;
    self.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1;
    } completion:nil];
    
    
    
}

/**
 移除视图
 */
- (void)hide{
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformMakeScale(0.8, 0.8);
        self.alpha = 0;
    } completion:^(BOOL finished) {
         [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
        [self removeFromSuperview];
    }];
}


- (void)changeRotateNewZhongkeView:(NSNotification*)noti {
    [self updateFrame];
    
}

@end

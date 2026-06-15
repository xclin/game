
#import "SaveScreenView.h"

@implementation SaveScreenView


- (instancetype) init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(SCREEN_FIT(40),SCREEN_FIT(40), SCREEN_FIT(300), SCREEN_FIT(240));
        self.backgroundColor =  [UIColor whiteColor];
        [self addSubview:self.TitleLbl];
        [self addSubview:self.tipsLbl];
        [self addSubview:self.userNameLbl];
        [self addSubview:self.PwdLbl];
        self.layer.cornerRadius= 10;
        self.layer.masksToBounds = YES;
        [self setupUI];
    }
    return self;
}


- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
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



- (void)setupUI {
    
    self.TitleLbl.frame = CGRectMake(0, SCREEN_FIT(10), SCREEN_FIT(300), SCREEN_FIT(30));
    self.tipsLbl.frame =CGRectMake(SCREEN_FIT(20), CGRectGetMaxY(self.TitleLbl.frame)+SCREEN_FIT(10), SCREEN_FIT(260), SCREEN_FIT(40));
    
    self.userNameLbl.frame = CGRectMake(SCREEN_FIT(20), CGRectGetMaxY(self.tipsLbl.frame)+SCREEN_FIT(10), SCREEN_FIT(120), SCREEN_FIT(30));
    self.PwdLbl.frame = CGRectMake(CGRectGetMaxX(self.userNameLbl.frame)+SCREEN_FIT(20),  CGRectGetMaxY(self.tipsLbl.frame)+SCREEN_FIT(10), SCREEN_FIT(120), SCREEN_FIT(30));
    
}

@end

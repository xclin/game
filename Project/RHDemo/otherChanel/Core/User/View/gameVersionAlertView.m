

#import "gameVersionAlertView.h"
@interface gameVersionAlertView ()
@property (nonatomic,strong) BaseButton *submitBtn;
@property (nonatomic,strong)  UITextView   *contentview;
@end


@implementation gameVersionAlertView

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}



- (void)setupUI{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRotateNewZhongkePhoneLoginView:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentview];
    [self.loginBtn setTitle:@"立即更新" forState:UIControlStateNormal];
    [self updateFrame];
}


- (UITextView *)contentview{
    if (!_contentview) {
        _contentview =  [UITextView new];
        _contentview.frame = CGRectMake(20, SCREEN_FIT(100), UserViewWidth-40, 140);
        _contentview.backgroundColor = [UIColor clearColor]; //设置背景色
        _contentview.scrollEnabled = YES;
        _contentview.editable = NO;
        _contentview.text = @"   由于您当前版本过低导致无法正常登录，请保存好您的账号密码.通过下方“立即更新”入口获取最新的下载地址。";
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 7;// 字体的行间距
        NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName:paragraphStyle
                                    };
        
        _contentview.attributedText = [[NSAttributedString alloc] initWithString:_contentview.text attributes:attributes];
    }
    return _contentview;
}

- (void)updateFrame{
    
    UIInterfaceOrientation sataus=[UIApplication sharedApplication].statusBarOrientation;
    if (sataus == UIInterfaceOrientationPortrait || sataus == UIInterfaceOrientationPortraitUpsideDown) {//竖屏
        self.contentview.frame = CGRectMake(20, SCREEN_FIT(100), UserViewWidth-40, 140);
        self.loginBtn.frame = CGRectMake(CGRectGetMinX(self.contentview.frame),ZKUserViewHeight-SCREEN_FIT(100), CGRectGetWidth(self.contentview.frame),SCREEN_FIT(50));
    }else{//横版  未知
        self.contentview.frame = CGRectMake(20, SCREEN_FIT(100), UserViewWidth-40, 140);
        self.loginBtn.frame = CGRectMake(CGRectGetMinX(self.contentview.frame),ZKUserViewHeight-SCREEN_FIT(100), CGRectGetWidth(self.contentview.frame),SCREEN_FIT(50));
    }
}


- (void)loginBtnAction{
    if (self.submitBtnBlock) {
        self.submitBtnBlock(@"");
    }
}

- (void)changeRotateNewZhongkePhoneLoginView:(NSNotification*)noti {
    [self updateFrame];
    
}
@end

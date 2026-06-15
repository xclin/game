
#import "MessagePopView.h"
#import "Masonry.h"
#import "VersionAllMethod.h"
#import "BaseLabel.h"
#import "UIColor+Category.h"
#import "BaseView.h"
#import "ZhongkeView.h"
#import "NSUserDefaults+Category.h"
@interface MessagePopView()
{
    UIView * _messagePopView;
}
@end

@implementation MessagePopView
- (BOOL)shouldAutorotate
{
    return YES;
}

//登录欢迎小窗
- (void) show:(int)user_type {
    [self updateConstraintsIfNeeded];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    if (_messagePopView) {
        [_messagePopView removeFromSuperview];
    }
    //小窗视图
    _messagePopView = [[UIView alloc] init];
    _messagePopView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    _messagePopView.layer.cornerRadius = 8;
    [_messagePopView setUserInteractionEnabled:NO];
    _messagePopView.alpha = 0.9;
    
    [window addSubview:_messagePopView];

    if ([UIScreen mainScreen].bounds.size.width >= 480) {
        _messagePopView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-420)/2, 20, 420, 50);
    }else{
        _messagePopView.frame = CGRectMake(20, 20, [UIScreen mainScreen].bounds.size.width-40, 50);
    }
    UIImage *image;

    image =[UIImage imageNamed:[NSString stringWithFormat:@"FYSDK_Resourcres.bundle/zhongke_loginType_selected_%@",COMMONMETHOD.userType]];

    NSString * userStr =COMMONMETHOD.userName;
    
    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleBtn setImage:image forState:UIControlStateNormal];
     [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    NSString * str = [NSString stringWithFormat:@"   %@,欢迎进入游戏！",userStr];
    [titleBtn setTitle:str forState:UIControlStateNormal];
    NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithString:str];
    [attString addAttribute:NSForegroundColorAttributeName value:rgba(252, 197, 105, 1) range:[str rangeOfString:[NSString stringWithFormat:@"%@",userStr]]];
    [titleBtn setAttributedTitle:attString forState:UIControlStateNormal];
    titleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
   
    [_messagePopView addSubview:titleBtn];
    [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(@0);
    }];
    
    //小窗弹出动画
    [UIView animateWithDuration:0.45 animations:^{
        _messagePopView.alpha = 1;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideWithWindow:self];
            [self layoutIfNeeded];
        });
    }];
    
}

//小窗隐藏动画
- (void)hideWithWindow:(UIView *)view {
    [UIView animateWithDuration:0.45 animations:^{
        _messagePopView.alpha = 0;
    } completion:^(BOOL finished) {
        [_messagePopView removeFromSuperview];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    }];
}

- (void)changeRotate:(NSNotification*)noti {
    
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait
        || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown) {
        //竖屏
        _messagePopView.frame = CGRectMake(20, 20, [UIScreen mainScreen].bounds.size.width-40, 50);
    } else {
        //横屏
        _messagePopView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-420)/2, 20, 420, 50);
    }
}

@end


#import "RemindView.h"
#import "UIColor+Category.h"
#import "VersionAllMethod.h"
#import "SDKCommonMethod.h"

static RemindView * _singletonVC;

@implementation RemindView

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    
    static dispatch_once_t onceToken;
    // 一次函数
    dispatch_once(&onceToken, ^{
        if (_singletonVC == nil) {
            _singletonVC = [super allocWithZone:zone];
        }
    });
    
    return _singletonVC;
}
+ (instancetype)share{
    return  [[self alloc] init];
}

- (void)setRemindViewUI:(NSString *)msgString{
    //防止重复点击
    if (self.tempTime > 0) {
        return;
    }
    
    self.remindView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UserViewWidth/6*5, 50)];
    self.remindView.backgroundColor = [UIColor clearColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.remindView.frame];
    imageView.backgroundColor = [UIColor colorWithHexString:@"#333333"];
    imageView.alpha = 0.9;
    imageView.layer.cornerRadius = 9;
    [self.remindView addSubview:imageView];
    
    UILabel *remindLabel = [[UILabel alloc] initWithFrame:self.remindView.frame];
    remindLabel.textAlignment = NSTextAlignmentCenter;
    remindLabel.font = [UIFont systemFontOfSize:16];
    remindLabel.textColor = [UIColor whiteColor];
    remindLabel.numberOfLines = 0;
    remindLabel.text = msgString;
    [self.remindView addSubview:remindLabel];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.remindView];
    self.remindView.center = window.center;
}


- (void)show:(NSString *)msgString
        time:(CGFloat)time
{
    [self setRemindViewUI:msgString];
    self.tempTime = time;
    if (time > 0) {
        [self performSelector:@selector(hidden) withObject:nil afterDelay:time];
    }else
        [self performSelector:@selector(hidden) withObject:nil afterDelay:2.0];
}

- (void)showAllTheTime:(NSString *)msgString
              isCanTouch:(BOOL)isCanTouch
{
    [self setRemindViewUI:msgString];
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = isCanTouch;
}

- (void)hidden
{
    self.tempTime = 0;
    __block typeof (self) bSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        
    } completion:^(BOOL finished) {
        [bSelf.remindView removeFromSuperview];
        [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
    }];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

- (void)changeRotate:(NSNotification*)noti {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.remindView.center = window.center;
    
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait
        || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown) {
        //竖屏
    } else {
        //横屏
    }
}

@end

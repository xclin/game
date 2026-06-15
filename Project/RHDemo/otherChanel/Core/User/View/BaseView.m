
#import "BaseView.h"
#import "VersionAllMethod.h"
#import "VersionAllMethod.h"
#import "sdkInitModel.h"
#import "VerifyIDCardView.h"

@implementation BaseView
- (instancetype) init {
    self = [super init];
    if (self) {
        [self setupUI];
        [self defaultConfig];
        if (![self isKindOfClass:[VerifyIDCardView class]]) {
            [self addLogoImageView];
        }
        //悬浮窗关闭时
        if ((([[NSUserDefaults takeoutNSUserDefault:HIDESUSPENSION] intValue] == 1) && [sdkInitModel share].bg_color.length > 0)) {
            self.backgroundColor = [UIColor colorWithHexString:[sdkInitModel share].bg_color];
        }

    }
    return self;
}
- (void) setupUI {
    NSLog(@"BaseView--setupUI");
}

- (void) addLogoImageView{
    
    _logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(UserViewWidth/2-LOGOImage.size.width/2, 12, LOGOImage.size.width, LOGOImage.size.height)];
    [_logoImageView setImage:LOGOImage];
    [self addSubview:_logoImageView];
    //是否隐藏SDK的logo
    if ([sdkInitModel share].hide_logo) {
        _logoImageView.hidden = YES;
    }else
        _logoImageView.hidden = NO;
}
- (void) addBackItem {
    _backButton = [[BaseButton alloc] init];
    _backButton.frame = CGRectMake(0, 0, 60, 60);
    [_backButton setFYBtnImageName:@"FYSDK_Resourcres.bundle/left" selectImageName:nil highlightImageName:nil];
    [_backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_backButton];
    
}

- (void) addCancelItem {
    _cancelButton = [[BaseButton alloc] init];
    _cancelButton.frame = CGRectMake(UserViewWidth - 40, 12, 30, 30);
    [_cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [_cancelButton setFYBtnImageName:@"FYSDK_Resourcres.bundle/close" selectImageName:nil highlightImageName:nil];
    [self addSubview:_cancelButton];
    //隐藏按钮
    if ([getHIDECANNELBTN isEqualToString:@"1"]) {
        _cancelButton.hidden = YES;
    }
}
- (void) addCancelItem1 {
    _cancelButton = [[BaseButton alloc] init];
    _cancelButton.frame = CGRectMake(UserViewWidth - 40, 12, 30, 30);
    [_cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [_cancelButton setFYBtnImageName:@"FYSDK_Resourcres.bundle/close" selectImageName:nil highlightImageName:nil];
    [self addSubview:_cancelButton];

}
- (void)backAction {
    if (_backBlock) {
        _backBlock();
    }
}

- (void)cancelAction {
    PostCancelNotification()
    if (_cancleBlock) {
        _cancleBlock();
    }
}


- (void) showErrorAtMsg:(NSString *)msgString {

    NSLog(@"返回信息=%@",msgString);
}

- (CGRect)setSameFrameButY:(CGRect)frame Y:(CGFloat)Y{
    
    CGRect newFrame = frame;
    newFrame.origin.y = Y;
    return newFrame;
    
}

@end

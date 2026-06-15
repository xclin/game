
#import "sdkActivityIndicatorView.h"
#import "SDKCommonMethod.h"
#import "Masonry.h" 
#import "LQLogger.h"
#import "WTMGlyphGestureRecognizer.h"
static sdkActivityIndicatorView *sharedInstance = nil;

@interface sdkActivityIndicatorView ()
@property (nonatomic, retain) UIButton * backgroundButton;
@property (nonatomic, retain) UIActivityIndicatorView * aiView;
@end

@implementation sdkActivityIndicatorView
- (void)dealloc {
    DEBUGMSG(@"ActivityIndicatorView dealloc");
}
+ (instancetype)sharedInstance {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[sdkActivityIndicatorView alloc]init];
            [sharedInstance setupUI];
        }
    }
    return sharedInstance;
}

- (void)show {
    __weak typeof (self) bSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [bSelf.aiView startAnimating];
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:bSelf];
        [bSelf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(@0);
        }];
    });
    
}

- (void)hide {
    __weak typeof (self) bSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [bSelf.aiView stopAnimating];
        [bSelf removeFromSuperview];
    });
}

#pragma mark - UI
- (void)setupUI {
    _backgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backgroundButton.backgroundColor = [UIColor blackColor];
    _backgroundButton.alpha = 0.3;
    [self addSubview:_backgroundButton];
    [_backgroundButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(@0);
    }];
    _aiView=[[UIActivityIndicatorView alloc]init];
    [_aiView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_aiView setBackgroundColor:[UIColor blackColor]];
    _aiView.alpha = 0.8;
    [self addSubview:_aiView];
    [_aiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@80);
        make.center.equalTo(@0);
    }];
    _aiView.layer.cornerRadius = 8;
    AddRecognizeStarGestureRecognizer(_backgroundButton, ^{
        [self hide];
    });
}



@end

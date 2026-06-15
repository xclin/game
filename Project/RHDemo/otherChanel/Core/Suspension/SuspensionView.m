
#import "SuspensionView.h"
#import "SDKCommonMethod.h"
#import "UIButton+UIButtonExt.h"
#import "SDKComplatformBase.h"
#import "WaveView.h"
#import "NewZhongkeWebSuspenView.h"
#import "hideSupenViewTipsView.h"
#define ISiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define UIDeviceOrientationIsLandscapeLeft(orientation) ((orientation) == UIDeviceOrientationLandscapeLeft)
#define UIDeviceOrientationIsLandscapeRight(orientation) ((orientation) == UIDeviceOrientationLandscapeRight)
//static NSString * kSuspensionStaticNamed = @"FYSDK_Resourcres.bundle/ass_common_icon";
//static NSString * kSuspensionMoveNamed = @"FYSDK_Resourcres.bundle/ass_common_icon_hide";
//static NSString * kSuspensionOpenLeftNamed = @"FYSDK_Resourcres.bundle/ass_tb_return";
//static NSString * kSuspensionOpenRightNamed = @"FYSDK_Resourcres.bundle/ass_tb_return_right";
//static NSString * kWindowLeftNamed = @"FYSDK_Resourcres.bundle/ass_tb_bg_left";
//static NSString * kWindowRightNamed = @"FYSDK_Resourcres.bundle/ass_tb_bg_right";
static NSString * kSuspensionStaticNamed = @"ass_common_icon";
static NSString * kSuspensionMoveNamed = @"ass_common_icon_hide";
static NSString * kSuspensionOpenLeftNamed = @"ass_common_icon";
static NSString * kSuspensionOpenRightNamed = @"ass_common_icon";
static NSString * kWindowLeftNamed = @"ass_common_icon";
static NSString * kWindowRightNamed = @"ass_common_icon";
typedef NS_ENUM (NSUInteger, LocationTag) {
    kLocationTag_top = 1,
    kLocationTag_left,
    kLocationTag_bottom,
    kLocationTag_right
};

@interface SuspensionView () {
    UIInterfaceOrientation orientation;    //旋转方向
    NSTimer * timer;                    //缩进定时器
}


@property (nonatomic,strong) UIImageView * hideImageXView;
@property (nonatomic,strong) UIImageView * hideImageXViewTips;
@property (nonatomic,assign) BOOL  isRetract;   //是否缩进
@property (nonatomic,assign) CGFloat  menuW;   //悬浮窗整体宽度
@property (nonatomic,assign) BOOL  showMenu;   //是否打开悬浮按钮
@property (nonatomic,assign) LocationTag  locationTag;   //定位
@property (nonatomic,assign) CGFloat  widthScreen;   //屏幕宽度
@property (nonatomic,assign) CGFloat  heightScreen;   //屏幕高度
@property (nonatomic,strong) UIButton * suspensionButton;
@property (nonatomic,strong) UIView * windowView;
@property (nonatomic,strong) UIImageView * windowBgIV;
@property (nonatomic,strong) UIButton * bButton;
@end

@implementation SuspensionView

- (void)dealloc {
    DEBUGMSG(@"SuspensionView dealloc");
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupData];
        [self setupUI];
//        [self setupWindowView];
        //注册旋转通知
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(svDeviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupBadge) name:kSetupBadgeNoticationName object:nil];

        [self moveImageAtChange:NO];
        [self initTimer];

        [self setupBadge];
    }
    return self;
}

-  (UIImageView *)hideImageXView{
    if (!_hideImageXView) {
        _hideImageXView = [[UIImageView alloc]init];
        _hideImageXView.frame = CGRectMake(([SDKCommonMethod getWidth] - 50)/2,([SDKCommonMethod getHeight] - 50)/2, 50, 50);
        _hideImageXView.image = [UIImage imageNamed:@"FYSDK_Resourcres.bundle/drop_close_icon_off"];
        _hideImageXView.hidden = YES;
    }
    return  _hideImageXView;
}

-  (UIImageView *)hideImageXViewTips{
    if (!_hideImageXViewTips) {
        _hideImageXViewTips = [[UIImageView alloc]init];
        _hideImageXViewTips.frame = CGRectMake(([SDKCommonMethod getWidth] - 160)/2,CGRectGetMinY(self.hideImageXView.frame)- 50, 160, 40);
        _hideImageXViewTips.image = [UIImage imageNamed:@"FYSDK_Resourcres.bundle/drop_close_tip_off"];
        _hideImageXViewTips.hidden = YES;
    }
    return  _hideImageXViewTips;
}


#pragma mark - 初始化数据
- (void)setupData {
    orientation = [[UIApplication sharedApplication] statusBarOrientation];
    self.showMenu = NO;
    self.locationTag = kLocationTag_right;
    self.widthScreen = [SDKCommonMethod getWidth];
    self.heightScreen = [SDKCommonMethod getHeight];
}

#pragma mark - 初始化视图
- (void)setupUI {
    self.suspensionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.suspensionButton setAdjustsImageWhenHighlighted:NO];
    [self.suspensionButton addTarget:self action:@selector(clickSuspensionAction) forControlEvents:UIControlEventTouchUpInside];
    self.suspensionButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.suspensionButton.layer.cornerRadius = self.frame.size.height/2;
    self.suspensionButton.layer.masksToBounds = YES;
    [self addSubview:self.suspensionButton];
    UIPanGestureRecognizer * panGR = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:panGR];
    UILongPressGestureRecognizer * longGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longImgV:)];
    [longGestureRecognizer setMinimumPressDuration:1.0f];
    [self addGestureRecognizer:longGestureRecognizer];

    [[UIApplication sharedApplication].keyWindow addSubview:self.hideImageXView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.hideImageXViewTips];
}

- (void)setupWindowView {
    
    NSMutableArray * arr = [[NSKeyedUnarchiver unarchiveObjectWithData:[NSUserDefaults takeoutNSUserDefault:suspensionview]] mutableCopy];
    
    self.menuW = ([arr count]+1) * 45;
    
    _windowView = [[UIView alloc]initWithFrame:CGRectMake(-8, 0, self.frame.size.width, self.frame.size.height)];
    _windowView.backgroundColor = [UIColor clearColor];
    [self addSubview:_windowView];
    _windowBgIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, self.menuW, self.frame.size.height-20)];
    [_windowView addSubview:_windowBgIV];
    _windowView.hidden = YES;
    
    for (int i = 0; i < [arr count]; i++) {
        _bButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bButton.tag = i+100;
        [_bButton setTitle:arr[i][@"title"] forState:UIControlStateNormal];
        [_bButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"FYSDK_Resourcres.bundle/%@",arr[i][@"image"]]] forState:UIControlStateNormal];

        _bButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_bButton setTitleColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1] forState:UIControlStateNormal];
        if (self.locationTag == kLocationTag_right) {
            _bButton.frame = CGRectMake(5+i * (40 + 15/[arr count]), 13, 40, 40);
        } else if (self.locationTag == kLocationTag_left){
            _bButton.frame = CGRectMake(i * (40 + 15/[arr count]), 13, 40, 40);
        }
        [_windowView addSubview:_bButton];
        [_bButton addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bButton centerImageAndTitle:1];
    }
    
    UIButton * hidebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [hidebtn setTitle:@"隐藏" forState: UIControlStateNormal];
    [hidebtn setImage:[UIImage imageNamed:@"FYSDK_Resourcres.bundle/hides"] forState:UIControlStateNormal];
    hidebtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [hidebtn setTitleColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1] forState:UIControlStateNormal];
    if (self.locationTag == kLocationTag_right) {
        hidebtn.frame = CGRectMake(5+[arr count] * (40 + 15/[arr count]), 13, 40, 40);
    } else if (self.locationTag == kLocationTag_left){
        hidebtn.frame = CGRectMake([arr count] * (40 + 15/[arr count]), 13, 40, 40);
    }
    [_windowView addSubview:hidebtn];
    [hidebtn addTarget:self action:@selector(hideAction:) forControlEvents:UIControlEventTouchUpInside];
    [hidebtn centerImageAndTitle:1];
}

#pragma mark 移动悬浮按钮
- (void)moveImageAtChange:(BOOL)isChange {
    [self.suspensionButton setImage:[UIImage imageNamed:isChange ? kSuspensionMoveNamed : kSuspensionStaticNamed] forState:UIControlStateNormal];
}

#pragma mark 打开悬浮窗
- (void)showMenuAtShow:(BOOL)isShow
           andDuration:(CGFloat)duration
           andComplete:(void(^)(void))complete {
    self.userInteractionEnabled = NO;
    [[COMMONMETHOD getRootViewController].view setUserInteractionEnabled:NO];
    __weak typeof (self) bSelf = self;
    if (isShow) {
        [self.suspensionButton hideBadgeOnButtonIndex:0];
        [self shopTimer];
        _windowView.hidden = NO;
        if (self.locationTag == kLocationTag_left) {
            [self.suspensionButton setFrame:CGRectMake(0, 0, self.suspensionButton.frame.size.width, self.suspensionButton.frame.size.height)];
            [self.suspensionButton setImage:[UIImage imageNamed:kSuspensionOpenLeftNamed] forState:UIControlStateNormal];
            [_windowBgIV setImage:[[UIImage imageNamed:kWindowLeftNamed] stretchableImageWithLeftCapWidth:0 topCapHeight:0]];
            self.frame = CGRectMake(5, self.frame.origin.y, self.frame.size.width + self.menuW, self.frame.size.height);
            [UIView animateWithDuration:duration animations:^{

                bSelf.windowView.frame = CGRectMake(bSelf.suspensionButton.frame.origin.x + bSelf.suspensionButton.frame.size.width-4, 0, self.menuW, bSelf.suspensionButton.frame.size.height);
            } completion:^(BOOL finished) {
                [[COMMONMETHOD getRootViewController].view setUserInteractionEnabled:YES];
                bSelf.userInteractionEnabled = YES;
                complete();
            }];
        } else {
            [self.suspensionButton setImage:[UIImage imageNamed:kSuspensionOpenRightNamed] forState:UIControlStateNormal];
            [_windowBgIV setImage:[[UIImage imageNamed:kWindowRightNamed] stretchableImageWithLeftCapWidth:0 topCapHeight:0]];
            self.frame = CGRectMake(self.widthScreen - self.frame.size.width - self.menuW-5, self.frame.origin.y, self.frame.size.width + self.menuW, self.frame.size.height);
            self.suspensionButton.frame = CGRectMake(self.menuW, 0, self.suspensionButton.frame.size.width, self.suspensionButton.frame.size.height);
            bSelf.windowView.frame = CGRectMake(self.menuW, 0, 0, bSelf.suspensionButton.frame.size.height);
            [UIView animateWithDuration:duration animations:^{

                bSelf.windowView.frame = CGRectMake(4, 0, self.menuW, bSelf.suspensionButton.frame.size.height);
            } completion:^(BOOL finished) {
                [[COMMONMETHOD getRootViewController].view setUserInteractionEnabled:YES];
                bSelf.userInteractionEnabled = YES;
                complete();
            }];
        }
    } else {
        if (self.locationTag == kLocationTag_left) {
            [UIView animateWithDuration:duration animations:^{
                [bSelf.windowView setFrame:CGRectMake(bSelf.suspensionButton.frame.size.width-10, 0, 0, bSelf.suspensionButton.frame.size.height)];
            } completion:^(BOOL finished) {
                [bSelf setFrame:CGRectMake(bSelf.frame.origin.x, bSelf.frame.origin.y, bSelf.suspensionButton.frame.size.width, bSelf.suspensionButton.frame.size.height)];
                [bSelf.suspensionButton setFrame:CGRectMake(-4, 0, bSelf.suspensionButton.frame.size.width, bSelf.suspensionButton.frame.size.height)];
                [bSelf.suspensionButton setImage:[UIImage imageNamed:kSuspensionStaticNamed] forState:UIControlStateNormal];
                self.userInteractionEnabled = YES;
                [[COMMONMETHOD getRootViewController].view setUserInteractionEnabled:YES];
                [bSelf.windowView setHidden:YES];
                [bSelf initTimer];
                complete();
                [bSelf.suspensionButton showBadgeOnButonRightIndex:0 andOffset:-2.5];
            }];
        } else {
            [UIView animateWithDuration:duration animations:^{
                [bSelf.windowView setFrame:CGRectMake(bSelf.suspensionButton.frame.size.width, 0, 0, bSelf.suspensionButton.frame.size.height)];
            } completion:^(BOOL finished) {
                [bSelf setFrame:CGRectMake(bSelf.frame.origin.x + bSelf.menuW, bSelf.frame.origin.y, bSelf.suspensionButton.frame.size.width, bSelf.suspensionButton.frame.size.height)];
                [bSelf.suspensionButton setFrame:CGRectMake(4, 0, bSelf.suspensionButton.frame.size.width, bSelf.suspensionButton.frame.size.height)];
                bSelf.userInteractionEnabled = YES;
                [[COMMONMETHOD getRootViewController].view setUserInteractionEnabled:YES];
                [bSelf.suspensionButton setImage:[UIImage imageNamed:kSuspensionStaticNamed] forState:UIControlStateNormal];
                [bSelf.windowView setHidden:YES];
                [bSelf initTimer];
                complete();
                [bSelf.suspensionButton showBadgeOnButonLeftIndex:0 andOffset:-2.5];
            }];
        }
    }
}

#pragma mark 缩进
- (void)initTimer {
    self.isRetract = NO;
    timer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)shopTimer {
    if (timer && !self.isRetract) { [timer invalidate]; }
}

- (void)timerFired:(NSTimer*)t {
    [timer invalidate];
    timer = nil;
    
    [self retractBanner];
}
- (void)retractBanner {
    if (!self.showMenu ) {
        __weak typeof (self) bSelf = self;
        [UIView animateWithDuration:0.25 animations:^{
            if (self.locationTag == kLocationTag_left) {
                [bSelf setFrame:CGRectMake(bSelf.frame.origin.x - 35, bSelf.frame.origin.y, bSelf.frame.size.width, bSelf.frame.size.height)];
            } else if (self.locationTag == kLocationTag_right) {

                [bSelf setFrame:CGRectMake(bSelf.frame.origin.x + 35, bSelf.frame.origin.y, bSelf.frame.size.width, bSelf.frame.size.height)];
            }
        } completion:^(BOOL finished) { self.isRetract = YES; }];
    }
}

#pragma mark - 定位
- (void)computeOfLocation:(void(^)(void))complete {
    float x = self.frame.origin.x;
    float y = self.frame.origin.y;
    CGPoint m = CGPointZero;
    m.x = x;
    m.y = y;
    float sW = self.frame.size.width;
    if (x + 30 < self.widthScreen/2) { self.locationTag = kLocationTag_left;}
    else { self.locationTag = kLocationTag_right;}
    
    switch (self.locationTag) {
        case kLocationTag_top:
            m.y = 0 + self.frame.size.width/2 + 20;
            break;
        case kLocationTag_left:
            m.x = 0;
            if (m.y >  self.heightScreen)  m.y = self.heightScreen - sW;
            break;
        case kLocationTag_bottom:
            m.y =  self.heightScreen - self.frame.size.height/2;
            break;
        case kLocationTag_right:
            m.x = self.widthScreen - sW;
            if (m.y >  self.heightScreen) m.y = self.heightScreen - sW;
            break;
    }
    //这个是在旋转是微调浮标出界时
    if (m.x + sW > self.widthScreen)
        m.x = self.widthScreen - sW;
    if (m.y + sW >  self.heightScreen)
        m.y =  self.heightScreen - sW;
    __weak typeof (self) bSelf = self;
    [UIView animateWithDuration:0.01 animations:^{
        //如果缩进的话，kLocationTag_right的x要加35，kLocationTag_left的要减35
        if (self.locationTag == kLocationTag_right) {
            [bSelf setFrame:CGRectMake(m.x + 35, m.y, sW, sW)];
        } else {
            [bSelf setFrame:CGRectMake(m.x - 35, m.y, sW, sW)];
        }
    } completion:^(BOOL finished) {
         complete();
    }];
}

#pragma mark - 点击悬浮按钮，显示悬浮按钮条
- (void)clickSuspensionAction {
    
    if (self.showMenu ){
         [self showMenuAtShow:NO andDuration:0.01 andComplete:^{
        }];
    }else{
 
        if (_BannerMenuViewBlock) {
            _BannerMenuViewBlock(0);
        }
        [self showMenuAtShow:YES andDuration:0.01 andComplete:^{
    }];
        
    }
    self.showMenu  = !self.showMenu;
}



- (void)hidesMenu{
    
    [self showMenuAtShow:NO andDuration:0.01 andComplete:^{
    
    }];
    self.showMenu  = !self.showMenu ;
}

#pragma mark - 点击悬浮按钮的悬浮条里面的按钮
- (void)tapAction:(UIButton*)button {
    if (_BannerMenuViewBlock) {
        _BannerMenuViewBlock(button.tag-100);
    }
}
-(void)hideAction:(UIButton*)btn{
    [NewZhongkeWebSuspenView.shared hideSuspensionToolBar];
    
}
#pragma mark - UIGestureRecognizer
#pragma mark Pan
- (void)pan:(UIPanGestureRecognizer *)panGestureRecognizer {

    if (self.showMenu ){
        return;
    }

    [self moveImageAtChange:YES];
    UIView * panView = panGestureRecognizer.view;

    CGFloat ViewmidX = CGRectGetMidX(panView.frame);
    CGFloat ViewmidY = CGRectGetMidY(panView.frame);
    //1、计算悬浮窗中间X值和中间Y值
    
    float midX = [SDKCommonMethod getWidth]/2;
    float midY = [SDKCommonMethod getHeight]/2;
    if (((midX  - ViewmidX) < 20 && (midX  - ViewmidX) > -20) && ((midY  - ViewmidY)< 20 && (midY  - ViewmidY) > -20) ) {

            self.hideImageXView.image = [UIImage imageNamed:@"FYSDK_Resourcres.bundle/drop_close_icon_on"];
            self.hideImageXViewTips.image = [UIImage imageNamed:@"FYSDK_Resourcres.bundle/drop_close_tip_on"];
    }else{
            self.hideImageXView.image = [UIImage imageNamed:@"FYSDK_Resourcres.bundle/drop_close_icon_off"];
            self.hideImageXViewTips.image = [UIImage imageNamed:@"FYSDK_Resourcres.bundle/drop_close_tip_off"];
    }
    

    
    
    self.hideImageXView.hidden = NO;
    self.hideImageXViewTips.hidden = NO;
    float pW = panView.frame.size.width;
    __weak typeof (self) bSelf = self;
    [UIView animateWithDuration:0.001 animations:^{
        
        if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
            [bSelf shopTimer];
        }
        if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
            CGPoint translation = [panGestureRecognizer translationInView:panView];
            [panView setCenter:(CGPoint){panView.center.x + translation.x, panView.center.y + translation.y}];
            [panGestureRecognizer setTranslation:CGPointZero inView:panView];
        }
    }];
    [UIView animateWithDuration:0.15 animations:^{

        if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
            
            
            if (((midX  - ViewmidX) < 20 && (midX  - ViewmidX) > -20) && ((midY  - ViewmidY)< 20 && (midY  - ViewmidY) > -20) ) {

                    self.hideImageXView.image = [UIImage imageNamed:@"FYSDK_Resourcres.bundle/drop_close_icon_on"];
                    self.hideImageXViewTips.image = [UIImage imageNamed:@"FYSDK_Resourcres.bundle/drop_close_tip_on"];
                [panView setFrame:CGRectMake(([SDKCommonMethod getWidth]-panView.frame.size.width)/2, ([SDKCommonMethod getHeight]-panView.frame.size.height)/2, panView.frame.size.width, panView.frame.size.height)];
                
                BOOL showTips = [[NSUserDefaults standardUserDefaults] boolForKey:@"notshowHidenagain"];
                if (!showTips) {
                    hideSupenViewTipsView *view =[[hideSupenViewTipsView alloc]init];
                    [view show];
                    view.block = ^(BOOL hideView) {
                        if (hideView) {
                            [bSelf hide];//隐藏
     
                        }else{//不隐藏
                            self.hideImageXView.hidden = YES;
                            self.hideImageXViewTips.hidden = YES;
                            if (panView.frame.origin.x + 30 <= self.widthScreen/2) {
                                if (panView.frame.origin.y <= 0) {
                                    [panView setFrame:CGRectMake(0, 0, pW, pW)];
                                } else if (panView.frame.origin.y + pW >=  self.heightScreen) {
                                    [panView setFrame:CGRectMake(0,  self.heightScreen - pW, pW, pW)];
                                } else {
                                    [panView setFrame:CGRectMake(0, panView.frame.origin.y, pW, pW)];
                                }
                                self.locationTag = kLocationTag_left;
                            } else {
                                if (panView.frame.origin.y <= 0) {
                                    [panView setFrame:CGRectMake(self.widthScreen - pW, 0, pW, pW)];
                                } else if (panView.frame.origin.y + pW >=  self.heightScreen) {
                                    [panView setFrame:CGRectMake(self.widthScreen - pW,  self.heightScreen - pW, pW, pW)];
                                } else {
                                    [panView setFrame:CGRectMake(self.widthScreen - pW, panView.frame.origin.y, pW, pW)];
                                }
                                self.locationTag = kLocationTag_right;
                            }
                            [bSelf initTimer];
                            [bSelf moveImageAtChange:NO];
                            
                            if (self.locationTag == kLocationTag_right) {
                                [self.suspensionButton showBadgeOnButonLeftIndex:0 andOffset:-2.5];
                            } else {
                                [self.suspensionButton showBadgeOnButonRightIndex:0 andOffset:-2.5];
                            }
                        }
                    };
                    return;
                }else{
                    
                    [bSelf hide];//隐藏
                }

            }
            
            self.hideImageXView.hidden = YES;
            self.hideImageXViewTips.hidden = YES;
            if (panView.frame.origin.x + 30 <= self.widthScreen/2) {
                if (panView.frame.origin.y <= 0) {
                    [panView setFrame:CGRectMake(0, 0, pW, pW)];
                } else if (panView.frame.origin.y + pW >=  self.heightScreen) {
                    [panView setFrame:CGRectMake(0,  self.heightScreen - pW, pW, pW)];
                } else {
                    [panView setFrame:CGRectMake(0, panView.frame.origin.y, pW, pW)];
                }
                self.locationTag = kLocationTag_left;
            } else {
                if (panView.frame.origin.y <= 0) {
                    [panView setFrame:CGRectMake(self.widthScreen - pW, 0, pW, pW)];
                } else if (panView.frame.origin.y + pW >=  self.heightScreen) {
                    [panView setFrame:CGRectMake(self.widthScreen - pW,  self.heightScreen - pW, pW, pW)];
                } else {
                    [panView setFrame:CGRectMake(self.widthScreen - pW, panView.frame.origin.y, pW, pW)];
                }
                self.locationTag = kLocationTag_right;
            }
            [bSelf initTimer];
            [bSelf moveImageAtChange:NO];
            
            if (self.locationTag == kLocationTag_right) {
                [self.suspensionButton showBadgeOnButonLeftIndex:0 andOffset:-2.5];
            } else {
                [self.suspensionButton showBadgeOnButonRightIndex:0 andOffset:-2.5];
            }
        }
    }];
}

#pragma mark - NSNotification
- (void)svDeviceOrientationDidChange:(NSNotification *)notification {
   
    UIInterfaceOrientation deviceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    //横屏
    if (deviceOrientation == 1 ||deviceOrientation == 0 || deviceOrientation == 2 ) {
        return;
    }
    //同方向return，防止抖动
    if (orientation == deviceOrientation) {
        return;
    }
    
    orientation = deviceOrientation;
    self.widthScreen = [SDKCommonMethod getWidth];
    self.heightScreen = [SDKCommonMethod getHeight];
    void(^func)(BOOL b) = ^(BOOL b) {
        self.widthScreen = [SDKCommonMethod getWidth];
        self.heightScreen = [SDKCommonMethod getHeight];
        [self computeOfLocation:^{
            if (b) {
                self.showMenu  = YES;
                [self showMenuAtShow:self.showMenu  andDuration:0 andComplete:^{
                    return ;
                }];
            }
        }];
    };
    BOOL bS = self.showMenu ;
    if (bS) {
        self.showMenu  = NO;
        [self showMenuAtShow:self.showMenu  andDuration:0 andComplete:^{
            func(bS);
        }];
    } else {
        [self shopTimer];
        self.isRetract = YES;
        func(bS);
    }
}

#pragma mark - Long
- (void)longImgV:(UILongPressGestureRecognizer *)longGR {
    if (longGR.state == UIGestureRecognizerStateBegan) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示框" message:@"下次登录时将重新显示，确认隐藏？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView setTag:10001];
        [alertView show];
    }
}

- (void)setupBadge {
    int btntag = 0;
    if (COMMONMETHOD.phoneBadgeNum == 0 || COMMONMETHOD.cardBadgeNum == 0) {
        btntag = 0;
        UIButton * button = [self viewWithTag:btntag+100];
        [button showBadgeOnButonRightIndex:0 andOffset:-2.5];
    }
    else {
        btntag = 0;
        UIButton * button = [self viewWithTag:btntag+100];
        [button hideBadgeOnButtonIndex:0];
    }
    if (COMMONMETHOD.msgBadgeNum != 0) {
        btntag = 1;
        UIButton * button = [self viewWithTag:btntag+100];
        [button showBadgeOnButonRightIndex:0 andOffset:-2.5];
    } else {
        btntag = 1;
        UIButton * button = [self viewWithTag:btntag+100];
        [button hideBadgeOnButtonIndex:0];
    }
    if (COMMONMETHOD.giftBadgeNum != 0) {
        btntag = 2;
        UIButton * button = [self viewWithTag:btntag+100];
        [button showBadgeOnButonRightIndex:0 andOffset:-2.5];
    } else {
        btntag = 2;
        UIButton * button = [self viewWithTag:btntag+100];
        [button hideBadgeOnButtonIndex:0];
    }
    if (!self.showMenu ) {
        if (self.locationTag == kLocationTag_left) {
            [self.suspensionButton showBadgeOnButonRightIndex:0 andOffset:-2.5];
        } else if (self.locationTag == kLocationTag_right){
            [self.suspensionButton showBadgeOnButonLeftIndex:0 andOffset:-2.5];
        }
    } else {
        [self.suspensionButton hideBadgeOnButtonIndex:0];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 10001 && buttonIndex == 1) {
        NSLog(@"show--clickedButtonAtIndex");
        [[NewZhongkeWebSuspenView shared] hideSuspensionToolBar] ;
        
    }
}


- (void) show {
    NSLog(@"show--HIDESUSPENSION");
    if (![NSUserDefaults takeoutNSUserDefault:HIDESUSPENSION] || [[NSUserDefaults takeoutNSUserDefault:HIDESUSPENSION] intValue] == 0) {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
}

- (void) hide {
    [self.hideImageXView removeFromSuperview];
    [self.hideImageXViewTips removeFromSuperview];
    [self removeFromSuperview];
}

@end


//使用宏来对SDK的业务逻辑解耦
#define ISUseInSDK
#import "LQAlertView.h"
#ifdef ISUseInSDK
#import "WTMGlyphGestureRecognizer.h"
#import "NSUserDefaults+Category.h"
#import "CommonStoreKey.h"
#import "LQLogger.h"
#import "VersionAllMethod.h"
#endif
@interface LQAlertView()
@property (nonatomic,retain) UILabel * titleLabel;
@property (nonatomic,retain) UILabel * messageLabel;
@property (nonatomic,retain) UIView * centerView;
@property (nonatomic,retain) NSLayoutConstraint * centerYC;
@end
@implementation LQAlertView
- (instancetype) initWithTitle:(NSString *)title message:(NSString *)message actions:(NSArray *)actions {
    self = [super init];
    if (self) {
        self.title = title;
        self.message = message;
        self.actions = actions;
    }
    return self;
}

- (CGFloat) centerWidth {
    return MIN([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)-60;
}

- (CGFloat) centerHeight {
    return 70+self.actions.count*44 + [self heightForLabel:self.titleLabel width:[self centerWidth]-30]+[self heightForLabel:self.messageLabel width:[self centerWidth]-30];
}
- (void) show {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    self.alpha = 0;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    if (topWindow.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(topWindow in windows)
        {
            if (topWindow.windowLevel == UIWindowLevelNormal)
                break;
        }
    }
    UIView *rootView = [[topWindow subviews] objectAtIndex:0];
    [rootView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[LQAlertView class]]) {
            [obj removeFromSuperview];
        }
    }];
    [rootView addSubview:self];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.titleLabel.text = self.title;
    self.titleLabel.numberOfLines = 0;
    self.messageLabel = [UILabel new];
    self.messageLabel.text = self.message;
    self.messageLabel.font = [UIFont systemFontOfSize:15];
    self.centerView = [UIView new];
    self.centerView.layer.borderWidth = 0.5;
    self.centerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.centerView.backgroundColor = [UIColor whiteColor];
    self.centerView.layer.cornerRadius = 10;
    self.centerView.layer.masksToBounds = YES;
    [self addSubview:self.centerView];
    self.centerView.translatesAutoresizingMaskIntoConstraints = NO;
    CGFloat width = [self centerWidth];
    CGFloat height = [self centerHeight];
    self.centerYC = [NSLayoutConstraint constraintWithItem:self.centerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.centerView.superview attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    [self.centerView.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.centerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.centerView.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.centerView.superview addConstraint:self.centerYC];
    [self.centerView.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.centerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:width]];
    [self.centerView.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.centerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:height]];
    
    [self.centerView addSubview:self.titleLabel];
    [self.centerView addSubview:self.messageLabel];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.messageLabel.numberOfLines = 0;
    [self.titleLabel.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.titleLabel.superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.titleLabel.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleLabel.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:36]];
    [self.titleLabel.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.titleLabel.superview attribute:NSLayoutAttributeWidth multiplier:1 constant:-30]];
    [self.messageLabel.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.messageLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.messageLabel.superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.messageLabel.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.messageLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:4]];
    [self.messageLabel.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.messageLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.messageLabel.superview attribute:NSLayoutAttributeWidth multiplier:1 constant:-30]];
    
    
    [self.actions enumerateObjectsUsingBlock:^(LQAlertAction *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:obj.title forState:UIControlStateNormal];
        button.tag = 100+idx;
        [self.centerView addSubview:button];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [button.superview addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:button.superview attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
        [button.superview addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:button.superview attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
        [button.superview addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.messageLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:44*idx+30]];
        [button.superview addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:44]];
        
        UIView * line = [UIView new];
        line.backgroundColor = [UIColor grayColor];
        [button addSubview:line];
        line.translatesAutoresizingMaskIntoConstraints = NO;
        [button addConstraint:[NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
        [button addConstraint:[NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
        [button addConstraint:[NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
        [button addConstraint:[NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.5]];
        
        [button addTarget:self action:@selector(touch:) forControlEvents:UIControlEventTouchUpInside];
    }];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
    #ifdef ISUseInSDK
    AddRecognizeStarGestureRecognizer(self, ^{})
    UIButton * exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitButton setImage:[UIImage imageNamed:@"FYSDK_Resourcres.bundle/close"] forState:UIControlStateNormal];
    [exitButton addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
    [self.centerView addSubview:exitButton];
    exitButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.centerView addConstraint:[NSLayoutConstraint constraintWithItem:exitButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:exitButton.superview attribute:NSLayoutAttributeTrailingMargin multiplier:1.0 constant:0.0]];
    [self.centerView addConstraint:[NSLayoutConstraint constraintWithItem:exitButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:exitButton.superview attribute:NSLayoutAttributeTopMargin multiplier:1.0 constant:0.0]];
    #endif
}

- (CGFloat) heightForLabel:(UILabel*) label width:(CGFloat) width{
    return [label.text boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size.height;
}
- (void) tap:(id) obj {
    [self dismiss:^{
        
    }];
}

- (void) dismiss:(dispatch_block_t) complete {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (complete) {
          complete();
        }
    }];
}

- (void) touch:(UIButton*) button {
    NSInteger index = button.tag - 100;
    LQAlertAction * action = self.actions[index];
    [self dismiss:action.handler];
}
@end

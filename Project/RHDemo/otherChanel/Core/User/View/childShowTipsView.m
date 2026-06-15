

#import "childShowTipsView.h"
#import "VersionAllMethod.h"
#define windowWidth ([UIScreen mainScreen].bounds.size.width)
#define windowHeight ([UIScreen mainScreen].bounds.size.height)
@interface childShowTipsView ()

@end

@implementation childShowTipsView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, windowWidth, windowHeight)];
    if (self) {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
        self.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.3];
        [self setUpView];
    }
    return self;
}

- (void)setUpView{
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.titleLbl];
    [self.bgView addSubview:self.btnSure];
    
}


- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.frame = CGRectMake(20, (windowHeight-300)/2, windowWidth-40, 300);
        _bgView.layer.cornerRadius = 10;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIButton *)btnSure{
    if (!_btnSure) {
        _btnSure = [UIButton new];
        _btnSure.frame = CGRectMake(0, CGRectGetHeight(self.bgView.frame)-50, CGRectGetWidth(self.bgView.frame), 50);
        [_btnSure setTitle:@"我知道了" forState:UIControlStateNormal];
        [_btnSure addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_btnSure setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    }
    return _btnSure;
    
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [UILabel new];
        _titleLbl.frame = CGRectMake(0, 20, windowWidth-40, 20);
        _titleLbl.font = [UIFont systemFontOfSize:18];
        _titleLbl.textColor = [UIColor blackColor];
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        _titleLbl.text = @"小号说明";
        
    }
    
    return _titleLbl;
}


- (void)show{
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
    self.bgView.alpha = 0;
    self.bgView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.bgView.transform = CGAffineTransformIdentity;
        self.bgView.alpha = 1;
    } completion:nil];
    
    
    
}


- (void)sureBtnClick{
    
         [self hide];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    
    
     [self hide];
}

/**
 移除视图
 */
- (void)hide{
    [UIView animateWithDuration:0.2 animations:^{
        self.bgView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
         [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
        [self removeFromSuperview];
    }];
}


- (void)changeRotate:(NSNotification*)noti {
    
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait
        || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown) {
        //竖屏
          [ self setFrame:  CGRectMake(0, 0, windowWidth, windowHeight)];
        [self.bgView setFrame:CGRectMake(20, (windowHeight-300)/2, windowWidth-40, 300)];

    } else {
        //横屏
          [ self setFrame:  CGRectMake(0, 0, windowWidth, windowHeight)];
          [self.bgView setFrame:CGRectMake((windowWidth-(windowHeight-40))/2, (windowHeight-300)/2, windowHeight-40, 300)];
    }
}
@end

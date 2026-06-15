

#import "LQMenuView.h"
@interface LQMenuView()
@property (nonatomic,assign) BOOL showMenu;
@property (nonatomic,retain) NSMutableArray<UIButton*> * buttons;
@end
@implementation LQMenuView
LQSingletonInstanceMMethod(LQMenuView, ^{
    [instance setUP];
})

- (void) setUP {
    self.buttons = [NSMutableArray new];
    self.frame = CGRectMake(0, 0, 55, 55);
    self.alpha = 0.8;
    [self setAttributedTitle:[[NSAttributedString alloc] initWithString:@"⚫️" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:50]}]forState:UIControlStateNormal];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(-1, 0, 0, -5)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.center = CGPointMake(100, 100);
   
    self.layer.cornerRadius = 25;
    self.layer.masksToBounds = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)]];
    
}

- (void) setItems:(NSArray *)items {
    _items = items;
    [self.buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.buttons removeAllObjects];
    [_items enumerateObjectsUsingBlock:^(LQMenuItem *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton * button = [UIButton new];
        button.frame = CGRectMake(0, 0, 50, 50);
        button.center = self.center;
        button.layer.cornerRadius = 25;
        button.layer.masksToBounds = YES;
        button.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        
        [button setAttributedTitle:[[NSAttributedString alloc] initWithString:obj.title
                                                                   attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}] forState:UIControlStateNormal];
        button.tag = idx;
        [button addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttons addObject:button];
    }];
 
}

- (void) touchButton:(UIButton*) button {
    LQMenuItem * item = self.items[button.tag];
    if (item.action) {
        item.action();
    }
}
- (void) tap:(UITapGestureRecognizer*) tap {
    [self ffff:^{
        
    }];
}


- (void) ffff:(dispatch_block_t) block {
    self.showMenu = !self.showMenu;
    if (self.showMenu) {
        CGFloat rate = 0.1;
        CGFloat radius = 100;
        CGFloat one = 2*M_PI / self.buttons.count;
        self.userInteractionEnabled = NO;
        [self.buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.center = self.center;
            obj.alpha = 0;
        }];
        [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubicPaced animations:^{
            [self.buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.superview addSubview:obj];
                obj.center = CGPointMake(self.center.x+radius*cos(idx*one), self.center.y+radius*sin(idx*one));
                obj.alpha = 1;
            }];
        } completion:^(BOOL finished) {
            block();
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5*rate*M_PI * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.userInteractionEnabled = YES;
        });
    } else {
        [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubicPaced animations:^{
            [self.buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.superview addSubview:obj];
                obj.center = self.center;
                obj.alpha = 0;
            }];
        } completion:^(BOOL finished) {
            [self.buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj removeFromSuperview];
                block();
            }];
        }];
    }

}

- (void) pan:(UIPanGestureRecognizer*) pan {
    CGPoint point = [pan locationInView:pan.view.superview];
    CGPoint offset = CGPointMake(point.x-self.center.x, point.y-self.center.y);
    self.center = CGPointMake(self.center.x+offset.x, self.center.y+offset.y);
    if (self.showMenu) {
        [self.buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.center = CGPointMake(obj.center.x+offset.x, obj.center.y+offset.y);
        }];
    }
}
- (void) show {
    CGPoint center = self.center;
    if (self.superview) {
        [self removeFromSuperview];
    }
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
    [topWindow addSubview:self];
    CGPoint newCenter = CGPointMake(MAX(55/2.0,MIN(center.x, [UIScreen mainScreen].bounds.size.width-55/2.0)),
                                    MAX(55/2.0,MIN(center.y, [UIScreen mainScreen].bounds.size.height-55/2.0)));
    self.center = newCenter;
}
- (void) hide {
    if (!self.showMenu) {
        [self removeFromSuperview];
    } else {
        [self ffff:^{
            [self removeFromSuperview];
        }];
    }
}
@end
@implementation LQMenuItem
+ (instancetype) itemWithTitle:(NSString*) title image:(UIImage*) image action:(dispatch_block_t) action{
    LQMenuItem * item = [LQMenuItem new];
    item.image = image;
    item.title = title;
    item.action = action;
    return item;
}
@end

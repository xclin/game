
#import "SDKCenterMenuView.h"
#import "AnimateAction.h"
#import "SequenceAction.h"
#import "SDKBlockAction.h"
#import "DelayAction.h"
#define DIAMETER 60
#define RADIUS DIAMETER/2
#define MenuHeight 60
#define MenuMarginH 10
#define MenuPaddingH 5
#define MenuMarginV 5
#define MenuItemWidth 50
#define MenuItemHeight 50
#import "SDKCommonMethod.h"
static SDKCenterMenuView * instance;

static UIView * menuView;
typedef NS_OPTIONS(NSUInteger, FYCenterMenuViewStatus) {
    FYCenterMenuViewStatusAdhere = 1 << 0,
    FYCenterMenuViewStatusEdge = 1 << 1,
    FYCenterMenuViewStatusCenter = 1 << 2,
};
@interface SDKCenterMenuView() {
    SequenceAction * sequence;
    SequenceAction * sequence2;
}
@property (nonatomic,assign) BOOL show;
@property (nonatomic,assign) CGPoint lastPoint;
@property (nonatomic,assign) FYCenterMenuViewStatus status;
@end
@implementation SDKCenterMenuView
+(instancetype) shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        menuView = [UIView new];
        menuView.layer.cornerRadius = 5;
        menuView.layer.masksToBounds = YES;
        menuView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        instance = [[SDKCenterMenuView alloc] initWithFrame:CGRectMake(0, 0, DIAMETER, DIAMETER)];
        [instance setImage:[UIImage imageNamed:@"FYSDK_Resourcres.bundle/ass_common_icon"] forState:UIControlStateNormal];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:instance action:@selector(tap:)];
        [instance addGestureRecognizer:tap];
        [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(rotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
    });
    return instance;
}

- (void) rotate:(NSNotification*) note {
    if([UIDevice currentDevice].orientation == UIDeviceOrientationUnknown) {return;}
    [self hover];
}
- (void) tap:(UITapGestureRecognizer*) tap {
    self.show = !self.show;
    CGPoint rightPoint = [self rightPoint];
    [sequence cancel];
    AnimateAction * action1 = [[AnimateAction alloc] initWithView:instance duration:0.1 key:@"transform.scale" from:@1 to:@0.8];
    SDKBlockAction * action2 = [[SDKBlockAction alloc] initWithBlock:^(SDKBlockAction *action) {
        [menuView removeFromSuperview];
        action.hasFinished = YES;
    }];
    SDKBlockAction * action2_1 = [[SDKBlockAction alloc] initWithBlock:^(SDKBlockAction *action) {
        [menuView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        action.hasFinished = YES;
    }];
    SDKBlockAction * action3 = [[SDKBlockAction alloc] initWithBlock:^(SDKBlockAction *action) {
        CGPoint rightPoint = [self rightPoint];
        menuView.frame = CGRectMake(rightPoint.x, rightPoint.y,[self menuWidth], MenuHeight);
        [[SDKCenterMenuView shared].superview insertSubview:menuView belowSubview:instance];
        action.hasFinished = YES;
    }];

    AnimateAction * action4 = [[AnimateAction alloc] initWithView:menuView duration:0.1 key:@"bounds" from:[NSValue valueWithCGRect:CGRectMake(rightPoint.x, rightPoint.y, 0, 0)] to:[NSValue valueWithCGRect:CGRectMake(rightPoint.x, rightPoint.y, MenuMarginH*2+MenuItemWidth*self.items.count+MenuPaddingH*(self.items.count-1), MenuHeight)]];
    SDKBlockAction * action5 = [[SDKBlockAction alloc] initWithBlock:^(SDKBlockAction *action) {
        [self.items enumerateObjectsUsingBlock:^(SDKCenterMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(MenuMarginH+(MenuItemWidth+MenuPaddingH)*idx, MenuMarginV, MenuItemWidth, MenuItemHeight)];
            [button setImage:obj.image forState:UIControlStateNormal];
            [button setTitle:obj.title forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
            CGFloat imageW = button.imageView.frame.size.width;
            CGFloat imageH = button.imageView.frame.size.height;
            CGFloat titleW = button.titleLabel.frame.size.width;
            CGFloat titleH = button.titleLabel.frame.size.height;
            //图片上文字下
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageW, -imageH - 10, 0.f)];
            [button setImageEdgeInsets:UIEdgeInsetsMake(-titleH, 15, 0.f,-titleW)];
            button.tag = idx;
            [button addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
            [menuView addSubview:button];
        }];
        action.hasFinished = YES;
    }];
    NSMutableArray * actions = [NSMutableArray new];

    if (self.frame.origin.x == -35  || self.frame.origin.x == [UIScreen mainScreen].bounds.size.width-25) {
        [actions addObject:self.edgeAction];
    }
    [actions addObjectsFromArray:@[action1,action1.reversed]];
    [actions addObject:action2_1];
    if (self.show) {
        [actions addObjectsFromArray:@[action3,action4,action5]];
        sequence = [[SequenceAction alloc] initWithActions:actions];
    } else {
        [actions addObjectsFromArray:@[action2,[SDKAction delay:2],self.adhereAction]];
        sequence = [[SequenceAction alloc] initWithActions:actions];
    }
    [sequence execute];
}

- (void) buttonTouch:(UIButton*) button {
    SDKCenterMenuItem * item = self.items[button.tag];
    item.block(item);
}

- (CGFloat) menuWidth {
    return MenuMarginH*2+MenuItemWidth*self.items.count+MenuPaddingH*(self.items.count-1);
}

- (CGPoint) rightPoint {
    CGFloat X,Y;
    NSInteger i = 0;
    if (self.frame.origin.x < RADIUS) {
        X = CGRectGetMaxX(self.frame) + 10;
        i = 0;
    }
    else if (self.frame.origin.x > [UIScreen mainScreen].bounds.size.width - 90) {
        X = CGRectGetMinX(self.frame) - 10 - [self menuWidth];
        i = 2;
    } else {
        X = CGRectGetMinX(self.frame) - ([self menuWidth]-DIAMETER) / 2;
        i = 1;
    }
    switch (i) {
        case 0:
        case 2:
            Y = CGRectGetMinY(self.frame)-(MenuHeight-DIAMETER)/2;
            break;
        default:
            if (self.center.y < RADIUS) {
                Y = CGRectGetMaxY(self.frame) + 10;
            }
            else if (self.center.y > [UIScreen mainScreen].bounds.size.height - 90) {
                Y = CGRectGetMinY(self.frame) - MenuHeight - 10;
            } else {
                if (self.center.y > [UIScreen mainScreen].bounds.size.height / 2) {
                    Y = CGRectGetMinY(self.frame) - MenuHeight - 10;
                } else {
                    Y = CGRectGetMaxY(self.frame) + 10;
                }
            }
            break;
    }

    return CGPointMake(X, Y);
}


- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.lastPoint = [[touches anyObject] locationInView:self.superview];
    self.status = FYCenterMenuViewStatusCenter;
    [super touchesBegan:touches withEvent:event];

}

- (void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point =  [[touches anyObject] locationInView:self.superview];
    CGPoint offset = CGPointMake(point.x - self.lastPoint.x,point.y - self.lastPoint.y);
    self.center = CGPointMake(self.center.x+offset.x,self.center.y+offset.y);
    self.lastPoint = point;
    [super touchesMoved:touches withEvent:event];
}

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point =  [[touches anyObject] locationInView:self.superview];
    CGPoint offset = CGPointMake(point.x - self.lastPoint.x,point.y - self.lastPoint.y);
    self.center = CGPointMake(self.center.x+offset.x,self.center.y+offset.y);
    self.lastPoint = point;
    [super touchesEnded:touches withEvent:event];
    [self hover];
}

- (SDKBlockAction*) edgeAction {
    return [[SDKBlockAction alloc] initWithBlock:^(SDKBlockAction *action) {
        CGFloat xValue = 0;
        CGFloat yValue = instance.frame.origin.y;
        if (self.center.x < [UIScreen mainScreen].bounds.size.width/2) {
            xValue = 0;
        } else {
            xValue = [UIScreen mainScreen].bounds.size.width-DIAMETER;
        }
        if (yValue > [UIScreen mainScreen].bounds.size.height-DIAMETER) {
            yValue = [UIScreen mainScreen].bounds.size.height-DIAMETER;
        }
        [UIView animateWithDuration:0.1 animations:^{
            instance.frame = CGRectMake(xValue, yValue, instance.frame.size.width, instance.frame.size.height);
            self.status = FYCenterMenuViewStatusEdge;
        } completion:^(BOOL finished) {
            [action stop];
        }];
    }];
}

- (SDKAction*) adhereAction {
    SDKBlockAction * action1 = [[SDKBlockAction alloc] initWithBlock:^(SDKBlockAction *action) {
        if (instance.show) {
            [action stop];
            return;
        }
        CGFloat xValue = 0;
        if (self.center.x < [UIScreen mainScreen].bounds.size.width/2) {
            xValue = -35;
        } else {
            xValue = [UIScreen mainScreen].bounds.size.width-25;
        }
        [UIView animateWithDuration:0.1 animations:^{
            instance.frame = CGRectMake(xValue, instance.frame.origin.y, instance.frame.size.width, instance.frame.size.height);
        } completion:^(BOOL finished) {
            self.status = FYCenterMenuViewStatusAdhere;
            [action stop];
        }];
    }];
    return action1;
}

- (void) hover {
    [sequence2 cancel];
    SDKBlockAction * action7 = [[SDKBlockAction alloc] initWithBlock:^(SDKBlockAction *action) {
        CGRect rect;
        rect.origin = [self rightPoint];
        rect.size = menuView.frame.size;
        [UIView animateWithDuration:0.1 animations:^{
            menuView.frame = rect;
        } completion:^(BOOL finished) {
            [action stop];
        }];
    }];
    if((self.frame.origin.x >= [UIScreen mainScreen].bounds.size.width-25 || self.frame.origin.x <= -35) && !self.show) {
        sequence2  = [[SequenceAction alloc] initWithActions:@[[SDKAction delay:1],self.adhereAction]];
    } else {
        sequence2  = [[SequenceAction alloc] initWithActions:@[[SDKAction delay:1],self.edgeAction,[SDKAction delay:0.1],action7,self.adhereAction]];
    }
    
    [sequence2 execute];
}

+(void) show {
    [[COMMONMETHOD getRootViewController].view addSubview:[SDKCenterMenuView shared]];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [SDKCenterMenuView shared].frame = CGRectMake([UIScreen mainScreen].bounds.size.width-DIAMETER,[UIScreen mainScreen].bounds.size.height/2-RADIUS, DIAMETER, DIAMETER);
        [[SDKCenterMenuView shared] hover];
    });
}
+(void) hide {
    [SDKCenterMenuView shared].show = NO;
    [[SDKCenterMenuView shared] removeFromSuperview];
    [menuView removeFromSuperview];
}
@end

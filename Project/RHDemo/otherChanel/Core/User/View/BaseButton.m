
#import "BaseButton.h"
#import "UIColor+Category.h"
#import "sdkInitRequestManager.h"
#import "VersionAllMethod.h"
@implementation BaseButton

- (instancetype)init{
    
    self = [super init];
    if (self) {
        
        [self addTarget:self action:@selector(BtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

//防止恶意点击
- (void)BtnAction{
    
    self.enabled = NO;
    [self performSelector:@selector(changeButtonStatus) withObject:nil afterDelay:0.5f];
}

-(void)changeButtonStatus{
    self.enabled =YES;
}

- (void)setFYBtnFrame:(CGRect)frame
             norTitle:(NSString *)norTitle
            titleFont:(NSInteger)titleFont
           titleColor:(UIColor *)titleColor
      backgroundColor:(UIColor *)backgroundColor{
    
    self.frame = frame;
    [self setTitle:norTitle forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:titleFont];
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    [self setBackgroundColor:backgroundColor];

}

- (void)setFYBtnImageName:(NSString *)norImageName
        selectImageName:(NSString *)selectImageName
     highlightImageName:(NSString *)highlightImageName
{
    
    [self setImage:[UIImage imageNamed:norImageName] forState:UIControlStateNormal];
    if (selectImageName.length > 0) {
        [self setImage:[UIImage imageNamed:selectImageName] forState:UIControlStateSelected];
    }
    if (highlightImageName.length > 0) {
        [self setImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];
    }
    
}

- (void)setFYBtnBackgroundImageName:(NSString *)norBackgroundImageName
          selectBackgroundImageName:(NSString *)selectBackgroundImageName
       highlightBackgroundImageName:(NSString *)highlightBackgroundImageName{
    
    [self setBackgroundImage:[UIImage imageNamed:norBackgroundImageName] forState:UIControlStateNormal];
    if (selectBackgroundImageName.length > 0) {
        [self setBackgroundImage:[UIImage imageNamed:selectBackgroundImageName] forState:UIControlStateSelected];
    }
    if (highlightBackgroundImageName.length > 0) {
        [self setBackgroundImage:[UIImage imageNamed:highlightBackgroundImageName] forState:UIControlStateHighlighted];
    }
}

//绘制圆角
- (void)drawFYBtnRound{
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:self.bounds.size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)countDownFromTime:(NSInteger)startTime unitTitle:(NSString *)unitTitle completion:(Completion)completion {
    __weak typeof(self) weakSelf = self;
    // 剩余的时间（必须用__block修饰，以便在block中使用）
    __block NSInteger remainTime = startTime;
    // 获取全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 每隔1s钟执行一次
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    // 在queue中执行event_handler事件
    dispatch_source_set_event_handler(timer, ^{
        if (remainTime <= 0) { // 倒计时结束
            dispatch_source_cancel(timer);
            // 回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.enabled = YES;
                setTimeDown(@"0");
                completion(weakSelf);
                
            });
        } else {
            NSString *timeStr = [NSString stringWithFormat:@"%ld", remainTime];
            // 回到主线程更新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf setTitle:[NSString stringWithFormat:@"等待%@%@",timeStr,unitTitle] forState:UIControlStateDisabled];
                weakSelf.enabled = NO;
                setTimeDown(timeStr);
            });
            remainTime--;
          
        }
    });
    dispatch_resume(timer);
}

+ (UIImage*)createImageWithColor:(UIColor*)color{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event{
    CGRect bounds = self.bounds;
    //扩大原热区直径至26，可以暴露个接口，用来设置需要扩大的半径。
    CGFloat widthDelta = MAX(26, 0);
    CGFloat heightDelta = MAX(26, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}
@end

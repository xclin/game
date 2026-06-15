
#import <UIKit/UIKit.h>

@interface RemindView : NSObject

@property (nonatomic, retain) UIView * remindView;
@property (nonatomic, assign) CGFloat tempTime;

+ (instancetype)share;
//time秒后显示消失，默认2秒
- (void)show:(NSString *)msgString
        time:(CGFloat)time;
//loading一直显示，window是否可点击
- (void)showAllTheTime:(NSString *)msgString
            isCanTouch:(BOOL)isCanTouch;

- (void)hidden;

@end

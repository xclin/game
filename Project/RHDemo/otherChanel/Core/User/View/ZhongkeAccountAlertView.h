

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZhongkeAccountAlertView : UIView

@property (nonatomic, copy) void(^submitBtnBlock)();
- (void)show;
@end

NS_ASSUME_NONNULL_END

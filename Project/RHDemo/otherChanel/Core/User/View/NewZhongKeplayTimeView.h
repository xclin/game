
#import "ZhongkeView.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewZhongKeplayTimeView : ZhongkeView
@property (nonatomic, copy) void(^submitBtnBlock)();
@property (nonatomic,strong)  UITextView   *contentview;
@end

NS_ASSUME_NONNULL_END

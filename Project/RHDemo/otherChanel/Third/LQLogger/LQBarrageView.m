
#import "LQBarrageView.h"
@implementation LQBarrageView
LQSingletonInstanceMMethod(LQBarrageView,^{
    
})

- (void) show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
- (void) hide {
    [self removeFromSuperview];
}
@end

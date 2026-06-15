
#import "DelayAction.h"

@implementation DelayAction
- (instancetype) initWithValue:(CGFloat)value {
    self = [super init];
    if (self) {
        self.value = value;
    }
    return self;
}
- (void) execute {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.value * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.hasCanceled)return;
        self.hasFinished = YES;
    });
}
- (void) dealloc {
   // NSLog(@"%s",__func__);
}
@end

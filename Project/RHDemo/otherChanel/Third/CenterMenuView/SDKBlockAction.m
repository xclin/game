
#import "SDKBlockAction.h"

@implementation SDKBlockAction
- (instancetype) initWithBlock:(BlockActionBlock) block {
    self = [super init];
    if (self) {
        self.block = block;
    }
    return self;
}
- (void) execute {
    self.block(self);
}
- (void) dealloc {
    //NSLog(@"%s",__func__);
}
@end

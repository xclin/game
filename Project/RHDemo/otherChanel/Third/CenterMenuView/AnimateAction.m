
#import "AnimateAction.h"
@interface AnimateAction()<CAAnimationDelegate>
@end
@implementation AnimateAction {
    CABasicAnimation * anim;
}
- (instancetype) initWithView:(UIView*) view duration:(CGFloat) duration key:(NSString*) key from:(id) from to:(id) to {
    self = [super init];
    if (self) {
        self.view = view;
        self.duration = duration;
        self.key = key;
        self.from = from;
        self.to = to;
    }
    return self;
}

- (AnimateAction*) reversed {
    return [[AnimateAction alloc] initWithView:self.view duration:self.duration key:self.key from:self.to to:self.from];
}
- (void) execute {
    anim = [CABasicAnimation animation];
    anim.duration = self.duration;
    anim.keyPath = self.key;
    anim.fromValue = self.from;
    anim.toValue = self.to;
    //anim.removedOnCompletion = NO;
    //anim.fillMode = kCAFillModeForwards;
    anim.delegate = self;
    [self.view.layer addAnimation:anim forKey:self.key];
}

- (void) animationDidStart:(CAAnimation *)anim {
    
}
- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        [self stop];
    }
}
- (void) cancel {
    [self.view.layer removeAnimationForKey:self.key];
}

- (void) dealloc {
    //NSLog(@"%s",__func__);
}

@end

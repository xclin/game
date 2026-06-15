
#import "AnimationGroupAction.h"
@interface AnimationGroupAction()<CAAnimationDelegate>
@end
@implementation AnimationGroupAction {
    CAAnimationGroup * group;
    NSArray<CABasicAnimation*> * _animations;
    NSString * key;
}
- (instancetype) initWithView:(UIView*) view Animcations:(NSArray <CABasicAnimation*> *) animations {
    self = [super init];
    if (self) {
        self.animations = animations;
        self.view = view;
        _animations = animations;
    }
    return self;
}
- (void) execute {
    group = [CAAnimationGroup animation];
    
    //anim.removedOnCompletion = NO;
    //anim.fillMode = kCAFillModeForwards;
    group.delegate = self;
    key = [NSUUID UUID].UUIDString;
    [self.view.layer addAnimation:group forKey:key];
}

- (void) animationDidStart:(CAAnimation *)anim {
    
}
- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        [self stop];
    }
}
- (void) cancel {
    [self.view.layer removeAnimationForKey:key];
}


@end

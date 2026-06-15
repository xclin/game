

#import "SDKAction.h"
#import "DelayAction.h"
#import "SequenceAction.h"
@implementation SDKAction
- (void) cancel {self.hasCanceled = YES;}
- (void) execute {}
- (void) stop {self.hasFinished = YES;}
@end
@implementation SDKAction (Category)

+(instancetype) delay:(CGFloat)value {
    return [[DelayAction alloc] initWithValue:value];
}
+(instancetype) sequence:(NSArray *)sequence {
    return [[SequenceAction alloc] initWithActions:sequence];
}
@end

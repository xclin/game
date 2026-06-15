
#import "SequenceAction.h"

@implementation SequenceAction {
    NSInteger selectedIndex;
}
- (instancetype) initWithActions:(NSArray *)actions {
    self = [super init];
    if (self) {
        self.actions = actions;
        [self.actions addObserver:self toObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.actions.count)] forKeyPath:@"hasFinished" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}
- (void) execute {
    [self.actions[selectedIndex] execute];
}
- (void) cancel {
    [super cancel];
    [self.actions[selectedIndex] cancel];
}
- (void) stop {
    if (!self.hasFinished) {
        self.hasFinished = YES;
        if ([self.actions[selectedIndex] hasFinished] == NO) {
            [self.actions[selectedIndex] stop];
        }
    }
}
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSInteger index = [self.actions indexOfObject:object];
    if (index == self.actions.count - 1) {
        [self stop];
    } else {
        selectedIndex += 1;
        [self.actions[selectedIndex] execute];
    }
}

- (void) dealloc {
    //NSLog(@"%s",__func__);
    [self.actions removeObserver:self fromObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.actions.count)] forKeyPath:@"hasFinished"];
}
@end

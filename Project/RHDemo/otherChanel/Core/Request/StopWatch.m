
#import "StopWatch.h"
#import "VersionAllMethod.h"
@implementation StopWatch {
    NSDate * date;
    NSString * _name;
}
- (instancetype) initWithName:(NSString*) name {
    self = [super init];
    if (self) {
        [self reset];
        _name = name;
    }
    return self;
}
- (void) reset {
    date = [NSDate new];
}
- (void) stop {
    DEBUGMSG(@"%@:%fs",_name,[[NSDate new] timeIntervalSinceDate:date]);
}

- (void) measure:(dispatch_block_t)block {
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
        [self reset];
        block();
        [self stop];
    });
}
@end

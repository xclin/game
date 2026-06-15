
#import "VerificationCode.h"
#import "SDKCommonMethod.h"
static VerificationCode *sharedInstance = nil;
@interface VerificationCode ()
@property (nonatomic) int timerNum;
@property (nonatomic,retain) NSTimer * timer;
@end

@implementation VerificationCode
+ (instancetype)sharedInstance {
    static dispatch_once_t pred;
    dispatch_once( &pred, ^{
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc]init];
        }

    });
    return sharedInstance;
}

- (void)setupTimer {
    _timerNum = 60;
    [[NSNotificationCenter defaultCenter] postNotificationName:fysdkVcHeartbeat object:@(_timerNum)];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                              target:self
                                            selector:@selector(timerAction)
                                            userInfo:nil
                                             repeats:YES];
}

- (void)timerAction {
    _timerNum--;
    if (_timerNum == 0) {
        [_timer invalidate];
        [[NSNotificationCenter defaultCenter] postNotificationName:fysdkVcInvalidate object:nil];
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:fysdkVcHeartbeat object:@(_timerNum)];
}

- (BOOL)canSetup {
    return _timerNum == 0? true : false;
}

@end

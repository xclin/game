
#import "requestRunLoopAcctokenReFresh.h"
#import "BaseModel.h"
#import "SDKCommonMethod.h"
#import "UserDataController.h"
#define timeLength  60.0
static requestRunLoopAcctokenReFresh * sharedLimit = nil;

@implementation requestRunLoopAcctokenReFresh

+ (instancetype)shared {
    @synchronized(self) {
        if (sharedLimit == nil) {
            sharedLimit = [[requestRunLoopAcctokenReFresh alloc]init];
        }
    }
    return sharedLimit;
}

- (void)startRunAcctokenReFresh{
    
    
    [self startLoop];
    
}

- (void)startLoop{
    
    self.timer =  [NSTimer scheduledTimerWithTimeInterval:timeLength target:self selector:@selector(getPlaytimelimitRequest) userInfo:nil repeats:YES];
}

- (void)getPlaytimelimitRequest{
    
    UserDataController * dc = [[UserDataController alloc]init];
    __weak typeof (self) wSelf = self;
    [dc getPlayTimeLimit:[NSString stringWithFormat:@"%f",timeLength] ageLevel:COMMONMETHOD.ageLevel andSuccess:^(int code, NSString *msg, id object) {
        if (code == 0 ) {
            [wSelf stopLoop];
        }
        } andFailure:^(int code, NSString *msg) {
            [wSelf stopLoop];
        }];
    
}



- (void)stopLoop{
    
    [self.timer invalidate];
    self.timer=nil;
    
}
@end

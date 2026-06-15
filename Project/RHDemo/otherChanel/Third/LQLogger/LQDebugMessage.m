
#import "LQLogger.h"
#import "LQDebugMessage.h"
@interface LQDebugMessage()

@end
@implementation LQDebugMessage

-(instancetype) initWithMessage:(NSString*) message {
    NSUInteger color = LQColorGreen;
   
    NSString * str = [message lowercaseString];
    __block int hasWarning = 0;
    __block int hasError = 0;
    [[LQLogger shared].warningKeys enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([str containsString:obj]) {
            hasWarning++;
        }
    }];
    [[LQLogger shared].errorKeys enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([str containsString:obj]) {
            hasError++;
        }
    }];
    if ([str containsString:@"failureBlock"]) {
        hasError--;
    }
    if (hasWarning > 0 || hasError > 0) {
        if (hasWarning > hasError) {
            color = LQColorOrange;
        } else {
            color = LQColorRed;
        }
    }
    
    self = [super initWithTime:[NSDate new].timeIntervalSince1970 color:color message:message];
    return self;
}
@end


#import <Foundation/Foundation.h>
#define fysdkVcHeartbeat @"vcHeartbeat"
#define fysdkVcInvalidate @"vcInvalidate"

#define VC [VerificationCode sharedInstance]
@interface VerificationCode : NSObject
+ (instancetype)sharedInstance;
- (void)setupTimer;
- (BOOL)canSetup;
@end

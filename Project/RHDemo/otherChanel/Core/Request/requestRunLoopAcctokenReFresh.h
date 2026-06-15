

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface requestRunLoopAcctokenReFresh : NSObject
+ (instancetype)shared;
@property (nonatomic,strong) NSTimer * __nullable timer;
- (void)startRunAcctokenReFresh;

- (void)stopLoop;
@end

NS_ASSUME_NONNULL_END



#import <Foundation/Foundation.h>
#import "PusherSwift/PusherSwift-Swift.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDKPusherManager : NSObject <PusherDelegate>
@property (nonatomic, strong) Pusher *client;
@property (nonatomic, strong)  PusherChannel *myPrivateChannel;
 // 计时器
@property (nonatomic, strong) NSTimer *connectTimer;

+(instancetype)shared;
- (void)startConnectServer;
@end

NS_ASSUME_NONNULL_END

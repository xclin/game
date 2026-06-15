

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface scoketManager : NSObject
+(instancetype)shared;
- (void)startConnectServer;
@end

NS_ASSUME_NONNULL_END

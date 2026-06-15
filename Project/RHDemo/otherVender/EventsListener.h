

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EventsListener : NSObject
+ (instancetype)shared;

- (void)startListen;
@end

NS_ASSUME_NONNULL_END


#import "LQMessage.h"
///调试信息，通过统计包含的错误或警告的关键字数目推测是正常、错误还是警告消息。
@interface LQDebugMessage : LQMessage

/**
 初始化函数

 @param message 消息
 @return 描述
 */
-(instancetype) initWithMessage:(NSString*) message;
@end

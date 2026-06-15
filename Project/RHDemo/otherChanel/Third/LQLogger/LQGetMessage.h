

#import "LQMessage.h"

/**
 Get请求的消息
 */
@interface LQGetMessage : LQMessage

/**
 输入,html链接
 */
@property (nonatomic,strong) NSString * input;

/**
 输出
 */
@property (nonatomic,strong) NSString * output;

/**
 是否成功
 */
@property (nonatomic,assign) BOOL succeed;

/**
 实例化方法

 @param input 输入
 @param output 输出
 @param succeed 是否成功
 @return LQGetMessage实例
 */
+ (instancetype) messageWithInput:(NSString*) input output:(NSString*) output succeed:(BOOL) succeed;
@end

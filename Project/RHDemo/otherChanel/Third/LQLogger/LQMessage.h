
#import <Foundation/Foundation.h>
#import <UIKit/UIColor.h>
/**
 日志消息
 */
@interface LQMessage : NSObject

/**
 时间
 */
@property (nonatomic,assign) NSTimeInterval time;

/**
 颜色
 */
@property (nonatomic,assign) NSUInteger color;

/**
 消息
 */
@property (nonatomic,strong) NSString * message;

/**
 初始化函数

 @param time 事件
 @param color 颜色
 @param message 消息
 @return 实例
 */
-(instancetype) initWithTime:(NSTimeInterval) time color:(NSUInteger) color message:(NSString*) message;

/**
 初始化方法

 @param time 时间
 @param color 颜色
 @param message 消息
 @return 实例
 */
+(instancetype) messageWithTime:(NSTimeInterval) time color:(NSUInteger) color message:(NSString*) message;

/**
 初始化方法

 @param color 时间
 @param message 颜色
 @return 实例
 */
+(instancetype) messageWithColor:(NSUInteger) color message:(NSString*) message;

/**
 带时间的属性字符串

 @return 属性字符串
 */
- (NSAttributedString*) attributedStringWithTime;

/**
 属性字符串

 @return 属性字符串
 */
- (NSAttributedString*) attributedString;

- (UIColor*) uiColor;
@end


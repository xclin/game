

#import <Foundation/Foundation.h>
#import "LQConstants.h"
#import "LQMessage.h"
#import "LQDebugMessage.h"
@import UIKit;
/**
 日志查看器
 */
@interface LQLogger : NSObject
LQSingletonInstanceHMethod
/**
 网络消息
 
 @return 网络消息
 */
@property (nonatomic,readonly) NSArray * webMessages;

/**
 是否显示弹幕
 */
@property (nonatomic,assign) BOOL shouldShowBarrage;

/**
 是否打印日志
 */
@property (nonatomic,assign) BOOL shouldShowLog;
/**
 是否应该记录按钮状态
 */
@property (nonatomic,assign) BOOL shouldRecordStatus;

/**
 是否应该显示菜单
 */
@property (nonatomic,assign) BOOL shouldShowMenu;

/**
 如果需要恢复菜单显示
 */
- (void) recoverIfNeeded;

/**
 加入日志内容
 
 @param content 日志内容
 */
- (void) log:(LQMessage*) content;

/**
 分享日志内容
 */
- (void) share;

/**
 分享文本
 */
- (void) shareText;

/**
 复制到粘贴板
 */
- (void) copyToPastboard;

/**
 显示或隐藏弹幕
 */
- (void) showHideBarrage;

#pragma mark - Utils

/**
 警告的关键字
 */
@property (strong,nonatomic) NSArray * warningKeys;

/**
 错误的关键字
 */
@property (strong,nonatomic) NSArray * errorKeys;

+ (UIViewController*) rootPresentedController;

/**
 上传错误日志

 @param url 请求错误的链接
 @param error 错误信息
 */
- (void) uploadLogWithUrl:(NSString*) url error:(NSString*) error;
@end

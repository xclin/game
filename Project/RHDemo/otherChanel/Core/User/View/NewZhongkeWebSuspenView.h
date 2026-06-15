

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewZhongkeWebSuspenView : NSObject

+(instancetype)shared;

/**
 *  显示悬浮按钮
 */
- (void)showSuspension;

/**
 *  隐藏悬浮按钮
 */
- (void)hideSuspensionToolBar;

/**
 
 @param isHide 是否隐藏SDK界面的关闭按钮
 */
- (void)setHideCannelBtn:(BOOL)isHide;

@end

NS_ASSUME_NONNULL_END

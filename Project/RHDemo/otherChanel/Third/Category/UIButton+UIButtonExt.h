//
//  UIButton+UIButtonExt.h
//  FrameworkHome
//
//  Created by Johnny on 16/7/5.
//  Copyright © 2016年 FY65NetWork. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (UIButtonExt)

- (void)centerImageAndTitle:(float)space;
- (void)centerImageAndTitle;
- (void)showBadgeOnButonRightIndex:(int)index andOffset:(CGFloat)offset;//显示小红点
- (void)hideBadgeOnButtonIndex:(int)index;//隐藏小红点
- (void)showBadgeOnButonLeftIndex:(int)index andOffset:(CGFloat)offset;//显示小红点

@end

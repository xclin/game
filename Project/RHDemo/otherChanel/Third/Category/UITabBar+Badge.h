//
//  UITabBar+Badge.h
//  FYAppStoreDemo
//
//  Created by 凡跃 on 2017/12/18.
//  Copyright © 2017年 fanyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (Badge)

//tabbar方法
- (void)showBadgeOnItemIndex:(NSInteger)index withTabAccount:(NSInteger)account;   //显示小红点

- (void)hideBadgeOnItemIndex:(NSInteger)index; //隐藏小红点

@end

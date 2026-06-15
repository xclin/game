//
//  UITabBar+Badge.m
//  FYAppStoreDemo
//
//  Created by 凡跃 on 2017/12/18.
//  Copyright © 2017年 fanyue. All rights reserved.
//

#import "UITabBar+Badge.h"
#import "SDKCommonMethod.h"
#define TabbarItemNums 4.0    //tabbar的数量
#define ISiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

@implementation UITabBar (Badge)

- (void)showBadgeOnItemIndex:(NSInteger)index withTabAccount:(NSInteger)account{
    
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 999 + index;
    badgeView.layer.cornerRadius = 5;
    badgeView.backgroundColor = [UIColor redColor];
    CGRect tabFrame = self.frame;

    //确定小红点的位置
    float percentX = (index + 0.52) / account;
    CGFloat x;
    x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    
    if (ISiPhoneX) {
        CGFloat itemWith = tabFrame.size.width/3/account;  //item宽
        if (ISiPhoneX) {
            itemWith = tabFrame.size.width/3/account-20;
        }
        CGFloat tempWith = (tabFrame.size.width - itemWith*account)/(account+1);  //每一空白处宽
        CGFloat z = itemWith/account*(account-1);   //红点往图标处移
        x = (itemWith+tempWith)*(index+1) - z;
    }
    
    badgeView.frame = CGRectMake(x, y, 10, 10);
    badgeView.clipsToBounds = YES;
    [self addSubview:badgeView];
    
}

- (void)hideBadgeOnItemIndex:(NSInteger)index{
    
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}

- (void)removeBadgeOnItemIndex:(NSInteger)index{
    
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        
        if (subView.tag == 999+index) {
            
            [subView removeFromSuperview];
            
        }
    }
}

@end

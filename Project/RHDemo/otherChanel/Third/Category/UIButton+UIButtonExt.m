//
//  UIButton+UIButtonExt.m
//  FrameworkHome
//
//  Created by Johnny on 16/7/5.
//  Copyright © 2016年 FY65NetWork. All rights reserved.
//

#import "UIButton+UIButtonExt.h"
#import "SDKCommonMethod.h"

static CGFloat kXOffset = 4; //偏移量
static CGFloat kYOffset = 4; //偏移量

@implementation UIButton (UIButtonExt)
- (void)centerImageAndTitle:(float)spacing {
    // get the size of the elements here for readability
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    // get the height they will take up as a unit
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    
    // raise the image and push it right to center it
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 11, 0.0, 0);
    } else if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 10, 0.0, 0);
    } else {
        self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 10, 0.0, 10);
    }
    
    // lower the text and push it left to center it
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (totalHeight - titleSize.height),0.0);
}

- (void)centerImageAndTitle {
    const int DEFAULT_SPACING = 4.0f;
    [self centerImageAndTitle:DEFAULT_SPACING];
}
//悬浮窗在右侧时
- (void) showBadgeOnButonRightIndex:(int)index andOffset:(CGFloat)offset {
    //移除之前的小红点
    [self removeBadgeOnButtonItemIndex:index];
    if ([COMMONMETHOD isShowBadgeNum]) {
        CGFloat size = 10;
        //新建小红点
        UIView * badgeView = [[UIView alloc]init];
        badgeView.tag = 888+index;
        badgeView.layer.cornerRadius = size/2;
        badgeView.backgroundColor = [UIColor redColor];
        badgeView.frame = CGRectMake(0, 0, size, size);
        badgeView.center = CGPointMake(self.frame.size.width - (self.frame.size.width/4) + kXOffset + offset, (self.frame.size.height/4) - kYOffset - offset);
//        [self addSubview:badgeView];
    }
}
//悬浮窗在左侧时
- (void)showBadgeOnButonLeftIndex:(int)index andOffset:(CGFloat)offset {
    //移除之前的小红点
    [self removeBadgeOnButtonItemIndex:index];
    if ([COMMONMETHOD isShowBadgeNum]) {
        CGFloat size = 10;
        //新建小红点
        UIView * badgeView = [[UIView alloc]init];
        badgeView.tag = 888+index;
        badgeView.layer.cornerRadius = size/2;
        badgeView.backgroundColor = [UIColor redColor];
        badgeView.frame = CGRectMake(0, 0, size, size);
        badgeView.center = CGPointMake((self.frame.size.width/4) - kXOffset - offset, (self.frame.size.height/4) - kYOffset - offset);
//        [self addSubview:badgeView];
    }
}
- (void)hideBadgeOnButtonIndex:(int)index {
    //移除小红点
    [self removeBadgeOnButtonItemIndex:index];
}
- (void)removeBadgeOnButtonItemIndex:(int)index {
    //按照tag值移除
    for (UIView * subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}
@end

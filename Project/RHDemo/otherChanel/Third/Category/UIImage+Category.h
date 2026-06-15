//
//  UIImage+Category.h
//  FrameWork
//
//  Created by lonnie on 2017/5/3.
//  Copyright © 2017年 fanyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)
/**
 *  color 创建图片
 *
 *   color
 *
 *  @return image
 */
+ (UIImage *) imageWithColor: (UIColor *) color;
#pragma mark - 以view来截图
+ (UIImage *)imageFromView:(UIView *)theView;
@end

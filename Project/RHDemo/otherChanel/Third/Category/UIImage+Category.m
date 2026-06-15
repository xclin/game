//
//  UIImage+Category.m
//  FrameWork
//
//  Created by lonnie on 2017/5/3.
//  Copyright © 2017年 fanyue. All rights reserved.
//

#import "UIImage+Category.h"

@implementation UIImage (Category)
/**
 *  color 创建图片
 *
 *  @param color
 *
 *  @return image
 */
+ (UIImage *) imageWithColor: (UIColor *) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+(UIImage *) imageFromView:(UIView *)theView {
    UIGraphicsBeginImageContextWithOptions(theView.bounds.size, YES, theView.layer.contentsScale);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end

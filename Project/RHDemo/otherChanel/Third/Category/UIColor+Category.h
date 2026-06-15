//
//  UIColor+Category.h
//  FYAppStoreDemo
//
//  Created by lonnie on 2017/5/3.
//  Copyright © 2017年 fanyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Category)
/**
 *  颜色--16进制转RGB
 *
 *  @param color 例如：#99999
 *
 *  @return RGB值
 */

+ (UIColor *)colorWithHexString: (NSString *)color;
@end

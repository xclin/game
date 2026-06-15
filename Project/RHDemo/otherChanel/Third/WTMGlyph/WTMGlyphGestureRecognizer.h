//
//  WTMGlyphGestureRecognizer.h
//  FrameWork
//
//  Created by lonnie on 2017/4/25.
//  Copyright © 2017年 fanyue. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^WTMGlyphGestureReconizeBlock)(NSString * glyph);
@interface WTMGlyphGestureRecognizer : UIPanGestureRecognizer
@property (nonatomic,copy) WTMGlyphGestureReconizeBlock block;
- (instancetype) initWithView:(UIView*) view handler:(WTMGlyphGestureReconizeBlock) block;
+ (void) addGestureToView:(UIView*) view handler:(WTMGlyphGestureReconizeBlock) block;
@end

//
//  WTMGlyphGestureRecognizer.m
//  FrameWork
//
//  Created by lonnie on 2017/4/25.
//  Copyright © 2017年 fanyue. All rights reserved.
//

#import "WTMGlyphGestureRecognizer.h"
#import "WTMGlyphDetector.h"
@implementation WTMGlyphGestureRecognizer
- (instancetype) initWithView:(UIView*) view handler:(WTMGlyphGestureReconizeBlock) block {
    self = [super initWithTarget:self action:@selector(pan:)];
    if (self) {
        view.userInteractionEnabled = YES;
        [view addGestureRecognizer:self];
        self.block = block;
    }
    return self;
}

- (void) pan:(UIPanGestureRecognizer*) pan {
    CGPoint point = [pan locationInView:pan.view];
    [[WTMGlyphDetector shared] addPoint:point];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
            break;
        case UIGestureRecognizerStateEnded:
        {
            WTMDetectionResult *  obj =  [[WTMGlyphDetector shared] detectGlyph];
            if (obj.bestScore > 1.5) {
                if (self.block) {
                    self.block(obj.bestMatch.name);
                }
            }
            [[WTMGlyphDetector shared] removeAllPoints];
        }
            break;
        default:
            [[WTMGlyphDetector shared] removeAllPoints];
            break;
    }
}
+ (void) addGestureToView:(UIView *) view handler :(WTMGlyphGestureReconizeBlock)block {
    WTMGlyphGestureRecognizer * recognizer = [[WTMGlyphGestureRecognizer alloc] initWithView:view handler:block];
    [recognizer description];
}
@end

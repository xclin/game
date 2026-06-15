//
//  setNewPwdTipsView.m
//  FYAppStoreDemo
//
//  Created by xiaocong lin on 2021/1/26.
//  Copyright © 2021 fanyue. All rights reserved.
//

#import "NewZhongkeSetNewPwdTipsView.h"
#import "VersionAllMethod.h"
@implementation NewZhongkeSetNewPwdTipsView

- (instancetype) init {
    self = [super init];
    if (self) {
        [self setupUI];
        self.frame  = CGRectMake((windowWidth-SCREEN_FIT(200))/2, (windowHeight - SCREEN_FIT(40))/2, SCREEN_FIT(200), SCREEN_FIT(40));
        
        
    }
    return self;
}

- (void) setupUI {
    
    [self addSubview: self.textLbl];
}


- (UILabel *)textLbl{
    if (!_textLbl) {
        _textLbl = [UILabel new];
        _textLbl.frame = CGRectMake(0, 0,SCREEN_FIT(200), SCREEN_FIT(40));
        _textLbl.font = [UIFont systemFontOfSize:20.0f];
        _textLbl.textColor = [UIColor whiteColor];
        _textLbl.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7];
        _textLbl.textAlignment = NSTextAlignmentCenter;
        _textLbl.layer.cornerRadius = SCREEN_FIT(5);
        _textLbl.layer.masksToBounds = YES;
        _textLbl.text = @"新密码设置成功";
    }
    return _textLbl;
}


- (void)show{
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
    self.textLbl.alpha = 0;
    [UIView animateWithDuration:1 animations:^{
        self.textLbl.alpha = 1;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:1 animations:^{
                self.textLbl.alpha = 0;
                
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }
    }];
    
}

@end

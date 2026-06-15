//
//  hideSupenViewTipsView.m
//  GameSDK
//
//  Created by 凡跃 on 2021/8/7.
//  Copyright © 2021 lonnie. All rights reserved.
//

#import "hideSupenViewTipsView.h"
#define windowWidth ([UIScreen mainScreen].bounds.size.width)
#define windowHeight ([UIScreen mainScreen].bounds.size.height)
#define rgba(r,g,b,c) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:c]
@interface hideSupenViewTipsView ()

@end
@implementation hideSupenViewTipsView

- (instancetype)initWithFrame:(CGRect)frame{
    NSLog(@"进来了");
    self = [super initWithFrame:CGRectMake(0, 0, windowWidth, windowHeight)];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.3];
        [self setUpView];
    }
    return self;
}

- (void)setUpView{
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.titleLbl];
    [self.bgView addSubview:self.btnAgreed];
    [self.bgView addSubview:self.btnCancel];
    [self.bgView addSubview:self.btnSure];
   
}


- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = rgba(0, 0, 0, 0.8);
        _bgView.frame = CGRectMake((windowWidth-300)/2, (windowHeight-150)/2, 300, 150);
        _bgView.layer.cornerRadius = 10;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [UILabel new];
        _titleLbl.frame = CGRectMake(0, 20, CGRectGetWidth(self.bgView.frame), 20);
        _titleLbl.font = [UIFont systemFontOfSize:18];
        _titleLbl.textColor = rgba(252, 197, 105, 1);
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        _titleLbl.text = @"重启游戏后悬浮球再次出现";

    }
    
    return _titleLbl;
}

- (UIButton *)btnAgreed{
    if (!_btnAgreed) {
        _btnAgreed = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnAgreed.frame = CGRectMake(50,CGRectGetMaxY(self.titleLbl.frame), 200, 40);
        [_btnAgreed setTitle:@"不再提示" forState:UIControlStateNormal];
        [_btnAgreed setImage:[UIImage imageNamed:@"FYSDK_Resourcres.bundle/forHide_false"] forState:UIControlStateNormal];
        [_btnAgreed addTarget:self action:@selector(agreedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btnAgreed setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnAgreed setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
        [_btnAgreed setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];

          
    }
    return _btnAgreed;
    
}

- (UIButton *)btnCancel{
    if (!_btnCancel) {
        _btnCancel = [UIButton new];
        _btnCancel.frame = CGRectMake(40, CGRectGetMaxY(self.btnAgreed.frame)+5, 100, 50);
        [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [_btnCancel addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnCancel.backgroundColor = rgba(206, 206, 206, 1);
        _btnCancel.layer.cornerRadius = 5;
        _btnCancel.layer.masksToBounds = YES;

    }
    return _btnCancel;
    
}


- (UIButton *)btnSure{
    if (!_btnSure) {
        _btnSure = [UIButton new];
        _btnSure.frame = CGRectMake(CGRectGetMaxX(self.btnCancel.frame)+20, CGRectGetMaxY(self.btnAgreed.frame)+5, 100, 50);
        [_btnSure setTitle:@"确定" forState:UIControlStateNormal];
        [_btnSure addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _btnSure.backgroundColor = rgba(252, 197, 105, 1);
        [_btnSure setTitleColor:rgba(93, 49, 22, 1) forState:UIControlStateNormal];
        _btnSure.layer.cornerRadius = 5;
        _btnSure.layer.masksToBounds = YES;
    }
    return _btnSure;
    
}






- (void)agreedBtnClick:(UIButton *)sender{
    
    self.btnAgreed.selected = !sender.selected;
    if (self.btnAgreed.selected) {
        [self.btnAgreed setImage:[UIImage imageNamed:@"FYSDK_Resourcres.bundle/forHide_true"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"notshowHidenagain"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        [self.btnAgreed setImage:[UIImage imageNamed:@"FYSDK_Resourcres.bundle/forHide_false"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"notshowHidenagain"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

}

- (void)cancelBtnClick{
    
    [self hide];
    
    if (self.block) {
        self.block(NO);
    }
}

- (void)sureBtnClick{
    
    [self hide];
    if (self.block) {
        self.block(YES);
    }
}


/**
 移除视图
 */
- (void)hide{
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformMakeScale(0.8, 0.8);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (void)show{
  
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
  
////    self.alpha = 0;
//    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
////        self.transform = CGAffineTransformIdentity;
////        self.alpha = 1;
//    } completion:nil];
//
    
    
}
@end

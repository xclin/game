//
//  NewZhongkePwdWarningView.m
//  FYAppStoreDemo
//
//  Created by xiaocong lin on 2021/1/26.
//  Copyright © 2021 fanyue. All rights reserved.
//

#import "NewZhongkePwdWarningView.h"
#import "ZhongkeView.h"
#import "SDKCommonMethod.h"
static NewZhongkePwdWarningView * _singletonVC;


@implementation NewZhongkePwdWarningView

- (instancetype)init{
       self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void) setupUI {
    [[COMMONMETHOD getRootViewController].view addSubview:self.remindView];
    [self.remindView addSubview: self.titleLbl];
    [self.remindView addSubview: self.textLbl1];
    [self.remindView addSubview: self.textLbl2];
    [self.remindView addSubview: self.cancelBtn];
    [self.remindView addSubview: self.surBtn];
    self.remindView.center = [COMMONMETHOD getRootViewController].view.center;
}



- (UIView *)remindView{
    if (!_remindView) {
        _remindView = [UIView new];
        _remindView.frame  = CGRectMake(10, 10, SCREEN_FIT(300), SCREEN_FIT(200));
        _remindView.layer.cornerRadius = 5;
        _remindView.layer.masksToBounds = YES;
        _remindView.userInteractionEnabled = YES;
        _remindView.backgroundColor = [UIColor whiteColor];
    }
    
    return _remindView;
}
- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [UILabel new];
        _titleLbl.text = @"密码风险";
        _titleLbl.frame =CGRectMake(0, SCREEN_FIT(20),SCREEN_FIT(300), SCREEN_FIT(25));
        _titleLbl.textAlignment =NSTextAlignmentCenter;
        _titleLbl.textColor =rgba(0, 0, 0, 1);
        _titleLbl.font = font(23);
        
    }
    return _titleLbl;
}

- (UILabel *)textLbl1{
    if (!_textLbl1) {
        _textLbl1 = [UILabel new];
        _textLbl1.text = @"您设置的密码复杂度较低、有账号安全方面的风险，确定要使用吗？";
        _textLbl1.frame =CGRectMake(SCREEN_FIT(20), CGRectGetMaxY(self.titleLbl.frame)+SCREEN_FIT(15),SCREEN_FIT(260), SCREEN_FIT(50));
        _textLbl1.textAlignment =NSTextAlignmentLeft;
        _textLbl1.textColor =rgba(145, 145, 145, 1);
        _textLbl1.font = font(15);
        _textLbl1.numberOfLines = 0;
        _textLbl1.backgroundColor = [UIColor whiteColor];
        [_textLbl1 sizeToFit];
    }
    return _textLbl1;
}



- (UILabel *)textLbl2{
    if (!_textLbl2) {
        _textLbl2 = [UILabel new];
        _textLbl2.text = @" * 试试字母、数字、符号混搭";
        _textLbl2.frame =CGRectMake(SCREEN_FIT(20), CGRectGetMaxY(self.textLbl1.frame)+SCREEN_FIT(15),SCREEN_FIT(260), SCREEN_FIT(25));
        _textLbl2.textAlignment =NSTextAlignmentLeft;
        _textLbl2.textColor = rgba(218, 91, 87, 1);
        _textLbl2.font = font(15);
        
    }
    return _textLbl2;
}


- (BaseButton *)surBtn{
    if (!_surBtn) {
        _surBtn = [BaseButton new];
        _surBtn.titleLabel.font = font(20);
        _surBtn.frame = CGRectMake(SCREEN_FIT(30), CGRectGetMaxY(self.textLbl2.frame)+SCREEN_FIT(20),SCREEN_FIT(110) , SCREEN_FIT(30));
        [_surBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_surBtn setBackgroundColor:rgba(252, 197, 105, 1)];
        _surBtn.layer.cornerRadius = SCREEN_FIT(5);
        _surBtn.layer.masksToBounds = YES;
        [_surBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _surBtn;
}

- (BaseButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [BaseButton new];
        _cancelBtn.titleLabel.font = font(20);
        _cancelBtn.frame = CGRectMake(CGRectGetMaxX(self.surBtn.frame)+SCREEN_FIT(20), CGRectGetMinY(self.surBtn.frame), CGRectGetWidth(self.surBtn.frame), CGRectGetHeight(self.surBtn.frame));
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setBackgroundColor:rgba(200, 200, 200, 0.6)];
        _cancelBtn.layer.cornerRadius = SCREEN_FIT(5);
        _cancelBtn.layer.masksToBounds = YES;
        [_cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _cancelBtn;
}

- (void)show{
    [self setupUI];
    
    
}


- (void)changeRotate:(NSNotification*)noti {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.remindView.center = window.center;
    CGRect Newframe = self.remindView.frame;
    Newframe.origin.x = windowWidth-ZKUserViewWidth-Newframe.size.width-SCREEN_FIT(50);
    self.remindView.frame = Newframe;
}

- (void)cancelBtnAction{

    [self.remindView removeFromSuperview];
}

- (void)sureBtnAction{
    if (self.sureCallBlock) {
        self.sureCallBlock();
    }
  [self.remindView removeFromSuperview];
}
@end

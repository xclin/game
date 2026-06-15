//
//  playTimeLimit.m
//  FYAppStoreDemo
//
//  Created by xiaocong lin on 2021/1/26.
//  Copyright © 2021 fanyue. All rights reserved.
//

#import "NewZhongKeplayTimeView.h"

@implementation NewZhongKeplayTimeView

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (void)setupUI{
    self.titleLbl.hidden = YES;
    self.LogingTypeLbl.text = @"游戏提醒";
    self.LogingTypeLbl.hidden = NO;
    [self addSubview:self.contentview];
    [self.loginBtn setTitle:@"确定" forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRotateNewZhongKeplayTimeView:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
     [self updateFrame];
}


- (UITextView *)contentview{
    if (!_contentview) {
        NSString *mesg = [NSString stringWithFormat:@"【健康系统】%@",COMMONMETHOD.bannedORplayoutString];
        if ([SDKCommonMethod shared].playLimitMsg.length > 5) {
            mesg =[SDKCommonMethod shared].playLimitMsg;
        }

        _contentview =  [UITextView new];
        _contentview.frame =CGRectMake(SCREEN_FIT(20), CGRectGetMaxY(self.LogingTypeLbl.frame)+SCREEN_FIT(40), ZKUserViewWidth-SCREEN_FIT(40), SCREEN_FIT(200));
        _contentview.backgroundColor = [UIColor clearColor]; //设置背景色
        _contentview.scrollEnabled = YES;
        _contentview.textColor = [UIColor whiteColor];
        _contentview.font = font(18);
        _contentview.showsVerticalScrollIndicator = NO;
        _contentview.showsHorizontalScrollIndicator = NO;
        _contentview.editable = NO;
        _contentview.text =mesg;
    

//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        paragraphStyle.lineSpacing = 7;// 字体的行间距
//        NSString *str1 = _contentview.text;
//         NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18], NSParagraphStyleAttributeName:paragraphStyle};
//        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_contentview.text];
//        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,6)];
//         [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(6,str1.length-6)];
//        [str addAttributes:attributes range:NSMakeRange(0,str1.length)];
//        [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str1   length])];
//        _contentview.attributedText = str;
        
        
    }
    return _contentview;
}


- (void)loginBtnAction{
    
    if (self.submitBtnBlock) {
        self.submitBtnBlock();
    }
}

- (void)submitBtnAction{
    
}

- (void)updateFrame{
    
    UIInterfaceOrientation sataus=[UIApplication sharedApplication].statusBarOrientation;
    if (sataus == UIInterfaceOrientationPortrait ||sataus ==  UIInterfaceOrientationPortraitUpsideDown) {//竖屏
        self.LogingTypeLbl.frame = CGRectMake(SCREEN_FIT(60), SCREEN_FIT(30), ZKUserViewWidth-SCREEN_FIT(120), SCREEN_FIT(30));
        self.contentview.frame = CGRectMake(SCREEN_FIT(20), CGRectGetMaxY(self.LogingTypeLbl.frame)+SCREEN_FIT(40), ZKUserViewWidth-SCREEN_FIT(40), SCREEN_FIT(200));
        self.loginBtn.frame = CGRectMake(CGRectGetMinX(self.contentview.frame),ZKUserViewHeight-SCREEN_FIT(100), CGRectGetWidth(self.contentview.frame),SCREEN_FIT(50));
        
    }else {//横版
        
        self.LogingTypeLbl.frame = CGRectMake(SCREEN_FIT(60), SCREEN_FIT(30), ZKUserViewWidth-SCREEN_FIT(120), SCREEN_FIT(30));
        self.contentview.frame = CGRectMake(SCREEN_FIT(20), CGRectGetMaxY(self.LogingTypeLbl.frame)+SCREEN_FIT(20), ZKUserViewWidth-SCREEN_FIT(40), SCREEN_FIT(150));
        self.loginBtn.frame = CGRectMake(CGRectGetMinX(self.contentview.frame),ZKUserViewHeight-SCREEN_FIT(70), CGRectGetWidth(self.contentview.frame),SCREEN_FIT(50));
        
    }
    
}

- (void)changeRotateNewZhongKeplayTimeView:(NSNotification*)noti {
    [self updateFrame];
    
}

@end

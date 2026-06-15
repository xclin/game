//
//  VerifyIDCardView.m
//  FYAppStoreDemo
//
//  Created by 凡跃 on 2018/6/4.
//  Copyright © 2018年 fanyue. All rights reserved.
//

#import "VerifyIDCardView.h"

@interface VerifyIDCardView ()<UITextFieldDelegate>
@property (nonatomic, retain) TTextField *accountField;
@property (nonatomic, retain) TTextField *idcardField;
@property (nonatomic, retain) BaseButton *submitBtn;

@end

@implementation VerifyIDCardView

- (void)dealloc {
    DEBUGMSG(@"VerifyIDCardView dealloc");
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (void)setupUI {
    BaseLabel * titleLabel = [[BaseLabel alloc]init];
    [titleLabel setFYLabFrame:CGRectMake((UserViewWidth-UserViewWidth/6*5)/2, 25, UserViewWidth/6*5, 30) text:@"根据文化部《网络游戏管理暂行方法》，用户需使用有效身份证进行实名认证" textAlignment:NSTextAlignmentLeft textColor:FONTColor136 font:10];
    titleLabel.numberOfLines = 0;
    titleLabel.clipsToBounds = YES;
    [self addSubview:titleLabel];
    
    BorderView *accountbordView = [[BorderView alloc] init];
    [accountbordView setUI:CGRectMake((UserViewWidth-UserViewWidth/6*5)/2, 12 + titleLabel.frame.size.height + 15-4, UserViewWidth/6*5, 50)];
    [self addSubview:accountbordView];
    
    BaseLabel *accountTipsLab = [[BaseLabel alloc] init];
    [accountTipsLab setFYLabFrame:CGRectMake(10, accountbordView.frame.size.height/3, 50, accountbordView.frame.size.height/3) text:@"姓名：" textAlignment:NSTextAlignmentLeft textColor:FONTColor51 font:16];
    [accountbordView addSubview:accountTipsLab];
    
    _accountField = [[TTextField alloc] init];
    [_accountField setFYTextField:CGRectMake(accountTipsLab.frame.origin.x+accountTipsLab.frame.size.width, 0, accountbordView.frame.size.width-accountTipsLab.frame.origin.x-accountTipsLab.frame.size.width-15, accountbordView.frame.size.height) placeholder:@"张三" backgroundColor:[UIColor clearColor] textColor:FONTColor51 font:16 keyboardType:UIKeyboardTypeDefault returnKeyType:UIReturnKeyNext secureTextEntry:NO];
    _accountField.font = [UIFont boldSystemFontOfSize:16];
    [_accountField changePlaceholderFontColor:@"张三" font:16 color:FONTColor136];
    _accountField.delegate = self;
    [accountbordView addSubview:_accountField];
    
    BorderView *passwordBordView = [[BorderView alloc] init];
    [passwordBordView setUI:[self setSameFrameButY:accountbordView.frame Y:accountbordView.frame.origin.y+accountbordView.frame.size.height+10]];
    [self addSubview:passwordBordView];
    
    BaseLabel *passwordLab = [[BaseLabel alloc] init];
    [passwordLab setFYLabFrame:CGRectMake(10, passwordBordView.frame.size.height/3, 50, passwordBordView.frame.size.height/3) text:@"身份证：" textAlignment:NSTextAlignmentLeft textColor:FONTColor51 font:16];
    [passwordBordView addSubview:passwordLab];
    
    _idcardField = [[TTextField alloc] init];
    [_idcardField setFYTextField:CGRectMake(passwordLab.frame.origin.x+passwordLab.frame.size.width, 0, passwordBordView.frame.size.width-passwordLab.frame.origin.x-passwordLab.frame.size.width-15, passwordBordView.frame.size.height) placeholder:@"请输入身份证" backgroundColor:[UIColor clearColor] textColor:FONTColor51 font:16 keyboardType:UIKeyboardTypeEmailAddress returnKeyType:UIReturnKeyDone secureTextEntry:NO];
    _idcardField.font = [UIFont boldSystemFontOfSize:16];
    [_idcardField changePlaceholderFontColor:@"请输入身份证" font:16 color:FONTColor136];
    _idcardField.delegate = self;
    [passwordBordView addSubview:_idcardField];
    
    [_accountField addTarget:self action:@selector(textChangeAction) forControlEvents:UIControlEventEditingChanged];
    [_idcardField addTarget:self action:@selector(textChangeAction) forControlEvents:UIControlEventEditingChanged];
    
    //attention
    BaseLabel *attentionLab = [[BaseLabel alloc] init];
    [attentionLab setFYLabFrame:CGRectMake((UserViewWidth-UserViewWidth/6*5)/2, passwordBordView.frame.origin.y+passwordBordView.frame.size.height+4, UserViewWidth-20, 16) text:@"*身份证信息只能提交一次，不能更改，请谨慎填写！" textAlignment:NSTextAlignmentLeft textColor:FONTColor136 font:10];
    [self addSubview:attentionLab];
    
    //提交绑定
    _submitBtn = [[BaseButton alloc] init];
    [_submitBtn setFYBtnFrame:CGRectMake(passwordBordView.frame.origin.x, attentionLab.frame.origin.y+attentionLab.frame.size.height+20, passwordBordView.frame.size.width-10, 40) norTitle:@"提交绑定" titleFont:18 titleColor:[UIColor whiteColor] backgroundColor:BTNBlueColor];
    //    [registerAndLoginBtn drawFYBtnRound];
    _submitBtn.layer.cornerRadius = 5;
    [_submitBtn setBackgroundImage:BTNHighlightedImage forState:UIControlStateHighlighted];
    [_submitBtn addTarget:self action:@selector(submitBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_submitBtn];
    
}

#pragma mark action

- (void)submitBtnAction{
    _verifyBlock(self.accountField.text,self.idcardField.text,[SDKCommonMethod shared].uToken);
}
- (void)textChangeAction {
    if ( _accountField.text.length > 0 && _idcardField.text.length > 0) {
        _submitBtn.selected = YES;
    } else {
        _submitBtn.selected = NO;
    }
}
#pragma mark delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if ([textField isEqual:_accountField]) {
        [_accountField becomeFirstResponder];
    }else {
        [_idcardField resignFirstResponder];
    }
    
    
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (textField == _accountField) {
        _accountField.text = @"";
        _idcardField.text = @"";
    } else {
        _idcardField.text = @"";
    }
    return YES;
}

@end

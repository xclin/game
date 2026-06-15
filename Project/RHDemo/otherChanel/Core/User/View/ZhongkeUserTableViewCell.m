//
//  ZhongkeUserTableViewCell.m
//  FYAppStoreDemo
//
//  Created by xiaocong lin on 2021/1/25.
//  Copyright © 2021 fanyue. All rights reserved.
//
#import "ZhongkeView.h"
#import "ZhongkeUserTableViewCell.h"
#import "VersionAllMethod.h"
#import "LQGetMessage.h"
#import "NSUserDefaults+Category.h"
@implementation ZhongkeUserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


+ (ZhongkeUserTableViewCell *)cellWithTableView:(UITableView *)tableView withCellIdentifier:(NSString *)CellIdentifierStr{
    
    ZhongkeUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierStr];
    if (!cell) {
        
        cell = [[ZhongkeUserTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierStr];;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}


- (void)setUiews{
    [self addSubview:self.backView];
    
    [self.backView  addSubview:self.btnImage];
    [self.backView  addSubview:self.accountName];
    [self.backView   addSubview:self.textLbl];
    NSLog(@"-----%@--%@--%@",self.paramsModel.user_type,self.paramsModel.phone,self.paramsModel.userName);
    if ([self.paramsModel.user_type isEqualToString:@"2"]) {
        self.accountName.text =self.paramsModel.phone;
    }else{
        
        self.accountName.text =self.paramsModel.userName;
    }
    
    [self.btnImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"FYSDK_Resourcres.bundle/zhongke_loginType_%@",self.paramsModel.user_type]] forState:UIControlStateNormal];
    [self.btnImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"FYSDK_Resourcres.bundle/zhongke_loginType_selected_%@",self.paramsModel.user_type]] forState:UIControlStateSelected];
    
    if (self.paramsModel.isSelect) {
        self.backView.backgroundColor = rgba(252, 197, 105, 1);
        self.btnImage.selected = YES;
        self.accountName.textColor =rgba(116, 58, 7, 1);
        self.textLbl.textColor = rgba(116, 58, 7, 1);
    }else{
        self.backView.backgroundColor =rgba(0, 0, 0, 0.3);
        self.accountName.textColor =rgba(255, 255, 255, 1);
        self.textLbl.textColor = rgba(255, 255, 255, 1);
        self.btnImage.selected = NO;
    }
    
    if ([self.paramsModel.uid  isEqualToString:[NSUserDefaults takeoutNSUserDefault:LASTLOGINUID]]) {
        self.textLbl.hidden = NO;
        }else{
        self.textLbl.hidden = YES;
    }

}



- (void)setParamsModel:(UserModel *)paramsModel{
   _paramsModel = paramsModel;

    [self setUiews];
    
    
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [UIView new];
        _backView.frame = CGRectMake(0,SCREEN_FIT(5), ZKUserViewWidth-SCREEN_FIT(60), SCREEN_FIT(50));
        _backView.backgroundColor =rgba(0, 0, 0, 0.3);;
        _backView.layer.cornerRadius = SCREEN_FIT(5);
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}
- (UILabel *)accountName{
    if (!_accountName) {
        _accountName = [UILabel new];
        _accountName.frame = CGRectMake(CGRectGetMaxX(self.btnImage.frame)+SCREEN_FIT(15),0, ZKUserViewWidth-SCREEN_FIT(60)-SCREEN_FIT(80)-SCREEN_FIT(60), SCREEN_FIT(50));
        _accountName.font = [UIFont systemFontOfSize:17.0f];
        _accountName.textColor =[UIColor whiteColor];
        _accountName.textAlignment = NSTextAlignmentLeft;;
    }
    return _accountName;
}
- (UIButton *)btnImage{
    if (!_btnImage) {
        _btnImage = [UIButton new];
        _btnImage.frame = CGRectMake(SCREEN_FIT(20),SCREEN_FIT(12.5),SCREEN_FIT(25), SCREEN_FIT(25));
        _btnImage.backgroundColor= [UIColor clearColor];
    }
    return _btnImage;
}


- (UILabel *)textLbl{
    if (!_textLbl) {
        _textLbl = [UILabel new];
        _textLbl.frame = CGRectMake(CGRectGetMaxX(self.accountName.frame), 0, SCREEN_FIT(80), SCREEN_FIT(50));
        _textLbl.font = [UIFont systemFontOfSize:14.0f];
        _textLbl.textColor = rgba(255, 255, 255, 1);
        _textLbl.textAlignment = NSTextAlignmentLeft;
        _textLbl.text = @"(上次登录)";
        _textLbl.hidden = YES;
        
    }
    return _textLbl;
}



@end

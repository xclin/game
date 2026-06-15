//
//  ZhongkeUserTableViewCell.h
//  FYAppStoreDemo
//
//  Created by xiaocong lin on 2021/1/25.
//  Copyright © 2021 fanyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZhongkeUserTableViewCell : UITableViewCell

@property (nonatomic,strong)  UILabel * accountName;
@property (nonatomic,strong)  UIButton * btnImage;
@property (nonatomic,strong)   UILabel *textLbl;
@property (nonatomic,strong)   UIView  *backView;
@property (nonatomic,strong)   UserModel *paramsModel;

+ (ZhongkeUserTableViewCell *)cellWithTableView:(UITableView *)tableView withCellIdentifier:(NSString *)CellIdentifierStr;
@end

NS_ASSUME_NONNULL_END

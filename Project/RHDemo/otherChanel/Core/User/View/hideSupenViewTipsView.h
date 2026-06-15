//
//  hideSupenViewTipsView.h
//  GameSDK
//
//  Created by 凡跃 on 2021/8/7.
//  Copyright © 2021 lonnie. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^hideSupenViewBlock)(BOOL hideView);

@interface hideSupenViewTipsView : UIView
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UILabel *titleLbl;
@property (nonatomic,strong) UIButton  *btnAgreed;
@property (nonatomic,strong) UIButton  *btnCancel;
@property (nonatomic,strong) UIButton  *btnSure;
@property (nonatomic,copy)  hideSupenViewBlock block;
- (void)show;
@end

NS_ASSUME_NONNULL_END

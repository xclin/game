//
//  NewZhongkePwdWarningView.h
//  FYAppStoreDemo
//
//  Created by xiaocong lin on 2021/1/26.
//  Copyright © 2021 fanyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseButton.h"
#import "VersionAllMethod.h"

@interface NewZhongkePwdWarningView : UIView
@property (nonatomic, strong) UIView * remindView;
@property (nonatomic,strong)   UILabel *titleLbl;
@property (nonatomic,strong)   UILabel *textLbl1;
@property (nonatomic,strong)   UILabel *textLbl2;
@property (nonatomic,strong)   BaseButton *surBtn;
@property (nonatomic,strong)    BaseButton *cancelBtn;
@property (nonatomic,copy)   void(^sureCallBlock)();
- (void)show;
@end



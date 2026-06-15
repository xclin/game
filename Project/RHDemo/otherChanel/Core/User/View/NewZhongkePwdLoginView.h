//
//  NewZhongkePwdLoginView.h
//  FYAppStoreDemo
//
//  Created by xiaocong lin on 2021/1/22.
//  Copyright © 2021 fanyue. All rights reserved.
//

#import "ZhongkeView.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewZhongkePwdLoginView : ZhongkeView

@property (nonatomic,copy)  void (^LoginCallBlock)( NSString * _Nullable Name,NSString * _Nullable pwd);
@property (nonatomic,copy)  void (^getBackPwdCallBlock)();
@property (nonatomic,strong) BaseButton *agreedBtn;
@property (nonatomic,strong) BaseButton *pwdLoginBtn;
@property (nonatomic,strong) BaseButton *downBtn;
@property (nonatomic,strong) BaseButton *eyesBtn;
@property (nonatomic,strong) UILabel *getPwdtipsLbl;

@end

NS_ASSUME_NONNULL_END

//
//  NewZhongkeRegister.h
//  GameSDK
//
//  Created by xiaocong lin on 2021/1/23.
//  Copyright © 2021 lonnie. All rights reserved.
//

#import "ZhongkeView.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewZhongkeRegisterView : ZhongkeView
@property (nonatomic,copy)  void (^registerCallBlock)( NSString * _Nullable userName,NSString * _Nullable pwd);
@property(nonatomic,copy)  void (^registerErrorCallBlock)( NSString * _Nullable userName,NSString * _Nullable pwd);
//@property (nonatomic, copy) void(^userProCallBlock)(NSString *proStr); //隐私、协议
@property (nonatomic,strong) BaseButton *agreedBtnregit;
@end

NS_ASSUME_NONNULL_END

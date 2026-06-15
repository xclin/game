//
//  NewZhongkeGetbackPwdView.h
//  FYAppStoreDemo
//
//  Created by xiaocong lin on 2021/1/23.
//  Copyright © 2021 fanyue. All rights reserved.
//

#import "ZhongkeView.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewZhongkeGetbackPwdView : ZhongkeView

@property (nonatomic,copy)  void (^nextCallBlock)( NSString * _Nullable userAccount);
@end

NS_ASSUME_NONNULL_END

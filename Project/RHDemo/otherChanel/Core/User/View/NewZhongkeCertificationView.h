//
//  NewZhongkeCertificationView.h
//  FYAppStoreDemo
//
//  Created by xiaocong lin on 2021/1/23.
//  Copyright © 2021 fanyue. All rights reserved.
//

#import "ZhongkeView.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewZhongkeCertificationView : ZhongkeView
@property (nonatomic,copy)  void (^userCertifiCallBlock)( NSString * _Nullable UserName,NSString * _Nullable idcard,NSString *_Nullable token);
@property (nonatomic,strong)UILabel *nameLbl;
@property (nonatomic,strong)UILabel *LineLbl;
@property (nonatomic,strong) UILabel *tipsLbl;
@end

NS_ASSUME_NONNULL_END

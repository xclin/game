//
//  sdkRoleConfiter.h
//  Translate
//
//  Created by xiaocong lin on 2020/8/3.
//  Copyright © 2020 wuwh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface sdkRoleConfiter : NSObject

/// 服务器id
@property (nonatomic, copy) NSString * sId;
/// 服务器名称
@property (nonatomic, copy) NSString * sName;
/// 角色id
@property (nonatomic, copy) NSString * roleId;
/// 角色等级
@property (nonatomic, copy) NSString * roleLevel;
/// 角色名称
@property (nonatomic, copy) NSString * roleName;
/// 余额
@property (nonatomic, copy) NSString * balance;
/// 角色战力
@property (nonatomic, copy) NSString * power;
/// 拓展参数
@property (nonatomic, copy) NSString * other;
/// 事件类型 2：创建角色 3：进入游戏 4、角色升级
@property (nonatomic, assign)  XYUserRoleType roleType;

+ (instancetype)share;
@end

NS_ASSUME_NONNULL_END

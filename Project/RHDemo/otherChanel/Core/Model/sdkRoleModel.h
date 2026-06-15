
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define sdkRoleShare [sdkRoleModel share]

@interface sdkRoleModel : NSObject
@property (nonatomic, copy) NSString *server_id;  //服务器id
@property (nonatomic, copy) NSString *server_name;  //服务器名称
@property (nonatomic, copy) NSString *role_id;  //角色id
@property (nonatomic, copy) NSString *role_name;  //角色名称
@property (nonatomic, copy) NSString *role_Level;  //角色等级
@property (nonatomic, copy) NSString *role_Power;  //战斗力
@property (nonatomic, copy) NSString *role_balance;  //游戏币数量
+ (instancetype)share;
@end

NS_ASSUME_NONNULL_END

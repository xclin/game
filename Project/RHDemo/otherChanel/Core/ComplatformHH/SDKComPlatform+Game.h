
#import "SDKComPlatform.h"
@interface SDKComPlatform (Game)

/// 选服创角色
/// @param server_id 区服Id
/// @param server_name 区服名称
/// @param role_id 角色id
/// @param role_name 角色名称
- (void)reportCreateRoleWithSid:( NSString *)server_id
                          SName:( NSString*)server_name
                         Roleid:( NSString*)role_id
                       RoleName:( NSString*)role_name;

/// 角色等级上报
/// @param server_id 区服Id
/// @param server_name 区服名称
/// @param role_id 角色id
/// @param role_name 角色名称
/// @param role_level 角色等级
- (void)reportRoleLevelWithSid:( NSString *)server_id
                   server_name:( NSString*)server_name
                       role_id:( NSString*)role_id
                     role_name:( NSString*)role_name
                    role_level:( NSString*)role_level;






@end

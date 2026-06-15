

#import "SDKComPlatform+Game.h"
#import "SDKComplatformBase.h"
#import "DataBaseManager.h"
#import "SDKCommonMethod.h"
#import "BaseModel.h"
#import "RequestUtil.h"
#import "UserDataModel.h"
#import "SDKUserAccountModel.h"
#import "NSString+category.h"
#import "sdkRoleModel.h"
@implementation SDKComPlatform (Game)

/// 选服
/// @param server_id 服务器id
/// @param server_name 服务器名称
/// @param role_id 角色id
/// @param role_name 角色名称
- (void)reportSelectServerWithSid:( NSString *)server_id
                            SName:( NSString*)server_name
                           Roleid:( NSString*)role_id
                         RoleName:( NSString*)role_name{
    if ([self isLogined]) {
        requestSelectServerModel *model = [[requestSelectServerModel alloc]initSelectServerModel:server_id server_name:server_name role_id:role_id role_name:role_name];
        [sdkRequestManager startRequestWithModel:model succeedBlock:^(id responseObject) {
            ResponseModel * model = [ResponseModel modelWithJSON:responseObject];
            if (model.code == 0) {
                [NSUserDefaults reserveNSUserDefault:sdkRoleShare.server_id field:ServiceID];
                MessageStatus * message = [[MessageStatus alloc] init];
                message.code = model.code;
                message.msg = model.msg;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RoleServerNotification" object:nil userInfo:@{@"result":@YES,@"MessageStatus":message}];
            } else {
                ErrorStatus * error1 = [[ErrorStatus alloc] init];
                error1.fySDKErrorStatus = _ERROR_STATUS_SERVICE;
                MessageStatus * message = [[MessageStatus alloc] init];
                message.code =model.code;
                message.msg = model.msg;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RoleServerNotification" object:nil userInfo:@{@"ErrorStatus":error1,@"result":@NO,@"MessageStatus":message}];
            }
        }];
    }
}



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
                    role_level:( NSString*)role_level{
    if ([self isLogined]) {
        sdkRoleShare.role_id = [role_id valueAt:@"role_id"];
        sdkRoleShare.role_name = [role_name valueAt:@"role_name"];
        sdkRoleShare.server_name = [server_name valueAt:@"server_name"];
        sdkRoleShare.server_id = [server_id valueAt:@"server_id"];
        sdkRoleShare.role_Level = [role_level valueAt:@"role_level"];
        
        requestSendRoleLevel *model = [[requestSendRoleLevel alloc]initSendRoleLevel:server_id server_name:server_name role_id:role_id role_name:role_name role_level:role_level];
        [sdkRequestManager startRequestWithModel:model succeedBlock:^(id responseObject) {
            NSLog(@"responseObject--%@",responseObject);
          
        }];
        
    }
    
}


/// 选服创角色
/// @param server_id 区服Id
/// @param server_name 区服名称
/// @param role_id 角色id
/// @param role_name 角色名称
- (void)reportCreateRoleWithSid:( NSString *)server_id
                          SName:( NSString*)server_name
                         Roleid:( NSString*)role_id
                       RoleName:( NSString*)role_name{
    if ([self isLogined]) {
        sdkRoleShare.role_id = [role_id valueAt:@"role_id"];
        sdkRoleShare.role_name = [role_name valueAt:@"role_name"];
        sdkRoleShare.server_name = [server_name valueAt:@"server_name"];
        sdkRoleShare.server_id = [server_id valueAt:@"server_id"];
        __weak typeof (self) weakSelf = self;
        requestRoleModel *model = [[requestRoleModel alloc]initRole:server_id server_name:server_name role_id:role_id role_name:role_name];
        [sdkRequestManager startRequestWithModel:model succeedBlock:^(id responseObject) {
            [weakSelf reportSelectServerWithSid:server_id SName:server_name Roleid:role_id RoleName:role_name];
        }];
    }
}

@end


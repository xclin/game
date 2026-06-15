
#import "UserDataModel.h"
#import "DataBaseManager.h"

@implementation UserDataModel

+ (NSArray *)selectUserAccount:(NSString *)userId {
    
    UserModel * model = [[UserModel alloc]init];
    model.uid = [NSString stringWithFormat:@"%@",userId];
    return [[DataBaseManager sharedInstance] selectUserWithModel:model];
}

+ (void)deleteUser:(NSString *)userName {
    UserModel * model = [[UserModel alloc]init];
    model.userName = userName;
    [[DataBaseManager sharedInstance]deleteUserWithUserNameModel:model];
}

+ (void)insertUser:(UserModel *)userModel{
    
    [[DataBaseManager sharedInstance] insertUserIntoDatabase:userModel];
}


+ (void)updateUserPhoneBind:(NSString *)uid
                      phone:(NSString *)phone{
    
    [[DataBaseManager sharedInstance] updateUserPhoneBind:uid phone:phone];
    
}


+ (void)updatesub_uid:(NSString *)uid
              sub_uid:(NSString *)sub_uid{
    
    [[DataBaseManager sharedInstance] updatesub_uid:uid sub_uid:sub_uid];
}

+ (void)updateUserAgeByUid:(NSString *)uid userAge:(NSString *)age{
    
    [[DataBaseManager sharedInstance] updateUserAgeByUid:uid userAge:age];
    
}

///  更新登录token
/// @param uid 用户id
/// @param access_token 登录token
/// @param refresh_token 刷新token
/// @param expires_in 过期时间
/// @param refresh_token_expires_in 过期时间
+ (void)updateUserAccesstokenByuid:(NSString *)uid
                      access_token:(NSString *)access_token
                     refresh_token:(NSString *)refresh_token
                        expires_in:(NSString *)expires_in
          refresh_token_expires_in:(NSString *)refresh_token_expires_in{
    
    [[DataBaseManager sharedInstance] updateUserAccesstokenByuid:uid access_token:access_token refresh_token:refresh_token expires_in:expires_in refresh_token_expires_in:refresh_token_expires_in];
}

+ (void)updateUserVerifyByUid:(NSString *)uid
           verify_after_login:(NSString * )verify_after_login
            verify_before_pay:(NSString * )verify_before_pay{
   [[DataBaseManager sharedInstance] updateUserVerifyByUid:uid verify_after_login:verify_after_login verify_before_pay:verify_before_pay];
    
}

+ (NSArray *)selectIAPProduct:(NSString*)iapID {
    IAPProducts * model = [[IAPProducts alloc]init];
    model.iapID = iapID;
    return [[DataBaseManager sharedInstance]selectIAPWithModel:model];
}

+ (NSArray *)selectIAP {
    return [[DataBaseManager sharedInstance] selectIAP];
}

+ (NSArray *)selectUnfinishedIAP {
    return [[DataBaseManager sharedInstance]selectUnfinishedIAP];
}

+ (void)insertIAPProduct:(IAPProducts *)iapModel{
    [[DataBaseManager sharedInstance]insertIAPTableWithModel:iapModel];
}
+ (void)updateIAPProduct:(IAPProducts *)iapModel{
    [[DataBaseManager sharedInstance]updateIAPTableWithModel:iapModel];
}
@end

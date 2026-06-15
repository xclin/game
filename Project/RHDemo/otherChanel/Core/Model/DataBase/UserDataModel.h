
#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "IAPProducts.h"

@interface UserDataModel : NSObject

+ (NSArray *)selectUserAccount:(NSString *)userId;

+ (void)deleteUser:(NSString *)userName;

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
          refresh_token_expires_in:(NSString *)refresh_token_expires_in;

+ (void)insertUser:(UserModel *)userModel ;

+ (void)updateUserPhoneBind:(NSString *)uid
                      phone:(NSString *)phone;

+ (void)updatesub_uid:(NSString *)uid
              sub_uid:(NSString *)sub_uid;


+ (void)updateUserVerifyByUid:(NSString *)uid
           verify_after_login:(NSString * )verify_after_login
            verify_before_pay:(NSString * )verify_before_pay;

+ (NSArray *)selectUnfinishedIAP;
+ (NSArray *)selectIAP;
+ (NSArray *)selectIAPProduct:(NSString*)iapID;
+ (void)insertIAPProduct:(IAPProducts *)iapModel;
+ (void)updateIAPProduct:(IAPProducts *)iapModel;
+ (void)updateUserAgeByUid:(NSString *)uid userAge:(NSString *)age;
@end

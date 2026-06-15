
#import <Foundation/Foundation.h>
#import "BaseModel.h"

typedef void (^SuccessBlcok)(int code, NSString *msg, id object);
typedef void (^FailureBlcok)(int code, NSString *msg);

@interface UserDataController : NSObject
/**
 *  获取全部用户
 *
 *  @return 全部用户
 */
- (NSMutableArray *)getAllAccounds;

/**
 *  保存一键注册的界面
 *
 *  @param userName 账号
 *  @param passWork 密码
 */
- (void)saveScreenshotWithUserName:(NSString*)userName
                       andPassWork:(NSString*)passWork;

#pragma mark -----------new---------------

/// 登录
/// @param tokenString 登录token
/// @param uidString 大号uid
/// @param sub_uidString 小号uid
/// @param successBlock 成功回调
/// @param failureBlcok 失败回调
- (void)loginWithToken:(NSString *)tokenString
                   uid:(NSString *)uidString
              PassWord:(NSString *)pwdString
               sub_uid:(NSString *)sub_uidString
            andSuccess:(SuccessBlcok)successBlock
            andFailure:(FailureBlcok)failureBlcok;


//多账号快速登录
- (void)loginFast:(NSString *)unString
      andPassWord:(NSString *)pwString
        userToken:(NSString *)userToken
      childUserId:(NSString *)childuserId
       andSuccess:(SuccessBlcok)successBlock
       andFailure:(FailureBlcok)failureBlcok;


/**
 *  根据手机号、验证码获取登录token
 *  @param phoneString     手机
 * @param codeString      验证码
 *  @param successBlock 成功回调
 *  @param failureBlcok 失败回调
 */
- (void)getLoginTokenByPhone:(NSString *)phoneString
              codeNum:(NSString *)codeString
           andSuccess:(SuccessBlcok)successBlock
           andFailure:(FailureBlcok)failureBlcok;

/**
 *  根据用户名和密码获取token
 *  @param unString 账号
 *  @param pwdString 密码
 */
- (void)getLoginTokenByUserName:(NSString *)unString
             PassWord:(NSString *)pwdString
              Success:(SuccessBlcok)successBlock
                        Failure:(FailureBlcok)failureBlcok;

/**
 *  普通注册
 *
 *  @param unString 账号
 *  @param pwString 密码
 */
- (void)registeredUserName:(NSString *)unString
               andPassWord:(NSString *)pwString
                andSuccess:(SuccessBlcok)successBlock
                andFailure:(FailureBlcok)failureBlcok;



/// 小号注册
/// @param display_name 小号名
/// @param successBlock 成功回调
/// @param failureBlcok 失败回调
- (void)registeredChildUserName:(NSString *)display_name
                     andSuccess:(SuccessBlcok)successBlock
                     andFailure:(FailureBlcok)failureBlcok;



/// 小号切换登录
/// @param access_token 登录token
/// @param sub_uid 小号id
/// @param successBlock 成功回调
/// @param failureBlcok 失败回调
- (void)loginChangeChild:(NSString *)access_token
                    andsub_uid:(NSString *)sub_uid
                     andSuccess:(SuccessBlcok)successBlock
                     andFailure:(FailureBlcok)failureBlcok;


//检测用户名是否已经存在
- (void)checkUserName:(NSString *)unString
                andSuccess:(SuccessBlcok)successBlock
                andFailure:(FailureBlcok)failureBlcok;


//获取用户信息
- (void)getUserInfoByName:(NSString *)unString
                andSuccess:(SuccessBlcok)successBlock
                andFailure:(FailureBlcok)failureBlcok;



/// 获取验证吗
/// @param pString 手机号
/// @param successBlock 成功回调
/// @param failureBlcok 失败回调
- (void)getPhoneCode:(NSString *)pString
          andSuccess:(SuccessBlcok)successBlock
          andFailure:(FailureBlcok)failureBlcok;

//根据uid获取验证吗
- (void)getPhoneByUid:(NSString *)uidString
                andSuccess:(SuccessBlcok)successBlock
                andFailure:(FailureBlcok)failureBlcok;


//new重置密码
- (void)resetNewPassword:(NSString *)phone
                     num:(NSString *)num
                password:(NSString *)password
              andSuccess:(SuccessBlcok)successBlock
              andFailure:(FailureBlcok)failureBlcok;

//获取游戏时长
- (void)getPlayTimeLimit:(NSString *)timeLength
                     ageLevel:(NSString *)age
              andSuccess:(SuccessBlcok)successBlock
              andFailure:(FailureBlcok)failureBlcok;

//刷新token
- (void)refReshUserToken;
@end

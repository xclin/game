

#import "SDKComPlatform.h"
#import "UserModel.h"

@interface SDKComPlatform (User)

/**
 *  判断是否已经登录平台
 *
 *  @return 是否
 */
- (BOOL)isLogined;


///  SDK登录
- (void)loginSDK;

/**
 *  注销,退出登录
 */

- (void) logout;

/**
 *  切换账号（logout+login），会注销当前登录的账号
 */
- (void) switchAccount;

/**

 *  用户唯一标识
 */
@property (nonatomic,readonly) NSString * sub_uid;


/**

 *  cp登录需要用到的code
 */
@property (nonatomic,readonly) NSString * access_code;


@end


/**
 用户状态
 */
typedef NS_ENUM(NSUInteger, __ACCOUNT_STATUS) {
    /**
     *  注销状态
     */
    _ACCOUNT_STATUS_LOGOUT,
    /**
     *  切换账号状态
     */
    _ACCOUNT_STATUS_SWITCHACCOUNT,
    /**
     *  登录成功状态
     */
    _ACCOUNT_STATUS_LOGINSUCCEED,

};

/**
 用户状态类
 */
@interface AccountStatus : NSObject

/**
 __ACCOUNT_STATUS枚举值
 */
@property (nonatomic,assign)int fySDKAccountStatus;	//返回

/**(fySDKAccountStatus == _ACCOUNT_STATUS_LOGOUT)*/
- (BOOL)isStatusLogout;
/**(fySDKAccountStatus == _ACCOUNT_STATUS_LOGINSUCCEED)*/
- (BOOL)isStatusLoginSucceed;
/**(fySDKAccountStatus == _ACCOUNT_STATUS_SWITCHACCOUNT)*/
- (BOOL)isStatusSwitchAccount;

@end


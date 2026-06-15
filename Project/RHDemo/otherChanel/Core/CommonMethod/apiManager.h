
#ifndef apiManager_h
#define apiManager_h

////测试
//#define sdkDomain  @"sapi.020richang.com"
//#define payDomain  @"spay.020richang.com"
//#define socktePort @"8099"


//正式
#define sdkDomain  @"apisdk.020richang.com"
#define payDomain  @"papi.020richang.com"
#define socktePort @"8099"


//支付
//#define  DoActivityURL [NSString stringWithFormat:@"http://%@/pages/sfios/activity_ios.html?",PAYURL]//竖版
//#define  DoActivityURL [NSString stringWithFormat:@"http://%@/pages/sfios/transversePay.html?",PAYURL]//横版

#define    sdkH5PayURL [NSString stringWithFormat:@"http://%@/storage/pay-page/ios/index.html?",payDomain]//横版


//初始化
#define  sdkInitAPI [NSString stringWithFormat:@"http://%@/report/active?",sdkDomain]

//通过用户id，手机验证码修改密码
#define  sdkChangePwdAPI [NSString stringWithFormat:@"http://%@/user/chg-pwd/renew?",sdkDomain]

//通过用户名和密码获取 token
#define  sdkGetLoginTokenByNameAPI [NSString stringWithFormat:@"http://%@/user/login-by-name?",sdkDomain]


//根据用户名/手机获取用户信息,用于找回密码
#define  sdkGetUserInfoAPI [NSString stringWithFormat:@"http://%@/user/chg-pwd/check-name?",sdkDomain]

//通过uid发送验证码、修改密码
#define  sdkSendcaptchaoByUidAPI [NSString stringWithFormat:@"http://%@/user/chg-pwd/send-captcha?",sdkDomain]

//通过新用户名和密码注册 
#define sdkRegisterbynameAPI [NSString stringWithFormat:@"http://%@/user/register-by-name?",sdkDomain]

//通检查用户名是否已存在
#define  sdkChecknameAPI [NSString stringWithFormat:@"http://%@/user/check-name?",sdkDomain]

//角色上报
#define  sdkCreatRoleAPI [NSString stringWithFormat:@"http://%@/report/create-role?",sdkDomain]

//角色等级上报
#define  sdkSendRoleLevelAPI [NSString stringWithFormat:@"http://%@/report/level-up?",sdkDomain]

//角色选服
#define  sdkSelectRoleServerAPI [NSString stringWithFormat:@"http://%@/report/select-server?",sdkDomain]

//获取验证码
#define  sdkGetPhoneCodeAPI [NSString stringWithFormat:@"http://%@/user/get-token-by-phone/send-captcha?",sdkDomain]

//通过验证码获取 token
#define  sdkGetTokenPhoneCodeAPI [NSString stringWithFormat:@"http://%@/user/get-token-by-phone?",sdkDomain]

//用户登录
#define  sdkLoginAPI [NSString stringWithFormat:@"http://%@/user/login?",sdkDomain]

//刷新token
#define  sdkrefReshTokenAPI [NSString stringWithFormat:@"http://%@/user/refresh-token?",sdkDomain]


//创建小号
#define  sdkSubusercreateAPI [NSString stringWithFormat:@"http://%@/sub-user/create?",sdkDomain]

//上报实名认证
#define sdkReportidentityCardAPI [NSString stringWithFormat:@"http://%@/anti-addiction/report-identity-card?",sdkDomain]

//补单
#define  sdkCheckOrderAPI [NSString stringWithFormat:@"http://%@/api65/65api/65sdk/checkoorder.php?",sdkDomain]

//商品接口
#define  sdkGetProductAPI    [NSString stringWithFormat:@"http://%@/api65/65api/65sdk/noappstore.php?",sdkDomain]

//切支付
#define sdkGetPayStatue [NSString stringWithFormat:@"http://%@/sdk102/ps/psu.php?",sdkDomain]



//支付回调（针对苹果支付）
#define  sdkPayCallBackAPI  [NSString stringWithFormat:@"https://%@/sfsdk/callback/ios_callback.php?",PAYURL]

//在线时长
#define sdkReportPlayTimeAPI   [NSString stringWithFormat:@"http://%@/apiunionchannels/api/common/1.0.0/real_verification/sdk/get_play_time_limit.php?",sdkDomain]

#endif

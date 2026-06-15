
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "VersionAllMethod.h"
#import "xysdkKeyChain.h"
#import "CommonStoreKey.h"
#import "SDKComplatformBase.h"
#import "NSString+category.h"
#import "UIColor+Category.h"
#import "NSUserDefaults+Category.h"
#import "sdkActivityIndicatorView.h"
#import "sdkRequestManager.h"
#import "RemindView.h"
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/ASIdentifierManager.h>
//账号key，密码，手机，更新时间

//设置idfv
#define setIDFV(IDFV) [[NSUserDefaults standardUserDefaults] setObject:(IDFV) forKey:@"IDFV"];[[NSUserDefaults standardUserDefaults] synchronize];
#define getIDFV [[NSUserDefaults standardUserDefaults] objectForKey:@"IDFV"]

//设置behavior_id
#define setBehavior_id(behavior_id) [[NSUserDefaults standardUserDefaults] setObject:(behavior_id) forKey:@"behavior_id"];[[NSUserDefaults standardUserDefaults] synchronize];
#define getBehavior_id [[NSUserDefaults standardUserDefaults] objectForKey:@"behavior_id"]

#define COMMONMETHOD [SDKCommonMethod shared]
@class BBModel;
@interface SDKCommonMethod : NSObject
@property (nonatomic, copy)NSString * FYCid; //渠道id
@property (nonatomic, copy)NSString * c_uid; //渠道uid
@property (nonatomic, copy)NSString * access_token; //登录token
@property (nonatomic, copy)NSString * refresh_token; //刷新token
@property (nonatomic, copy)NSString * expires_in; //过期时间 24小时
@property (nonatomic, copy)NSString * refresh_token_expires_in; //过期时间 一个月
@property (nonatomic, copy)NSString * password_plaintext; //
@property (nonatomic, copy)NSString * password; //用户密码
@property (nonatomic, copy)NSString * uid; //大号uid
@property (nonatomic, copy)NSString * userName; //
@property (nonatomic, copy)NSString * sub_uid; //子账号id
@property (nonatomic, copy)NSString * age; // 年龄
@property (nonatomic, copy)NSString * phone; //手机号
@property (nonatomic, copy)NSString * userType; //
@property (nonatomic, assign) BOOL  sub_AccountSwith; //小号切换
@property (nonatomic, assign) BOOL  bannedORplayout; //封禁或者踢下线
@property (nonatomic, copy)NSString * verify_after_login; //是否需要实名认证
@property (nonatomic, copy)NSString * verify_before_pay; //支付之前是否需要实名认证
@property (nonatomic, copy)NSString * allow_purchase_voucher; //支付之前是否需要实名认证
@property (nonatomic, copy)NSString * access_code; //登录码，给 CP 用于校验 sub_uid,有效期 20分钟
@property (nonatomic, copy)NSString * roleData;
@property (nonatomic,copy) NSString *age_level;//
@property (nonatomic,copy) NSString  *playLimitMsg;//
@property (nonatomic,copy) NSString  *bannedORplayoutString;//

@property (nonatomic, copy)NSString * is_newuser; //渠道is_newuser
@property (nonatomic, copy)NSString * mouth_Rechare;//当前月
@property (nonatomic, copy)NSString * channel_result; //渠道channel_result
@property (nonatomic, copy)NSString * FYDeviceToken; //设备码
@property (nonatomic, copy)NSString * uToken; //登录token

@property (nonatomic, copy)NSString * FYType; //设备类型
@property (nonatomic, copy) NSString * FYdeviceNo; //user标识
@property (nonatomic, copy) NSString * FYuserProtocol; //user协议
@property (nonatomic, copy) NSString * FYH5_URL; //H5的登录地址
@property (nonatomic, copy) NSString * FYH5_key; //H5的私钥
@property (nonatomic, copy) NSString * Ssandbox; //沙盒环境
@property (nonatomic, copy) NSString * FYVisitorSavePasswordTips; //一键注册截图的提示文字
@property (nonatomic, assign) BOOL hasLoginSucceedNotification;

@property (nonatomic) int phoneBadgeNum;            //手机绑定提醒
@property (nonatomic) int cardBadgeNum;             //实名认证提醒

@property (nonatomic) int switchIDCard;             //实名认证开关(0关 1开启

@property (nonatomic,assign) BOOL userHaveVerId;             //玩家是否已经实名认证
@property (nonatomic) int msgBadgeNum;              //消息提醒
@property (nonatomic) int giftBadgeNum;          //福利提醒
@property (nonatomic, copy) NSString * ageLevel; //年龄水平
@property (nonatomic, assign) NSInteger recordShowSDK;  //0没弹出，1弹出
@property (nonatomic, copy)NSString * behavior_id;// 激活标示

+ (instancetype)shared;

- (int)returnOrientation;


#pragma mark - 获取屏幕大小尺寸
/**
 *  获取屏幕高度
 *
 *  @return 屏幕高度
 */
+ (CGFloat )getHeight;

/**
 *  获取屏幕宽度
 *
 *  @return 屏幕宽度
 */
+ (CGFloat )getWidth;

#pragma mark - Device ID
/**
 *  用于游客一键
 *
 *  @return string
 */
- (NSString* )getVisitorDeviceMSG:(NSString *)random;



/// 获取游戏版本
- (NSString *)getGameVersion;
/**
 *  取 唯一标识符
 *
 *  @return string
 */
- (NSString *)getDeviceID;

- (NSString *)getDeviceMSG;

- (NSString* )getRest;
/**
 *  取 本机ip
 *
 *  @return string
 */
- (NSString *)getIPAddress;

- (NSString *)getAppName;
/**
 *  取 本机idfv
 *
 *  @return string
 */
- (NSString *)getEquipmentIDFV;


//获取广告标识
- (NSString *)getEquipmentIDFA;

#pragma mark - rootViewController
/**
 *  获取rootViewController
 *
 *  @return rootViewController
 */
- (UIViewController*)getRootViewController;

/**
 *  存进rootViewController
 *
 *  @param vc rootViewController
 */
- (void)setRootViewControllerWithViewController:(UIViewController*)vc;

/**
 获得当前的根控制器

 @return 根控制器
 */
-(UIViewController *)getCurrentRootViewController;

/**
 *  Base64 加密方式
 *
 *  @param encryptString 需要加密的字符串
 *
 *  @return 加密后的字符串
 */
+ (NSString *)encryptBase64WithString:(NSString *)encryptString;

/**
 *   Base64 解密方式
 *
 *  @param decodeString 需要解密的字符串
 *
 *  @return 解密后的字符串
 */
+ (NSString *)decodeBase64WithString:(NSString *)decodeString;

#pragma mark -  判断是否登录
- (BOOL)isLogin;

#pragma mark - 获取sdk生成账号的密码
- (NSString *)getInitGameAccountPassword;

- (BOOL)isShowBadgeNum;

+ (NSString *)getTimeStamp;

+ (NSString *)getNowTime;


//刷新refresh_token是否已经过期
+ (BOOL) returnRefreshTokenDeadLine:(NSString *)userId;

//登录access_token是否过期
+ (BOOL) returnExpiresinDeadLine:(NSString *)userId;

//登录access_token离现在时间是否大于0小于1小时
+ (BOOL) returnExpiresinanyHour:(NSString *)userId;



/**
 打印日志

 @param domain 域名
 @param model 模型
 @param responseObject 响应对象
 */
+ (void) showWebLogWithDomain:(NSString*) domain model:(requestModel*) model object:(id) responseObject succeed:(BOOL) succeed;

+ (void) reconnectAlertWithAction:(requestModel *)model
                             time:(CGFloat)time
                           action:(dispatch_block_t)action;

- (void)saveUserSwitchVerification;

- (BOOL) getUserSwitchVerification;
/**
 保存玩家年龄
 
 @param ageStr 年龄
 */
- (void)saveUserAge:(NSString *)ageStr;


+ (NSString *)getTimeMethod;


//比较两个时间的大小
-(int)compareDate:(NSString*)date01 withDate:(NSString*)date02;
@end

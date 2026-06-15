

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define INITCONFIGURE [InitConfigure shared]

/**
 配置类
 */
@interface InitConfigure : NSObject


/**
 游戏ID
 */
@property (nonatomic, copy)NSString * gid;

/**
 游戏包链接
 */
@property (nonatomic, copy)NSString * lid;

@property (nonatomic, copy)NSString * pid;
@property (nonatomic, copy)NSString * udid;

/**
 游戏AppKey
 */
@property (nonatomic, copy)NSString * appKey;

/**
 游戏PrivateKey
 */
@property (nonatomic, copy)NSString * privateKey;

/**
 SDK版本号
 */
@property (nonatomic, copy)NSString * version;


/**
  game版本
 */
@property (nonatomic, copy)NSString * last_version;

/**
  超级签地址
 */
@property (nonatomic, copy)NSString * landing_url;

/**
 游戏名字
 */
@property (nonatomic, copy)NSString * gameName;

@property (nonatomic, copy)NSString * aidStr;

@property (nonatomic, copy)NSString * cps_idStr;


+(instancetype)shared;

/**
 @brief SDKComPlatform单例
 */
+ (instancetype)defaultPlatform NS_DEPRECATED_IOS(1.1.2, 1.1.2, "使用+shared代替。");
/**
 设置根控制器。如果自动获取不到游戏的ViewController，就手动添加游戏的ViewController
 
 @param viewController 控制器
 */
- (void)setRootViewController:(id)viewController;
@end
/**
 @brief SDKComPlatform单例宏
 平台类
 */
@interface SDKComPlatform : NSObject

/**
 @brief SDKComPlatform单例
 */
+ (instancetype)shared;


/**
 设备信息
 */
@property (nonatomic,readonly) NSString * deviceInfo;


/**
 *  清除缓存
 */
- (void)clearCache;

/**
 访问API是否加载界面
 
 @param loading 是否加载界面
 */
- (void)setLoading:(BOOL) loading;



/**
 @brief SDKComPlatform单例
 */
+ (instancetype)defaultPlatform NS_DEPRECATED_IOS(1.1.2, 1.1.2, "使用+shared代替。");

/**
 *  注销的时候是否弹出登录框,默认弹出，设置为YES则不弹
 *
 */
@property (nonatomic,assign) BOOL isHideLoginViewWhenLogout;

@end




#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

/// 角色操作事件类型
typedef NS_ENUM(NSInteger, XYUserRoleType)
{
    XY_TYPE_SELECT_Role = 2,//创角色 首次进入游戏选服创角色
    XY_TYPE_SELECT_Enter = 3,//进入游戏，不是首次进入游戏
    XY_TYPE_LEVEL_UP         //角色升级
};


@interface GameManager : NSObject
+ (instancetype)shared;


/**

 *  用户唯一标识
 */
@property (nonatomic,copy) NSString * uid;

/**
 获取用户账号 (需要登录)
 */
@property (nonatomic,copy) NSString * accountName;


/**
 获取用户token (需要登录)
 */
@property (nonatomic,copy) NSString * token;


/// 激活SDK
- (void)initSDK;

/// 登录SDK
- (void)loginSDK;

/// 注销SDK
- (void)logoutSDK;

/// 选服
/// @param sId 服务器Id
/// @param sName 服务器名称
/// @param roleId 角色Id
/// @param roleLevel 角色等级
/// @param roleName 角色名称
/// @param roleType 角色操作类型
/// @param balance 游戏币数量
/// @param power 战斗力
/// @param other 透传参数
- (void)sendRoleDataWithServerId:(NSString *)sId serverName:(NSString *)sName roleId:(NSString *)roleId roleLevel:(NSString *)roleLevel roleName:(NSString *)roleName roleType:(XYUserRoleType)roleType roleBalance:(NSString *)balance rolePower:(NSString *)power other:(NSString *)other;

/// 下单
/// @param transactionId 订单流水号
/// @param goodsId 商品id
/// @param goodsName 商品名称
/// @param goodsDec 商品描述
/// @param price 价格
/// @param serverId 服务器id
/// @param serverName 服务器名称
/// @param roleId 角色id
/// @param roleLevel 角色等级
/// @param roleName 角色名称
/// @param gameOther 透传参数
- (void)orderWithOrderNum:(NSString *)transactionId GoodsId:(NSString *)goodsId goodsName:(NSString *)goodsName goodsDec:(NSString *)goodsDec price:(NSString *)price serverId:(NSString *)serverId serverName:(NSString *)serverName roleId:(NSString *)roleId roleLevel:(NSString *)roleLevel roleName:(NSString *)roleName gameOther:(NSString *)gameOther;

// H5游戏
//获取webview
- (WKWebView *)getJSWebView;

//加载url
- (void)loadRequest:(WKWebView *)webView;

//移除js方法
- (void)removeScriptMessage:(WKWebView *)webView;



#pragma mark - 生命周期函数 必须调用。 参考demo

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options;


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;


- (void)applicationWillResignActive:(UIApplication *)application;


- (void)applicationDidEnterBackground:(UIApplication *)application;


- (void)applicationWillEnterForeground:(UIApplication *)application;


- (void)applicationDidBecomeActive:(UIApplication *)application;


- (void)applicationWillTerminate:(UIApplication *)application;

@end

NS_ASSUME_NONNULL_END

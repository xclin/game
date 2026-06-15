

#import "GameManager.h"
#import "EventsListener.h"
#import "ApiGame.h"
#import "sdkInitConfiger.h"
#import "DeviceUtils.h"
#import <SafariServices/SafariServices.h>
#import "PaySDkController.h"
#import "sdkLoginConfiger.h"
#import "GameSDK.h"
#import "JHSDKWebJs.h"
#import "UrlList.h"
#import "NSMutableDictionary+ValueNonnull.h"
#import "sdkRoleConfiter.h"
@interface GameManager () <UIWebViewDelegate,NSURLConnectionDataDelegate,SFSafariViewControllerDelegate,WKNavigationDelegate,WKUIDelegate>
@end

@implementation GameManager

static GameManager *gmaeManager = nil;
+ (instancetype)shared {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (gmaeManager == nil) {
            gmaeManager = [[self alloc]init];
        }
    });
    return gmaeManager;
}

- (instancetype)init {
    if (self = [super init]) {
        [[EventsListener shared] startListen];
    }
    return self;
}

- (NSString*) uid {

    return [sdkLoginConfiger share].s_uid;
}

- (NSString*) accountName {

    return [sdkLoginConfiger share].account;
}

- (NSString*) token {

    return [sdkLoginConfiger share].s_token;
}



#pragma mark - API

- (void)initSDK {
    //TODO: 渠道SDK激活接口
    NSLog(@"initSDKinitSDKinitSDKinitSDK");
    [GameSDK initSdkWithParams];

}



- (void)loginSDK {

    //TODO: 渠道SDK激活接口
    [GameSDK loginSDK];
    
}

- (void)logoutSDK {
    //TODO: 渠道SDK注销接口
    
    [GameSDK logout];
}


- (void)sendRoleDataWithServerId:(NSString *)sId serverName:(NSString *)sName roleId:(NSString *)roleId roleLevel:(NSString *)roleLevel roleName:(NSString *)roleName roleType:(XYUserRoleType)roleType roleBalance:(NSString *)balance rolePower:(NSString *)power other:(NSString *)other {
    [sdkRoleConfiter share].sId = sId;
    [sdkRoleConfiter share].sName = sName;
    [sdkRoleConfiter share].roleId =roleId;
    [sdkRoleConfiter share].roleName = roleName;
    [sdkRoleConfiter share].roleLevel = roleLevel;
    [sdkRoleConfiter share].balance =balance;
    [sdkRoleConfiter share].power = power;
    [sdkRoleConfiter share].other = other;
    [sdkRoleConfiter share].roleType = roleType;
    //TODO: 渠道SDK选服接口
    [GameSDK reportCreateRoleWithSid:sId SName:sName Roleid:roleId RoleName:roleName];
}


- (void)orderWithOrderNum:(NSString *)transactionId GoodsId:(NSString *)goodsId goodsName:(NSString *)goodsName goodsDec:(NSString *)goodsDec price:(NSString *)price serverId:(NSString *)serverId serverName:(NSString *)serverName roleId:(NSString *)roleId roleLevel:(NSString *)roleLevel roleName:(NSString *)roleName gameOther:(NSString *)gameOther{
    
    [GameSDK  buyWithProductId:goodsId gameOther:gameOther transactionId:transactionId goodsName:goodsName goodsDec:goodsDec price:price sid:serverId];
}


// H5游戏
//获取webview
- (WKWebView *)getJSWebView{
    
   return  [[JHSDKWebJs sharedSingleton] getJSWebView];
}

//加载url
- (void)loadRequest:(WKWebView *)webView{
    
    [[JHSDKWebJs sharedSingleton] loadRequest:webView];
    
}

//移除js方法
- (void)removeScriptMessage:(WKWebView *)webView{
    
      [[JHSDKWebJs sharedSingleton] removeScriptMessage:webView];
    
}

#pragma mark - 周期函

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

#pragma mark - private
- (UIViewController *)getCurrentRootViewController {
    UIViewController *result;
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    if (topWindow.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(topWindow in windows)
        {
            if (topWindow.windowLevel == UIWindowLevelNormal)
                break;
        }
    }
    UIView *rootView = [[topWindow subviews] objectAtIndex:0];
    
    id nextResponder = [rootView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else if (topWindow.rootViewController != nil)
        result = topWindow.rootViewController;
    else
        NSAssert(NO, @"SCould not find a root view controller.  You can assign one manually by calling [[SHK currentHelper] setRootViewController:YOURROOTVIEWCONTROLLER].");
    return result;
}


@end

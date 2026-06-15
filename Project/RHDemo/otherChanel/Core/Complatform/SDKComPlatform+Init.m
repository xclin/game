
#import "SDKComPlatform+Init.h"
#import "SDKCommonMethod.h"

#import "sdkActivityIndicatorView.h"
#import "AFNetworkReachabilityManager.h"
#import "sdkInitRequestManager.h"
#import "getSDKParamGPSID.h"
@implementation SDKComPlatform (Init)

+(void) LoadFirstTime {
    
    [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"isLoadFirstTime"];
}

+(BOOL) isLoadFirstTime {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"isLoadFirstTime"] == nil;
}



/**
 *  开始加载
 */
- (void) startInitRequest {

    static dispatch_once_t onceToken;
    //i第一次进行特别处理
    __block BOOL versonIsLargerThan10AndInstallFirstTime = [[self class] isLoadFirstTime] && [UIDevice currentDevice].systemVersion.floatValue >= 10;
    //加载控制器
    dispatch_block_t action = ^{
        static sdkInitRequestManager * request;
        dispatch_once(&onceToken, ^{
            if(versonIsLargerThan10AndInstallFirstTime ) {
                [[self class] LoadFirstTime];
                versonIsLargerThan10AndInstallFirstTime = NO;
            }
            
            request =[[sdkInitRequestManager alloc] initWithHandler:^(NSString *code) {
                if (![code isEqualToString:@"0"]) {
                     [[RemindView share] show:@"游戏初始化失败" time:2.0];
                }
                 [AIVIEW hide];
            }];
            [request initSDKRequest];
        });
    };
    
    
    AFNetworkReachabilityManager *mananger = [AFNetworkReachabilityManager sharedManager];
    [mananger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            case AFNetworkReachabilityStatusNotReachable:
                DEBUGMSG(@"没有网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                DEBUGMSG(@"手机网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                DEBUGMSG(@"wifi");
                break;
            default:
                break;
        }
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
            action();
        }
    }];
    [mananger startMonitoring];
    //10s后没执行再执行一遍
    NSTimeInterval delay = versonIsLargerThan10AndInstallFirstTime ? 10 : 3;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        action();
    });
}



///  sdk初始化
- (void) initSdkWithParams{
    NSDictionary * DicConfig = [getSDKParamGPSID getGPSIDConfig];
    NSString * aid= @"";
    NSString *cps_id = @"";
    NSString *gid = @"";
    NSString *lid = @"";
    NSString *pid = @"";
    NSString *versions = @"";
    NSString *udid = @"";
    if (DicConfig) {
        aid= DicConfig[@"aid"]?DicConfig[@"aid"]:@"";
        cps_id= DicConfig[@"cps_id"]?DicConfig[@"cps_id"]:@"";
        gid= DicConfig[@"gid"]?DicConfig[@"gid"]:@"";
        lid= DicConfig[@"lid"]?DicConfig[@"lid"]:@"";
        pid= DicConfig[@"pid"]?DicConfig[@"pid"]:@"";
        versions= DicConfig[@"version"]?DicConfig[@"version"]:@"";
        udid= DicConfig[@"udid"]?DicConfig[@"udid"]:@"";
    }
    
    INITCONFIGURE.aidStr         = aid;
    INITCONFIGURE.cps_idStr      = cps_id;
    INITCONFIGURE.gid  = gid;
    INITCONFIGURE.lid = lid;
    INITCONFIGURE.version = versions;
    INITCONFIGURE.pid = pid;
    INITCONFIGURE.udid = udid;
    if (@available(iOS 14, *)) {
            // iOS14及以上版本需要先请求权限
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                // 获取到权限后，依然使用老方法获取idfa
                if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                    [self startInitRequest];
                } else {
                         NSLog(@"请在设置-隐私-跟踪中允许App请求跟踪");
                    [self startInitRequest];
                }
            }];
        } else {
            // iOS14以下版本依然使用老方法
            // 判断在设置-隐私里用户是否打开了广告跟踪
            if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
                [self startInitRequest];
            } else {
                NSLog(@"请在设置-隐私-广告中打开广告跟踪功能");
                [self startInitRequest];
            }
        }
 
    

}
@end

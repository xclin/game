
#include <CommonCrypto/CommonCrypto.h>
#import "JHSDKWebJs.h"
#import <AdSupport/AdSupport.h>
#import "sdkInitConfiger.h"
#import "DeviceUtils.h"
#import "sdkLoginConfiger.h"
#import "GameManager.h"
#import "ApiGame.h"
#import "RequestUtils.h"
#import "EncryptUtils.h"
#import "NSMutableDictionary+ValueNonnull.h"
#import "NSURLProtocol+WKWebVIew.h"
#define MAIN_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define MAIN_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

static JHSDKWebJs * sharedSingleton = nil;

@interface JHSDKWebJs ()

@end

@implementation JHSDKWebJs

+ (instancetype)sharedSingleton {
    static dispatch_once_t pred;
    dispatch_once(&pred,^{
        if (sharedSingleton == nil) {
            sharedSingleton = [[self alloc] init];
        }
    });
    return sharedSingleton;
}

- (void)removeScriptMessage:(WKWebView *)webView{
    //这里需要注意，前面增加过的方法一定要remove掉。
    [webView.configuration.userContentController removeScriptMessageHandlerForName:@"loginAction"];
    [webView.configuration.userContentController removeScriptMessageHandlerForName:@"serviceAction"];
    [webView.configuration.userContentController removeScriptMessageHandlerForName:@"updateAction"];
    [webView.configuration.userContentController removeScriptMessageHandlerForName:@"purchaseAction"];
    [webView.configuration.userContentController removeScriptMessageHandlerForName:@"logoutAction"];
}

- (WKWebViewConfiguration *)webViewConfiguration{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    WKUserContentController *userCC = config.userContentController;
    [userCC addScriptMessageHandler:self name:@"loginAction"];
    [userCC addScriptMessageHandler:self name:@"serviceAction"];
    [userCC addScriptMessageHandler:self name:@"updateAction"];
    [userCC addScriptMessageHandler:self name:@"purchaseAction"];
    [userCC addScriptMessageHandler:self name:@"logoutAction"];
    config.userContentController = userCC;
    return config;
}

- (WKWebView *)getJSWebView{
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT) configuration:self.webViewConfiguration];
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    webView.backgroundColor = [UIColor clearColor];
    webView.opaque = NO;
    webView.scrollView.alwaysBounceVertical = NO;
    webView.scrollView.alwaysBounceHorizontal = NO;
    webView.scrollView.bounces = NO;
    //iphoneX安全区域适配
        if (@available(iOS 11.0, *)) {
            webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    return webView;
}

- (void)loadRequest:(WKWebView *)webView{
    NSString *url = [NSString stringWithFormat:@"http://applyapi.ggxx.net/xyoffical-ios/login?ctype=%@&gid=%@&uid=%@&token=%@&accountName=%@",[sdkInitConfiger share].ctype,[sdkInitConfiger share].gid,[sdkLoginConfiger share].s_uid,[sdkLoginConfiger share].s_token,[sdkLoginConfiger share].c_uid];
    NSLog(@"游戏url--%@",url);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [webView loadRequest:request];
    
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSDictionary *dict;
    NSError *err;
    if ([message.name isEqualToString:@"loginAction"]) {
        [[GameManager shared] loginSDK];//
    }else if ([message.name isEqualToString:@"serviceAction"]){
        if ([message.body isKindOfClass:[NSString class]]){
            NSData *jsonData = [message.body dataUsingEncoding:NSUTF8StringEncoding];
            dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        }else if ([message.body isKindOfClass:[NSDictionary class]]){
            
            NSData *data = [NSJSONSerialization dataWithJSONObject:message.body options:0 error:NULL];
            dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
            NSLog(@"选服--NSDictionary-=%@",dict);
        }
        
        NSDictionary *jsonDict = [dict objectForKey:@"json"];
             [[GameManager shared] sendRoleDataWithServerId:[self toStr:[jsonDict objectForKey:@"serverId"]] serverName:[self toStr:[jsonDict objectForKey:@"serverName"]] roleId:[self toStr:[jsonDict objectForKey:@"roleId"]] roleLevel:[self toStr:[jsonDict objectForKey:@"roleLevel"]] roleName:[self toStr:[jsonDict objectForKey:@"roleName"]] roleType:1 roleBalance:@"" rolePower:@"" other:@""];
        
    }else if ([message.name isEqualToString:@"updateAction"]){
        
    }else if ([message.name isEqualToString:@"purchaseAction"]){
        if ([message.body isKindOfClass:[NSString class]]){
            NSData *jsonData = [message.body dataUsingEncoding:NSUTF8StringEncoding];
            dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
            NSLog(@"购买-NSString-=%@",dict);
        }else if ([message.body isKindOfClass:[NSDictionary class]]){
            NSData *data = [NSJSONSerialization dataWithJSONObject:message.body options:0 error:NULL];
            dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
        }
        NSDictionary *jsonDict = [dict objectForKey:@"json"];

               [[GameManager shared] orderWithOrderNum:[self toStr:[jsonDict objectForKey:@"transactionId"]] GoodsId:jsonDict[@"apId"] goodsName:jsonDict[@"productName"] goodsDec:jsonDict[@"productDesc"] price:jsonDict[@"price"] serverId:[self toStr:[jsonDict objectForKey:@"serverId"]] serverName:[self toStr:[jsonDict objectForKey:@"serverName"]] roleId:[self toStr:[jsonDict objectForKey:@"roleId"]] roleLevel:[self toStr:[jsonDict objectForKey:@"roleLevel"]] roleName:[self toStr:[jsonDict objectForKey:@"roleName"]] gameOther:[self toStr:[jsonDict objectForKey:@"gameOther"]]];
            

    }else if ([message.name isEqualToString:@"logoutAction"]){
        NSLog(@"注销");
        [[GameManager shared] logoutSDK];
    }
}

- (NSString *)toStr:(id)sender {
      return [NSString stringWithFormat:@"%@",sender?sender:@""];
}

#pragma mark sign
- (NSString *)sign {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setSafeValue:[sdkLoginConfiger share].account forKey:@"accountName"];
    [dict setSafeValue:[sdkLoginConfiger share].s_uid forKey:@"uid"];
    [dict setSafeValue:[sdkLoginConfiger share].s_token forKey:@"token"];
    [dict setSafeValue:[sdkInitConfiger share].ver forKey:@"sdkVersionCode"];
    [dict setSafeValue:[sdkInitConfiger share].gid forKey:@"gid"];
    [dict setSafeValue:[sdkInitConfiger share].h5PrivateKey forKey:@"privateKey"];
    
    NSString *sign = [DeviceUtils compareWithNSDictionary:dict].md5String;
    return sign;
}

//获取当前UIViewController
- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

@end

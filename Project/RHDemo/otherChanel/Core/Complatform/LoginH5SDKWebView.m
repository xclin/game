
#include <CommonCrypto/CommonCrypto.h>
#import "VersionAllMethod.h"
#import "Config.h"
#import "SDKCommonMethod.h"
#import "WTMGlyphGestureRecognizer.h"
#import "LoginH5SDKWebView.h"
#import "sdkInitModel.h"
#import "DataBaseManager.h"
#import <AdSupport/AdSupport.h>
#import "SDKComPlatform.h"
#define MAIN_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define MAIN_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

static LoginH5SDKWebView * sharedSingleton = nil;
@interface LoginH5SDKWebView ()

@end

@implementation LoginH5SDKWebView

+ (instancetype)shared {
    static dispatch_once_t pred;
    dispatch_once(&pred,^{
        if (sharedSingleton == nil) {
            sharedSingleton = [[self alloc] init];
        }
    });
    return sharedSingleton;
}

- (WKWebView *)getJSWebView{
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT)];
    webView.navigationDelegate = self;
    webView.backgroundColor = [UIColor blackColor];
    webView.opaque = NO;
    webView.scrollView.alwaysBounceVertical = NO;
    webView.scrollView.alwaysBounceHorizontal = NO;
    webView.scrollView.bounces = NO;
    AddRecognizeStarGestureRecognizer(webView, ^{})
    //iphoneX安全区域适配
    if (@available(iOS 11.0, *)) {
        webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return webView;
}


- (void)loadRequest:(WKWebView *)webView{
    NSString *url  = @"";

        url = [sdkInitModel share].h5sdk_urltr;

  
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [webView loadRequest:request];
    
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURLRequest *req = navigationAction.request;
    NSURL *url = req.URL;
    NSString *urlStr = url.absoluteString;
    if (urlStr.length <= 0) {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }

    NSString *wUrl = @"weixin://wap/pay";
     NSString *aUrl =  @"alipays";
    NSLog(@"---%@,---%@",wUrl,aUrl);
    if ([urlStr containsString:wUrl] || [urlStr containsString:aUrl]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                if (success) {
                    decisionHandler(WKNavigationActionPolicyCancel);
                } else {
                    decisionHandler(WKNavigationActionPolicyAllow);
                }
            }];
        } else {
            BOOL succ = [[UIApplication sharedApplication] openURL:url];
            if (succ) {
                decisionHandler(WKNavigationActionPolicyCancel);
            } else {
                decisionHandler(WKNavigationActionPolicyAllow);
            }
        }

    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
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

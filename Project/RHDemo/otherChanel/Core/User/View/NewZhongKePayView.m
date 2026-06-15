

#import "NewZhongKePayView.h"
#import "SDKCommonMethod.h"
#import "Config.h"
#import <WebKit/WebKit.h>
#import "apiManager.h"
#import "NewZhongkeWebSuspenView.h"
//#import "ZhongkePayHandler.h"
#define RBGColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
@interface NewZhongKePayView ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,UIWebViewDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *doneBtn;
@end

@implementation NewZhongKePayView

- (void)removeScriptMessage:(WKWebView *)webView{
    //这里需要注意，前面增加过的方法一定要remove掉。
    [webView.configuration.userContentController removeScriptMessageHandlerForName:@"closePayView"];
    [webView.configuration.userContentController removeScriptMessageHandlerForName:@"alipayCallBack"];
    [webView.configuration.userContentController removeScriptMessageHandlerForName:@"wxpayCallBack"];
}

- (WKWebViewConfiguration *)webViewConfiguration{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    WKUserContentController *userCC = config.userContentController;
    [userCC addScriptMessageHandler:self name:@"closePayView"];
    [userCC addScriptMessageHandler:self name:@"alipayCallBack"];
    [userCC addScriptMessageHandler:self name:@"wxpayCallBack"];
    config.userContentController = userCC;
    return config;
}

- (void)setupUI{
    
    self.titleLbl.hidden = YES;
    self.backgroundColor = [UIColor clearColor];
    
    
    [self addSubview:self.contentView];
    
    
    [self.contentView addSubview:self.webView];
    
    
    self.contentView.hidden = NO;
    
    
    [self updateFrame];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRotateNewZhongKePayView:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
}

- (void)updateFrame{
    UIInterfaceOrientation sataus=[UIApplication sharedApplication].statusBarOrientation;
    if (sataus == UIInterfaceOrientationPortrait ||sataus ==  UIInterfaceOrientationPortraitUpsideDown) {//竖屏
        self.contentView.frame =CGRectMake(0,0, ZKUserViewWidth, ZKUserViewHeight);
        self.doneBtn.frame = CGRectMake(10, 0, 40, 40);
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, ZKUserViewWidth - 100, 40)];
        self.webView.frame = CGRectMake(0, 40, ZKUserViewWidth, ZKUserViewHeight - 40);
 
    }else {//横版
        self.contentView.frame =CGRectMake(0,0, ZKUserViewWidth, ZKUserViewHeight);
        self.doneBtn.frame = CGRectMake(10, 0, 40, 40);
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, ZKUserViewWidth - 100, 40)];
        self.webView.frame = CGRectMake(0, 40, ZKUserViewWidth, ZKUserViewHeight - 40);
    }
}


- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];

    }
    return _contentView;
}


- (WKWebView *)webView{
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0,0, 0, 0)configuration:self.webViewConfiguration];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.opaque = NO;
        _webView.scrollView.scrollEnabled= NO;
        [_webView.scrollView setShowsVerticalScrollIndicator:NO];
        _webView.scrollView.bounces = NO;
        _webView.backgroundColor =[UIColor clearColor];//RBGColor(0, 0, 0, 0.3);
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
        }
    }
    return _webView;
}


- (void)setUrlStr:(NSString *)urlStr{
    _urlStr = urlStr;
    [self.webView loadRequest:[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.urlStr]]];
}


- (void)closeView {
    if (self.backBlock) {
        self.backBlock();
    }
    [[NewZhongkeWebSuspenView shared] showSuspension];
}


#pragma mark - WKNavigationDelegate, WKUIDelegate

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    [webView reload];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    self.contentView.hidden = NO;
}


// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [AIVIEW hide];
    self.contentView.hidden = NO;
    
    
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
        NSLog(@"decidePolicyForNavigationAction urlStr---%@",urlStr);
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


- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [[COMMONMETHOD getRootViewController] presentViewController:alert animated:YES completion:nil];
}

- (void)changeRotateNewZhongKePayView:(NSNotification*)noti{
        [self updateFrame];
    
}


- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if ([message.name isEqualToString:@"closePayView"]){
        NSLog(@"%@",message.body);
        [self removeScriptMessage:self.webView];
        [self closeView];
    
    } else if([message.name isEqualToString:@"alipayCallBack"]){
        
//        [ZhongkePayHandler goToPay:message.body];
        
    } else if([message.name isEqualToString:@"wxpayCallBack"]){
        
    }
}

@end

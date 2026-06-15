
#import "PayViewController.h"
#import <WebKit/WebKit.h>
#import "SDKCommonMethod.h"
#import "Config.h"
#import "apiManager.h"
#import "NewZhongkeWebSuspenView.h"
#define RBGColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
@interface PayViewController ()<WKNavigationDelegate, WKUIDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *doneBtn;

@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat W =0;
    CGFloat H = 0;
    self.view.backgroundColor = RBGColor(0, 0, 0, 0.3);
    self.contentView = [[UIView alloc] init];
    if (true) {//横屏
        W = windowHeight;
        H =windowHeight *0.9;
        self.contentView.frame =CGRectMake((windowWidth-windowHeight)/2,windowHeight*0.05, W, H);
    }else{//竖屏
        W = windowWidth-10;
        H =windowHeight *0.6;
        self.contentView.frame =CGRectMake(5,windowHeight*0.4, W, H);
    }
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 8.0;
    self.contentView.layer.masksToBounds = YES;
    [self.view addSubview:self.contentView];
    
    self.doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 40, 40 )];
    [self.doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.doneBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    [self.doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.doneBtn];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, W - 100, 40)];
    self.titleLabel.text = @"选择支付方式";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLabel];
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 40, W, H - 40)];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    self.webView.opaque = NO;
    self.webView.scrollView.bounces = NO;
    [self.contentView addSubview:self.webView];
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.contentView.hidden = YES;

    [self.webView loadRequest:[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.urlStr]]];
}


- (void)done {
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NewZhongkeWebSuspenView shared] showSuspension ];
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


- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alert animated:true completion:nil];
}

@end

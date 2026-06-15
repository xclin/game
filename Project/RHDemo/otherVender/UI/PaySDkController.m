
#import "PaySDkController.h"
#import <WebKit/WebKit.h>

#define windowWidth ([UIScreen mainScreen].bounds.size.width)
#define RBGColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface PaySDkController ()<WKNavigationDelegate, WKUIDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *doneBtn;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;

@end

@implementation PaySDkController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat W = windowWidth *0.8;
    self.view.backgroundColor = RBGColor(0, 0, 0, 0.3);
    self.contentView = [[UIView alloc] init];
    self.contentView.center  = self.view.center;
    self.contentView.bounds = CGRectMake(0, 0, W, W);
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
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 40, W, W - 40)];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    self.webView.opaque = NO;
    self.webView.scrollView.bounces = NO;
    [self.contentView addSubview:self.webView];
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.loadingIndicator startAnimating];
    self.contentView.hidden = YES;
  
    [self.webView loadRequest:[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.urlStr]]];
}


- (void)done {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - WKNavigationDelegate, WKUIDelegate

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    [webView reload];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.loadingIndicator stopAnimating];
    self.contentView.hidden = NO;
}

- (NSString *)decode:(NSString *)decode{
    NSData *decodeData = [[NSData alloc]initWithBase64EncodedString:decode options:0];
    NSString *decodestring= [[NSString alloc]initWithData:decodeData encoding:NSUTF8StringEncoding];
    
    return decodestring;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURLRequest *req = navigationAction.request;
    NSURL *url = req.URL;
    NSString *urlStr = url.absoluteString;
    if (urlStr.length <= 0) {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    NSString *wUrl = [self decode:@"d2VpeGluOi8vd2FwL3BheQ=="];
    NSString *aUrl =[self decode:@"YWxpcGF5Oi8vYWxpcGF5Y2xpZW50"];
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


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.loadingIndicator stopAnimating];
    self.contentView.hidden = NO;
}


- (UIActivityIndicatorView *)loadingIndicator {
    if (_loadingIndicator == nil) {
        if (@available(iOS 13.0, *)) {
            _loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
        } else {
            _loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        }
        _loadingIndicator.frame = CGRectMake(0, 0, 80, 80);
        _loadingIndicator.center = self.view.center;
        _loadingIndicator.color = [UIColor blackColor];
        _loadingIndicator.alpha = 0.8;
        _loadingIndicator.hidesWhenStopped = YES;
        [self.view addSubview:_loadingIndicator];
    }
    return _loadingIndicator;
}

@end

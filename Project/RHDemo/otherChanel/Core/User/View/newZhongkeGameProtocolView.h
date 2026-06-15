
#import "ZhongkeView.h"
#import <WebKit/WebKit.h>
@interface newZhongkeGameProtocolView : ZhongkeView
@property (nonatomic,copy) NSString *proStr;
@property (nonatomic,copy) NSString *loadUrlStr;
@property (nonatomic,strong) UITextView *aTextView;
@property (nonatomic, strong) WKWebView *webView;
- (void)loadRequestUrl;  
@end

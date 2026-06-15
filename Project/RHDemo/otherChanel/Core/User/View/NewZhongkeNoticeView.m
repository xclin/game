

#import "NewZhongkeNoticeView.h"
#import "sdkInitModel.h"


@interface NewZhongkeNoticeView ()<WKNavigationDelegate,WKUIDelegate,UIWebViewDelegate>
@end



@implementation NewZhongkeNoticeView

- (void)setupUI{
    
    self.titleLbl.hidden = YES;
    self.backBtn.hidden = NO;
    self.LogingTypeLbl.text = @"我的消息";
    self.LogingTypeLbl.hidden = NO;
    self.backForPhoneView.hidden = NO;
    self.backForPhoneView.backgroundColor = rgba(0, 0, 0, 0.3);
    [self.backForPhoneView addSubview:self.webView];
    [self.backForPhoneView addSubview:self.titleMsg];
    [self.backForPhoneView addSubview:self.timeLbl];
    [self.backForPhoneView addSubview:self.line];
    
    
    //如果需要弹出维护公告，那只能弹出一个，游戏其他公告不需要再弹
    if ([sdkInitModel share].maintain.count > 0) {
        for (NSDictionary *dic in [sdkInitModel share].maintain ) {
            if ([COMMONMETHOD compareDate:dic[@"start_at"] withDate:[SDKCommonMethod getTimeMethod]] && [COMMONMETHOD compareDate:[SDKCommonMethod getTimeMethod] withDate:dic[@"end_at"]]) {
                [self setUIText:dic andTypeText:Text_Maintain];
                self.type =Text_Maintain;
                break;
            }
            
        }
    }else if([sdkInitModel share].beforelogin.count > 0){
        for (NSDictionary *dic in [sdkInitModel share].beforelogin ) {
            if ([COMMONMETHOD compareDate:dic[@"start_at"] withDate:[SDKCommonMethod getTimeMethod]] && [COMMONMETHOD compareDate:[SDKCommonMethod getTimeMethod] withDate:dic[@"end_at"]]) {
                [self setUIText:dic andTypeText:Text_BeforeLogin];
                self.type =Text_BeforeLogin;
                break;
            }
            
        }
        
    }else if([sdkInitModel share].afterlogin.count > 0){
        for (NSDictionary *dic in [sdkInitModel share].afterlogin ) {
            if ([COMMONMETHOD compareDate:dic[@"start_at"] withDate:[SDKCommonMethod getTimeMethod]] && [COMMONMETHOD compareDate:[SDKCommonMethod getTimeMethod] withDate:dic[@"end_at"]]) {
                [self setUIText:dic andTypeText:Text_AftetLogin];
                self.type =Text_AftetLogin;
                break;
            }
            
        }
        
    }

    [self updateFrame];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRotateNewZhongkeNoticeView:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

-(WKWebView *)webView{
    if (!_webView) {
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        wkWebConfig.userContentController = wkUController;
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:wkWebConfig];
        _webView.navigationDelegate = self;
        _webView.scrollView.bounces = NO;
        _webView.scrollView.alwaysBounceVertical = NO;
        _webView.scrollView.scrollEnabled = YES;
        _webView.backgroundColor = [UIColor clearColor];
       
    }
    return _webView;
}

- (UITextView *)contentview{
    if (!_contentview) {
        NSString *mesg = @"";
        _contentview =  [UITextView new];
        _contentview.backgroundColor = [UIColor clearColor]; //设置背景色
        _contentview.scrollEnabled = YES;
        _contentview.showsVerticalScrollIndicator = NO;
        _contentview.showsHorizontalScrollIndicator = NO;
        _contentview.editable = NO;
        _contentview.textColor =rgba(255, 255, 255, 1);
        _contentview.text = mesg;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 7;// 字体的行间距
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName:paragraphStyle
        };
        _contentview.attributedText = [[NSAttributedString alloc] initWithString:_contentview.text attributes:attributes];
    }
    return _contentview;
}



- (void)setUIText:(NSDictionary *)dic andTypeText:(NoticeType)type{
    NSString *contentStr = @"";
    if (type == Text_Maintain) {
        self.backBtn.hidden = YES;
        self.LogingTypeLbl.text = @"游戏维护公告";
        self.titleMsg.text = dic[@"title"];
        self.timeLbl.text = dic[@"start_at"];
        contentStr = dic[@"content"];
    }else if(type == Text_BeforeLogin){
        self.LogingTypeLbl.text = @"游戏公告";
        self.titleMsg.text = dic[@"title"];
        self.timeLbl.text = dic[@"start_at"];
        contentStr = dic[@"content"];
    }else if(type == Text_AftetLogin){
        self.LogingTypeLbl.text = @"游戏公告";
        self.titleMsg.text = dic[@"title"];
        self.timeLbl.text = dic[@"start_at"];
        contentStr = dic[@"content"];
    }
    
    NSString * formatString =@"<span style=\"font-size:12px;color:#FFFFFF\">%@</span>";
    NSString * htmlString = [NSString stringWithFormat:formatString,contentStr];
//      NSString * urlStr1 = [NSString stringWithFormat:@"<html><body style=\"word-wrap:break-word;word-break:break-all;overflow: hidden;\">%@</body></html>",htmlString];
    NSString * urlStr1 = [NSString stringWithFormat:@"<html><body>%@</body></html>",htmlString];
    [self.webView loadHTMLString:urlStr1 baseURL:nil];
    
}


//页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
//    [webView evaluateJavaScript:@"document.body.offsetHeight;" completionHandler:^(id _Nullable any, NSError * _Nullable error) {
//
//        NSString *heightStr = [NSString stringWithFormat:@"%@",any];
//        NSLog(@"--高度--%@",heightStr);
//
//
//    }];
    
    
    [webView evaluateJavaScript:@"document.body.style.backgroundColor=\"#242424\"" completionHandler:nil];

    
}



- (void)backBtnAction{
    
    
    if (self.goBackBlock) {
        if (self.type == Text_AftetLogin) {
            self.goBackBlock(@"2");
        }else{
            self.goBackBlock(@"1");
        }
       
    }
}


- (UILabel *)titleMsg{
    if (!_titleMsg) {
        _titleMsg = [UILabel new];
        _titleMsg.font = [UIFont systemFontOfSize:14.0f];
        _titleMsg.textColor = rgba(255, 255, 255, 1);
        _titleMsg.textAlignment = NSTextAlignmentCenter;
        _titleMsg.text = @"尊敬的用户，欢迎您登录到Hapi游戏！";
        
    }
    return _titleMsg;
}


- (UILabel *)timeLbl{
    if (!_timeLbl) {
        _timeLbl = [UILabel new];
        _timeLbl.font = [UIFont systemFontOfSize:12.0f];
        _timeLbl.textColor = rgba(123, 123, 123, 1);
        _timeLbl.textAlignment = NSTextAlignmentCenter;
        _timeLbl.text = [SDKCommonMethod getNowTime];
        
    }
    return _timeLbl;
}


- (UILabel *)line{
    if (!_line) {
        _line = [UILabel new];
        _line.backgroundColor = rgba(222, 222, 222, 1);
    }
    return _line;
}



- (void)updateFrame{
    UIInterfaceOrientation sataus=[UIApplication sharedApplication].statusBarOrientation;
    if (sataus == UIInterfaceOrientationPortrait ||sataus ==  UIInterfaceOrientationPortraitUpsideDown) {//竖屏
        self.LogingTypeLbl.frame = CGRectMake(SCREEN_FIT(60), SCREEN_FIT(20), ZKUserViewWidth-SCREEN_FIT(120), SCREEN_FIT(30));
        self.backBtn.frame = CGRectMake(SCREEN_FIT(10), SCREEN_FIT(20), SCREEN_FIT(30), SCREEN_FIT(30));
        self.backForPhoneView.frame =CGRectMake(SCREEN_FIT(10), CGRectGetMaxY(self.LogingTypeLbl.frame)+SCREEN_FIT(10), ZKUserViewWidth-SCREEN_FIT(20), ZKUserViewHeight-SCREEN_FIT(90));
        self.titleMsg.frame  = CGRectMake(SCREEN_FIT(0), SCREEN_FIT(20), CGRectGetWidth(self.backForPhoneView.frame), SCREEN_FIT(20));
        self.timeLbl.frame = CGRectMake(SCREEN_FIT(0), CGRectGetMaxY(self.titleMsg.frame), CGRectGetWidth(self.backForPhoneView.frame), SCREEN_FIT(15));
        self.line.frame = CGRectMake(SCREEN_FIT(20), CGRectGetMaxY(self.timeLbl.frame)+SCREEN_FIT(5), CGRectGetWidth(self.backForPhoneView.frame)-SCREEN_FIT(40), 1);
        self.webView.frame = CGRectMake(0, CGRectGetMaxY(self.line.frame)+SCREEN_FIT(10), CGRectGetWidth(self.backForPhoneView.frame), CGRectGetHeight(self.backForPhoneView.frame)-SCREEN_FIT(60));
    }else {//横版
        self.LogingTypeLbl.frame = CGRectMake(SCREEN_FIT(60), SCREEN_FIT(20), ZKUserViewWidth-SCREEN_FIT(120), SCREEN_FIT(30));
        self.backBtn.frame = CGRectMake(SCREEN_FIT(10), SCREEN_FIT(20), SCREEN_FIT(30), SCREEN_FIT(30));
        self.backForPhoneView.frame =CGRectMake(SCREEN_FIT(20), CGRectGetMaxY(self.LogingTypeLbl.frame)+SCREEN_FIT(10), ZKUserViewWidth-SCREEN_FIT(40), ZKUserViewHeight-SCREEN_FIT(90));
        self.titleMsg.frame  = CGRectMake(SCREEN_FIT(0), SCREEN_FIT(20), CGRectGetWidth(self.backForPhoneView.frame), SCREEN_FIT(20));
        self.timeLbl.frame = CGRectMake(SCREEN_FIT(0), CGRectGetMaxY(self.titleMsg.frame), CGRectGetWidth(self.backForPhoneView.frame), SCREEN_FIT(15));
        self.line.frame = CGRectMake(SCREEN_FIT(20), CGRectGetMaxY(self.timeLbl.frame)+SCREEN_FIT(5), CGRectGetWidth(self.backForPhoneView.frame)-SCREEN_FIT(40), 1);
        self.webView.frame = CGRectMake(0, CGRectGetMaxY(self.line.frame)+SCREEN_FIT(10), CGRectGetWidth(self.backForPhoneView.frame), CGRectGetHeight(self.backForPhoneView.frame)-SCREEN_FIT(60));
    }
}

- (void)changeRotateNewZhongkeNoticeView:(NSNotification*)noti {
    [self updateFrame];
    
}


@end

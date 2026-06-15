
#import "NewZhongKeViewForSupen.h"
#import "SDKCommonMethod.h"
#import "DataBaseManager.h"
#import "SDKUserAccountModel.h"
#import "sdkActivityIndicatorView.h"
#import "SuspensionView.h"
#import "Masonry.h"
#import "UserDataModel.h"
#import "UserModel.h"
#import "YYKit.h"
#import "sdkRequestManager.h"
#import "WTMGlyphGestureRecognizer.h"
#import "DataBaseManager.h"
#import "LoginOperation.h"
#import "RemindView.h"
#import "UserDataController.h"
#import "BaseButton.h"
#import "NewZhongkeWebSuspenView.h"
#import "UserDataModel.h"
#define ISiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define RBGColor(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:0.1]
@interface NewZhongKeViewForSupen ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,UIWebViewDelegate>
@property (nonatomic,strong) WebASDFModel * model;
@property (nonatomic,strong) UIButton * dismissButton;
@property (nonatomic,assign) NSInteger switchStr;
@property (nonatomic,strong) UIButton * closeBtn;
@property (nonatomic,strong)  BaseButton *btnChangeSide;
@end

@implementation NewZhongKeViewForSupen

- (void)removeScriptMessage:(WKWebView *)webView{
    //这里需要注意，前面增加过的方法一定要remove掉。
    [webView.configuration.userContentController removeScriptMessageHandlerForName:@"addChildUserAction"];
    [webView.configuration.userContentController removeScriptMessageHandlerForName:@"changeChildUserAction"];
    [webView.configuration.userContentController removeScriptMessageHandlerForName:@"unBindPhoneCall"];
}


- (WKWebViewConfiguration *)webViewConfiguration{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    WKUserContentController *userCC = config.userContentController;
    [userCC addScriptMessageHandler:self name:@"addChildUserAction"];
    [userCC addScriptMessageHandler:self name:@"changeChildUserAction"];
    [userCC addScriptMessageHandler:self name:@"unBindPhoneCall"];
    config.userContentController = userCC;
    return config;
}


- (void)setupUI{
    
    self.titleLbl.hidden = YES;
    
    [self addSubview:self.webView];
    
    [self updateFrame];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRotateNewZhongKeViewForSupen:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    AddRecognizeStarGestureRecognizer(self, ^{})
    
    
}


- (WKWebView *)webView{
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0,0, ZKUserViewWidth, windowHeight)configuration:self.webViewConfiguration];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
        _webView.opaque = NO;
        _webView.scrollView.scrollEnabled= NO;
        _webView.scrollView.bounces = YES;
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
        }
        
        
    }
    return _webView;
}


- (BaseButton *)btnChangeSide{
    if (!_btnChangeSide) {
        _btnChangeSide = [BaseButton new];
        _btnChangeSide.backgroundColor = [UIColor clearColor];
        [_btnChangeSide setBackgroundImage:[UIImage imageNamed:@"FYSDK_Resourcres.bundle/turn_left"]  forState:UIControlStateNormal];
    }
    return _btnChangeSide;
}

- (void)btnChangeViewFrame:(UIButton *)sender{
    
    self.btnChangeSide = (BaseButton *)sender;
    if (sender.selected) {//移到左边
        [self.webView evaluateJavaScript:@"postWebviewOritation('0')" completionHandler:nil];
    }else{//在右边
        [self.webView evaluateJavaScript:@"postWebviewOritation('1')" completionHandler:nil];
    }
    
}

- (void)updateFrame{
    UIInterfaceOrientation sataus=[UIApplication sharedApplication].statusBarOrientation;
    if (self.btnChangeSide.selected) {//移到左边
        
        if (sataus == UIInterfaceOrientationPortrait || sataus == UIInterfaceOrientationPortraitUpsideDown) {//竖屏
            self.webView.frame =CGRectMake(0, 0, ZKUserViewWidth, ZKUserViewHeight);
        }else{
            self.webView.frame =CGRectMake(0, 0, ZKUserViewWidth, windowHeight);
            
        }
        
    }else{//在右边
        if (sataus == UIInterfaceOrientationPortrait || sataus == UIInterfaceOrientationPortraitUpsideDown) {//竖屏
            self.webView.frame =CGRectMake(0, 0, ZKUserViewWidth, ZKUserViewHeight);
        }else{
            
            self.webView.frame =CGRectMake(0, 0, ZKUserViewWidth, windowHeight);
        }
        
    }
}



- (void)changeRotateNewZhongKeViewForSupen:(NSNotification *)noti{
    [self changeBtnFrame];
    [self updateFrame];
}



- (void)changeBtnFrame{
    
    self.closeBtn.frame = CGRectMake(windowWidth-120, 40, 100, 40);
    
}

- (void)reloadASDFModel:(WebASDFModel *)model {
    self.model = model;
}

- (void)reloadAtUrl:(NSString*)urlString {
    NSLog(@"urlString--%@",urlString);
    NSURLRequest * requst = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:urlString]];
    [self.webView loadRequest:requst];
    
}

- (void)changeRotateNewZhongkePhoneLoginView:(NSNotification*)noti {
    [self updateFrame];
    
}

#pragma mark - Action
- (void)dismissAction {
    [[NSNotificationCenter defaultCenter] postNotificationName:kSetupBadgeNoticationName object:nil];
    [[COMMONMETHOD getRootViewController].view setUserInteractionEnabled:YES];
    
    if (self.backBlock) {
        self.backBlock();
    }
    [[NewZhongkeWebSuspenView shared] showSuspension];
    [self removeScriptMessage:self.webView];
}

- (void)backAction {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self dismissAction];
    }
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    [self.webView reload];
}
// 加载错误时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    DEBUGMSG(@"webError---%@",error);
}

// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [[COMMONMETHOD getRootViewController] presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    //    DLOG(@"msg = %@ frmae = %@",message,frame);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [[COMMONMETHOD getRootViewController] presentViewController:alertController animated:YES completion:nil];
}

// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    
    [[COMMONMETHOD getRootViewController] presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - WKWebViewDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSLog(@"decidePolicyForNavigationAction");
    if (self.btnChangeSide.selected) {
        [self.webView evaluateJavaScript:@"postWebviewOritation('0')" completionHandler:nil];
    }else{
        [self.webView evaluateJavaScript:@"postWebviewOritation('1')" completionHandler:nil];
    }
    NSURLRequest *req = navigationAction.request;
    NSURL *url = req.URL;
    NSString *urlStr = url.absoluteString;
    if (urlStr.length <= 0) {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    NSString *wUrl = @"weixin://wap/pay";
    NSString *aUrl =  @"alipay://alipayclient";
    if ([urlStr containsString:wUrl] || [urlStr containsString:aUrl]) {
        if ([urlStr containsString:aUrl]) {
            UIButton *btn  = [UIButton new];
            btn.frame = CGRectMake(windowWidth-120, 40, 100, 40);
            btn.backgroundColor = RBGColor(244, 83, 80);
            [btn setTitle:@"关闭" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.layer.cornerRadius = 10;
            btn.layer.masksToBounds = YES;
            [btn addTarget:self action:@selector(goback:) forControlEvents:UIControlEventTouchUpInside];
            [self.webView addSubview:btn];
            self.closeBtn = btn;
        }
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
        
    }else if ([self shouldStartLoadWithRequest:navigationAction.request]) {
        decisionHandler(WKNavigationActionPolicyAllow);
    } else {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}


- (void)goback:(UIButton *)sender{
    if (self.webView.canGoBack) {
        [sender removeFromSuperview];
        sender =nil;
        [self.webView goBack];
    }
    
}

// WKNavigationDelegate 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"didStartProvisionalNavigation");
    if (self.btnChangeSide.selected) {
        [self.webView evaluateJavaScript:@"postWebviewOritation('0')" completionHandler:nil];
    }else{
        [self.webView evaluateJavaScript:@"postWebviewOritation('1')" completionHandler:nil];
    }
}

// 页面加载完成之后调用
- (void) webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {

    if (self.btnChangeSide.selected) {
        [self.webView evaluateJavaScript:@"postWebviewOritation('0')" completionHandler:nil];
    }else{
        [self.webView evaluateJavaScript:@"postWebviewOritation('1')" completionHandler:nil];
    }
}


- (BOOL) shouldStartLoadWithRequest:(NSURLRequest*) request {
    NSString *urlString = [[request URL] absoluteString];
    NSArray *urlComps = [urlString componentsSeparatedByString:@"://"];
    
    NSLog(@"urlString------%@",urlString);
    NSLog(@"urlComps------%@",urlComps);
    
    //修改密码
    if([urlComps count] && [[urlComps objectAtIndex:0] isEqualToString:@"password"]) {
        if ([[urlComps objectAtIndex:1] isValidString]) {
            UserModel *userAccount = [UserDataModel selectUserAccount:[NSUserDefaults takeoutNSUserDefault:LASTLOGINUID]][0];
            DEBUGMSG(@"userAccount = %@",userAccount.userName);
            userAccount.passWord = [urlComps objectAtIndex:1];
            [UserDataModel insertUser:userAccount];
            [self dismissAction];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SDKComPlatform.shared switchAccount];
                [self dismissAction];
                [[NewZhongkeWebSuspenView shared] showSuspension] ;
            });
        } else {
            DEBUGMSG(@"修改过密码失败  ＝ %@",urlComps);
        }
        return NO;
    }
    //游客升级普通用户
    if([urlComps count] && [[urlComps objectAtIndex:0]
                            isEqualToString:@"updateuser"]) {
        NSString * str = [urlComps objectAtIndex:1] ;
        NSArray * array = [str componentsSeparatedByString:@","];
        //查询数据库，并根据uid更新用户表中的游客账号
        UserModel *userAccount = [UserDataModel selectUserAccount:[NSUserDefaults takeoutNSUserDefault:LASTLOGINUID]][0];
        userAccount.userName = array[1];
        userAccount.passWord = array[2];
        userAccount.access_token = array[3];
        userAccount.uid = array[4];
        userAccount.user_type = @"1";
        
        if ([[DataBaseManager sharedInstance]updateUserNameByUid:userAccount.uid changeUserName:userAccount.userName changeToken:userAccount.access_token changepassWord:userAccount.passWord changeusertype:[NSNumber numberWithInt:1]]) {
            //保存登录账号
            [NSUserDefaults reserveNSUserDefault:userAccount.uid field:LASTLOGINUID];
        }
        return NO;
    }
    //绑定手机
    if([urlComps count] && [[urlComps objectAtIndex:0]
                            isEqualToString:@"bindphone"]) {
        UserModel *userAccount = [UserDataModel selectUserAccount:[NSUserDefaults takeoutNSUserDefault:LASTLOGINUID]][0];
        userAccount.phone = [urlComps objectAtIndex:1];
        userAccount.user_type = @"2";
        userAccount.phone = [urlComps objectAtIndex:1];
        if ([userAccount.phone isEqualToString:@""]) {
            COMMONMETHOD.phoneBadgeNum = 0;
        }else {
            COMMONMETHOD.phoneBadgeNum = 1;
        }
        [UserDataModel insertUser:userAccount];
        return NO;
    }
    //绑定身份证
    if([urlComps count] && [[urlComps objectAtIndex:0]
                            isEqualToString:@"bindidcard"]) {
        UserModel *userAccount = [UserDataModel selectUserAccount:[NSUserDefaults takeoutNSUserDefault:LASTLOGINUID]][0];
        userAccount.idCard_bind = [urlComps objectAtIndex:1];
        userAccount.idCard = [urlComps objectAtIndex:1];
        if ([userAccount.idCard isEqualToString:@""]) {
            COMMONMETHOD.cardBadgeNum = 0;
        } else {
            COMMONMETHOD.cardBadgeNum = 1;
        }
        [UserDataModel insertUser:userAccount];
        [[NSNotificationCenter defaultCenter] postNotificationName:kSetupBadgeNoticationName object:nil];
        COMMONMETHOD.switchIDCard = 0;
        return NO;
    }
    //领取礼包
    if([urlComps count] && [[urlComps objectAtIndex:0]
                            isEqualToString:@"giftkey"]) {
        DEBUGMSG(@"[urlComps objectAtIndex:1] = %@",[urlComps objectAtIndex:1]);
        UIAlertView *alert = nil;
        if ([[urlComps objectAtIndex:1] isValidString]) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = [urlComps objectAtIndex:1];
            alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"领取礼包-复制成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
        } else {
            DEBUGMSG(@"领取礼包-复制错误  ＝ %@",urlComps);
            alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"领取礼包-复制失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        }
        
        [alert show];
        return NO;
    }
    //福利消息
    if([urlComps count] && [[urlComps objectAtIndex:0]
                            isEqualToString:@"giftmsgnum"]) {
        DEBUGMSG(@"[urlComps objectAtIndex:1] = %@",[urlComps objectAtIndex:1]);
        COMMONMETHOD.giftBadgeNum = [[urlComps objectAtIndex:1]intValue];
        [[NSNotificationCenter defaultCenter] postNotificationName:kSetupBadgeNoticationName object:nil];
        return NO;
    }
    //联系客服
    if([urlComps count] && [[urlComps objectAtIndex:0]
                            isEqualToString:@"sqphone"]) {
        if ([[urlComps objectAtIndex:1] isValidString]) {
            @autoreleasepool {
                NSArray *cellAry = [[urlComps objectAtIndex:1] componentsSeparatedByString:@"-"];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@%@%@",cellAry[0],cellAry[1],cellAry[2]]];
                [[UIApplication  sharedApplication] openURL:url];
            }
        } else {
            DEBUGMSG(@"联系客服-号码  ＝ %@",urlComps);
        }
        return NO;
    }
    //联系QQ
    if([urlComps count] && [[urlComps objectAtIndex:0] isEqualToString:@"openqq"]) {
        if ([[urlComps objectAtIndex:1] isValidString]) {
            @autoreleasepool {
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqqwpa://"]]) {
                    NSString * qqnumStr = [urlComps objectAtIndex:1];
                    // 提供uin, 你所要联系人的QQ号码
                    NSString * qqStr = [NSString stringWithFormat:@"http://wpa.b.qq.com/cgi/wpa.php?ln=2&uin=%@",qqnumStr];
                    NSURL *url = [NSURL URLWithString:qqStr];
                    [[UIApplication sharedApplication] openURL:url];
                } else {
                    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:nil message:@"未安装QQ" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                }
            }
        } else {
            DEBUGMSG(@"联系公众号  ＝ %@",urlComps);
        }
        return NO;
    }
    
    //官网
    if([urlComps count] && [[urlComps objectAtIndex:0]
                            isEqualToString:@"sendwangz"]) {
        if ([[urlComps objectAtIndex:1] isValidString]) {
            @autoreleasepool {
                UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
                NSString * msg = nil;
                
                pasteboard.string = [urlComps objectAtIndex:1];
                msg = [[NSString alloc]initWithFormat:@"已经复制%@",pasteboard.string];
                
                if (msg) {
                    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                    
                }
            }
        } else {
            DEBUGMSG(@"联系官网  ＝ %@",urlComps);
        }
        return NO;
    }
    
    //切换账号
    if([urlComps count] && [[urlComps objectAtIndex:0]
                            isEqualToString:@"switchaccount"]) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"切换账号提示" message:@"您确定要退出当前帐号吗？" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"暂不",@"确定", nil];
        alertView.delegate = self;
        [alertView show];
        [alertView setTag:20171218];
        return NO;
    }
    
    if([urlComps count] && [[urlComps objectAtIndex:0] isEqualToString:@"unbindphonecall"]) {
        __weak typeof(self)weakSelf = self;
        UserDataController * dc = [[UserDataController alloc]init];
        NSLog(@"unBindPhoneCall----unBindPhoneCall---unBindPhoneCall--unBindPhoneCall");
        //绑定手机
        [dc  getUserInfoByName:COMMONMETHOD.userName andSuccess:^(int code, NSString *msg, id object) {
            NSLog(@"获取用户手机信息----%@",object);
            if (code == 0) {
                [UserDataModel updateUserPhoneBind:COMMONMETHOD.userName phone:object[@"data"][@"phone"]];
                [weakSelf dismissAction];
                [SDKComPlatform.shared clearCache];
                AccountStatus * user = [[AccountStatus alloc] init];
                user.fySDKAccountStatus = _ACCOUNT_STATUS_SWITCHACCOUNT;
                MessageStatus * message = [[MessageStatus alloc] init];
                message.code = 0;
                message.msg =@"切换账号";
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UserCompleteNotification" object:nil userInfo:@{@"AccountStatus":user,@"result":@YES,@"MessageStatus":message}];
                [[NewZhongkeWebSuspenView shared] showSuspension] ;
            }
        } andFailure:^(int code, NSString *msg) {
            
        }];
    }
    
    
    
    //返回按钮
    if([urlComps count] && [[urlComps objectAtIndex:0]
                            isEqualToString:@"webpop"]) {
        [self backAction];
        return NO;
    }
    //关闭按钮
    if([urlComps count] && [[urlComps objectAtIndex:0]
                            isEqualToString:@"webcancel"]) {
        [self dismissAction];
        return NO;
    }
    //消息
    if([urlComps count] && [[urlComps objectAtIndex:0]
                            isEqualToString:@"newmsgnum"]) {
        COMMONMETHOD.msgBadgeNum = [[urlComps objectAtIndex:1] intValue];
        [[NSNotificationCenter defaultCenter] postNotificationName:kSetupBadgeNoticationName object:nil];
        return NO;
    }
    
    if([urlComps count] && [[urlComps objectAtIndex:0]
                            isEqualToString:@"reductionmsgnum"]) {
        COMMONMETHOD.msgBadgeNum = COMMONMETHOD.msgBadgeNum - 1;
        return NO;
    }
    if ([urlComps count] && [[urlComps objectAtIndex:0]
                             isEqualToString:@"close"]) {
        [self dismissAction];
        return NO;
    }
    return YES;
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 20171218 && buttonIndex == 1) {
        [self dismissAction];
        
        [SDKComPlatform.shared clearCache];
        AccountStatus * user = [[AccountStatus alloc] init];
        user.fySDKAccountStatus = _ACCOUNT_STATUS_SWITCHACCOUNT;
        MessageStatus * message = [[MessageStatus alloc] init];
        message.code = 0;
        message.msg =@"切换账号";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserCompleteNotification" object:nil userInfo:@{@"AccountStatus":user,@"result":@YES,@"MessageStatus":message}];
        [[NewZhongkeWebSuspenView shared] showSuspension] ;
    }
}



- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    __weak typeof(self)weakSelf = self;
    UserDataController * dc = [[UserDataController alloc]init];
    if ([message.name isEqualToString:@"addChildUserAction"]){//小号添加
        NSString *childName = message.body;
        //添加小号
        [dc registeredChildUserName:childName andSuccess:^(int code, NSString *msg, id object) {
            //提示成功
            [[RemindView share] show:@"添加成功" time:2.0];
            [self.webView evaluateJavaScript:@"postSmallAccountResigterStastus('0')" completionHandler:nil];
            

            
        } andFailure:^(int code, NSString *msg) {
            NSLog(@"registeredChildUserName---andFailure");
            //提示错误
            [[RemindView share] show:msg time:2.0];
            
        }];
    }else if ([message.name isEqualToString:@"changeChildUserAction"]){//小号切换
        NSString *s_uid = [NSString stringWithFormat:@"%@",message.body];
        [self dismissAction];
        NSLog(@"array.lastObject--%@",s_uid);
        COMMONMETHOD.sub_AccountSwith = YES;
        COMMONMETHOD.sub_uid =s_uid;
        AccountStatus * user = [[AccountStatus alloc] init];
        user.fySDKAccountStatus = _ACCOUNT_STATUS_SWITCHACCOUNT;
        MessageStatus * message = [[MessageStatus alloc] init];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserCompleteNotification" object:nil userInfo:@{@"AccountStatus":user,@"result":@YES,@"MessageStatus":message}];
        
        
    }else if ([message.name isEqualToString:@"unBindPhoneCall"]){//绑定手机
        //绑定手机、解绑手机 都要刷新tokne ，更改数据库 手机信息、然后重新登陆
        [dc  getUserInfoByName:COMMONMETHOD.userName andSuccess:^(int code, NSString *msg, id object) {
            NSLog(@"获取用户手机信息----%@",object);
            [UserDataModel updateUserPhoneBind:COMMONMETHOD.userName phone:object[@"data"][@"phone"]];
            // 刷新token
            requestRefreshTokenModel *model = [[requestRefreshTokenModel alloc]initRequestRefreshTokenModel:COMMONMETHOD.uid sub_uid:COMMONMETHOD.sub_uid refresh_token:COMMONMETHOD.refresh_token];
            [sdkRequestManager startRequestWithModel:model succeedBlock:^(id responseObject) {
                NSLog(@"刷新token----%@",responseObject);
                ResponseModel * model = [ResponseModel modelWithJSON:responseObject];
                if (model.code == 0) {
                    [UserDataModel updateUserAccesstokenByuid:COMMONMETHOD.uid access_token:responseObject[@"data"][@"access_token"] refresh_token:responseObject[@"data"][@"refresh_token"] expires_in:[NSString stringWithFormat:@"%d",[responseObject[@"data"][@"expires_in"] intValue] + [[SDKCommonMethod getTimeStamp] intValue]] refresh_token_expires_in:[NSString stringWithFormat:@"%d",[responseObject[@"data"][@"refresh_token_expires_in"] intValue] + [[SDKCommonMethod getTimeStamp] intValue]]];
                    [weakSelf dismissAction];
                    
                    [SDKComPlatform.shared clearCache];
                    AccountStatus * user = [[AccountStatus alloc] init];
                    user.fySDKAccountStatus = _ACCOUNT_STATUS_SWITCHACCOUNT;
                    MessageStatus * message = [[MessageStatus alloc] init];
                    message.code = 0;
                    message.msg =@"切换账号";
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserCompleteNotification" object:nil userInfo:@{@"AccountStatus":user,@"result":@YES,@"MessageStatus":message}];
                    [[NewZhongkeWebSuspenView shared] showSuspension] ;
                    
                    
                }
            }];
        } andFailure:^(int code, NSString *msg) {
            
        }];
    }
    
}

@end

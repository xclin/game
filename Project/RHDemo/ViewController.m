//
//  ViewController.m
//  RHDemo_H5
//
//  Created by Hunz on 2020/7/8.
//  Copyright © 2020 wuwh. All rights reserved.
//


#import "ViewController.h"
#import "Translate.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <JavaScriptCore/JSContext.h>
#define ISiPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define ISiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define ISiPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define ISiPhone6p ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define ISiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define MAIN_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define MAIN_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
@interface ViewController ()<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic,retain) WKWebView * webView;
@property (nonatomic,strong)UIImageView *imgview;

@end

static NSString *const xychinaGroup = @"com.xy.bundle.group"; //存取钥匙串具体业务的键值

@implementation ViewController

- (void)dealloc{
    NSLog(@"removeScriptMessage");
    [[GameManager shared] removeScriptMessage:self.webView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    //初始化成功回调
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(initCallBack:) name:kInitNotification object:nil];
    //用户登录回调
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginCallBack:) name:kLoginNotification object:nil];

    
    //用户注销回调
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutCallBack:) name:kLogoutNotification object:nil];
    //选服操作回调
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectRoleCallBack:) name:kSendRoleDataNotification object:nil];
    //内购操作回调
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderCallBack:) name:kOrderNotification object:nil];
    
    [[GameManager shared] initSDK];
    [self.view addSubview:self.imgview];
    self.view.backgroundColor = [UIColor blackColor];

    /*
     
     develop 分支修改了
     **/

    
    
    /*
     
     
     
     人才啊
     */


    /*
     
     develop 分支第二次修改了修改了
     **/

    
}

#pragma mark 增加了一个方法
- (void)addfucnk{
    
    [[GameManager shared] loginSDK];
    
}


- (IBAction)loginGameAction:(id)sender {

    [[GameManager shared] loginSDK];
}

- (IBAction)logoutGameAction:(id)sender {
    [[GameManager shared] logoutSDK];
}

- (IBAction)selectRoleAction:(id)sender {
    
    [[GameManager shared] sendRoleDataWithServerId:@"22" serverName:@"一服" roleId:@"11" roleLevel:@"22" roleName:@"吃菜的萝卜" roleType:XY_TYPE_SELECT_Role roleBalance:@"33" rolePower:@"333" other:@"other"];
}

- (IBAction)buyAction:(id)sender {
    
    [[GameManager shared] orderWithOrderNum:@"xy3232420482042042" GoodsId:@"com.xy.hdqq.6" goodsName:@"砖石6元" goodsDec:@"购买获得60钻石" price:@"6" serverId:@"333" serverName:@"一服" roleId:@"33" roleLevel:@"333" roleName:@"霸王龙" gameOther:@"otheaongqtq"];
}



#pragma mark - NSNotification Action
- (void)initCallBack:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    NSString *code = info[@"code"];
    NSString *msg = info[@"msg"];
    [[GameManager shared] loginSDK];
}

- (void)loginCallBack:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    NSString *code = info[@"code"];
    NSString *msg = info[@"msg"];
    
    if ([code intValue] == 0) {//登录成功
        NSDictionary *channelInfo = info[@"data"];
        NSString *s_uid = channelInfo[@"s_uid"];
        NSString *user_Token = channelInfo[@"s_token"];
        NSString *accountName = channelInfo[@"s_accountName"];
        [self loadStart];
        NSLog(@"loginCallBack--code:%@, msg:%@, s_uid:%@, token:%@, accountName:%@", code, msg, s_uid, user_Token, accountName);
    } else {
        NSLog(@"loginCallBack--code:%@,msg:%@", code, msg);
    }
}

//小号切换
- (void)childloginCallBack:(NSNotification *)notification{
    NSDictionary *info = notification.userInfo;
       [self.view addSubview:self.imgview];
    NSLog(@"info---%@",info);
    [self loadStart];
}

- (void)logoutCallBack:(NSNotification *)notification {
      [self.view addSubview:self.imgview];
    [[GameManager shared] loginSDK];
}

- (void)selectRoleCallBack:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    NSString *code = info[@"code"];
    NSString *msg = info[@"msg"];
    
    NSLog(@"selectRoleCallBack--code:%@,msg:%@", code, msg);
}

- (void)orderCallBack:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    NSString *code = info[@"code"];
    NSString *msg = info[@"msg"];
    
    NSLog(@"orderCallBack--code:%@,msg:%@", code, msg);
}

#pragma mark - Private Action
- (void)loadStart {
    _webView = [[GameManager shared] getJSWebView];
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    [self.view addSubview:_webView];
    if (@available(iOS 11.0, *)) {
        _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [[GameManager shared] loadRequest:_webView];
}

- (UIImageView *)imgview{
    if (!_imgview) {
        _imgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT)];
        [_imgview setImage:[self getBackgroundViewImage]];
        
    }
    return _imgview;
}

- (UIImage *)getBackgroundViewImage{
    NSString *name;
    if (ISiPhone4) {
        name = @"4s";
    }else if (ISiPhone5){
        name = @"5s";
    }else if (ISiPhoneX){
        name = @"iPhonex";
    }else if (ISiPhone6p){
        name = @"7p";
    }else if (ISiPhone6){
        name = @"6s";
    }else{
        name = @"ipad";
    }
    UIImage *image = [UIImage imageNamed:@"720x1280"];
    return image;
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {

}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.imgview removeFromSuperview];
    self.imgview = nil;
}

//提交发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
}

@end

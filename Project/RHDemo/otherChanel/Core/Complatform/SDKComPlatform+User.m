
#import "SDKComPlatform+User.h"
#import "SDKCommonMethod.h"
#import "SDKUserAccountModel.h"
#import "DataBaseManager.h"
#import "RequestUtil.h"
#import "BaseModel.h"
#import "SDKComPlatform.h"
#import "UserDataModel.h"
#import "sdkRequestManager.h"
#import "RecordViewPath.h"
#import "sdkInitModel.h"
#import "ZhongkeUserViewController.h"
#import "LoginH5SDKWebView.h"

@implementation SDKComPlatform (User)

- (BOOL)isLogined {
    
    return [NSUserDefaults takeoutNSUserDefault:ISLOGIN] ?YES:NO;
}

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

- (void)loginSDK{
    if ([sdkInitModel share].h5sdk_urltr.length > 0) {

       WKWebView * webView = [[LoginH5SDKWebView shared] getJSWebView];
        [[COMMONMETHOD getRootViewController].view addSubview:webView];
        [[LoginH5SDKWebView shared] loadRequest:webView];
    }else if ([sdkInitModel share].maintain.count > 0 || [sdkInitModel share].beforelogin.count > 0) {//弹出公告
        ZhongkeUserViewController * vc = [[ZhongkeUserViewController alloc]init];
        [[COMMONMETHOD getRootViewController] addChildViewController:vc];
        [[COMMONMETHOD getRootViewController].view addSubview:vc.view];
        [vc setupUI];
        [vc setupzhongkeNoticeView];
    }else if(COMMONMETHOD.bannedORplayout){
        ZhongkeUserViewController * vc = [[ZhongkeUserViewController alloc]init];
        [[COMMONMETHOD getRootViewController] addChildViewController:vc];
        [[COMMONMETHOD getRootViewController].view addSubview:vc.view];
        [vc setupUI];
        [vc setupplayTimeLimitView:[[NSUserDefaults standardUserDefaults] valueForKey:@"pushMessage"]];
    
    } else if (COMMONMETHOD.sub_AccountSwith) {//小号切换
        UserDataController * dc = [[UserDataController alloc]init];
        NSLog(@"loginSDK--COMMONMETHOD.sub_uid--%@",COMMONMETHOD.sub_uid);
        [dc loginChangeChild:COMMONMETHOD.access_token andsub_uid:COMMONMETHOD.sub_uid andSuccess:^(int code, NSString *msg, id object) {
            
        } andFailure:^(int code, NSString *msg) {
            
        }];
        COMMONMETHOD.sub_AccountSwith = NO;
    }else{//登陆
        [COMMONMETHOD setRootViewControllerWithViewController:[COMMONMETHOD getCurrentRootViewController]];
        BOOL updateGameWithURL =[[NSUserDefaults standardUserDefaults] boolForKey:@"updateGameWithURL"];
        if (updateGameWithURL) { //强制更新
            ZhongkeUserViewController * vc = [[ZhongkeUserViewController alloc]init];
            [[COMMONMETHOD getRootViewController] addChildViewController:vc];
            [[COMMONMETHOD getRootViewController].view addSubview:vc.view];
            [vc setupUI];
            [vc setupgameVersionAlertView];
        }else{
            //已经弹出
            if (COMMONMETHOD.recordShowSDK == 1) {
                return;
            }
            COMMONMETHOD.recordShowSDK = 1;
            //悬浮窗关闭时
            if ([[NSUserDefaults takeoutNSUserDefault:HIDESUSPENSION] intValue] == 1) {
                //开启记录界面轨迹记录
                [RecordViewPath share].isTurnOn = YES;
                [[RecordViewPath share] startCountDownFromTime:[sdkInitModel share].behavior_time];
            }
            
            if ([NSUserDefaults takeoutNSUserDefault:LASTLOGINUID]) {
                
                NSArray *array = [UserDataModel selectUserAccount:[NSUserDefaults takeoutNSUserDefault:LASTLOGINUID]];
                if (array.count>0) {
                    ZhongkeUserViewController * vc = [[ZhongkeUserViewController alloc]init];
                    [[COMMONMETHOD getRootViewController] addChildViewController:vc];
                    [[COMMONMETHOD getRootViewController].view addSubview:vc.view];
                    [vc setupUI];
                    [vc setupneewZhongKeHistoryAccountView];
                }else{
                    ZhongkeUserViewController * vc = [[ZhongkeUserViewController alloc]init];
                    [[COMMONMETHOD getRootViewController] addChildViewController:vc];
                    [[COMMONMETHOD getRootViewController].view addSubview:vc.view];
                    [vc setupUI];
                    [vc setUpnewZhongkePhoneLoginView];
                }
            }else {
                ZhongkeUserViewController * vc = [[ZhongkeUserViewController alloc]init];
                [[COMMONMETHOD getRootViewController] addChildViewController:vc];
                [[COMMONMETHOD getRootViewController].view addSubview:vc.view];
                [vc setupUI];
                [vc setUpnewZhongkePhoneLoginView];
            }
        }
    }
}


- (void)logout{
    [SDKComPlatform.shared clearCache];
    AccountStatus * user = [[AccountStatus alloc] init];
    user.fySDKAccountStatus = _ACCOUNT_STATUS_LOGOUT;
    MessageStatus * message = [[MessageStatus alloc] init];
    message.code = 0;
    message.msg =@"注销";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserCompleteNotification" object:nil userInfo:@{@"AccountStatus":user,@"result":@YES,@"MessageStatus":message}];
    
}

- (void) switchAccount {
    [SDKComPlatform.shared clearCache];
    AccountStatus * user = [[AccountStatus alloc] init];
    user.fySDKAccountStatus = _ACCOUNT_STATUS_SWITCHACCOUNT;
    MessageStatus * message = [[MessageStatus alloc] init];
    message.code = 0;
    message.msg =@"切换账号";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserCompleteNotification" object:nil userInfo:@{@"AccountStatus":user,@"result":@YES,@"MessageStatus":message}];
    
}

- (NSString*) sub_uid {
    NSString * string = nil;
    if (self.isLogined) {
        string = COMMONMETHOD.sub_uid;
    }else {
        string = @"没有登录";
    }
    return string;
}

- (NSString*) access_code {
    NSString * string = nil;
    if (self.isLogined) {
        string = COMMONMETHOD.access_code;
    }else {
        string = @"没有登录";
    }
    return string;
}
@end

@implementation AccountStatus
#define StatusFunction(name,value) - (BOOL)name {if (self.fySDKAccountStatus == value) { return YES;}return NO;}
StatusFunction(isStatusLogout, _ACCOUNT_STATUS_LOGOUT)
StatusFunction(isStatusSwitchAccount, _ACCOUNT_STATUS_SWITCHACCOUNT)
StatusFunction(isStatusLoginSucceed, _ACCOUNT_STATUS_LOGINSUCCEED)

@end


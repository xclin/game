
#import "EventsListener.h"
#import "NotificationList.h"
#import "ApiGame.h"
#import "sdkInitConfiger.h"
#import "sdkLoginConfiger.h"
#import "GameSDK.h"
#import "NSMutableDictionary+ValueNonnull.h"
#import "sdkRoleConfiter.h"


@implementation EventsListener

static EventsListener *eventsListener = nil;
+ (instancetype)shared {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (eventsListener == nil) {
            eventsListener = [[self alloc]init];
        }
    });
    return eventsListener;
}


- (void)startListen {
    //初始化成功回调
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(initCallBack:) name:@"InitSDKSuccessNotification" object:nil];
    //用户操作回调
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userActionCallBack:) name:@"UserCompleteNotification" object:nil];
    //选服操作回调
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectRoleCallBack:) name:@"RoleServerNotification" object:nil];
    //内购操作回调
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderCallBack:) name:@"ProductPayNotification" object:nil];
}


#pragma mark - Notification Action
- (void)initCallBack:(NSNotification *)notification {

    [ApiGame initXYWithSucc:^(NSDictionary * _Nonnull res) {
        //回调给游戏
        [self callBackToGameWithNotiName:kInitNotification info:[self callBackParamsWithMsg:@"激活成功" code:@"0" data:nil]];
    } failure:^(NSString * _Nonnull errMsg) {
        [self callBackToGameWithNotiName:kInitNotification info:[self callBackParamsWithMsg:errMsg code:@"-1" data:nil]];
    }];
    
    
}


- (void)userActionCallBack:(NSNotification *)notification {
    NSDictionary * dic  = notification.userInfo;
    BOOL result = [[dic objectForKey:@"result"]boolValue];
    AccountStatus * account  = dic[@"AccountStatus"];
    //拼接channel，渠道返回的参数
    NSMutableDictionary *channel_resultDic = [NSMutableDictionary new];
    [channel_resultDic setSafeValue:GameSDK.access_code forKey:@"access_code"];//
    [channel_resultDic setSafeValue:[[sdkInitConfiger share] getHapiGid] forKey:@"gid"];//
    [channel_resultDic setSafeValue:GameSDK.sub_uid forKey:@"sub_uid"];//
    [channel_resultDic setSafeValue:@"1" forKey:@"platform"];//
    NSLog(@"channel_resultDic---%@",channel_resultDic);
    NSString * channel_result = @"";
    if (channel_resultDic) {
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:channel_resultDic options:0 error:nil];
        channel_result  = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    //渠道SDK返回，不同渠道，取值不同
    [sdkLoginConfiger share].channel_result = channel_result;
    [sdkLoginConfiger share].account = GameSDK.sub_uid;
    if (result) {
        if ([account isStatusLoginSucceed]) {
            [ApiGame loginXYWithSucc:^(NSDictionary * _Nonnull res) {
                NSLog(@"loginsucc-%@", res);
                NSMutableDictionary *SDKresultDic = [NSMutableDictionary new];
                [SDKresultDic setSafeValue:res[@"s_uid"] forKey:@"s_uid"];
                [SDKresultDic setSafeValue:res[@"s_token"] forKey:@"s_token"];
                [SDKresultDic setSafeValue:res[@"c_uid"] forKey:@"s_accountName"];
                [sdkLoginConfiger share].c_uid =res[@"c_uid"];
                [self callBackToGameWithNotiName:kLoginNotification info:[self callBackParamsWithMsg:@"登录成功" code:@"0" data:SDKresultDic]];
            } failure:^(NSString * _Nonnull errMsg) {
                NSLog(@"loginfail:%@", errMsg);
                [self callBackToGameWithNotiName:kLoginNotification info:[self callBackParamsWithMsg:errMsg code:@"-1" data:nil]];
            }];
        } else if ([account isStatusLogout]) {
            [self callBackToGameWithNotiName:kLogoutNotification info:[self callBackParamsWithMsg:@"注销" code:@"0" data:nil]];
    
        }else if ([account isStatusSwitchAccount]){
            
             [self callBackToGameWithNotiName:kLogoutNotification info:[self callBackParamsWithMsg:@"注销" code:@"0" data:nil]];
        }
    }
}


//选服
- (void)selectRoleCallBack:(NSNotification *)notification {
    [ApiGame selectRoleWithServerId:^(NSDictionary * _Nonnull res) {
        NSLog(@"selectRolesucc-%@", res);
        [self callBackToGameWithNotiName:kSendRoleDataNotification info:[self callBackParamsWithMsg:@"选服成功" code:@"0" data:@{@"type": @([sdkRoleConfiter share].roleType)}]];
    } failure:^(NSString * _Nonnull errMsg) {
        NSLog(@"selectRolefail-%@", errMsg);
        [self callBackToGameWithNotiName:kSendRoleDataNotification info:[self callBackParamsWithMsg:errMsg code:@"-1" data:@{@"type": @([sdkRoleConfiter share].roleType)}]];
    }];
}

- (void)orderCallBack:(NSNotification *)notification {
    [self callBackToGameWithNotiName:kOrderNotification info:[self callBackParamsWithMsg:@"购买" code:@"0" data:nil]];
}

/// 回调给游戏
/// @param notiName 通知名称
/// @param info 信息
- (void)callBackToGameWithNotiName:(NSString *)notiName info:(NSDictionary *)info {
    [[NSNotificationCenter defaultCenter] postNotificationName:notiName object:nil userInfo:info];
}

- (NSMutableDictionary *)callBackParamsWithMsg:(NSString *)msg code:(NSString *)code data:(NSDictionary *)data {
    NSMutableDictionary *muDict = [[NSMutableDictionary alloc] init];
    [muDict setSafeValue:msg forKey:@"msg"];
    [muDict setSafeValue:code forKey:@"code"];
    if (data) {
        [muDict setSafeValue:data forKey:@"data"];
    }
    return muDict;
}

@end

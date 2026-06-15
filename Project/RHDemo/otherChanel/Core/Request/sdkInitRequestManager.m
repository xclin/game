
#import "sdkInitRequestManager.h"
#import "SDKCommonMethod.h"
#import "SDKComPlatform.h"
#import "zhongkeIAPManager.h"
#import "StopWatch.h"
#import "sdkInitModel.h"
#import "RecordViewPath.h"

#define MAX_REQUEST_COUNT 3
@implementation sdkInitRequestManager  {
    StopWatch * watch;
}
- (instancetype) initWithHandler:(initFinishBlock) succeed {
    self = [super init];
    if (self) {
        self.finishHandler = succeed;
        watch = [[StopWatch alloc] initWithName:@"初始化时间"];
        setTimeDown(@"0");   //初始化验证码倒计时
    }
    return self;
}

- (void) initSDKRequest {
    [watch reset];
    
    CGFloat  runTime = [[NSDate date] timeIntervalSince1970]*1000000;
    
    COMMONMETHOD.behavior_id = [NSString stringWithFormat:@"%.f",runTime];
    
    [self initStartRequest];
}


//新激活接口
-(void) initStartRequest {
    requestInitModel *model = [[requestInitModel alloc]initSDK:@"" withJsonData:@""];
    __weak typeof(self) weakSelf = self;
    [sdkInitRequestManager startRequestWithModel:model succeedBlock:^(id responseObject) {
        NSString *finishCode = @"";
        if (responseObject[@"code"] && [responseObject[@"code"] intValue] == 0) {
            NSLog(@"responseObject---激活返回%@",responseObject);
            [sdkInitModel share].cs_qq = responseObject[@"data"][@"cs"][@"cs_qq"];
            [sdkInitModel share].cs_contact = responseObject[@"data"][@"cs"][@"cs_contact"];
            [sdkInitModel share].cs_qq_group =responseObject[@"data"][@"cs"][@"cs_qq_group"];
            [sdkInitModel share].cs_qq_url = responseObject[@"data"][@"cs"][@"cs_qq_url"];
            [sdkInitModel share].enable_sandbox = [responseObject[@"data"][@"enable_sandbox"]boolValue] ;
            [sdkInitModel share].enable_third_part_pay = [responseObject[@"data"][@"enable_third_part_pay"] boolValue];
            [sdkInitModel share].package_url = responseObject[@"data"][@"package_url"];
            [sdkInitModel share].pay_status = [responseObject[@"data"][@"pay_status"] intValue];
            [sdkInitModel share].status = responseObject[@"data"];
            [sdkInitModel share].version = responseObject[@"data"];
            [sdkInitModel share].anti = responseObject[@"data"][@"sdk_links"][@"anti"];
            [sdkInitModel share].domain = responseObject[@"data"][@"sdk_links"][@"domain"];
            [sdkInitModel share].link1 = responseObject[@"data"][@"sdk_links"][@"link1"];
            [sdkInitModel share].link2 = responseObject[@"data"][@"sdk_links"][@"link2"];
            [sdkInitModel share].link3 = responseObject[@"data"][@"sdk_links"][@"link3"];
            [sdkInitModel share].link4 = responseObject[@"data"][@"sdk_links"][@"link4"];
            [sdkInitModel share].link5 = responseObject[@"data"][@"sdk_links"][@"link5"];
            [sdkInitModel share].user = responseObject[@"data"][@"sdk_links"][@"user"];
            [sdkInitModel share].privacy = responseObject[@"data"][@"sdk_links"][@"privacy"];
            [sdkInitModel share].userPrivacy = responseObject[@"data"][@"sdk_links"][@"user"];
            [sdkInitModel share].beforelogin =responseObject[@"data"][@"beforelogin"];
            [sdkInitModel share].maintain =responseObject[@"data"][@"maintain"];
            [sdkInitModel share].h5sdk_urltr = responseObject[@"data"][@"game_platform"][@"game_url"];
            NSMutableArray *linkArray = [NSMutableArray new];
            for (int i = 1; i< 6; i++) {
                 NSMutableDictionary *linkDic= [NSMutableDictionary new];
                if ( i== 1) {
                    [linkDic setValue:[sdkInitModel share].link1 forKey:@"link"];
                    [linkDic setValue:@"账号" forKey:@"title"];
                    [linkDic setValue:[NSString stringWithFormat:@"new_more"] forKey:@"image"];
                }else if ( i== 2){
                    [linkDic setValue:[sdkInitModel share].link2 forKey:@"link"];
                    [linkDic setValue:@"消息" forKey:@"title"];
                    [linkDic setValue:[NSString stringWithFormat:@"new_msg"] forKey:@"image"];
                }else if ( i== 3){
                    [linkDic setValue:[sdkInitModel share].link3 forKey:@"link"];
                    [linkDic setValue:@"福利" forKey:@"title"];
                    [linkDic setValue:[NSString stringWithFormat:@"new_gift"] forKey:@"image"];
                }else if ( i== 4){
                    [linkDic setValue:[sdkInitModel share].link4 forKey:@"link"];
                    [linkDic setValue:@"客服" forKey:@"title"];
                    [linkDic setValue:[NSString stringWithFormat:@"new_kf"] forKey:@"image"];
                }else if ( i== 5){
                        [linkDic setValue:[sdkInitModel share].link5 forKey:@"link"];
                        [linkDic setValue:@"充值" forKey:@"title"];
                        [linkDic setValue:[NSString stringWithFormat:@"new_purchase"] forKey:@"image"];
                }
                [linkArray addObject:linkDic];
            }
            
            [NSUserDefaults reserveNSUserDefault:[NSKeyedArchiver archivedDataWithRootObject:linkArray] field:suspensionview];
             finishCode= @"0";
        }else{
            finishCode= @"-1";
        }
        [weakSelf finishInitialization:finishCode];
        
    }
     
     ];
}



- (void) finishInitialization :(NSString *)codeStr{
    if (self.finishHandler) {
        self.finishHandler(codeStr);
    }
    if ([codeStr isEqualToString:@"0"]) {
        //清除缓存，特别是登录的状态
         [SDKComPlatform.shared clearCache];
         [[zhongkeIAPManager sharedIAPDManager] restoredIAP];
         //一定要在初始化完成后才会发送通知，不然登录的状态会混乱
         [[NSNotificationCenter defaultCenter] postNotificationName:@"InitSDKSuccessNotification" object:nil];
    }
 
    [watch stop];
}
@end

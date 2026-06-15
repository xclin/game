#import "ApiGame.h"
#import "RequestUtils.h"
#import "sdkInitConfiger.h"
#import "DeviceUtils.h"
#import "UrlList.h"
#import "sdkLoginConfiger.h"
#import "NSMutableDictionary+ValueNonnull.h"
#import "sdkRoleConfiter.h"
@implementation ApiGame

+ (void)initXYWithSucc:(SuccBlock)succ failure:(FailureBlock)failure {//NModel_Base NModel_Init
    NSMutableDictionary * postParams = [self returnPublicParams ];
    [postParams setSafeValue:@"active" forKey:@"action"];
    [postParams setSafeValue:[sdkInitConfiger share].app_key forKey:@"app_key"];
    [postParams setSafeValue:[sdkInitConfiger share].privateKey forKey:@"privatekey"];
    [postParams setSafeValue:@"2" forKey:@"menuver"];
    //需要返回激活的参数
    NSString *url = [NSString stringWithFormat:@"%@://%@%@", kProtocol,kDomain, kUriInit];
    NSLog(@"聚合激活请求url--%@",url);
    NSLog(@"聚合激活请求参数--%@",postParams);
    [RequestUtils postWithUrl:url parms:postParams timeout:10 succeed:^(NSDictionary * _Nonnull responseObject) {
        NSLog(@"聚合激活返回--%@",responseObject);
        if ([responseObject[@"code"] intValue] == 0) {
            if (responseObject[@"ver"]) {
                [sdkInitConfiger share].deviceNo= responseObject[@"deviceno"];
            }
        }
        succ(responseObject);
    } failure:^(NSString * _Nonnull errMsg) {
        failure(errMsg);
    }];
}


+ (void)loginXYWithSucc:(SuccBlock)succ failure:(FailureBlock)failure { // NModel_Base NModel_Login
    NSMutableDictionary * postParams = [self returnPublicParams ];
    [postParams setSafeValue:[sdkInitConfiger share].app_key forKey:@"app_key"];
    [postParams setSafeValue:[sdkLoginConfiger share].s_uid forKey:@"s_uid"];
    [postParams setSafeValue:@"0" forKey:@"is_newuser"];
    NSString *url = [NSString stringWithFormat:@"%@://%@%@", kProtocol,kDomain, kUriLogin];
    NSLog(@"聚合登录url--%@",url);
    NSLog(@"聚合登录postParams--%@",postParams);
    [RequestUtils postWithUrl:url parms:postParams timeout:10 succeed:^(NSDictionary * _Nonnull responseObject) {
        int code = [responseObject[@"code"] intValue];
        if (code == 0) {
            [sdkLoginConfiger share].s_token =responseObject[@"s_token"];
            [sdkLoginConfiger share].ptype = [NSString stringWithFormat:@"%@",responseObject[@"ptype"]];
            [sdkLoginConfiger share].s_uid =responseObject[@"s_uid"];
            succ(responseObject);
        }else{
            failure(responseObject[@"msg"]);
        }
    } failure:^(NSString * _Nonnull errMsg) {
        failure(errMsg);
    }];
}



+ (void)selectRoleWithServerId:(SuccBlock)succ failure:(FailureBlock)failure{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"sName":[sdkRoleConfiter share].sName,@"servernum":[sdkRoleConfiter share].sId,@"roleLevel":[sdkRoleConfiter share].roleLevel,@"rolename": [sdkRoleConfiter share].roleName,@"roleId":[sdkRoleConfiter share].roleId,@"countStr": [sdkRoleConfiter share].balance,@"otherString": [sdkRoleConfiter share].other,@"roleType":@([sdkRoleConfiter share].roleType),@"power":[sdkRoleConfiter share].power} options:0 error:nil];
    NSString *roleString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSMutableDictionary * postParams =[self returnPublicParams ];
    [postParams setSafeValue:[sdkLoginConfiger share].s_uid forKey:@"s_uid"];
    [postParams setSafeValue:[sdkInitConfiger share].app_key forKey:@"app_key"];
    [postParams setSafeValue:@"send_role" forKey:@"action"];
    [postParams setSafeValue:[sdkLoginConfiger share].user_Token forKey:@"token"];
    [postParams setSafeValue:[sdkInitConfiger share].deviceNo forKey:@"deviceno"];
    [postParams setSafeValue:roleString forKey:@"roleData"];
    NSString *url = [NSString stringWithFormat:@"%@://%@%@", kProtocol,kDomain, kUriSlectRole];
    [RequestUtils postWithUrl:url parms:postParams timeout:10 succeed:^(NSDictionary * _Nonnull responseObject) {
        succ(responseObject);
        NSLog(@"responseObject--%@",responseObject);
    } failure:^(NSString * _Nonnull errMsg) {
        failure(errMsg);
        NSLog(@"errMsg--%@",errMsg);
    }];
}


/// 公共请求参数
+ (NSMutableDictionary *)returnPublicParams{
    NSMutableDictionary *postParams = [NSMutableDictionary new];
    [postParams setSafeValue:[sdkInitConfiger share].cid forKey:@"cid"];
    [postParams setSafeValue:@"1.0.0" forKey:@"cver"];
    [postParams setSafeValue:[sdkInitConfiger share].ctype forKey:@"ctype"];
    [postParams setSafeValue:[sdkLoginConfiger share].channel_result forKey:@"channel_result"];
    [postParams setSafeValue:[DeviceUtils deviceIdfv] forKey:@"equipmentidfv"];
    [postParams setSafeValue:[DeviceUtils devicetoken]  forKey:@"devicetoken"];
    [postParams setSafeValue:[DeviceUtils idfa] forKey:@"equipmentid"];
    [postParams setSafeValue:[sdkInitConfiger share].gid forKey:@"gid"];
    [postParams setSafeValue:[DeviceUtils jsondata] forKey:@"jsondata"];
//    [postParams setSafeValue:[sdkInitConfiger share].cps_id forKey:@"cps_id"];
//    [postParams setSafeValue:[sdkInitConfiger share].aid forKey:@"aid"];
     [postParams setSafeValue:[sdkInitConfiger share].type forKey:@"type"];
    return postParams;
}

@end

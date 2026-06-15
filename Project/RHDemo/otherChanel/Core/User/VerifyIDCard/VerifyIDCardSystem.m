//
//  VerifyIDCardSystem.m
//  FYAppStoreDemo
//
//  Created by 凡跃 on 2018/6/5.
//  Copyright © 2018年 fanyue. All rights reserved.
//

#import "VerifyIDCardSystem.h"
#import "VerifyIDCardView.h"
#import "BaseModel.h"
#import "sdkRequestManager.h"
#import "RequestUtil.h"
#import "UserDataModel.h"
#import "NSMutableURLRequest+Model.h"
#import "IAPListRequest.h"
#import "DataBaseManager.h"
#import "ZhongkeUserViewController.h"
@interface VerifyIDCardSystem()
/**
 实名认证是否开启
 */
@property (nonatomic,assign) BOOL isVerifySwitchOpen;
@end

@implementation VerifyIDCardSystem

LQSingletonInstanceMMethod(VerifyIDCardSystem, ^{})

- (NSString*) currentUserName {
    NSArray * array = [[NSArray alloc]initWithArray:[UserDataModel selectUserAccount:[NSUserDefaults takeoutNSUserDefault:LASTLOGINUID]]];
    if (array.count > 0) {
        UserModel * accountModel = array[0];
        return accountModel.uid;
    } else {
        return @"";
    }
}
- (NSString*) currentCertificationKey {
    return [NSString stringWithFormat:@"certificationnTimeFor%@",[self currentUserName]];
}
- (BOOL) shouldShowCertificationView {
    return [[NSUserDefaults takeoutNSUserDefault:[self currentCertificationKey]] integerValue] < 2;
}

- (void) getVerifySwitchWithBlock:(FYSDKBoolBlock)complete {
    if (self.isVerifySwitchOpen) {
        if (complete)complete(YES);
        return;
    }

}



- (void) getCertificationComplete:(FYSDKBoolBlock)complete {

}

- (void)certificateWithRealName:(NSString*) realName IDNum:(NSString*) idNum complete:(FYSDKCertificationBlock) complete {
    NSString *userName = [self currentUserName];
    if (userName.length > 0) {
        requestReportidentitycardModel *model = [[requestReportidentitycardModel alloc]initRequestReportidentitycardModel:realName identity_card_no:idNum];
        [sdkRequestManager startRequestWithModel:model succeedBlock:^(id responceObject) {
            NSLog(@"responceObject实名认证--%@",responceObject);
            if ([responceObject[@"code"] integerValue] == 0) {
                
                [SDKCommonMethod shared].verify_after_login = [NSString stringWithFormat:@"%@",responceObject[@"data"][@"verify_before_pay"]];
                [SDKCommonMethod shared].verify_before_pay =[NSString stringWithFormat:@"%@",responceObject[@"data"][@"verify_before_pay"]];

                [[RemindView share] show:responceObject[@"msg"] time:2.0];
                if (complete)complete(YES,responceObject[@"msg"]);
                
                //更新
                [UserDataModel updateUserVerifyByUid:COMMONMETHOD.uid verify_after_login:[SDKCommonMethod shared].verify_after_login verify_before_pay:[SDKCommonMethod shared].verify_before_pay];
//                [sdkInitModel share].monthly_recharge_sum=[responceObject[@"data"][@"monthly_recharge_sum"] intValue];
//                [sdkInitModel share].each = [responceObject[@"data"][@"recharge_limit"][@"each"] intValue];
//                [sdkInitModel share].monthly=[responceObject[@"data"][@"recharge_limit"][@"monthly"]intValue];
//                NSMutableDictionary *RechargeDic = [NSMutableDictionary new];
//                [RechargeDic setValue:[SDKCommonMethod shared].c_uid forKey:@"uid"];
//                [RechargeDic setValue:[NSString stringWithFormat:@"%d",[sdkInitModel share].each] forKey:@"each"];
//                [RechargeDic setValue:[NSString stringWithFormat:@"%d",[sdkInitModel share].monthly] forKey:@"monthly"];
//                [RechargeDic setValue:[SDKCommonMethod shared].mouth_Rechare forKey:@"mouth"];
//                [RechargeDic setValue:[NSString stringWithFormat:@"%d",[sdkInitModel share].monthly_recharge_sum] forKey:@"monthly_recharge_sum"];
//                [[DataBaseManager sharedInstance] insertUserRecharge:RechargeDic];
            } else {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    NSString * string = [NSString stringWithFormat:@"%@",responceObject[@"msg"]];
                    [[RemindView share] show:string time:2.0];
                });
                if (complete)complete(NO,responceObject[@"msg"]);
                
            }
        }];
    } else {
        DEBUGMSG(@"没有用户");
        if (complete)complete(NO,@"请登录");
    }
}
- (void) showCertificationView {
    ZhongkeUserViewController * vc = [[ZhongkeUserViewController alloc]init];

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:vc.view];

    [vc setupUI];
    [vc setUpneewZhongkeCertificationView];
}

- (void) showCertificationViewIfNeeded{
    
    NSLog(@"---%@",[SDKCommonMethod shared].verify_after_login);
    if ([[SDKCommonMethod shared].verify_after_login isEqualToString:@"1"]) {//需要
        [[VerifyIDCardSystem shared] showCertificationView];
    }else{// 不需要实名认证  然后判断是否强梗
        int LocalVersion = [[INITCONFIGURE.version stringByReplacingOccurrencesOfString:@"." withString:@""] intValue];
        int Last_Version = [[INITCONFIGURE.last_version stringByReplacingOccurrencesOfString:@"." withString:@""] intValue];
        if (Last_Version > LocalVersion) {
            ZhongkeUserViewController * vc = [[ZhongkeUserViewController alloc]init];
            [[COMMONMETHOD getRootViewController] addChildViewController:vc];
            [[COMMONMETHOD getRootViewController].view addSubview:vc.view];
            [vc setupUI];
            [vc setupgameVersionAlertView];
        }else{//弹出登录之后的公告
            if ([sdkInitModel share].afterlogin.count > 0) {//弹出登录后的公告
                ZhongkeUserViewController * vc = [[ZhongkeUserViewController alloc]init];
                [[COMMONMETHOD getRootViewController] addChildViewController:vc];
                [[COMMONMETHOD getRootViewController].view addSubview:vc.view];
                [vc setupUI];
                [vc setupzhongkeNoticeView];
            }
        }
    }
}


@end

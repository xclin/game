

#import "UserDataController.h"
#import "DataBaseManager.h"
#import "SDKCommonMethod.h"
#import "LoginOperation.h"
#import "SDKUserAccountModel.h"
#import "xysdkKeyChain.h"
#import "VertificationCodeModel.h"
#import "SuspensionView.h"
#import "RequestUtil.h"
#import "UserDataModel.h"
#import "MessagePopView.h"
#import "NSString+category.h"
#import "UIImage+Category.h"
#import "StopWatch.h"
#import<AssetsLibrary/AssetsLibrary.h>
#import "SaveScreenView.h"
#import "VerifyIDCardView.h"
#import "requestRunLoopAcctokenReFresh.h"
#import "NewZhongkeWebSuspenView.h"
#import "scoketManager.h"
#import "SDKPusherManager.h"
#import "ZhongkeUserViewController.h"

@interface UserDataController ()<UIAlertViewDelegate>
@property (nonatomic,copy) NSString * userName;
@property (nonatomic,copy) NSString * passWord;
@property (nonatomic,copy) NSString * sub_uid;
@property (nonatomic,copy) NSString * access_token;
@property (nonatomic,copy) NSString * uid;
@property (nonatomic,copy) NSString * phone;
@property (nonatomic,copy) NSString * verificationCode;
@property (nonatomic,copy) SuccessBlcok sBlock;
@property (nonatomic,copy) FailureBlcok fBlock;
@end

@implementation UserDataController

- (instancetype)init {
    self = [super init];
    if (self) {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(pusherScoketResult:)
                                                     name:@"pusherScoket"
                                                   object:nil];
    }
    return self;
}
- (NSMutableArray *)getAllAccounds {
    NSMutableArray * array = [[UserDataModel selectUserAccount:@""] mutableCopy];
    NSLog(@"array--%@",array);
    return array;
}



- (void)getPhoneCode:(NSString *)pString
          andSuccess:(SuccessBlcok)successBlock
          andFailure:(FailureBlcok)failureBlcok {
    if (successBlock) {
        self.sBlock = successBlock;
    }
    if (failureBlcok) {
        self.fBlock = failureBlcok;
    }
    self.phone = pString;
    self.userName = pString;  //手机登录的时候，手机号码为用户名
    
    if (![pString isValidString]) {
        _fBlock(-1,@"手机号码不能为空");
        return;
    } else
        if (![pString isValidMobile]) {
            _fBlock(-1,@"请输入有效的手机号码");
            return;
        }
    [AIVIEW show];
    [self startGetPhoneCode];
}


/**
 *  保存首次登录界面，随机账号和密码截图
 *
 *  @param userName 游客账号
 *  @param passWork 游客密码
 */
- (void)saveScreenshotWithUserName:(NSString*)userName andPassWork:(NSString*)passWork {
    
    //相册权限
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied){
        //无权限 引导去开启
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"账号密码保存相册权限受限！" message:@"请授权本App可以访问相册\n设置方式:手机设置->隐私->照片\n允许本App访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        alert.tag = 100;
        [alert show];
        
        return;
    }
    
    UIView * screenshotView = [[UIView alloc]init];
    [screenshotView setBackgroundColor:[UIColor whiteColor]];
    [screenshotView setFrame:CGRectMake(0, 0, 380, 320)];
    
    COMMONMETHOD.userName = userName;
    COMMONMETHOD.password = passWork;
    
    SaveScreenView *aview = [[SaveScreenView alloc] init];
    [screenshotView addSubview:aview];
    
    UIImage * image = [UIImage imageFromView:screenshotView];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil;
    if(error != NULL){
        msg = @"保存图片失败";
    } else {
        msg = @"账号密码已保存至相册";
        [[RemindView share] show:msg time:2.0];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 100) {
        
        if (buttonIndex == 1) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        [[NewZhongkeWebSuspenView shared] showSuspension];
    }
}

#pragma mark -----------new---------------

//多账号快速登录，省略用户名密码限制判断
- (void)loginFast:(NSString *)unString
      andPassWord:(NSString *)pwString
        userToken:(NSString *)userToken
      childUserId:(NSString *)childuserId
       andSuccess:(SuccessBlcok)successBlock
       andFailure:(FailureBlcok)failureBlcok {
    if (successBlock) {
        self.sBlock = successBlock;
    }
    if (failureBlcok) {
        self.fBlock = failureBlcok;
    }
    self.uid = unString;
    self.passWord = pwString;
    self.access_token = userToken;
    self.sub_uid = childuserId;
    [self commonLoginMethod];
}



/// 根据用户名和密码获取登录toekn
/// @param unString 用户名
/// @param pwdString 密码
/// @param successBlock 成功回调
/// @param failureBlcok 失败回调
- (void)getLoginTokenByUserName:(NSString *)unString
                       PassWord:(NSString *)pwdString
                        Success:(SuccessBlcok)successBlock
                        Failure:(FailureBlcok)failureBlcok{
    if (successBlock) {
        self.sBlock = successBlock;
    }
    if (failureBlcok) {
        self.fBlock = failureBlcok;
    }
    
    self.userName = unString;
    self.passWord =pwdString;
    
    [self getLoginTokenByUserName];
}



/// 根据用户手机获取登录token
/// @param phoneString 手机号
/// @param codeString 验证码
/// @param successBlock 成功回调
/// @param failureBlcok 失败回调
- (void)getLoginTokenByPhone:(NSString *)phoneString
                     codeNum:(NSString *)codeString
                  andSuccess:(SuccessBlcok)successBlock
                  andFailure:(FailureBlcok)failureBlcok{
    if (successBlock) {
        self.sBlock = successBlock;
    }
    if (failureBlcok) {
        self.fBlock = failureBlcok;
    }
    
    self.phone = phoneString;
    self.verificationCode = codeString;
    [self getLoginToken];
    
    
}


- (void)loginWithToken:(NSString *)tokenString
                   uid:(NSString *)uidString
              PassWord:(NSString *)pwdString
               sub_uid:(NSString *)sub_uidString
            andSuccess:(SuccessBlcok)successBlock
            andFailure:(FailureBlcok)failureBlcok{
    
    if (successBlock) {
        self.sBlock = successBlock;
    }
    if (failureBlcok) {
        self.fBlock = failureBlcok;
    }
    self.passWord = pwdString;
    self.access_token = tokenString;
    self.uid = uidString;
    self.sub_uid = sub_uidString;
    [self commonLoginMethod];
}




- (void)registeredUserName:(NSString *)unString
               andPassWord:(NSString *)pwString
                andSuccess:(SuccessBlcok)successBlock
                andFailure:(FailureBlcok)failureBlcok {
    if (successBlock) {
        self.sBlock = successBlock;
    }
    if (failureBlcok) {
        self.fBlock = failureBlcok;
    }
    self.userName = unString;
    self.passWord = pwString;
    self.access_token = @"";
    
    if (![unString isValidString] ||
        ![pwString isValidString]) {
        _fBlock(-1,@"账号或密码不能为空");
        return;
    } else if (6 > [unString length]) {
        _fBlock(-1,@"账号过短，支持6~22个字母数字下划线组合");
        return;
    } else if ([unString length] > 22){
        _fBlock(-1,@"账号过长，支持6~22个字母数字下划线组合");
        return;
    }
    
    if (4 > [pwString length]) {
        _fBlock(-1,@"密码过短，支持4~12个英文数字字符");
        return;
    } else if([pwString length] > 12) {
        _fBlock(-1,@"密码过长，支持4~12个英文数字字符");
        return;
    }
    [self registeredNewUser:unString pwd:pwString];
}

//检测用户名
- (void)checkUserName:(NSString *)unString
           andSuccess:(SuccessBlcok)successBlock
           andFailure:(FailureBlcok)failureBlcok {
    if (successBlock) {
        self.sBlock = successBlock;
    }
    if (failureBlcok) {
        self.fBlock = failureBlcok;
    }
    self.userName = unString;
    
    if (!unString.isValidString) {
        _fBlock(-3,@"账号不能为空");
        return;
    }else {
        [self checkUserName];
    }
}

//获取用户信息
- (void)getUserInfoByName:(NSString *)unString
               andSuccess:(SuccessBlcok)successBlock
               andFailure:(FailureBlcok)failureBlcok{
    
    if (successBlock) {
        self.sBlock = successBlock;
    }
    if (failureBlcok) {
        self.fBlock = failureBlcok;
    }
    self.userName = unString;
    
    if (!unString.isValidString) {
        _fBlock(-3,@"账号不能为空");
        return;
    }else {
        [self getUserInfoByName];
    }
}


/**
 *
 *  //获取用户信息
 */
- (void)getUserInfoByName {
    requestGetNameInfoModel *model = [[requestGetNameInfoModel alloc]initRequestGetNameInfoModel:self.userName];;
    
    [sdkRequestManager startRequestWithModel:model succeedBlock:^(id responseObject) {
        ResponseModel * model = [ResponseModel modelWithJSON:responseObject];
        if (model.code == 0) {
            _sBlock(0,@"",responseObject);
        }else {
            _fBlock(model.code,model.msg);
            
        }
    }];
}


//根据uid获取验证吗
- (void)getPhoneByUid:(NSString *)uidString
           andSuccess:(SuccessBlcok)successBlock
           andFailure:(FailureBlcok)failureBlcok{
    
    
    if (successBlock) {
        self.sBlock = successBlock;
    }
    if (failureBlcok) {
        self.fBlock = failureBlcok;
    }
    self.uid = uidString;
    
    if (!uidString.isValidString) {
        _fBlock(-3,@"账号不能为空");
        return;
    }else {
        [self getCaptchaByUid];
    }
}
/**
 *  //获取验证吗
 */
- (void)getCaptchaByUid {
    requestGetCaptchaoByUidModel *model = [[requestGetCaptchaoByUidModel alloc]initRequestGetCaptchaoByUidModel:self.uid];
    
    [sdkRequestManager startRequestWithModel:model succeedBlock:^(id responseObject) {
        ResponseModel * model = [ResponseModel modelWithJSON:responseObject];
        if (model.code == 0) {
            _sBlock(0,responseObject,nil);
        }else {
            _fBlock(model.code,model.msg);
            
        }
    }];
}

//zhongke找回密码
- (void)resetNewPassword:(NSString *)phone
                     num:(NSString *)num
                password:(NSString *)password
              andSuccess:(SuccessBlcok)successBlock
              andFailure:(FailureBlcok)failureBlcok {
    if (successBlock) {
        self.sBlock = successBlock;
    }
    if (failureBlcok) {
        self.fBlock = failureBlcok;
    }
    self.phone = phone;
    self.verificationCode = num;
    self.passWord = password;
    if (4 > [password length]) {
        _fBlock(-1,@"密码过短，支持4~12个英文数字字符");
        return;
    } else if([password length] > 12) {
        _fBlock(-1,@"密码过长，支持4~12个英文数字字符");
        return;
    }
    [self resetNewPassWord:num];
}

#pragma mark - interface

- (void)loginChangeChild:(NSString *)access_token
              andsub_uid:(NSString *)sub_uid
              andSuccess:(SuccessBlcok)successBlock
              andFailure:(FailureBlcok)failureBlcok{
    
    if (successBlock) {
        _sBlock = successBlock;
    }
    if (failureBlcok) {
        _fBlock = failureBlcok;
    }
    self.access_token = access_token;
    self.sub_uid = sub_uid;
    self.uid = COMMONMETHOD.uid;
    
    requestLoginWithTokenModel *model = [[requestLoginWithTokenModel alloc]initRequestLoginWithTokenModel:self.uid sub_uid:self.sub_uid access_token:self.access_token];
    
    [sdkRequestManager startRequestWithModel:model succeedBlock:^(id responseObject) {
        ResponseModel * model = [ResponseModel modelWithJSON:responseObject];
        if (model.code == 0) {
            
            NSLog(@"小号登陆responseObject---%@",responseObject);
            
            
            COMMONMETHOD.sub_uid =[NSString stringWithFormat:@"%@",responseObject[@"data"][@"sub_uid"]];
            COMMONMETHOD.access_code =responseObject[@"data"][@"access_code"];
            
            MessagePopView * popView = [[MessagePopView alloc]init];
            [popView show:1];
            
            [UserDataModel updatesub_uid:COMMONMETHOD.uid sub_uid:COMMONMETHOD.sub_uid];
            
            _sBlock(0,model.msg,nil);
            AccountStatus * user = [[AccountStatus alloc] init];
            user.fySDKAccountStatus = _ACCOUNT_STATUS_LOGINSUCCEED;
            MessageStatus * message = [[MessageStatus alloc] init];
            message.code = [responseObject[@"code"] intValue];
            message.msg = responseObject[@"msg"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserCompleteNotification" object:nil userInfo:@{@"AccountStatus":user,@"result":@YES,@"MessageStatus":message}];
            [self getGiftAndMsg:responseObject[@"data"][@"uid"]];
            
        } else {
            _fBlock(model.code,model.msg);
            AccountStatus * user = [[AccountStatus alloc] init];
            user.fySDKAccountStatus = _ACCOUNT_STATUS_SWITCHACCOUNT;
            MessageStatus * message = [[MessageStatus alloc] init];
            message.code = [responseObject[@"code"] intValue];
            message.msg = responseObject[@"msg"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserCompleteNotification" object:nil userInfo:@{@"AccountStatus":user,@"result":@YES,@"MessageStatus":message}];
        }
    }];
}

/**
 *  登录
 */
- (void)commonLoginMethod {
    __weak typeof (self) bSelf = self;
    requestLoginWithTokenModel *model = [[requestLoginWithTokenModel alloc]initRequestLoginWithTokenModel:bSelf.uid sub_uid:bSelf.sub_uid access_token:bSelf.access_token];
    [sdkRequestManager startRequestWithModel:model succeedBlock:^(id responseObject) {
        NSLog(@"登录返回---responseObject%@",responseObject);
        ResponseModel * model = [ResponseModel modelWithJSON:responseObject];
        if (model.code == 0) {
            [SDKCommonMethod shared].access_code = responseObject[@"data"][@"access_code"];
            INITCONFIGURE.last_version =  responseObject[@"data"][@"version"];
           
            INITCONFIGURE.landing_url =  responseObject[@"data"][@"landing_url"];
            [SDKCommonMethod shared].sub_uid = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"sub_uid"]];
            [SDKCommonMethod shared].verify_after_login = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"verify_after_login"]];
            [SDKCommonMethod shared].verify_before_pay =[NSString stringWithFormat:@"%@",responseObject[@"data"][@"verify_before_pay"]];
            [SDKCommonMethod shared].allow_purchase_voucher = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"allow_purchase_voucher"]];
            [sdkInitModel share].afterlogin = responseObject[@"data"][@"after_login"];
            NSLog(@"allow_purchase_voucher--%@", [SDKCommonMethod shared].allow_purchase_voucher );
            if (![[SDKCommonMethod shared].allow_purchase_voucher isEqualToString:@"1"]) {//不等于1不显示
                NSMutableArray * arr = [[NSKeyedUnarchiver unarchiveObjectWithData:[NSUserDefaults takeoutNSUserDefault:suspensionview]] mutableCopy];
                for (NSDictionary * dic in arr) {
                    if ([dic[@"title"] isEqualToString:@"充值"]) {
                        [arr removeObject:dic];
                        break;
                    }
                }
                [NSUserDefaults reserveNSUserDefault:[NSKeyedArchiver archivedDataWithRootObject:arr] field:suspensionview];
            }
            [NSUserDefaults reserveNSUserDefault:@"sdkLogin" field:ISLOGIN];
            [NSUserDefaults reserveNSUserDefault:COMMONMETHOD.uid field:LASTLOGINUID];
            LoginOperation * login = [[LoginOperation alloc]init];
            [login saveUserInfoWithParams:COMMONMETHOD.userName withPassword:COMMONMETHOD.password withAccess_token:COMMONMETHOD.access_token withRefresh_token:COMMONMETHOD.refresh_token withPhone:COMMONMETHOD.phone withUser_type:COMMONMETHOD.userType withUid:COMMONMETHOD.uid withPhone_bind:@"0" withIdCard_bind:@"0"];
            MessagePopView * popView = [[MessagePopView alloc]init];
            [popView show:2];
            bSelf.sBlock(0,model.msg,nil);
            AccountStatus * user = [[AccountStatus alloc] init];
            user.fySDKAccountStatus = _ACCOUNT_STATUS_LOGINSUCCEED;
            MessageStatus * message = [[MessageStatus alloc] init];
            message.code = 0;
            message.msg = @"账号在线状态";
      
           
            
            int LocalVersion = [[INITCONFIGURE.version stringByReplacingOccurrencesOfString:@"." withString:@""] intValue];
           int Last_Version = [[INITCONFIGURE.last_version stringByReplacingOccurrencesOfString:@"." withString:@""] intValue];
           if (!(LocalVersion < Last_Version)) {// 不需要强更
               [[NSNotificationCenter defaultCenter] postNotificationName:@"UserCompleteNotification" object:nil userInfo:@{@"AccountStatus":user,@"result":@YES,@"MessageStatus":message}];
           }
            
            __strong typeof(bSelf)strongSelf = bSelf;
            //刷新未过期
            if([SDKCommonMethod returnRefreshTokenDeadLine:[NSUserDefaults takeoutNSUserDefault:LASTLOGINUID]]){
                if([SDKCommonMethod returnExpiresinDeadLine:[NSUserDefaults takeoutNSUserDefault:LASTLOGINUID]]){//登录token未过期
                    if ([SDKCommonMethod returnExpiresinanyHour:[NSUserDefaults takeoutNSUserDefault:LASTLOGINUID]]) {//小于any小时
                        [strongSelf refReshUserToken];
                    }
                }else{//过期了
                    [strongSelf refReshUserToken];
                }
            }
//            [[SDKPusherManager shared] startConnectServer];
            
            
            [[NewZhongkeWebSuspenView shared] showSuspension];
            [[RemindView share] show:@"登录成功" time:2.0];
            
        } else {
            _fBlock(model.code,model.msg);
        }
    }];
}



-(void)getGiftAndMsg:(NSString *)uid {
    
    
    NSArray * arr = [NSKeyedUnarchiver unarchiveObjectWithData:[NSUserDefaults takeoutNSUserDefault:suspensionview]];
    if (arr.count != 0) {
        [[NewZhongkeWebSuspenView shared] showSuspension];
    }
    
}


/**
 *  获取手机验证码
 */
- (void)startGetPhoneCode {
    requestGetPhoneCodeModel *model = [[requestGetPhoneCodeModel alloc]initRequestGetPhoneCode:self.phone codeLenght:@"4"];
    [sdkRequestManager startRequestWithModel:model succeedBlock:^(id responseObject) {
        ResponseModel * model = [ResponseModel modelWithJSON:responseObject];
        if (model.code == 0) {
            //保存至本地
            VertificationCodeModel *vertificationCodemodel = [[VertificationCodeModel alloc] init];
            vertificationCodemodel.expiretime = [responseObject[@"expiretime"] integerValue];
            vertificationCodemodel.code = model.code;
            // 1为找回密码标识  2手机绑定
            vertificationCodemodel.token = 1;
            //保存当前时间
            vertificationCodemodel.serviceTime = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970] * 1;
            vertificationCodemodel.account = self.phone;
            vertificationCodemodel.phoneNumber = self.phone;
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@[vertificationCodemodel]];
            [NSUserDefaults reserveNSUserDefault:data field:VerificationCodeInfo];
            _sBlock(0,model.msg,nil);
            COMMONMETHOD.is_newuser = @"1";
        }else {
            _fBlock(-1,model.msg);
        }
    }];
}



#pragma mark new interface
/**
 *  用户名、密码获取登录token
 */
- (void)getLoginTokenByUserName{
    requestGetTokenByUserNameModel *model =[[ requestGetTokenByUserNameModel alloc]initRequestGetTokenByUserNameModel:self.userName password:self.passWord];
    [sdkRequestManager startRequestWithModel:model succeedBlock:^(id responseObject) {
        ResponseModel * model = [ResponseModel modelWithJSON:responseObject];
        
        if (model.code == 0) {
            NSLog(@"通过账号密码获取token---responseObject%@",responseObject);
            [SDKCommonMethod shared].access_token =responseObject[@"data"][@"access_token"];
            [SDKCommonMethod shared].refresh_token =responseObject[@"data"][@"refresh_token"];
            [SDKCommonMethod shared].refresh_token_expires_in = [NSString stringWithFormat:@"%d",[responseObject[@"data"][@"refresh_token_expires_in"] intValue] + [[SDKCommonMethod getTimeStamp] intValue]];
            [SDKCommonMethod shared].expires_in =[NSString stringWithFormat:@"%d",[responseObject[@"data"][@"expires_in"] intValue] + [[SDKCommonMethod getTimeStamp] intValue]];
            [SDKCommonMethod shared].uid =[NSString stringWithFormat:@"%@",responseObject[@"data"][@"uid"]];
            
            [NSUserDefaults reserveNSUserDefault:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"uid"]] field:LASTLOGINUID];
            _sBlock(0,model.msg,responseObject);
            
        } else {
            _fBlock(model.code,model.msg);
        }
    }];
    
    
}

/**
 *  手机验证码获取token
 */
- (void)getLoginToken {
    requestGetTokenModel *model = [[requestGetTokenModel alloc]initRequestGetTokenModel:self.phone code:self.verificationCode];;
    [sdkRequestManager startRequestWithModel:model succeedBlock:^(id responseObject) {
        ResponseModel * model = [ResponseModel modelWithJSON:responseObject];
        
        if (model.code == 0) {
            NSLog(@"手机验证码获取token---responseObject%@",responseObject);
            [SDKCommonMethod shared].access_token =responseObject[@"data"][@"access_token"];
            [SDKCommonMethod shared].refresh_token =responseObject[@"data"][@"refresh_token"];
            [SDKCommonMethod shared].refresh_token_expires_in = [NSString stringWithFormat:@"%d",[responseObject[@"data"][@"refresh_token_expires_in"] intValue] + [[SDKCommonMethod getTimeStamp] intValue]];
            [SDKCommonMethod shared].expires_in =[NSString stringWithFormat:@"%d",[responseObject[@"data"][@"expires_in"] intValue] + [[SDKCommonMethod getTimeStamp] intValue]];
            [SDKCommonMethod shared].uid =[NSString stringWithFormat:@"%@",responseObject[@"data"][@"uid"]];
            [SDKCommonMethod shared].userName = responseObject[@"data"][@"username"];
            [SDKCommonMethod shared].password_plaintext = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"password_plaintext"]];
            [NSUserDefaults reserveNSUserDefault:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"uid"]] field:LASTLOGINUID];
            _sBlock(0,model.msg,responseObject);
            
        } else {
            _fBlock(model.code,model.msg);
        }
    }];
    
}




/**
 *  注册新用户
 */
- (void)registeredNewUser:(NSString *)userName pwd:(NSString *)pwd {
    requestRegisterByNameModel *model = [[requestRegisterByNameModel alloc]initRequestRegisterByNameModel:userName password:pwd];;
    
    [sdkRequestManager startRequestWithModel:model succeedBlock:^(id responseObject) {
        ResponseModel * model = [ResponseModel modelWithJSON:responseObject];
        if (model.code == 0) {
            NSLog(@"用户注册---responseObject%@",responseObject);
            [SDKCommonMethod shared].access_token =responseObject[@"data"][@"access_token"];
            
            [SDKCommonMethod shared].refresh_token =responseObject[@"data"][@"refresh_token"];
            [SDKCommonMethod shared].refresh_token_expires_in = [NSString stringWithFormat:@"%d",[responseObject[@"data"][@"refresh_token_expires_in"] intValue] + [[SDKCommonMethod getTimeStamp] intValue]];
            [SDKCommonMethod shared].expires_in =[NSString stringWithFormat:@"%d",[responseObject[@"data"][@"expires_in"] intValue] + [[SDKCommonMethod getTimeStamp] intValue]];
            [SDKCommonMethod shared].uid =[NSString stringWithFormat:@"%@",responseObject[@"data"][@"uid"]];
            [SDKCommonMethod shared].userName =responseObject[@"data"][@"username"];
            [NSUserDefaults reserveNSUserDefault:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"uid"]] field:LASTLOGINUID];
            
            _sBlock(0,model.msg,responseObject);
        }else {
            _fBlock(model.code,model.msg);
        }
    }];
}

/// 小号注册
/// @param display_name 小号名
/// @param successBlock 成功回调
/// @param failureBlcok 失败回调
- (void)registeredChildUserName:(NSString *)display_name
                     andSuccess:(SuccessBlcok)successBlock
                     andFailure:(FailureBlcok)failureBlcok{
    if (successBlock) {
        self.sBlock = successBlock;
    }
    if (failureBlcok) {
        self.fBlock = failureBlcok;
    }
    requestSubUsercCreaterModel *model = [[requestSubUsercCreaterModel alloc]initRequestSubUsercCreaterModel:display_name access_token:COMMONMETHOD.access_token uid:COMMONMETHOD.uid];
    [sdkRequestManager startRequestWithModel:model succeedBlock:^(id responseObject) {
        ResponseModel * model = [ResponseModel modelWithJSON:responseObject];
        NSLog(@"小号添加---%@",responseObject);
        if (model.code == 0) {
            _sBlock(0,model.msg,nil);
        }else {
            _fBlock(model.code,model.msg);
        }
    }];
    
}



/**
 *  检查用户名是否已存在
 */
- (void)checkUserName {
    requestCheckNameModel *model = [[requestCheckNameModel alloc]initRequestRequestCheckNameModel:self.userName];;
    
    [sdkRequestManager startRequestWithModel:model succeedBlock:^(id responseObject) {
        ResponseModel * model = [ResponseModel modelWithJSON:responseObject];
        if (model.code == 0) {
            _sBlock(0,responseObject[@"data"],nil);
        }else {
            _fBlock(model.code,model.msg);
            
        }
    }];
}

/**
 *  重置密码
 */
- (void)resetNewPassWord:(NSString *)code{
    requestChangePwModel *model = [[requestChangePwModel alloc]initRequestChangePwModel:COMMONMETHOD.uid captcha:code password:self.passWord];
    [sdkRequestManager startRequestWithModel:model succeedBlock:^(id responseObject) {
        ResponseModel * model = [ResponseModel modelWithJSON:responseObject];
        
        if (model.code == 0) {
            _sBlock(0,model.msg,responseObject);
            //如果本地数据库存在该账号，则更新密码
            NSArray *userArr =  [UserDataModel selectUserAccount:[NSUserDefaults takeoutNSUserDefault:COMMONMETHOD.uid]];
            if (userArr.count > 0) {
                UserModel *userAccount = userArr[0];
                userAccount.passWord = self.passWord;
                [UserDataModel insertUser:userAccount];
            }
            
            
        }else {
            _fBlock(model.code,model.msg);
        }
    }];
}

//获取游戏时长
- (void)getPlayTimeLimit:(NSString *)timeLength
                     ageLevel:(NSString *)age
              andSuccess:(SuccessBlcok)successBlock
              andFailure:(FailureBlcok)failureBlcok{
    self.sBlock= successBlock;
    self.fBlock = failureBlcok;
    getPlayTimeLimitModel *model = [[getPlayTimeLimitModel alloc]initWithTime:timeLength age:age];
    [sdkRequestManager startRequestWithModel:model succeedBlock:^(id responseObject) {
        NSLog(@"responseObject--%@",responseObject);
        if ([responseObject[@"code"] intValue] == 0) {
            //成功返回
            if ([responseObject[@"data"][@"allow_login"] intValue] == 1) {

                _sBlock(1,@"允许用户登录",nil);
            }else{//不允许登录
                ZhongkeUserViewController * vc = [[ZhongkeUserViewController alloc]init];
                [[COMMONMETHOD getRootViewController].view addSubview:vc.view];
                [vc setupUI];
                [vc setupplayTimeLimitView:responseObject[@"msg"]];  //
                _sBlock(0,@"不允许登录",nil);
            }
        }else{//失败
            
        }
    }];

    
}


- (void)refReshUserToken {
    NSLog(@"refReshUserToken------进来了");
    requestRefreshTokenModel *model = [[requestRefreshTokenModel alloc]initRequestRefreshTokenModel:COMMONMETHOD.uid sub_uid:COMMONMETHOD.sub_uid refresh_token:COMMONMETHOD.refresh_token];
    [sdkRequestManager startRequestWithModel:model succeedBlock:^(id responseObject) {
        ResponseModel * model = [ResponseModel modelWithJSON:responseObject];
        if (model.code == 0) {
            [UserDataModel updateUserAccesstokenByuid:COMMONMETHOD.uid access_token:responseObject[@"data"][@"access_token"] refresh_token:responseObject[@"data"][@"refresh_token"] expires_in:[NSString stringWithFormat:@"%d",[responseObject[@"data"][@"expires_in"] intValue] + [[SDKCommonMethod getTimeStamp] intValue]] refresh_token_expires_in:[NSString stringWithFormat:@"%d",[responseObject[@"data"][@"refresh_token_expires_in"] intValue] + [[SDKCommonMethod getTimeStamp] intValue]]];
        }else {
            
        }
    }];
    
}

- (void)pusherScoketResult:(NSNotification*)noti{
    
    NSLog(@"pusherScoketResult---%@",noti);
    
    
}

@end


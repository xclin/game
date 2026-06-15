
#import "LoginOperation.h"
#import "SDKCommonMethod.h"
#import "xysdkKeyChain.h"
#import "SDKComplatformBase.h"
#import "DataBaseManager.h"
#import "sdkEncryption.h"
#import "UserDataModel.h"
#import "MessagePopView.h"
#import "UserPayListRequest.h"
#import "RecordViewPath.h"
#import "sdkInitModel.h"
#import "UserModel.h"
#import "NSUserDefaults+Category.h"
@implementation LoginOperation

- (void)saveUserInfoWithParams:(NSString *)userName withPassword:(NSString *)password withAccess_token:(NSString *)Atoken withRefresh_token:(NSString *)Rtoken withPhone:(NSString *)phone withUser_type:(NSString *)user_type withUid:(NSString *)uid withPhone_bind:(NSString *)phone_bind withIdCard_bind:(NSString *)idCard_bind{

    //保存当前登录用户的信息
    UserModel * model = [[UserModel alloc]init];
    model.userName = userName;
    model.passWord = password?password:@"";
    model.access_token = Atoken;
    model.refresh_token = Rtoken;
    NSLog(@"保存phone---%@",phone);
    model.phone = phone?phone:@"";
    model.uid = uid;
    model.lastLoginTime = [SDKCommonMethod getNowTime];
    model.phone_bind = phone_bind;
    model.user_type = user_type;
    model.idCard_bind = idCard_bind;
    model.sub_uid = COMMONMETHOD.sub_uid;
    model.lastLoginIP = COMMONMETHOD.getIPAddress;
    model.password_plaintext = password;
    model.age = @"";
    model.idCard = @"";
    model.isAdulted = @"";
    model.expires_in = COMMONMETHOD.expires_in?COMMONMETHOD.expires_in:@"";
    model.refresh_token_expires_in = COMMONMETHOD.refresh_token_expires_in?COMMONMETHOD.refresh_token_expires_in:@"";
    model.verify_before_pay =  [SDKCommonMethod shared].verify_before_pay;
    model.verify_after_login = [SDKCommonMethod shared].verify_after_login;
    [UserDataModel insertUser:model];
    
    [NSUserDefaults reserveNSUserDefault:COMMONMETHOD.uid field:LASTLOGINUID];
    [xysdkKeyChain saveKeyChainWithString:[SDKCommonMethod encryptBase64WithString: userName] Andkey:[NSString stringWithFormat:@"%@%@",INITCONFIGURE.gid,UserNameKey]];
    [xysdkKeyChain saveKeyChainWithString:[SDKCommonMethod encryptBase64WithString:password] Andkey:[NSString stringWithFormat:@"%@%@",INITCONFIGURE.gid,PassworkKey]];

    
    //标识SDK关闭
    COMMONMETHOD.recordShowSDK = 0;

    //取消view记录轨迹请求
    [RecordViewPath share].isTurnOn = NO;
}
@end

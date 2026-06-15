
#import <Foundation/Foundation.h>



#pragma mark --- 一级：父类BBModel
@interface requestModel : NSObject
@property (nonatomic,copy) NSString * gid;
@property (nonatomic,copy) NSString * lid;
@property (nonatomic,copy) NSString * pid;
@property (nonatomic,copy) NSString * platform;
@property (nonatomic,copy) NSString * access_token;
@property (nonatomic,copy) NSString * uid;
@property (nonatomic,copy) NSString * udid;
@property (nonatomic,copy) NSString * version;
@property (nonatomic,copy) NSString * sub_uid;
@property (nonatomic,copy) NSString * equipment_id;
@property (nonatomic,copy) NSString * equipment_idfv;
@property (nonatomic,copy) NSString * rest;
@property (nonatomic,copy) NSString * domain;
- (NSDictionary*)jsonModel;
@end


#pragma mark --- 初始化SDK
@interface requestInitModel : requestModel
- (id)initSDK:(NSString *)deviceToken
 withJsonData:(NSString *)jsonData;
@end


#pragma mark --- 创角色
@interface requestRoleModel : requestModel
@property (nonatomic, copy) NSString *server_id;  //服务器id
@property (nonatomic, copy) NSString *server_name;  //服务器名称
@property (nonatomic, copy) NSString *role_id;  //角色id
@property (nonatomic, copy) NSString *role_name;  //角色名称
- (id)initRole:(NSString *)server_id
   server_name:(NSString *)server_name
       role_id:(NSString *)role_id
     role_name:(NSString *)role_name;
@end


#pragma mark --- 等级上报
@interface requestSendRoleLevel : requestModel
@property (nonatomic, copy) NSString *server_id;  //服务器id
@property (nonatomic, copy) NSString *server_name;  //服务器名称
@property (nonatomic, copy) NSString *role_id;  //角色id
@property (nonatomic, copy) NSString *role_name;  //角色名称
@property (nonatomic, copy) NSString *role_level;  //角色等级
- (id)initSendRoleLevel:(NSString *)server_id
            server_name:(NSString *)server_name
                role_id:(NSString *)role_id
              role_name:(NSString *)role_name
             role_level:(NSString *)role_Level;
@end



#pragma mark --- 选服接口
/// 选服后如果没有还没有角色 ，先不请求选服接口，创角后再请求创角接口即可
@interface requestSelectServerModel : requestModel
@property (nonatomic, copy) NSString *server_id;  //服务器id
@property (nonatomic, copy) NSString *server_name;  //服务器名称
@property (nonatomic, copy) NSString *role_id;  //角色id
@property (nonatomic, copy) NSString *role_name;  //角色名称

- (id)initSelectServerModel:(NSString *)server_id
                server_name:(NSString *)server_name
                    role_id:(NSString *)role_id
                  role_name:(NSString *)role_name;
@end



#pragma mark --- 时长

@interface getPlayTimeLimitModel : requestModel
@property (nonatomic,copy) NSString *age_level;
@property (nonatomic,copy) NSString *polling_interval;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *c_uid;
@property (nonatomic,copy) NSString *ver;
@property (nonatomic,copy) NSString * ctype;
- (id)initWithTime:(NSString *)timeLength
                age:(NSString *)age;
@end

#pragma mark --- 获取手机验证码
@interface requestGetPhoneCodeModel : requestModel
@property (nonatomic, copy) NSString *phone;  //手机号
@property (nonatomic, copy) NSString *captcha_length;  //验证码长度

- (id)initRequestGetPhoneCode:(NSString *)phone
                   codeLenght:(NSString *)codeLenght;
@end



#pragma mark --- 根据用户名、密码获取将要登录的token
@interface requestGetTokenByUserNameModel : requestModel
@property (nonatomic, copy) NSString *name;  //手机号
@property (nonatomic, copy) NSString *password;  //密码

- (id)initRequestGetTokenByUserNameModel:(NSString *)name
                          password:(NSString *)pwd;
@end



#pragma mark --- 根据手机、验证码获取将要登录的token
@interface requestGetTokenModel : requestModel
@property (nonatomic, copy) NSString *phone;  //手机号
@property (nonatomic, copy) NSString *captcha;  //验证码

- (id)initRequestGetTokenModel:(NSString *)phone
                          code:(NSString *)captcha;
@end


#pragma mark --- 根据token登录

@interface requestLoginWithTokenModel : requestModel

- (id)initRequestLoginWithTokenModel:(NSString *)uid
                             sub_uid:(NSString *)sub_uid
                        access_token:(NSString *)access_token;

@end

#pragma mark --- 刷新token
@interface requestRefreshTokenModel : requestModel
@property (nonatomic, copy) NSString *refresh_token;
- (id)initRequestRefreshTokenModel:(NSString *)uid
                           sub_uid:(NSString *)sub_uid
                     refresh_token:(NSString *)refresh_token;

@end

#pragma mark --- 创建小号
/// 选服后如果没有还没有角色 ，先不请求选服接口，创角后再请求创角接口即可
@interface requestSubUsercCreaterModel : requestModel
@property (nonatomic,copy)NSString *sub_username;
@property (nonatomic,copy)NSString *refresh_token;

- (id)initRequestSubUsercCreaterModel:(NSString *)sub_username
                         access_token:(NSString *)access_token
                                  uid:(NSString *)uid;
@end


#pragma mark --- 检查用户名是否已存在
@interface requestCheckNameModel : requestModel
@property (nonatomic,copy) NSString *name;
- (id)initRequestRequestCheckNameModel:(NSString *)name;
@end


#pragma mark --- 根据用户名，获取用户信息
@interface requestGetNameInfoModel : requestModel
@property (nonatomic,copy) NSString *name;
- (id)initRequestGetNameInfoModel:(NSString *)name;
@end

#pragma mark --- 根据用户名id发送验证码
@interface requestGetCaptchaoByUidModel : requestModel
@property (nonatomic,copy) NSString *captcha_length;

- (id)initRequestGetCaptchaoByUidModel:(NSString *)uid;
@end



#pragma mark --- 更改密码
@interface requestChangePwModel : requestModel
@property (nonatomic,copy) NSString *captcha;
@property (nonatomic,copy) NSString *password;
- (id)initRequestChangePwModel:(NSString *)uid
                        captcha:(NSString *)captcha
                       password:(NSString *)password;

@end

#pragma mark --- 通过用户名注册
@interface requestRegisterByNameModel : requestModel
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *password;
- (id)initRequestRegisterByNameModel:(NSString *)name
                        password:(NSString *)password;

@end



#pragma mark - 上报实名认证
@interface requestReportidentitycardModel : requestModel
@property (nonatomic,copy) NSString * true_name;
@property (nonatomic,copy) NSString * identity_card_type;
@property (nonatomic,copy) NSString * identity_card_no;
- (instancetype) initRequestReportidentitycardModel:(NSString*)true_name
                    identity_card_no:(NSString*) identity_card_no;

@end

#pragma mark ---内购回调
@interface IAPCallBackModel : requestModel<NSCoding>
@property (nonatomic,copy) NSString *gameid;
@property (nonatomic,copy) NSString *apid;
@property (nonatomic,copy) NSString *cid;
@property (nonatomic,copy) NSString *sid;
@property (nonatomic,copy) NSString *gameOther;
@property (nonatomic,copy) NSString *deviceToken;
@property (nonatomic,copy) NSString *receipt;
@property (nonatomic,copy) NSString *sandbox;
@property (nonatomic,copy) NSString *token;
@property (nonatomic,copy) NSString *transactionId;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *userid;
@property (nonatomic,copy) NSString *roleData;
- (id)initIAPCallBackWithApid:(NSString *)apid
                      withSid:(NSString *)sid
                withGameOther:(NSString *)gameOther
                  withReceipt:(NSString *)receipt
                  withSandbox:(NSString *)sandBox
                    withToken:(NSString *)token
            withTransactionId:(NSString *)transactionId
                    withPrice:(NSString *)price
                 withUsername:(NSString *)username
                   withUserid:(NSString *)userid
                  andRoleData:(NSString *)roleData;


@end

#pragma mark --- 回调
@interface ResponseModel : NSObject
@property (nonatomic, assign) int code;
@property (nonatomic, copy) NSString * msg;
@end



#import "BaseModel.h"
#import "YYKit.h"
#import "SDKCommonMethod.h"
#import "Config.h"
#import <AdSupport/AdSupport.h>
#import "sdkInitModel.h"
#import "apiManager.h"
#import "UserModel.h"


@implementation requestModel
- (id)init {
    self = [super init];
    if (self) {
        self.rest = [COMMONMETHOD getRest]==nil?@"":[COMMONMETHOD getRest];
        self.equipment_idfv = [COMMONMETHOD getEquipmentIDFV];
        self.equipment_id =[COMMONMETHOD getEquipmentIDFA];
        self.version =INITCONFIGURE.version;
        self.gid = INITCONFIGURE.gid;
        self.platform = @"1";
        self.pid  =INITCONFIGURE.pid;
        self.lid = INITCONFIGURE.lid;
        self.access_token = COMMONMETHOD.access_token;
        self.sub_uid = COMMONMETHOD.sub_uid?COMMONMETHOD.sub_uid:@"";
        self.uid = COMMONMETHOD.uid;
        self.udid = INITCONFIGURE.udid;
    }
    return self;
}

- (NSDictionary*)jsonModel {
    NSMutableDictionary * dic = [[self modelToJSONObject] mutableCopy];
    [dic removeObjectForKey:@"domain"];
    return dic;
}
/**
 *  签名加密
 *
 *  @param keyString 加密字符串
 *
 *  @return 、加密后
 */
- (NSString *)generateSignKey:(NSString *) keyString {
    if (keyString) {
        NSString * signKey = [keyString stringByAppendingFormat:@"%@",INITCONFIGURE.privateKey];
        signKey = signKey.md5String;
        return signKey;
    }
    return nil;
    
}
/**
 *  排序加密
 *
 *  @param dic sign字典
 *
 *  @return 比较大小后的字符
 */
- (NSString*)compareWithNSDictionary:(NSDictionary*)dic {
    NSArray *array = [[dic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSMutableString * valueString = [[NSMutableString alloc]initWithFormat:@""];
    for (int i=0; i<[array count]; i++) {
        NSString * string = dic[array[i]];
        if (i == [array count] - 1) {
            [valueString appendFormat:@"%@",string];
        }else
        {
            [valueString appendFormat:@"%@&",string];
        }
    }
    return valueString;
}



@end



#pragma mark --- 子类initSDKModel继承父类requestModel
@implementation requestInitModel

- (id)initSDK:(NSString *)deviceToken withJsonData:(NSString *)jsonData {
    self = [super init];
    if (self) {
        self.domain = sdkInitAPI;
    }
    return self;
}
@end

@implementation requestRoleModel
- (id)initRole:(NSString *)server_id server_name:(NSString *)server_name role_id:(NSString *)role_id role_name:(NSString *)role_name{
    self = [super init];
    if (self) {
        self.domain = sdkCreatRoleAPI;
        self.role_id = role_id;
        self.role_name = role_name;
        self.server_id = server_id;
        self.server_name = server_name;
    }
    return self;
}
@end


@implementation requestSendRoleLevel
- (id)initSendRoleLevel:(NSString *)server_id server_name:(NSString *)server_name  role_id:(NSString *)role_id role_name:(NSString *)role_name  role_level:(NSString *)role_Level{
    self = [super init];
    if (self) {
        self.domain = sdkSendRoleLevelAPI;
        self.role_id = role_id;
        self.role_name = role_name;
        self.server_id = server_id;
        self.server_name = server_name;
        self.role_level = role_Level;
    }
    return self;
}
@end

@implementation requestSelectServerModel
- (id)initSelectServerModel:(NSString *)server_id server_name:(NSString *)server_name  role_id:(NSString *)role_id role_name:(NSString *)role_name{
    self = [super init];
    if (self) {
        self.domain = sdkSelectRoleServerAPI;
        self.role_id = role_id;
        self.role_name = role_name;
        self.server_id = server_id;
        self.server_name = server_name;
    }
    return self;
}
@end


@implementation requestGetPhoneCodeModel
- (id)initRequestGetPhoneCode:(NSString *)phone codeLenght:(NSString *)codeLenght{
    self = [super init];
    if (self) {
        self.domain = sdkGetPhoneCodeAPI;
        self.phone = phone;
        self.captcha_length = codeLenght;
    }
    return self;
}
@end

@implementation requestGetTokenModel
- (id)initRequestGetTokenModel:(NSString *)phone code:(NSString *)captcha{
    self = [super init];
    if (self) {
        self.domain = sdkGetTokenPhoneCodeAPI;
        self.phone = phone;
        self.captcha = captcha;
    }
    return self;
}
@end


@implementation requestGetTokenByUserNameModel
- (id)initRequestGetTokenByUserNameModel:(NSString *)name password:(NSString *)pwda{
    self = [super init];
    if (self) {
        self.domain = sdkGetLoginTokenByNameAPI;
        self.name = name;
        self.password = pwda;
    }
    return self;
}
@end




@implementation requestLoginWithTokenModel
- (id)initRequestLoginWithTokenModel:(NSString *)uid
                             sub_uid:(NSString *)sub_uid
                        access_token:(NSString *)access_token{
    self = [super init];
    if (self) {
        self.domain = sdkLoginAPI;
        self.uid = uid;
        if ([sub_uid isEqualToString:@"(null)"]) {
            self.sub_uid = @"";
        }else{
            self.sub_uid = sub_uid?sub_uid:@"";
        }
        if ([access_token isEqualToString:@"(null)"]) {
            self.access_token = @"";
        }else{
            
            self.access_token = access_token?access_token:@"";
        }
    }
    return self;
}
@end


@implementation requestRefreshTokenModel
- (id)initRequestRefreshTokenModel:(NSString *)uid
                           sub_uid:(NSString *)sub_uid
                     refresh_token:(NSString *)refresh_token{
    self = [super init];
    if (self) {
        self.domain = sdkrefReshTokenAPI;
        self.uid = uid;
        self.sub_uid = sub_uid?sub_uid:@"";
        self.refresh_token = refresh_token;
    }
    return self;
}
@end

@implementation requestSubUsercCreaterModel
- (id)initRequestSubUsercCreaterModel:(NSString *)sub_username
                         access_token:(NSString *)access_token
                                  uid:(NSString *)uid{
    self = [super init];
    if (self) {
        self.domain = sdkSubusercreateAPI;
        self.uid = uid;
        self.sub_username = sub_username;
        self.access_token = access_token;
        self.refresh_token = COMMONMETHOD.refresh_token;
    }
    return self;
}
@end


@implementation requestCheckNameModel
- (id)initRequestRequestCheckNameModel:(NSString *)name{
    self = [super init];
    if (self) {
        self.domain = sdkChecknameAPI;
        self.name = name;
    }
    return self;
}
@end


@implementation requestGetNameInfoModel
- (id)initRequestGetNameInfoModel:(NSString *)name{
    self = [super init];
    if (self) {
        self.domain = sdkGetUserInfoAPI;
        self.name = name;
    }
    return self;
}
@end


@implementation requestGetCaptchaoByUidModel
- (id)initRequestGetCaptchaoByUidModel:(NSString *)uid{
    self = [super init];
    if (self) {
        self.domain = sdkSendcaptchaoByUidAPI;
        self.uid = uid;
        self.captcha_length = @"4";
    }
    return self;
}
@end



@implementation requestChangePwModel

- (id)initRequestChangePwModel:(NSString *)uid
                             captcha:(NSString *)captcha
                            password:(NSString *)password{
    self = [super init];
    if (self) {
        self.domain = sdkChangePwdAPI;
        self.uid = uid;
        self.password = password;
        self.captcha = captcha;
    }
    return self;
    
}

@end

@implementation getPlayTimeLimitModel

- (id)initWithTime:(NSString *)timeLength age:(NSString *)age{
    
    self = [super init];
    if (self) {
        self.domain =GetPlayTimeLimit;
        self.age_level = age?age:@"3";//默认未成年
        self.polling_interval = timeLength;
        self.type = @"2";
        self.c_uid = COMMONMETHOD.c_uid;
        self.ver = INITCONFIGURE.version;
        self.ctype = @"offical";
    }
    return self;
}

@end

@implementation requestRegisterByNameModel
- (id)initRequestRegisterByNameModel:(NSString *)name
                            password:(NSString *)password{
    self = [super init];
    if (self) {
        self.domain = sdkRegisterbynameAPI;
        self.name = name;
        self.password = password;
    }
    return self;
    
}
@end

@implementation requestReportidentitycardModel
- (instancetype) initRequestReportidentitycardModel:(NSString *)true_name identity_card_no:(NSString *)identity_card_no{
    self = [super init];
     if (self) {
        self.domain = sdkReportidentityCardAPI;
        self.true_name = true_name;
        self.identity_card_type = @"0";
        self.identity_card_no = identity_card_no;
    }
    return self;
}
@end

@implementation IAPCallBackModel

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
                  andRoleData:(NSString *)roleData {
    self =[super init];
    if (self) {
        self.gameid = INITCONFIGURE.gid;
        self.apid = apid;
        self.cid = COMMONMETHOD.FYCid;
        self.sid = sid;
        self.gameOther = gameOther;
        self.deviceToken = [COMMONMETHOD getDeviceID];
        self.receipt = receipt;
        self.sandbox = sandBox;
        self.token = token;
        self.transactionId = transactionId;
        self.price = price;
        self.username = username;
        self.userid = userid;
        self.roleData = roleData;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.gameid forKey:@"gameid"];
    [encoder encodeObject:self.apid forKey:@"apid"];
    [encoder encodeObject:self.cid forKey:@"cid"];
    [encoder encodeObject:self.sid forKey:@"sid"];
    [encoder encodeObject:self.gameOther forKey:@"gameOther"];
    [encoder encodeObject:self.deviceToken forKey:@"deviceToken"];
    [encoder encodeObject:self.receipt forKey:@"receipt"];
    [encoder encodeObject:self.sandbox forKey:@"sandbox"];
    [encoder encodeObject:self.token forKey:@"token"];
    [encoder encodeObject:self.transactionId forKey:@"transactionId"];
    [encoder encodeObject:self.price forKey:@"price"];
}

- (id)initWithCoder:(NSCoder *)decoder{
    self = [super init];
    if (self) {
        self.gameid = [decoder decodeObjectForKey:@"gameid"];
        self.apid = [decoder decodeObjectForKey:@"apid"];
        self.cid = [decoder decodeObjectForKey:@"cid"];
        self.sid = [decoder decodeObjectForKey:@"sid"];
        self.gameOther = [decoder decodeObjectForKey:@"gameOther"];
        self.deviceToken = [decoder decodeObjectForKey:@"deviceToken"];
        self.receipt = [decoder decodeObjectForKey:@"receipt"];
        self.sandbox = [decoder decodeObjectForKey:@"sandbox"];
        self.token = [decoder decodeObjectForKey:@"token"];
        self.transactionId = [decoder decodeObjectForKey:@"transactionId"];
        self.price = [decoder decodeObjectForKey:@"price"];
    }
    return self;
}
@end



#pragma mark --- ResponseModel
@implementation ResponseModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"code" : @"code",
             @"msg" : @"msg"};
}
@end








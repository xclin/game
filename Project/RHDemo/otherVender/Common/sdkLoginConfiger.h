

#import <Foundation/Foundation.h>


@interface sdkLoginConfiger : NSObject
@property (nonatomic, copy) NSString * channel_result;//渠道返回的数据，如：{"uid":"62543","token":"92434a9695d2c6ff4e88872590c20587","account":"yuyuyu"} 不同渠道，返回不一样的数据
@property (nonatomic, copy) NSString * c_uid;
@property (nonatomic, copy) NSString * s_token;
@property (nonatomic, copy) NSString * s_uid;
@property (nonatomic,copy) NSString  * ptype;
@property (nonatomic, copy) NSString * user_Token;
@property (nonatomic, copy) NSString * account;
@property (nonatomic, copy) NSString * newuser;
+ (instancetype)share;
@end



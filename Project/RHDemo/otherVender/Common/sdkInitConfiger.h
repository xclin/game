
#import <Foundation/Foundation.h>

@interface sdkInitConfiger : NSObject
@property (nonatomic, copy) NSString * gid;
@property (nonatomic, copy) NSString * ver;
@property (nonatomic, copy) NSString * verName;
@property (nonatomic, copy) NSString * app_key;
@property (nonatomic, copy) NSString * privateKey;
@property (nonatomic, copy) NSString * deviceNo;
@property (nonatomic, copy) NSString * cid;
@property (nonatomic, copy) NSString * sid;
@property (nonatomic, copy) NSString * is_large_screen_pay;
@property (nonatomic, copy) NSString * aid;
@property (nonatomic, copy) NSString * cps_id;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * ctype;
@property (nonatomic, copy) NSString *url_Type;  //0 游戏链接 1 H5sdk 2 网页链接
@property (nonatomic, copy) NSString *gameUrl; //游戏链接
@property (nonatomic, copy) NSString *h5sdk_urltr;  //h5sdk
@property (nonatomic, copy) NSString *h5web_urltr;  //网页url
@property (nonatomic, copy) NSString *h5PrivateKey;  //h5的私钥key
+ (instancetype)share;

- (NSString *)getHapiGid;
@end



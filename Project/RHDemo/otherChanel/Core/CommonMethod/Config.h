
#ifndef Config_H
#define Config_H


#define DOMAINURL  @"capisdk.ggxx.net"
#define PAYURL @"papi.ggxx.net"
#define BATCH_NO @"01"

//测试
//#define DOMAINURL  @"xyapisdk.ttlewan.com"//测试

////#define PAYURL @"cpapis.ggxx.net"
//#define PAYURL @"release-papi.ggxx.net"
//#define BATCH_NO @"01"


//#define  DoActivityURL [NSString stringWithFormat:@"http://%@/pages/sfios/activity_ios.html?",PAYURL]//竖版
//#define  DoActivityURL [NSString stringWithFormat:@"http://%@/pages/sfios/transversePay.html?",PAYURL]//横版

#define  CheckOrderURL [NSString stringWithFormat:@"http://%@/api65/65api/65sdk/checkoorder.php?",DOMAINURL]
#define  DoNoIAPURL    [NSString stringWithFormat:@"https://%@/api65/65api/65sdk/noappstore.php?",DOMAINURL]
#define  DoIAPURL  [NSString stringWithFormat:@"https://%@/api65/65api/65sdk/appstore.php?",DOMAINURL]

#define ASDFSURL [NSString stringWithFormat:@"https://%@/sdk102/ps/psu.php?",DOMAINURL]
#define  DomainURL [NSString stringWithFormat:@"https://%@/sdk102/api_2019_01.php?",DOMAINURL]

#define RealNameVerificationURL [NSString stringWithFormat:@"http://%@/apiunionchannels/api/common/1.0.0/real_verification/sdk/get_real_verification.php?",DOMAINURL]


#define reportNameVerificationURL [NSString stringWithFormat:@"http://%@/apiunionchannels/api/common/1.0.0/real_verification/sdk/report_real_verification.php?",DOMAINURL]


#define  DoVerifyReceiptIAPURL  [NSString stringWithFormat:@"https://%@/sfsdk/callback/ios_callback.php?",PAYURL]

#define GetPlayTimeLimit   [NSString stringWithFormat:@"http://%@/apiunionchannels/api/common/1.0.0/real_verification/sdk/get_play_time_limit.php?",DOMAINURL]

#define REGISTERCOUNT [NSString stringWithFormat:@"https://%@/apiunionchannels/burial_point.php?",DOMAINURL]
//统计接口
#define ACTIVECOUNT [NSString stringWithFormat:@"https://%@/apiunionchannels/api/xyoffical/ios/active.php?",DOMAINURL]
#define LOGINCOUNT  [NSString stringWithFormat:@"https://%@/apiunionchannels/api/xyoffical/ios/login.php?",DOMAINURL]
#define SERVERCOUNT [NSString stringWithFormat:@"https://%@/apiunionchannels/api/xyoffical/ios/role.php?",DOMAINURL]
#endif

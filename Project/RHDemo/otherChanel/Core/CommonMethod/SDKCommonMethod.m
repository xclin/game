

#import "SDKCommonMethod.h"
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/ASIdentifierManager.h>
#import<CommonCrypto/CommonDigest.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <sys/sysctl.h>
#import "SecurityUtil.h"
#import "GTMBase64.h"
#import "YYKit.h"
#import "BaseModel.h"
#import "LQGetMessage.h"
#import "LQAlertView.h"
#import "AFNetworkReachabilityManager.h"
#import "BaseView.h"
#import "NSString+category.h"
#import "Config.h"
#import "sys/utsname.h"

#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "UserDataModel.h"

static SDKCommonMethod * shared = nil;

@interface SDKCommonMethod()
{
    UIDeviceOrientation orientation;
}
@property (nonatomic,retain) UIViewController * rootViewController;

@end

@implementation SDKCommonMethod

+ (instancetype)shared {
    static dispatch_once_t pred;
    dispatch_once(&pred,^{
        if (shared == nil) {
            shared = [[self alloc]init];
            shared.FYCid = @"1";
            shared.FYType = @"2";
        }
    });
    return shared;
}

- (int)returnOrientation{
    
    UIInterfaceOrientation sataus=[UIApplication sharedApplication].statusBarOrientation;
    return (int)sataus;
}



#pragma mark - 获取屏幕大小尺寸

+ (CGFloat)getHeight {
    if (IS_VERSION_IOS7) {
        return windowHeight;
    }
    CGFloat height = 0;
    if (windowWidth < windowHeight) {
        height = windowWidth;
    }
    else
    {
        height = windowHeight;
    }
    
    return height;
}

+(CGFloat)getWidth {
    
    
    if (IS_VERSION_IOS7) {
        return windowWidth;
    }
    CGFloat width = 0;
    if (windowWidth > windowHeight) {
        width = windowWidth;
    }
    else {
        width = windowHeight;
        
    }
    return width;
}


#pragma mark -  Device ID
/**
 *  取 唯一标识符
 *
 *  @return string
 */
- (NSString *)getDeviceID {
    NSString *deviceID = nil;
    NSString *string = [xysdkKeyChain getKeyChainWithkey:deviceIDKey];
    if (string.isValidString) {
        deviceID = string;
    } else {
        NSInteger num = arc4random() % 1000000;
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSS"];
        NSString *date =  [formatter stringFromDate:[NSDate date]];
        NSString *timeLocal = [[NSString alloc] initWithFormat:@"FY%@%ld", date,(long)num];
        [xysdkKeyChain saveKeyChainWithString:timeLocal.md5String Andkey:deviceIDKey];
    }
    return deviceID;
}

/**
 *  用于游客一键
 *
 *  @return string
 */
- (NSString* )getVisitorDeviceMSG:(NSString *)random {
    
    //如果空值，随机生成18位数
    if ([getIDFV length] == 0) {
        NSString *idfv = [NSString getRandomidfv:18];
        setIDFV(idfv);
    }
    
    NSString *network_name;
    if ([[self getNetWorkType] isEqualToString:@"WIFI"]){
        network_name = [self getWifiName];
    }else{
        network_name = [self getCarrierName];
    }
    
    NSString *ip =  [COMMONMETHOD getIPAddress]; //ip地址
    NSString *model = [COMMONMETHOD getDeviceName];//手机型号
    NSString *version = [[UIDevice currentDevice] systemVersion]; //系统版本
    NSString *resolution = [NSString stringWithFormat:@"%.0f*%.0f",[SDKCommonMethod getWidth],[SDKCommonMethod getHeight]];
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:@{@"phone_ip":ip, @"phone_model":model, @"phone_version":version,@"phone_resolution":resolution,@"idfa":[self getEquipmentIDFA],@"ver":[SDKComPlatform shared].sdkVersion,@"ver_name":[SDKComPlatform shared].sdkVersion,@"idfv":getIDFV,@"batch_no":SDKIdentifier,@"network_type":[self getNetWorkType],@"network_name":network_name,@"progress":[NSProcessInfo processInfo].processName,@"behavior_id":COMMONMETHOD.behavior_id} options:0 error:nil];
    
    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return myString;
}
- (NSString *)getEquipmentIDFV {
    //如果空值，随机生成18位数
    if ([getIDFV length] == 0) {
        NSString *idfv = [NSString getRandomidfv:18];
        setIDFV(idfv);
    }
    return getIDFV;
}


//获取广告标识
- (NSString *)getEquipmentIDFA{
    
 __block   NSString * idfaString = @"00000000-0000-0000-0000-000000000000";
    if (@available(iOS 14, *)) {
            // iOS14及以上版本需要先请求权限
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                // 获取到权限后，依然使用老方法获取idfa
                if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                    idfaString = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
                    NSLog(@"idfaString%@",idfaString);
                } else {
                         NSLog(@"请在设置-隐私-跟踪中允许App请求跟踪");
                }
            }];
        } else {
            // iOS14以下版本依然使用老方法
            // 判断在设置-隐私里用户是否打开了广告跟踪
            if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
                idfaString = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
                NSLog(@"%@",idfaString);
            } else {
                NSLog(@"请在设置-隐私-广告中打开广告跟踪功能");
            }
        }
    
    return idfaString;
}

- (NSString *)getAppName{
    
    NSDictionary *infoDictionary =[[NSBundle mainBundle] infoDictionary];
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    return app_Name;
    
}


//获取游戏版本
- (NSString *)getGameVersion{
    
    NSDictionary *infoDictionary =[[NSBundle mainBundle] infoDictionary];
    // app版本

    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];


    
  return app_Version;
}

//ssid
- (id)fetchSSIDInfo {
    
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) { break; }
    }
    return info;
}
//wifi名、地址
- (NSString *)getWifiName
{
    NSString *wifiName = nil;
    NSString *bssid = nil;
    NSDictionary *networkInfo = (NSDictionary*)[self fetchSSIDInfo];
    wifiName = [networkInfo objectForKey:(__bridge NSString*)kCNNetworkInfoKeySSID];
    bssid = [networkInfo objectForKey:(__bridge NSString*)kCNNetworkInfoKeyBSSID];
    return [NSString stringWithFormat:@"%@__%@",wifiName,bssid];
}

//获取网络类型
- (NSString *)getNetWorkType{
    NSString *strNetworkType = @"";
    
    //创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_storage zeroAddress;
    
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.ss_len = sizeof(zeroAddress);
    zeroAddress.ss_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability =SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    //获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    //如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags)
    {
        return strNetworkType;
    }
    
    //没有网络
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
    {
        return @"";
    }
    
    if ((flags &kSCNetworkReachabilityFlagsConnectionRequired) ==0)
    {
        // if target host is reachable and no connection is required
        // then we'll assume (for now) that your on Wi-Fi
        strNetworkType = @"WIFI";
    }
    
    if (
        ((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) !=0) ||
        (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) !=0
        )
    {
        // ... and the connection is on-demand (or on-traffic) if the
        // calling application is using the CFSocketStream or higher APIs
        if ((flags &kSCNetworkReachabilityFlagsInterventionRequired) ==0)
        {
            // ... and no [user] intervention is needed
            strNetworkType = @"WIFI";
        }
    }
    
    if ((flags &kSCNetworkReachabilityFlagsIsWWAN) ==kSCNetworkReachabilityFlagsIsWWAN)
    {
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >=7.0)
        {
            CTTelephonyNetworkInfo * info = [[CTTelephonyNetworkInfo alloc]init];
            NSString *currentRadioAccessTechnology = info.currentRadioAccessTechnology;
            
            if (currentRadioAccessTechnology)
            {
                if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE])
                {
                    strNetworkType =  @"4G";
                }
                else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS])
                {
                    strNetworkType =  @"2G";
                }
                else
                {
                    strNetworkType =  @"3G";
                }
            }
        }
        else
        {
            if((flags &kSCNetworkReachabilityFlagsReachable) ==kSCNetworkReachabilityFlagsReachable)
            {
                if ((flags &kSCNetworkReachabilityFlagsTransientConnection) ==kSCNetworkReachabilityFlagsTransientConnection)
                {
                    if((flags &kSCNetworkReachabilityFlagsConnectionRequired) ==kSCNetworkReachabilityFlagsConnectionRequired)
                    {
                        strNetworkType = @"2G";
                    }
                    else
                    {
                        strNetworkType = @"3G";
                    }
                }
            }
        }
    }
    
    if ([strNetworkType isEqualToString:@""]) {
        strNetworkType = @"WWAN";
    }
    
    return strNetworkType;
}
//运营商
- (NSString *)getCarrierName{
    CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [telephonyInfo subscriberCellularProvider];
    NSString *currentCountry = [carrier carrierName];
    return currentCountry;
}

/**
 *  取 设备信息
 *
 *  @return string
 */
- (NSString* )getDeviceMSG {
    //如果空值，随机生成18位数
    if ([getIDFV length] == 0) {
        NSString *idfv = [NSString getRandomidfv:18];
        setIDFV(idfv);
    }
    NSString *network_name;
    if ([[self getNetWorkType] isEqualToString:@"WIFI"]){
        network_name = [self getWifiName];
    }else{
        network_name = [self getCarrierName];
    }
    NSString *ip =  [COMMONMETHOD getIPAddress]; //ip地址
    NSString *model = [COMMONMETHOD getDeviceName];//手机型号
    NSString *version = [[UIDevice currentDevice] systemVersion]; //系统版本
    NSString *resolution = [NSString stringWithFormat:@"%.0f*%.0f",[SDKCommonMethod getWidth],[SDKCommonMethod getHeight]];
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:@{@"phone_ip":ip, @"phone_model":model, @"phone_version":version,@"phone_resolution":resolution,@"idfa":[self getEquipmentIDFA],@"ver":[SDKComPlatform shared].sdkGameVersion,@"idfv":getIDFV,@"batch_no":SDKIdentifier,@"network_type":[self getNetWorkType],@"network_name":network_name,@"progress":[NSProcessInfo processInfo].processName,@"behavior_id":COMMONMETHOD.behavior_id} options:0 error:nil];
    
    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return myString;
}

- (NSString* )getRest {
    //如果空值，随机生成18位数
    if ([getIDFV length] == 0) {
        NSString *idfv = [NSString getRandomidfv:18];
        setIDFV(idfv);
    }
    NSString *network_name;
    if ([[self getNetWorkType] isEqualToString:@"WIFI"]){
        network_name = [self getWifiName];
    }else{
        network_name = [self getCarrierName];
    }
    NSString *ip =  [COMMONMETHOD getIPAddress]; //ip地址
    NSString *model = [COMMONMETHOD getDeviceName];//手机型号
    NSString *version = [[UIDevice currentDevice] systemVersion]; //系统版本
    NSString *resolution = [NSString stringWithFormat:@"%.0f*%.0f",[SDKCommonMethod getWidth],[SDKCommonMethod getHeight]];
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:@{@"phone_ip":ip, @"phone_model":model, @"phone_version":version,@"phone_resolution":resolution,@"idfa":[self getEquipmentIDFA],@"ver":[SDKComPlatform shared].sdkGameVersion,@"idfv":getIDFV,@"batch_no":SDKIdentifier,@"network_type":[self getNetWorkType],@"network_name":network_name,@"progress":[NSProcessInfo processInfo].processName,@"behavior_id":COMMONMETHOD.behavior_id} options:0 error:nil];
    
    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return myString;
}


/**
 *  取 本机ip
 *
 *  @return string
 */
- (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            if (temp_addr->ifa_addr->sa_family == AF_INET6) {
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}

/**
 *  获得设备型号
 *
 *  @return string
 */
- (NSString *)getCurrentDeviceModel {
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    return platform;
}
/**
 *  获得设备名字
 *
 *  @return string
 */
- (NSString *)getDeviceName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceString isEqualToString:@"iPhone3,1"])
        return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])
        return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"])
        return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])
        return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])
        return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])
        return @"iPhone 5 (GSM_CDMA)";
    if ([deviceString isEqualToString:@"iPhone5,3"])
        return @"iPhone 5c (GSM)";
    if ([deviceString isEqualToString:@"iPhone5,4"])
        return @"iPhone 5c (GSM_CDMA)";
    if ([deviceString isEqualToString:@"iPhone6,1"])
        return @"iPhone 5s (GSM)";
    if ([deviceString isEqualToString:@"iPhone6,2"])
        return @"iPhone 5s (GSM_CDMA)";
    if ([deviceString isEqualToString:@"iPhone7,1"])
        return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])
        return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])
        return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])
        return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])
        return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone11,2"])
        return @"iPhone XS";
    if ([deviceString isEqualToString:@"iPhone11,4"])
        return @"iPhone XS Max";
    if ([deviceString isEqualToString:@"iPhone11,6"])
        return @"iPhone XS Max";
    if ([deviceString isEqualToString:@"iPhone11,8"])
        return @"iPhone XR";
    if ([deviceString isEqualToString:@"iPhone12,1"])
        return @"iPhone 11";
    if ([deviceString isEqualToString:@"iPhone12,3"])
        return @"iPhone 11 Pro";
    if ([deviceString isEqualToString:@"iPhone12,5"])
        return @"iPhone 11 Pro Max";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([deviceString isEqualToString:@"iPhone9,1"])
        return @"国行_日版_港行iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])
        return @"港行_国行iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone9,3"])
        return @"美版_台版iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,4"])
        return @"美版_台版iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"])
        return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,4"])
        return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"])
        return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,5"])
        return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"])
        return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone10,6"])
        return @"iPhone X";
    if ([deviceString isEqualToString:@"iPod1,1"])
        return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])
        return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])
        return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])
        return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])
        return @"iPod Touch (5 Gen)";
    if ([deviceString isEqualToString:@"iPad1,1"])
        return @"iPad";
    if ([deviceString isEqualToString:@"iPad1,2"])
        return @"iPad 3G";
    if ([deviceString isEqualToString:@"iPad2,1"])
        return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])
        return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,3"])
        return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])
        return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,5"])
        return @"iPad Mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])
        return @"iPad Mini";
    if ([deviceString isEqualToString:@"iPad2,7"])
        return @"iPad Mini (GSM_CDMA)";
    if ([deviceString isEqualToString:@"iPad3,1"])
        return @"iPad 3 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])
        return @"iPad 3 (GSM_CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])
        return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"])
        return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])
        return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"])
        return @"iPad 4 (GSM_CDMA)";
    if ([deviceString isEqualToString:@"iPad4,1"])
        return @"iPad Air (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,2"])
        return @"iPad Air (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,4"])
        return @"iPad Mini 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,5"])
        return @"iPad Mini 2 (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,6"])
        return @"iPad Mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"])
        return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,8"])
        return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,9"])
        return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"])
        return @"iPad Mini 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad5,2"])
        return @"iPad Mini 4 (LTE)";
    if ([deviceString isEqualToString:@"iPad5,3"])
        return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])
        return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,3"])
        return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,4"])
        return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,7"])
        return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,8"])
        return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"i386"])
        return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])
        return @"Simulator";
    
    return deviceString;
    
}
#pragma mark - rootViewController
/**
 *  获取rootViewController
 *
 *  @return rootViewController
 */
- (UIViewController*)getRootViewController {
    if (_rootViewController) {

        return _rootViewController;
    }else {

        return  [COMMONMETHOD getCurrentRootViewController];
    }
    
}

/**
 *  存进rootViewController
 *
 *  @param vc rootViewController
 */
- (void)setRootViewControllerWithViewController:(UIViewController*)vc
{
    if (vc && [vc isKindOfClass:[UIViewController class]]) {
        
        _rootViewController = vc;
    }
}

-(UIViewController *)getCurrentRootViewController {
    UIViewController *result;
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    if (topWindow.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(topWindow in windows)
        {
            if (topWindow.windowLevel == UIWindowLevelNormal)
                break;
        }
    }
    UIView *rootView = [[topWindow subviews] objectAtIndex:0];
    
    id nextResponder = [rootView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else if (topWindow.rootViewController != nil)
        result = topWindow.rootViewController;
    else
        NSAssert(NO, @"SCould not find a root view controller.  You can assign one manually by calling [[SHK currentHelper] setRootViewController:YOURROOTVIEWCONTROLLER].");
    return result;
}
#pragma mark - md5加密
- (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

#pragma mark - base64 加密、解密
/**
 *  Base64 加密方式
 *
 *  @param encryptString 需要加密的字符串
 *
 *  @return 加密后的字符串
 */
+ (NSString *)encryptBase64WithString:(NSString *)encryptString{
    encryptString = [NSString stringWithFormat:@"%@",encryptString];
    NSString *encryptStr = [[NSString alloc] init];
    if (![encryptString isValidString]) {
        return @"";
    } else {
        encryptStr = [SecurityUtil encryptAESData:encryptString app_key:[NSString stringWithFormat:@"%@%@", [INITCONFIGURE.privateKey substringWithRange:NSMakeRange(0, 6)], [INITCONFIGURE.appKey substringWithRange:NSMakeRange(0, 6)]]];
    }
    return encryptStr;
}

/**
 *   Base64 解密方式
 *
 *  @param decodeString 需要解密的字符串
 *
 *  @return 解密后的字符串
 */
+ (NSString *)decodeBase64WithString:(NSString *)decodeString{
    NSString *decodeStr = [[NSString alloc] init];
    if (![decodeString isValidString]) {
        return @"";
    } else {
        NSData *EncryptData = [GTMBase64 decodeString:decodeString]; //解密前进行GTMBase64编码
        decodeStr = [SecurityUtil decryptAESData:EncryptData app_key:[NSString stringWithFormat:@"%@%@", [INITCONFIGURE.privateKey substringWithRange:NSMakeRange(0, 6)], [INITCONFIGURE.appKey substringWithRange:NSMakeRange(0, 6)]]];
    }
    return decodeStr;
}

#pragma mark - 判断登录
- (BOOL)isLogin {
    BOOL isLogin = YES;
    if (![NSUserDefaults takeoutNSUserDefault:ISLOGIN]) {
        isLogin = NO;
        [SDKComPlatform.shared loginSDK];
    }
    return isLogin;
}

#pragma mark - 获取sdk生成账号的密码
- (NSString *)getInitGameAccountPassword {
    NSString *password = @"";
    if ([NSUserDefaults takeoutNSUserDefault:InitGameAccount]) {
        NSArray *ary = [[NSUserDefaults takeoutNSUserDefault:InitGameAccount] componentsSeparatedByString:@"|"];
        if ([ary[0] isEqualToString:[NSUserDefaults takeoutNSUserDefault:LASTLOGINUID]]) {
            password = ary[1];
        }
    }
    return password;
}

- (BOOL)isShowBadgeNum {
    if (_msgBadgeNum != 0 || _giftBadgeNum != 0 || _cardBadgeNum == 0 || _phoneBadgeNum == 0) {
        return YES;
    }
    return NO;
}

+ (void) showWebLogWithDomain:(NSString*) domain model:(requestModel*) model object:(id) responseObject succeed:(BOOL)succeed{
    NSDictionary * jsonModel = model.jsonModel;
    NSArray * sortedKeys = [jsonModel.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *  _Nonnull obj1, NSString *  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    NSMutableString * queryString = [NSMutableString new];
    for (int i = 0; i < sortedKeys.count; i++) {
        NSString * key = sortedKeys[i];
        [queryString appendFormat:@"%@=%@%@",key,jsonModel[key],i == sortedKeys.count-1 ? @"":@"&"];
    }
    NSString * query = [queryString stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "] invertedSet]];
    NSString * str;
    NSString * url = [NSString stringWithFormat:@"%@%@",domain,query];
    if ([responseObject isKindOfClass:[NSData class]]) {
        NSMutableDictionary *jsonDict = [[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil] mutableCopy];
        if (jsonDict) {
            if ([jsonDict containsObjectForKey:@"protocol_new"]) {
                [jsonDict removeObjectForKey:@"protocol_new"];
            }
            responseObject= [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:nil];
        }
        str = [[ NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
    } else {
        str = [NSString stringWithFormat:@"%@",responseObject];
    }
    if (!succeed) {
        if ([responseObject isKindOfClass:[NSError class]]) {
            NSError * err = responseObject;
            [[LQLogger shared] uploadLogWithUrl:url error:[NSString stringWithFormat:@"%@ %@",err.localizedDescription,err.localizedFailureReason]];
        } else {
            [[LQLogger shared] uploadLogWithUrl:url error:str];
        }
    }
    LQGetMessage * message = [LQGetMessage messageWithInput:url output:str succeed:succeed];
    LQLog(message);
}


+ (void) reconnectAlertWithAction:(requestModel *)model
                             time:(CGFloat)time
                           action:(dispatch_block_t)action {
    NSString * message = @"";
    if([AFNetworkReachabilityManager sharedManager].reachable) {
        message = @"网络连接超时，请检查网络后重新尝试。";
        message = [NSString stringWithFormat:@"%@\ncode:%@_%.3f_%@",message,model.domain,time,[self getNowTime]];
    } else {
        message = @"网络连接失败，请检查网络后重新尝试。";
        
    }
    
    LQAlertView * alert = [[LQAlertView alloc] initWithTitle:@"重连提示"
                                                     message:message
                                                     actions:@[[LQAlertAction actionWithTitle:@"重连" handler:action]]];
    [alert show];
}


//当前北京时间
+ (NSString *)getNowTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYYMMddHHmmss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间
    return [formatter stringFromDate:datenow];
}


#pragma mark---当前时间的时间戳 --10位
+ (NSString *)getTimeStamp{
    NSDate* date = [NSDate date];
    NSTimeInterval time = [date timeIntervalSince1970];
    NSString *timeStr = [NSString stringWithFormat:@"%.0f",time];
    return timeStr;
}




- (void)saveUserSwitchVerification{
    NSString *keyVerStr = [NSString stringWithFormat:@"UserNameCount%@",[SDKCommonMethod shared].c_uid];
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:keyVerStr];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL) getUserSwitchVerification {
    NSString *keyVerStr = [NSString stringWithFormat:@"UserNameCount%@",[SDKCommonMethod shared].c_uid];
    NSString *keyVerBool  =[[NSUserDefaults standardUserDefaults] objectForKey:keyVerStr];
    if ([keyVerBool isEqualToString:@"YES"]) {
        return YES;
    }
    return NO;
}


/**
 保存玩家年龄
 
 @param ageStr 年龄
 */
- (void)saveUserAge:(NSString *)ageStr{
    
    [UserDataModel updateUserAgeByUid:[SDKCommonMethod shared].c_uid userAge:ageStr];
    
    
}


//登录token未过期
+ (BOOL) returnExpiresinDeadLine :(NSString *)userId{
    NSArray *array = [UserDataModel selectUserAccount:userId];
    UserModel *dataModel = nil;
    if (array.count>0) {
        dataModel = array[0];
    }
    int expires_in = [dataModel.expires_in intValue];//10位
    //后取当前的时间戳
    int nowTime = [[SDKCommonMethod getTimeStamp] intValue];
    if ((expires_in - nowTime) > 0) {//未过期
        return YES;
    }
    
    return NO;
    
}

//登录token离现在时间是否大于0小于1小时 未过期
+ (BOOL) returnExpiresinanyHour:(NSString *)userId{
    NSArray *array = [UserDataModel selectUserAccount:userId];
    UserModel *dataModel = nil;
    if (array.count>0) {
        dataModel = array[0];
    }
    int expires_in = [dataModel.expires_in intValue];//10位
    //后取当前的时间戳
    int nowTime = [[SDKCommonMethod getTimeStamp] intValue];
    if ((expires_in - nowTime) > 0 && (expires_in - nowTime) < (1*60*60)){//未过期 并且小于nay小时
        return  YES;
    }
    return NO;
}



//刷新token
+ (BOOL) returnRefreshTokenDeadLine:(NSString *)userId{
    NSArray *array = [UserDataModel selectUserAccount:userId];
    UserModel *dataModel = nil;
    if (array.count>0) {
        dataModel = array[0];
    }
    int nowTime = [[SDKCommonMethod getTimeStamp] intValue];
    int refresh_token_expires_in = [dataModel.refresh_token_expires_in intValue];//10位
    //后取当前的时间戳

    if((refresh_token_expires_in - nowTime) > 0){//
    
        return YES;
    }
    return NO;
}



//当前北京时间
+ (NSString *)getTimeMethod{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间
    return [formatter stringFromDate:datenow];
}



-(int)compareDate:(NSString*)date01 withDate:(NSString*)date02{

    int ci;

    NSDateFormatter *df = [[NSDateFormatter alloc] init];

    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    NSDate *dt1 = [[NSDate alloc] init];

    NSDate *dt2 = [[NSDate alloc] init];

    dt1 = [df dateFromString:date01];

    dt2 = [df dateFromString:date02];

    NSComparisonResult result = [dt1 compare:dt2];

    switch (result)

    {

        //date02比date01大

        case NSOrderedAscending:
            ci=1;
            break;

        //date02比date01小

        case NSOrderedDescending:
            ci=-1;
            break;

        //date02=date01 相等，也返回大

        case NSOrderedSame:
            ci=1;
            break;

        default:
            break;

    }

    return ci;

}




@end

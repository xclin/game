

#import "LQLogger.h"
#import "LQTextView.h"
#import "LQGetMessage.h"
#import "LQMenuView.h"
#import "LQLogViewController.h"
#import "LQWebMessageListViweController.h"
#import "LQFileExploreViewController.h"
#import "SDKCommonMethod.h"
#import "UIDevice+YYAdd.h"
#import "AFNetworkReachabilityManager.h"
#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>
@import UIKit;
@import CoreTelephony;
@implementation LQLogger {
    NSMutableArray * logs;
    UIDocumentInteractionController * c;
    NSMutableDictionary * urlDictionary;
}
LQSingletonInstanceMMethod(LQLogger,^{
    [instance setup];
})

- (void) setup {
    //打印上次崩溃日志
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString * filePath = [path stringByAppendingPathComponent:@"crashlog.txt"];
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        NSString * string = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:filePath] encoding:NSUTF8StringEncoding];
        LQMessage * m = [LQMessage messageWithColor:LQColorRed message:[NSString stringWithFormat:@"\n上次崩溃信息\n%@",string]];
        [self log:m];
    }
    urlDictionary = [NSMutableDictionary new];
}


- (NSArray*) warningKeys {
    if (!_warningKeys) {
        _warningKeys =  @[@"警告",@"warning",@"leaked"];
    }
    return _warningKeys;
}

- (NSArray*) errorKeys {
    if (!_errorKeys) {
        _errorKeys = @[@"崩溃",@"不成功",@"失败",@"错误",@"没有",@"未知",@"不能",@"无法",@"error",@"could not",@"unknown"];
    }
    return _errorKeys;
}

- (void) log:(LQMessage *) message {
    if (logs == nil) {
        logs = [NSMutableArray new];
    }
    [logs addObject:message];
    NSAttributedString * attr = message.attributedStringWithTime;
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.shouldShowBarrage) {
            UILabel * label = [UILabel new];
            label.text = message.attributedString.string;
            label.numberOfLines = 100;
            label.textColor = message.uiColor;
            label.font = [UIFont systemFontOfSize:12];
            label.frame = CGRectMake(0, 0, 300, [label.text boundingRectWithSize:CGSizeMake(300, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size.height);
            CGRect rect = label.frame;
            NSInteger y = random() % (NSInteger)([UIScreen mainScreen].bounds.size.height - label.frame.size.height);
            rect.origin = CGPointMake([UIScreen mainScreen].bounds.size.width, y);
            label.frame = rect;
            //NSLog(@"%@",logs);
            //[[LQBarrageView shared] addSubview:label];
            [UIView animateWithDuration:10 animations:^{
                label.frame = CGRectMake(-label.frame.size.width, label.frame.origin.y, label.frame.size.width, label.frame.size.height);
            } completion:^(BOOL finished) {
                [label removeFromSuperview];
            }];
        }
        if (self.shouldShowLog) {
            [[LQTextView shared].textStorage appendAttributedString:attr];
            [[LQTextView shared] scrollRangeToVisible:NSMakeRange([LQTextView shared].textStorage.length-attr.string.length,attr.length)];
        }

    });
    
}


- (NSAttributedString*) attributedString {
    NSMutableAttributedString * string = [NSMutableAttributedString new];
    NSDateFormatter * df = [NSDateFormatter new];
    [df setDateFormat:@"MM-dd HH:mm:ss"];
    [logs enumerateObjectsUsingBlock:^(LQMessage *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [string appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:",[df stringFromDate:[NSDate dateWithTimeIntervalSince1970:obj.time]]] attributes:@{NSForegroundColorAttributeName:obj.uiColor,NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
        [string appendAttributedString:[obj attributedString]];
        [string appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    }];
    return string;
}

- (void) copyToPastboard {
    UIPasteboard.generalPasteboard.string = [self attributedString].string;
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"复制成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    });
}

- (void) share {
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL showAlert = YES;
        if (showAlert) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"操作" message:@"选择操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"复制文本",@"导出rtf文件",@"导出html文件", nil];
            [alert show];

        } else {
            [self shareLog];
        }
    });
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            [[LQLogger shared] copyToPastboard];
        }
            break;
        case 2:
            [[LQLogger shared] shareRTF];
            break;
        case 3:
            [[LQLogger shared] shareHTML];
            break;
        default:
            break;
    }
}

- (void) shareRTF {
    [self shareWithType:NSRTFTextDocumentType postfix:@"rtf"];
}
- (void) shareHTML {
    [self shareWithType:NSHTMLTextDocumentType postfix:@"html"];
}

- (void) shareText {
    [self shareWithType:NSRTFTextDocumentType postfix:@"rtf"];
}
- (void) shareLog {
    [self shareWithType:NSPlainTextDocumentType postfix:@"log"];
}

- (void) shareWithType:(NSString*) type postfix:(NSString*) postfix{
    NSAttributedString * attr = self.attributedString;
    NSString * path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"shareContents"];
    NSFileManager * manager = [NSFileManager defaultManager];
    NSError * error;
    if (![manager fileExistsAtPath:path isDirectory:nil]) {
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    NSString * filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",[NSUUID UUID].UUIDString,postfix]];
    NSDictionary *tempDic = @{NSDocumentTypeDocumentAttribute:type,
                              NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]};
    NSData *htmlData = [attr dataFromRange:NSMakeRange(0, attr.length)
                        documentAttributes:tempDic
                                     error:nil];
    [manager createFileAtPath:filePath contents:htmlData attributes:nil];
    UIViewController * top = [LQLogger rootPresentedController];
    c =
    [UIDocumentInteractionController
     interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    [c presentOpenInMenuFromRect:CGRectZero
                          inView:top.view
                        animated:YES];
}
- (void) showHideBarrage {
    self.shouldShowBarrage = !self.shouldShowBarrage;
}


- (void) setShouldShowBarrage:(BOOL)shouldShowBarrage{
    _shouldShowBarrage = shouldShowBarrage;
    if (_shouldShowBarrage) {
       // [[LQBarrageView shared] show];
    } else {
        //[[LQBarrageView shared] hide];
    }
}

- (void) setShouldShowLog:(BOOL)shouldShowLog {
    _shouldShowLog = shouldShowLog;
    if (_shouldShowLog) {
        LQLogViewController * controller = [LQLogViewController shared];
        [LQTextView shared].attributedText = [self attributedString];
        [LQTextView shared].translatesAutoresizingMaskIntoConstraints = NO;
        [controller.view insertSubview:[LQTextView shared] atIndex:0];
        UIView * containerView = controller.view;
        [containerView addConstraint:[NSLayoutConstraint constraintWithItem:[LQTextView shared] attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
        [containerView addConstraint:[NSLayoutConstraint constraintWithItem:[LQTextView shared] attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
        [containerView addConstraint:[NSLayoutConstraint constraintWithItem:[LQTextView shared] attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
        [containerView addConstraint:[NSLayoutConstraint constraintWithItem:[LQTextView shared] attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    } else {
        [[LQTextView shared] removeFromSuperview];
    }
}


- (NSArray*) webMessages {
    return [logs filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject isKindOfClass:[LQGetMessage class]];
    }]];
}

- (void) recoverIfNeeded {
    NSDictionary * settings = [[NSUserDefaults standardUserDefaults] objectForKey:@"LQMenuViewShow"];
    if (settings) {
        _shouldRecordStatus = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [LQLogger shared].shouldShowMenu = YES;
            [LQMenuView shared].center = CGPointFromString([settings objectForKey:@"center"]);
        });
    }
}

- (void) setShouldRecordStatus:(BOOL)shouldRecordStatus {
    _shouldRecordStatus = shouldRecordStatus;
    if(_shouldRecordStatus) {
        [self recordStatus];
    } else {
        [self removeStatus];
    }
}

- (void) recordStatus {
    
    [[NSUserDefaults standardUserDefaults] setObject:@{
                                                       @"center":[NSString stringWithFormat:@"{%f,%f}",[LQMenuView shared].center.x,[LQMenuView shared].center.y]                                                       } forKey:@"LQMenuViewShow"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void) removeStatus {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LQMenuViewShow"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) setShouldShowMenu:(BOOL)shouldShowMenu{
    _shouldShowMenu = shouldShowMenu;
    if (_shouldShowMenu) {
        [[LQMenuView shared] show];
    } else {
        [[LQMenuView shared] hide];
    }
}

+ (UIViewController*) rootPresentedController {
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
    else {
      //  NSLog(@"警告，没有根控制器");
        return nil;
    }
    while (result.presentedViewController)
    {
        result = result.presentedViewController;
    }
    return result;
}

- (BOOL) isUnExpectedURL:(NSString*) url {
    return
    [url containsString:@"action=getversion"] ||
    [url containsString:@"action=active"] ||
    [url containsString:@"action=get_menu_new"] ||
    [url containsString:@"action=checkCertification"]||
    [url containsString:@"ps/ps"] ||
    [url containsString:@"action=verify_switc"];
}

- (void) uploadLogWithUrl:(NSString*) url error:(NSString*) error{
    return;
    NSTimeInterval time = [NSDate new].timeIntervalSince1970;
    //过滤重复请求
    if(ABS(time-[urlDictionary[url] doubleValue]) < 10) {return;}
    //过滤掉不需要的请求
    if ([self isUnExpectedURL:url]) {return;}
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    dic[@"gid"] = INITCONFIGURE.gid;
    dic[@"gname"] = @"--0--";
    dic[@"deviceno"] = COMMONMETHOD.FYdeviceNo;
    dic[@"type"] = @"2";
    urlDictionary[url] = @(time);
    dic[@"time"] = @(time);
    dic[@"cid"] = @"1";
    NSMutableDictionary * dic2 = [NSMutableDictionary new];
    dic2[@"url"] = url;
    dic2[@"packageName"] = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier * ct = [info subscriberCellularProvider];
    if (ct) {
        dic2[@"carrierName"] = ct.carrierName;
        dic2[@"countryCode"] = ct.isoCountryCode;
    }
    NSString * tec = [info.currentRadioAccessTechnology stringByReplacingOccurrencesOfString:@"CTRadioAccessTechnology" withString:@""];
    if(tec) {
        dic2[@"radioAccessTechnology"] = tec;
    }
    dic2[@"phoneModel"] = [UIDevice currentDevice].machineModelName;
    dic2[@"reachableViaWiFi"] = @([AFNetworkReachabilityManager sharedManager].reachableViaWiFi);
    dic2[@"reachableViaWWAN"] = @([AFNetworkReachabilityManager sharedManager].reachableViaWWAN);
    dic2[@"isIpv6"] = @([[self class] isIpv6]);
    if ([UIDevice currentDevice].ipAddressWIFI) {
        dic2[@"wifiAddress"] = [UIDevice currentDevice].ipAddressWIFI;
    }
    if ([UIDevice currentDevice].ipAddressCell) {
        dic2[@"cellAddress"] = [UIDevice currentDevice].ipAddressCell;
    }
    dic2[@"versionName"] = INITCONFIGURE.version;
    dic2[@"systemsVersion"] = [UIDevice currentDevice].systemVersion;
    dic2[@"error"] = error;
    NSData * data = [NSJSONSerialization dataWithJSONObject:dic2 options:NSJSONWritingPrettyPrinted error:nil];
    NSString * errorLog = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
    errorLog = [errorLog stringByReplacingOccurrencesOfString:@" " withString:@""];
    errorLog = [errorLog stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    dic[@"errorLog"] = errorLog;
    NSMutableString * kvp = [@"http://sdkelog.65.com/sdk_error_log.php?" mutableCopy];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [kvp appendFormat:@"%@=%@&",key,[obj isKindOfClass:[NSString class]] ? [obj stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> &?"] invertedSet]] : obj];
    }];
    [kvp replaceCharactersInRange:NSMakeRange(kvp.length-1, 1) withString:@""];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kvp]];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    }] resume];
}

- (NSString *)getIPAddress
{
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    NSString *wifiAddress = nil;
    NSString *cellAddress = nil;
    // retrieve the current interfaces - returns 0 on success
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            sa_family_t sa_type = temp_addr->ifa_addr->sa_family;
            if(sa_type == AF_INET || sa_type == AF_INET6) {
                NSString *name = [NSString stringWithUTF8String:temp_addr->ifa_name];
                NSString *addr = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]; // pdp_ip0
                if([name isEqualToString:@"en0"]) {
                    // Interface is the wifi connection on the iPhone
                    wifiAddress = addr;
                } else
                    if([name isEqualToString:@"pdp_ip0"]) {
                        // Interface is the cell connection on the iPhone
                        cellAddress = addr;
                    }
            }
            temp_addr = temp_addr->ifa_next;
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    NSString *addr = wifiAddress ? wifiAddress : cellAddress;
    return addr ? addr : @"0.0.0.0";
}

+ (BOOL)isIpv6{
    NSArray *searchArray =
    @[ IOS_VPN @"/" IP_ADDR_IPv6,
       IOS_VPN @"/" IP_ADDR_IPv4,
       IOS_WIFI @"/" IP_ADDR_IPv6,
       IOS_WIFI @"/" IP_ADDR_IPv4,
       IOS_CELLULAR @"/" IP_ADDR_IPv6,
       IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    __block BOOL isIpv6 = NO;
    
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         if ([key rangeOfString:@"ipv6"].length > 0  && ![[NSString stringWithFormat:@"%@",addresses[key]] hasPrefix:@"(null)"] ) {
             if ( ![addresses[key] hasPrefix:@"fe80"]) {
                 isIpv6 = YES;
             }
         }
         
     }];
    
    return isIpv6;
}

+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}
@end

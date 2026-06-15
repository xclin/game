
#import "LQLogger.h"
#define windowWidth ([UIScreen mainScreen].bounds.size.width)
#define windowHeight ([UIScreen mainScreen].bounds.size.height)

#define IS_VERSION_IOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0

#define Alert(msg)     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知栏" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];\
alert.window.windowLevel = 2001;\
[alert show];

#define kSetupBadgeNoticationName @"SetupBadgeNoticationName"

#define setVIEWPATH(VIEWPATH) [[NSUserDefaults standardUserDefaults] setObject:(VIEWPATH) forKey:@"VIEWPATH"];[[NSUserDefaults standardUserDefaults] synchronize];
#define getVIEWPATH [[NSUserDefaults standardUserDefaults] objectForKey:@"VIEWPATH"]
//SDK出包版本标识（域名_bundleID_后台版本号_当前日期时分秒（每次出包都手动写）），每次出包需手动修改
#define SDKIdentifier [NSString stringWithFormat:@"%@__%@2021-10-26",BATCH_NO,[[NSBundle mainBundle] bundleIdentifier]]

///发出取消的通知
#define CancelNoticationName @"CancelNoticationName"
#define PostCancelNotification() [[NSNotificationCenter defaultCenter] postNotificationName:CancelNoticationName object:[self class]];
//测试,发布要改成release版本
#define DEBUGSTR(fmt, ...) [NSString stringWithFormat:(@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__]
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 40000
#define DEBUGMSG(fmt,...) [[LQLogger shared] log:DebugMessage(DEBUGSTR(fmt, ##__VA_ARGS__))];NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DEBUGMSG(fmt,...) [[LQLogger shared] log:DebugMessage(DEBUGSTR(fmt,##__VA_ARGS__))];
#endif

#define AddRecognizeStarGestureRecognizer(view,fuck)     [WTMGlyphGestureRecognizer addGestureToView:view handler:^(NSString *glyph) {\
if ([glyph isEqualToString:@"star"]) {\
        BOOL b = ![NSUserDefaults takeoutNSUserDefault:LOGSWITCH] || [[[NSUserDefaults takeoutNSUserDefault:LOGSWITCH] description] integerValue] != 0;\
        fuck();\
    if (b) {\
        [LQLogger shared].shouldShowMenu = YES;\
    }\
}\
}];

//设置是否隐藏SDK界面的关闭按钮，默认读后台返回状态，1为关闭
#define setHIDECANNELBTN(HIDECANNELBTN) [[NSUserDefaults standardUserDefaults] setObject:(HIDECANNELBTN) forKey:@"HIDECANNELBTN"];[[NSUserDefaults standardUserDefaults] synchronize];

#define getHIDECANNELBTN [[NSUserDefaults standardUserDefaults] objectForKey:@"HIDECANNELBTN"]

#define UserViewHeight  280



//#define SCREEN_FIT(wiDth) (wiDth)

#define UserViewWidth  (([COMMONMETHOD returnOrientation] == 3 || [COMMONMETHOD returnOrientation] == 4) ? 380 : (([SDKCommonMethod getWidth] > [SDKCommonMethod getHeight] ? [SDKCommonMethod getHeight] : [SDKCommonMethod getWidth]) > 320 ? 320 :([SDKCommonMethod getWidth] > [SDKCommonMethod getHeight] ? [SDKCommonMethod getHeight] : [SDKCommonMethod getWidth]) - 15))


#define SCREEN_FIT(wiDth)  (([COMMONMETHOD returnOrientation] == 3 || [COMMONMETHOD returnOrientation] == 4) ? ([UIScreen mainScreen].bounds.size.width / 736.0f)* wiDth :([UIScreen mainScreen].bounds.size.height / 736.0f)* wiDth)


#define ZKUserViewHeight  (([COMMONMETHOD returnOrientation] == 3 || [COMMONMETHOD returnOrientation] == 4) ? windowHeight :windowHeight-SCREEN_FIT(200))


#define ZKUserViewWidth   (([COMMONMETHOD returnOrientation] == 3 || [COMMONMETHOD returnOrientation] == 4) ? 350 : windowWidth-SCREEN_FIT(35))

//记录倒计时
#define setTimeDown(TimeDown) [[NSUserDefaults standardUserDefaults] setObject:(TimeDown) forKey:@"TimeDown"];[[NSUserDefaults standardUserDefaults] synchronize];

#define getTimeDown [[NSUserDefaults standardUserDefaults] objectForKey:@"TimeDown"]



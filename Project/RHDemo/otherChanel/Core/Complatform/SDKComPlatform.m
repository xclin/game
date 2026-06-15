

#import "SDKComPlatform.h"
#import "SDKCommonMethod.h"
#import "SuspensionView.h"
#import "SDKComplatformBase.h"
#import "RequestUtil.h"
#import "DataBaseManager.h"
#import "zhongkeIAPManager.h"
#import "SDKCommonMethod.h"
#import "sdkInitRequestManager.h"
#import "sdkActivityIndicatorView.h"
#import "LQMenuView.h"
#import "LQStatusViewController.h"
#import "LQLogViewController.h"
#import "UserDataModel.h"
#import <AdSupport/AdSupport.h>
static InitConfigure * sharedInitConfigure = nil;
@interface InitConfigure ()<UIAlertViewDelegate>
@end
@implementation InitConfigure
+ (instancetype)shared {
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        if (sharedInitConfigure == nil) {
            sharedInitConfigure = [[self alloc]init];
            [DataBaseManager sharedInstance];
            
            COMMONMETHOD.FYDeviceToken = [COMMONMETHOD getDeviceID];
            //先给一个随机的UUID
            COMMONMETHOD.FYdeviceNo = [NSUUID UUID].UUIDString;
            NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
            [LQMenuView shared].items = @[
                                          [LQMenuItem itemWithTitle:@"所有日志" image:[UIImage new] action:^{
                                              [[LQLogViewController shared] present];
                                          }],
                                          [LQMenuItem itemWithTitle:@"导出日志" image:[UIImage new] action:^{
                                              [[LQLogger shared] shareText];
                                          }],
                                          [LQMenuItem itemWithTitle:@"复制日志" image:[UIImage new] action:^{
                                              [[LQLogger shared] copyToPastboard];
                                          }],
                
                                          [LQMenuItem itemWithTitle:@"应用状态" image:[UIImage new] action:^{
                                              [[LQStatusViewController shared] present];
                                          }]
                                          ,[LQMenuItem itemWithTitle:@"隐藏菜单" image:[UIImage new] action:^{
                                              [[LQMenuView shared] hide];
                                          }]];
        }
    });
    return sharedInitConfigure;
}

+ (instancetype) defaultPlatform {
    return [self shared];
}

//实现自己的处理函数
void UncaughtExceptionHandler(NSException *exception) {
    NSArray * arr = [exception callStackSymbols];//得到当前调用栈信息
    NSString * reason  = [exception reason];//非常重要，就是崩溃的原因
    NSString * name = [exception name];//异常类型
    DEBUGMSG(@"exception type : %@ \n crash reason : %@ \n call stack info : %@", name, reason, arr);
    
    NSString *crashLogInfo = [NSString stringWithFormat:@"exception type : %@ \n crash reason : %@ \n call stack info : %@", name, reason, arr];
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager * manager = [NSFileManager defaultManager];
    NSError * error;
    if (![manager fileExistsAtPath:path isDirectory:nil]) {
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    }
    NSString * filePath = [path stringByAppendingPathComponent:@"crashlog.txt"];
    [manager createFileAtPath:filePath contents:[crashLogInfo dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
}

- (void)setRootViewController:(id)viewController {
    if (![COMMONMETHOD getRootViewController]) {
        [COMMONMETHOD setRootViewControllerWithViewController:viewController];
    }
}


@end

static SDKComPlatform *sharedFYComPlatform = nil;
@interface SDKComPlatform ()
@property (nonatomic,retain) SuspensionView * bannerMenuView;
@property (nonatomic,retain) NSArray * tabArray;
@end
@implementation SDKComPlatform

/**
 @brief 获取NdComPlatform的实例对象
 */
+ (instancetype)shared {
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        if (sharedFYComPlatform == nil) {
            sharedFYComPlatform = [[self alloc]init];
        }
    });
    return sharedFYComPlatform;
}

+ (instancetype) defaultPlatform {
    return [self shared];
}

/**
 *  清空缓存
 */
- (void)clearCache{
    [NSUserDefaults removeNSUserDefault:ISLOGIN];
    [NSUserDefaults removeNSUserDefault:USERINFO];
}


- (void)setHideCannelBtn:(BOOL)isHide{
    
    NSString *hide = [NSString stringWithFormat:@"%d",isHide];
    setHIDECANNELBTN(hide);
    
}

- (void) setLoading:(BOOL) loading {
    
}

- (NSString*) deviceInfo {
    return [COMMONMETHOD getDeviceMSG] == nil ? @"" : [COMMONMETHOD getDeviceMSG];
}


@end

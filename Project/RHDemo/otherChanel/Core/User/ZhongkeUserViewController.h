
#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "SDKCommonMethod.h"
#import "UserDataController.h"
#import "sdkActivityIndicatorView.h"
#import "VerificationCode.h"
#import "VersionAllMethod.h"
#define BindingPhone @"BindingPhone"

@interface ZhongkeUserViewController : UIViewController
- (void)setUpnewZhongkePhoneLoginView;
- (void)setUpnewzhongkePwdLoginView;
- (void)setupUI;
- (void)setUpnewZhongkeRegisterView;
- (void)setUpneewZhongkeGetbackPwdView;
- (void)setUpneewZhongkeGetbackPhonePwd;
- (void)setUpneewZhongkeGetbackAccontPwdView;
- (void)setUpneewZhongkeCertificationView;
- (void)setupzhongkeNoticeView;
//历史
- (void)setupneewZhongKeHistoryAccountView;
//支付
- (void)setupneewZhongKePayView:(NSString *)urlStr;
//强更新
- (void)setupgameVersionAlertView;

// 防沉迷
- (void)setupplayTimeLimitView:(NSString *)showTisStr;

//  悬浮窗
- (void)setupWebSupenView:(NSString *)urlStr;

@end

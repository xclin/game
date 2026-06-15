
#import <UIKit/UIKit.h>
#import "SDKCommonMethod.h"
#import "UIView+CommonStyle.h"

#import "BaseButton.h"
#import "BaseLabel.h"
#import "BorderView.h"
#import "TTextField.h"
#import "TempUserMessage.h"
#import "RemindView.h"
#import "sdkInitModel.h"

//logo图
#define LOGOImage [UIImage imageNamed:@"FYSDK_Resourcres.bundle/logo"]
//字体/边框颜色
#define FONTColor136 [UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1]
#define FONTColor51 [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1]
#define BTNRedColor (([[NSUserDefaults takeoutNSUserDefault:HIDESUSPENSION] intValue] == 1) && [ResetUIModel share].button_color.length > 0) ? [UIColor colorWithHexString:[ResetUIModel share].button_color] : [UIColor colorWithRed:247.0/255.0 green:85.0/255.0 blue:74.0/255.0 alpha:1]
#define BTNBlueColor (([[NSUserDefaults takeoutNSUserDefault:HIDESUSPENSION] intValue] == 1) && [sdkInitModel share].button_color.length > 0) ? [UIColor colorWithHexString:[sdkInitModel share].button_color] : [UIColor colorWithRed:49.0/255.0 green:150.0/255.0 blue:255.0/255.0 alpha:1]
//RGB色值
#define RBGColor(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

//红按钮的点击效果
//#define BTNHighlightedImage [FYSDKBaseButton createImageWithColor:[UIColor colorWithHexString:@"#c6443b"]]
#define BTNHighlightedImage (([[NSUserDefaults takeoutNSUserDefault:HIDESUSPENSION] intValue] == 1) && [sdkInitModel share].button_color.length > 0) ? [BaseButton createImageWithColor:[UIColor colorWithHexString:[sdkInitModel share].button_color]] : [BaseButton createImageWithColor:[UIColor colorWithRed:49.0/255.0 green:150.0/255.0 blue:255.0/255.0 alpha:1]]

//记录发送的手机号码
#define setSENDPHONE(SENDPHONE) [[NSUserDefaults standardUserDefaults] setObject:(SENDPHONE) forKey:@"SENDPHONE"];[[NSUserDefaults standardUserDefaults] synchronize];
#define getSENDPHONE [[NSUserDefaults standardUserDefaults] objectForKey:@"SENDPHONE"]

#define ISiPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define ISiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define ISiPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define ISiPhone6p ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define ISiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

@interface BaseView : UIView<UITextFieldDelegate>
- (instancetype) init;
@property (nonatomic,retain) BaseButton * backButton;
@property (nonatomic,retain) BaseButton * cancelButton;
@property (nonatomic,retain) UIImageView *logoImageView;
@property (nonatomic, copy) void(^backBlock)(); //返回回调
@property (nonatomic ,copy) void (^cancleBlock)();
@property (nonatomic,retain) UIView * logoView;

/**
 *  显示错误界面
 *
 *  @param viewModel 错误信息
 */
- (void)setupUI;
- (void) addBackItem;
- (void) addCancelItem;
- (void) addCancelItem1;
- (void) backAction;
- (void) cancelAction;
//- (void)setUpLogo;
- (void)showErrorAtMsg:(NSString*)msgString;
- (CGRect)setSameFrameButY:(CGRect)frame Y:(CGFloat)Y;

@end


#define rgba(r,g,b,c) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:c]
#define font(a)          [UIFont systemFontOfSize:a]
#define WKAlertShow(messageText,buttonName)\
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:(messageText)\
 delegate:nil cancelButtonTitle:(buttonName) otherButtonTitles: nil];\
 [alert show];

#import <UIKit/UIKit.h>
#import "BaseLabel.h"
#import "VersionAllMethod.h"
#import "BaseButton.h"
#import "RemindView.h"
#import "IXAttributeTapLabel.h"
#import "CommonStoreKey.h"
#import "NSString+category.h"
#import "SDKCommonMethod.h"
@interface ZhongkeView : UIView<UITextFieldDelegate>

- (instancetype) init;

@property (nonatomic,strong) UIButton * backButton;
@property (nonatomic,strong) UIButton * cancelButton;
@property (nonatomic,strong) UIView *backForCodeView;
@property (nonatomic,strong) UIView *backForPhoneView;
@property (nonatomic,strong) UIImageView *logoImageView;
@property (nonatomic,strong) BaseLabel *titleLbl;
@property (nonatomic, copy) void(^backBlock)();
@property (nonatomic ,copy) void (^cancleBlock)();
@property (nonatomic, copy) void(^userProCallBlock)(NSString *proStr); //隐私、协议
@property (nonatomic,retain) UIView * logoView;
@property (nonatomic,strong) BaseButton *backBtn;
@property (nonatomic,strong) BaseLabel *LogingTypeLbl;
@property (nonatomic,strong) BaseButton *loginBtn;
@property (nonatomic,strong) UITextField *phoneTxtF;
@property (nonatomic,strong) UITextField *phoneCodeTxtF;
@property (nonatomic,strong) UILabel *agreementLbl;
@property (nonatomic,strong) BaseButton *getPhoneCodeBtn;
@property (nonatomic,strong) IXAttributeTapLabel * hahalabel;


- (void)loginBtnAction;
- (void)backBtnAction;
- (void)getPhoneCodeBtnAction;
- (void) setupUI;
- (void) backAction;
- (void) cancelAction;
- (CGRect)setSameFrameButY:(CGRect)frame Y:(CGFloat)Y;
@end


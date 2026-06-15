
#import "SuspensionView.h"
#import "NewZhongkeWebSuspenView.h"
#import "VersionAllMethod.h"
#import "SDKCommonMethod.h"
#import <AdSupport/AdSupport.h>
#import "UserDataModel.h"
#import "SDKCommonMethod.h"
#import "ZhongkeUserViewController.h"
@interface NewZhongkeWebSuspenView()
@property (nonatomic,retain) SuspensionView * bannerMenuView;
@property (nonatomic,retain) NSArray * tabArray;
@property (nonatomic,strong) ZhongkeUserViewController * zhongkeUserVC;

@end

static NewZhongkeWebSuspenView *shareManager = nil;

@implementation NewZhongkeWebSuspenView

+(instancetype)shared{
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        if (shareManager == nil) {
            shareManager = [[self alloc]init];
        }
    });
    return shareManager;
    
}

- (SuspensionView *)bannerMenuView{
    if (!_bannerMenuView) {
        _bannerMenuView = [[SuspensionView alloc]initWithFrame:CGRectMake(windowWidth-80, 40, 70, 70)];
    }
    return _bannerMenuView;
}

/**
 *  显示悬浮按钮
 */
- (void)showSuspension {
    __weak typeof (self) aself = self;
    self.bannerMenuView.BannerMenuViewBlock = ^(NSInteger index) {
        if ([COMMONMETHOD isLogin]) {
            [aself clickBannerMenuWithIndex:index];
        }
    };
    [self.bannerMenuView show];
}


/**
 *  隐藏悬浮按钮
 */
- (void)hideSuspensionToolBar {
    NSLog(@"hideSuspensionToolBar");
    [self.bannerMenuView hide];
    
}

/**
 
 @param isHide 是否隐藏SDK界面的关闭按钮
 */
- (void)setHideCannelBtn:(BOOL)isHide{
    
    NSString *hide = [NSString stringWithFormat:@"%d",isHide];
    setHIDECANNELBTN(hide);
}

/**
 *  点击悬浮窗展开后里面的按钮
 *
 *  @param index 展开后对应的按钮
 */
- (void)clickBannerMenuWithIndex:(NSInteger)index {
    NSArray * linklist = [NSKeyedUnarchiver unarchiveObjectWithData:[NSUserDefaults takeoutNSUserDefault:suspensionview]];
    ZhongkeUserViewController * vc = [[ZhongkeUserViewController alloc]init];
    [[COMMONMETHOD getRootViewController] addChildViewController:vc];
    [[COMMONMETHOD getRootViewController].view addSubview:vc.view];
    [vc setupUI];
    [vc setupWebSupenView:[self getUrlAtInitialUrl:linklist[index][@"link"]]];
    
}

-(ZhongkeUserViewController *)zhongkeUserVC{
    if (!_zhongkeUserVC) {
        _zhongkeUserVC = [[ZhongkeUserViewController alloc]init];
    }
    return _zhongkeUserVC;
}


- (NSString*)getUrlAtInitialUrl:(NSString*)string {


    string  =[NSString stringWithFormat:@"%@%@",[sdkInitModel share].domain,string];
    

    NSArray *array = nil;
    NSString * userToken = @"";
    NSString * uid = @"";
    NSString *sub_id = @"";
    NSString *username = @"";
    array = [UserDataModel selectUserAccount:[NSUserDefaults takeoutNSUserDefault:LASTLOGINUID]];
    if (array.count>0) {
        UserModel *userAccount = array[0];
        userToken = userAccount.access_token;
        uid       = userAccount.uid;
        sub_id    = userAccount.sub_uid;
        username = userAccount.userName;
    }
    
    
    if (![string isKindOfClass:[NSNull class]]) {
        string = [NSString stringWithFormat:@"%@?gid=%@&lid=%@&platform=1&equipment_id=%@&equipment_idfv=%@&access_token=%@&uid=%@&sub_uid=%@&ver=%@&account=%@&verify_before_pay=%@&allow_purchase_voucher=%@",string,INITCONFIGURE.gid,INITCONFIGURE.lid,[COMMONMETHOD getEquipmentIDFA],getIDFV,COMMONMETHOD.access_token,COMMONMETHOD.uid,COMMONMETHOD.sub_uid,INITCONFIGURE.version,COMMONMETHOD.userName,COMMONMETHOD.verify_before_pay,COMMONMETHOD.allow_purchase_voucher];

    
        }
    
    NSLog(@"string = %@",string);
    [self.bannerMenuView hidesMenu];
    NSString *urlStr=  [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"urlStr = %@",string);
    return urlStr;
}

@end

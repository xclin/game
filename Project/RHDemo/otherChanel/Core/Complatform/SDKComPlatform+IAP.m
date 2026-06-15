
#import "SDKComPlatform+IAP.h"
#import "RequestUtil.h"
#import "BaseModel.h"
#import "SDKComplatformBase.h"
#import "SDKCommonMethod.h"
#import "zhongkeIAPManager.h"
#import "NSString+category.h"
#import "sdkActivityIndicatorView.h"
#import "DataBaseManager.h"
#import "RemindView.h"
#import "sdkInitModel.h"
#import "ZhongkeUserViewController.h"
@implementation SDKComPlatform (IAP)

- (void)buyWithProductId:(NSString *)goodID
                       gameOther:(NSString *)gameOther
                   transactionId:(NSString *)transactionId
                       goodsName:(NSString *)goodsName
                        goodsDec:(NSString *)goodsDec
                           price:(NSString *)price
                             sid:(NSString *)sid{
     [AIVIEW show];
    if (![COMMONMETHOD isLogin]) {
        [AIVIEW hide];
        return;
    }
    
    if ([[SDKCommonMethod shared].verify_before_pay isEqualToString:@"1"]) {
        ZhongkeUserViewController * vc = [[ZhongkeUserViewController alloc]init];
        [[COMMONMETHOD getRootViewController] addChildViewController:vc];
        [[COMMONMETHOD getRootViewController].view addSubview:vc.view];
        [vc setupUI];
        [vc setUpneewZhongkeCertificationView];
        [AIVIEW hide];
        return;
    }

    
    ProductModel *iapProduct = [ProductModel new];
    iapProduct.apid = goodID;
    iapProduct.name = goodsName;
    iapProduct.desc = goodsDec;
    iapProduct.price =price;
    
//        NSArray *listArr = [[DataBaseManager sharedInstance] selectAppStoreProductListTable];
//        ProductModel *iapProduct;
//        for (ProductModel *model in listArr) {
//            if ([model.apid isEqualToString:goodID]) {
//                iapProduct = model;
//                break;
//            }
//        }
//
    
    if (!iapProduct) {
        [AIVIEW hide];
        IAPStatus * user = [[IAPStatus alloc] init];
        user.fySDKIAPStatus = _IAP_STATUS_PRODUCTLIST;
        ErrorStatus * error1 = [[ErrorStatus alloc] init];
        error1.fySDKErrorStatus = _ERROR_STATUS_PRODUCTLIST_EMPTY;
        MessageStatus * message = [[MessageStatus alloc] init];
        message.code = -1;
        message.msg = @"商品列表为空";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ProductPayNotification" object:nil userInfo:@{@"IAPStatus":user,@"ErrorStatus":error1,@"result":@NO,@"MessageStatus":message}];
        return;
    }
    

    
    if (![SKPaymentQueue canMakePayments]) {
        [AIVIEW hide];
        IAPStatus * user = [[IAPStatus alloc] init];
        user.fySDKIAPStatus = _IAP_STATUS_PRODUCTLIST;
        
        ErrorStatus * error1 = [[ErrorStatus alloc] init];
        error1.fySDKErrorStatus = _ERROR_STATUS_PRODUCTLIST_EMPTY;
        MessageStatus * message = [[MessageStatus alloc] init];
        message.code = -1;
        message.msg = @"不允许程序内付费";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ProductPayNotification" object:nil userInfo:@{@"IAPStatus":user,@"ErrorStatus":error1,@"result":@NO,@"MessageStatus":message}];
    }
    
    NSDictionary * rechargeDic=  [[DataBaseManager sharedInstance] selectUserRecharge:[SDKCommonMethod shared].c_uid];
    if (rechargeDic.count>0) {
        if([rechargeDic[@"each"] intValue] < [iapProduct.price intValue]){
            DEBUGMSG(@"单笔充值不能超过现购买金额");
            [[RemindView share] show:@"超过单笔充值金额最大值" time:2.0];
            return;
        }
        if (([rechargeDic[@"monthly"] intValue] - [rechargeDic[@"monthly_recharge_sum"] intValue])< [iapProduct.price intValue]){
            DEBUGMSG(@"当前月充值总金额不能超过限制");
            [[RemindView share] show:@"超过当前月充值金额。" time:2.0];
            return;
        }
        NSMutableDictionary *dic =[NSMutableDictionary new];
        [dic setObject:[SDKCommonMethod shared].c_uid forKey:@"uid"];
        [dic setObject:[NSString stringWithFormat:@"%d",([rechargeDic[@"monthly_recharge_sum"] intValue]+[iapProduct.price intValue])] forKey:@"monthly_recharge_sum"];
        [dic setObject:[SDKCommonMethod shared].mouth_Rechare forKey:@"mouth"];
        [[DataBaseManager sharedInstance] updateUserRecharge:dic];
    }
    
    //1开启，0关闭
    NSString * isSandbox = [NSUserDefaults takeoutNSUserDefault:FYSANDBOXSWITCH]  == nil? @"0" : [NSUserDefaults takeoutNSUserDefault:FYSANDBOXSWITCH];
    [[zhongkeIAPManager sharedIAPDManager] buyWithIapProduct:iapProduct andGameOther:[gameOther valueAt:@"gameOther"] transactionId: transactionId andSid:[sid valueAt:@"sid"] andSanbox:isSandbox];
}


@end

@implementation ProductModel

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.price forKey:@"price"];
    [encoder encodeObject:self.apid forKey:@"apid"];
    [encoder encodeObject:self.currency forKey:@"currency"];
    [encoder encodeObject:self.game_coin forKey:@"game_coin"];
    [encoder encodeObject:self.pp forKey:@"pp"];
    [encoder encodeObject:self.desc forKey:@"desc"];
    [encoder encodeObject:self.type forKey:@"type"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.price = [decoder decodeObjectForKey:@"price"];
        self.apid = [decoder decodeObjectForKey:@"apid"];
        self.currency = [decoder decodeObjectForKey:@"currency"];
        self.game_coin = [decoder decodeObjectForKey:@"game_coin"];
        self.pp = [decoder decodeObjectForKey:@"pp"];
        self.desc = [decoder decodeObjectForKey:@"desc"];
        self.type = [decoder decodeObjectForKey:@"type"];    }
    return self;
}

@end

@implementation IAPStatus
@synthesize fySDKIAPStatus;

#pragma mark - 判断状态
- (BOOL)isStatusProductList
{
    if (fySDKIAPStatus == _IAP_STATUS_PRODUCTLIST) {
        return YES;
    }
    return NO;
}

- (BOOL)isStatusProductBuy
{
    if (fySDKIAPStatus == _IAP_STATUS_PRODUCTBUY) {
        return YES;
    }
    return NO;
}
@end


#import "zhongkeIAPManager.h"
#import "UserDataModel.h"
#import "SDKCommonMethod.h"
#import "SDKUserAccountModel.h"
#import "SDKComplatformBase.h"
#import "RequestUtil.h"
#import "DataBaseManager.h"
#import "IAPProducts.h"
#import "YYKit.h"
#import "sdkActivityIndicatorView.h"
#import "UIImage+Category.h"
#import "sdkRequestManager.h"
#import "StopWatch.h"
#import "Masonry.h"
#import <WebKit/WebKit.h>
#import "WTMGlyphGestureRecognizer.h"
#import <WebKit/WKWebView.h>
#import <SafariServices/SafariServices.h>
#import <AdSupport/AdSupport.h>
#import "PayViewController.h"
#import "apiManager.h"
#import "NewZhongkeWebSuspenView.h"
#import "sdkRoleModel.h"
#import "ZhongkeUserViewController.h"
#define UIDeviceOrientationIsPortrait(orientation)  ((orientation) == UIDeviceOrientationPortrait || (orientation) == UIDeviceOrientationPortraitUpsideDown)
#define UIDeviceOrientationIsLandscape(orientation) ((orientation) == UIDeviceOrientationLandscapeLeft || (orientation) == UIDeviceOrientationLandscapeRight)
#define setIDFV(IDFV) [[NSUserDefaults standardUserDefaults] setObject:(IDFV) forKey:@"IDFV"];[[NSUserDefaults standardUserDefaults] synchronize];
//记录用户选择的支付方式
#define setPayINDEX(PayINDEX) [[NSUserDefaults standardUserDefaults] setObject:(PayINDEX) forKey:@"PayINDEX"];[[NSUserDefaults standardUserDefaults] synchronize];
#define getPayINDEX [[NSUserDefaults standardUserDefaults] objectForKey:@"PayINDEX"]

@implementation WebASDFModel
@end
static zhongkeIAPManager *sharedIAPDataController = nil;

@interface zhongkeIAPManager()<NSURLConnectionDataDelegate,SFSafariViewControllerDelegate,WKScriptMessageHandler,WKNavigationDelegate,WKUIDelegate>
@property (nonatomic) BOOL isAppleRestored; //是否恢复交易
@property (nonatomic,strong)NSString * sStr;
@property (nonatomic,strong) WebASDFModel * model;
@property (nonatomic, strong) NSString* orieint;
@property (nonatomic,strong) NSURLConnection *urlConnection;
@property (nonatomic,strong) NSURLRequest *request;
@property (nonatomic,strong) WKWebView *FYWebView;

@end
@implementation zhongkeIAPManager

+ (instancetype)sharedIAPDManager {
    static dispatch_once_t pred;
    dispatch_once(&pred,^{
        if (sharedIAPDataController == nil) {
            sharedIAPDataController = [[zhongkeIAPManager alloc] init];
            sharedIAPDataController.isAppleRestored = true;
        }
        
    });
    return sharedIAPDataController;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //程序入口监听开始
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

- (void)buyWithIapProduct:(ProductModel*)iapProductModel
             andGameOther:(NSString*)gameOther
            transactionId:(NSString *)transactionId
                   andSid:(NSString*)sid
                andSanbox:(NSString *)isSanbox {
    [self buyProductWithPayType:iapProductModel andGameOther:gameOther transactionId:transactionId andSid:sid andSanbox:isSanbox andRoleData:COMMONMETHOD.roleData];
}

- (void)buyProductWithPayType:(ProductModel*)iapProductModel
                 andGameOther:(NSString*)gameOther
                transactionId:(NSString *)transactionId
                       andSid:(NSString*)sid
                    andSanbox:(NSString *)isSanbox
                  andRoleData:(NSString *)roleData {
    DEBUGMSG(@"_str === %@",_sStr);
    WebASDFModel * model = [[WebASDFModel alloc]init];
    model.iapProductModel = iapProductModel;
    model.gameOther = gameOther;
    model.transactionId = transactionId;
    model.sid = sid;
    
    NSString *child_userToken = @"";
    NSString *child_userName = @"";
    NSString *child_userUid = @"";
    NSArray * array = [UserDataModel selectUserAccount:[NSUserDefaults takeoutNSUserDefault:LASTLOGINUID]];
    if (array.count>0) {
        UserModel * userAccountModel = array[0];
        child_userToken = userAccountModel.access_token;
        child_userName = userAccountModel.userName;
        child_userUid = userAccountModel.sub_uid;
    }
    
    if ([[UIDevice currentDevice].systemVersion floatValue] < 9.0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"ios9以下系统暂不支持" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    _orieint = [NSUserDefaults takeoutNSUserDefault:FYORIEINTSHOW]  == nil? @"1" : [NSUserDefaults takeoutNSUserDefault:FYORIEINTSHOW];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"IDFV"] length] == 0) {
        NSString *idfv = [NSString getRandomidfv:18];
        setIDFV(idfv);
    }
    
    
    //    pay_Channel other_channel  代表可以集成支付宝 微信，apple_channel 表示上架appstore 只能H5现在zhifu
    NSString * urlStr = [NSString stringWithFormat:@"%@lid=%@&gid=%@&platform=1&uid=%@&sub_uid=%@&server_id=%@&server_name=%@&role_id=%@&role_name=%@&money=%@&gold=%@&equipment_id=%@&cp_order_no=%@&product_id=%@&product_desc=%@&product_name=%@&app_name=%@&payment=%@&gateway=%@&access_token=%@&cp_pass_through=%@&pay_channel=%@", sdkH5PayURL,INITCONFIGURE.lid,INITCONFIGURE.gid,COMMONMETHOD.uid,COMMONMETHOD.sub_uid,sdkRoleShare.server_id,sdkRoleShare.server_name,sdkRoleShare.role_id,sdkRoleShare.role_name,iapProductModel.price,@"",[COMMONMETHOD getEquipmentIDFA],transactionId,iapProductModel.apid,iapProductModel.desc,iapProductModel.name,COMMONMETHOD.getAppName,@"",@"",COMMONMETHOD.access_token,gameOther,@"apple_channel"];
    
    [[NewZhongkeWebSuspenView shared] hideSuspensionToolBar];
    
    if ([getPayINDEX length] == 0) {
        setPayINDEX(@"1");
    }
    [NSUserDefaults reserveNSUserDefault:[NSKeyedArchiver archivedDataWithRootObject:iapProductModel] field:PRODUCTMODEL];
    [NSUserDefaults reserveNSUserDefault:[NSKeyedArchiver archivedDataWithRootObject:gameOther] field:GameOther];
    [NSUserDefaults reserveNSUserDefault:[NSKeyedArchiver archivedDataWithRootObject:transactionId] field:TransactionId];
    [NSUserDefaults reserveNSUserDefault:[NSKeyedArchiver archivedDataWithRootObject:sid] field:SID];
    urlStr =  [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    DEBUGMSG(@"支付url---%@",urlStr);
    NSLog(@"支付url---%@",urlStr);
    
    ZhongkeUserViewController * vc = [[ZhongkeUserViewController alloc]init];
    [[COMMONMETHOD getRootViewController] addChildViewController:vc];
    [[COMMONMETHOD getRootViewController].view addSubview:vc.view];
    [vc setupUI];
    
    [vc setupneewZhongKePayView:urlStr];
    
    
    //设置时间为2
    double delayInSeconds = 1.5;
    //创建一个调度时间,相对于默认时钟或修改现有的调度时间。
    dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    //推迟两纳秒执行
    dispatch_queue_t concurrentQueue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
        [self reloadASDFModel:model];
        
    });
    
    
}


-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    DEBUGMSG(@"JS交互=%@，%@",message.name,message.body);
    if ([message.name isEqualToString:@"XYSDKFK"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:message.body]];
        [_FYWebView removeFromSuperview];
    }else if ([message.name isEqualToString:@"XYSDKFH"]) {
        [_FYWebView removeFromSuperview];
    }else if ([message.name isEqualToString:@"XYSDKLX"]) {
        setPayINDEX(message.body);
    }
}

- (void)reloadASDFModel:(WebASDFModel *)model {
    [AIVIEW hide];
    self.model = model;
}
#pragma mark ------SFSafariViewControllerDelegate{
- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    
    [controller dismissViewControllerAnimated:NO completion:nil];
    NSArray * arr = [NSKeyedUnarchiver unarchiveObjectWithData:[NSUserDefaults takeoutNSUserDefault:suspensionview]];
    if (arr.count != 0) {
        [[NewZhongkeWebSuspenView shared] showSuspension];
    }
    
}

- (void)webNewbuyWithIapProduct:(ProductModel*)iapProductModel
                   andGameOther:(NSString*)gameOther
                  transactionId:(NSString *)transactionId
                         andSid:(NSString*)sid
                      andSanbox:(NSString *)isSanbox
                    andRoleData:(NSString *)roleData{
    _isAppleRestored = false;
    
    NSString *userToken = @"";
    NSString *userName = @"";
    NSString *userUid = @"";
    NSArray * array = [UserDataModel selectUserAccount:[NSUserDefaults takeoutNSUserDefault:LASTLOGINUID]];
    if (array.count>0) {
        UserModel * userAccountModel = array[0];
        userToken = userAccountModel.access_token;
        userName = userAccountModel.userName;
        userUid = userAccountModel.sub_uid;
    }
    IAPCallBackModel *iapCallBackModel = [[IAPCallBackModel alloc]initIAPCallBackWithApid:iapProductModel.apid  withSid:sid withGameOther:gameOther withReceipt:@"" withSandbox:isSanbox withToken:userToken withTransactionId:transactionId withPrice:iapProductModel.price withUsername:userName withUserid:userUid andRoleData:COMMONMETHOD.roleData];
    //本地化存储IAPCallBackModel
    
    [NSUserDefaults reserveNSUserDefault:[NSKeyedArchiver archivedDataWithRootObject:iapCallBackModel] field:PRODUCT];
    
    //1.从苹果后台取出所有的待交易商品
    NSArray * transactionArray = [SKPaymentQueue defaultQueue].transactions;
    if (transactionArray.count > 0) {
        SKPaymentTransaction * transaction = [transactionArray firstObject];
        if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
            [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
            return;
        }
    }
    DEBUGMSG(@"-------------请求对应的产品信息----------------");
    NSArray * productArray = [[NSArray alloc]initWithObjects:iapProductModel.apid, nil];
    //2.请求对应的商品信息，转换成字符集合
    NSSet * set = [NSSet setWithArray:productArray];
    SKProductsRequest * request = [[SKProductsRequest alloc]initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
    
}

#pragma mark ---- 代理方法
/**
 *  收到产品返回信息
 *
 *  @param request  请求类对象
 *  @param response 返回信息
 */
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    DEBUGMSG(@"--------------收到产品反馈消息---------------------");
    NSArray * productArray = response.products;
    if (productArray.count == 0) {
        DEBUGMSG(@"--------------没有商品------------------");
        IAPStatus * status = [[IAPStatus alloc] init];
        ErrorStatus * errorStatus = [[ErrorStatus alloc] init];
        MessageStatus * message = [[MessageStatus alloc] init];
        status.fySDKIAPStatus = _IAP_STATUS_PRODUCTLIST;
        errorStatus.fySDKErrorStatus = _ERROR_STATUS_PRODUCTLIST_EMPTY;
        message.code = -1;
        message.msg = @"没有此商品";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ProductPayNotification" object:nil userInfo:@{@"IAPStatus":status,@"ErrorStatus":errorStatus,@"result":@NO,@"MessageStatus":message}];
        [AIVIEW hide];
        return;
    }
    DEBUGMSG(@"productID:%@", response.invalidProductIdentifiers);
    DEBUGMSG(@"产品付费数量:%lu",(unsigned long)[productArray count]);
    ProductModel * productModel = [NSKeyedUnarchiver unarchiveObjectWithData:[NSUserDefaults takeoutNSUserDefault:PRODUCT]];
    SKProduct * products = nil;
    for (SKProduct * product in productArray) {
        DEBUGMSG(@"%@", [product description]);
        DEBUGMSG(@"%@", [product localizedTitle]);
        DEBUGMSG(@"%@", [product localizedDescription]);
        DEBUGMSG(@"%@", [product price]);
        DEBUGMSG(@"%@", [product productIdentifier]);
        if ([product.productIdentifier isEqualToString:productModel.apid]) {
            products = product;
        }
    }
    if (products == nil) {
        IAPStatus * status = [[IAPStatus alloc] init];
        ErrorStatus * errorStatus = [[ErrorStatus alloc] init];
        MessageStatus * message = [[MessageStatus alloc] init];
        status.fySDKIAPStatus = _IAP_STATUS_PRODUCTLIST;
        errorStatus.fySDKErrorStatus = _ERROR_STATUS_PRODUCTLIST_EMPTY;
        message.code = -1;
        message.msg = @"没有此商品";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ProductPayNotification" object:nil userInfo:@{@"IAPStatus":status,@"ErrorStatus":errorStatus,@"result":@NO,@"MessageStatus":message}];
        [AIVIEW hide];
        return;
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:products];
    
    DEBUGMSG(@"发送购买请求");
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}
//查询失败后的回调
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    DEBUGMSG(@"------------------错误-----------------:%@", error);
    // 购买失败，后台未确认状态
    IAPStatus * status = [[IAPStatus alloc] init];
    ErrorStatus * errorStatus = [[ErrorStatus alloc] init];
    MessageStatus * message = [[MessageStatus alloc] init];
    status.fySDKIAPStatus = _IAP_STATUS_PRODUCTLIST;
    errorStatus.fySDKErrorStatus = _ERROR_STATUS_PRODUCTLIST_EMPTY;
    message = [[MessageStatus alloc] init];
    message.code = -1;
    message.msg = @"请求失败，请重试。";
    [AIVIEW hide];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ProductPayNotification" object:nil userInfo:@{@"IAPStatus":status,@"ErrorStatus":errorStatus,@"result":@NO,@"MessageStatus":message}];
}

- (void)requestDidFinish:(SKRequest *)request{
    DEBUGMSG(@"------------反馈信息结束-----------------");
}

/**
 *  监听购买结果，已更新的交易,每个状态下都要结束订单
 *  购买成功，后台未验证状态
 *
 *  @param queue       交易队列
 *  @param transaction 被更新状态的交易
 */
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction {
    for (SKPaymentTransaction * payTrans in transaction) {
        NSString * sendString = nil;
        DEBUGMSG(@"hdiahdihd===%ld",(long)payTrans.transactionState);
        switch (payTrans.transactionState) {
            case SKPaymentTransactionStatePurchased: {
                DEBUGMSG(@"付款成功，进行服务端二次验证");
                [self completeTransaction:payTrans];
                DEBUGMSG(@"订单结束");
                //获取交易凭证receipt...transactionReceipt: Only valid if state is SKPaymentTransactionStatePurchased.
                sendString = [self encode:payTrans.transactionReceipt.bytes length:payTrans.transactionReceipt.length];
                IAPCallBackModel * iapCallBackModel = [NSKeyedUnarchiver unarchiveObjectWithData:[NSUserDefaults takeoutNSUserDefault:PRODUCT]];
                iapCallBackModel.receipt = sendString;
                //插入，保存到数据库中
                IAPProducts * model = [[IAPProducts alloc]init];
                __block NSString *iapID = iapCallBackModel.transactionId;
                model.iapID = iapID;
                model.apid = iapCallBackModel.apid;
                model.postDate = [NSDate new];
                model.token = iapCallBackModel.token;
                model.msg = @"未验证";
                model.price = iapCallBackModel.price;
                model.code = 0;
                NSMutableDictionary * dic = [[iapCallBackModel modelToJSONObject] mutableCopy];
                [dic removeObjectForKey:@"domain"];
                model.IAPInfoDic = dic;
                [UserDataModel insertIAPProduct:model];
                DEBUGMSG(@"_isAppleRestored = %d", _isAppleRestored);
                if (_isAppleRestored == false) {
                    StopWatch * watch = [[StopWatch alloc] initWithName:@"内购回调"];
                    [[RequestUtil sharedAPIManager] getIAPCallBack:iapCallBackModel];
                    [[RequestUtil sharedAPIManager] complectionBlock:^(id responseObject) {
                        [watch stop];
                        [AIVIEW hide];
                        //查询数据库，并根据时间戳id更新内购列表中订单的状态
                        IAPProducts * model = [UserDataModel selectIAPProduct:iapID][0];
                        model.code = 1;
                        model.msg = responseObject[@"msg"];
                        [UserDataModel updateIAPProduct:model];
                        IAPStatus * iap = [[IAPStatus alloc] init];
                        iap.fySDKIAPStatus = _IAP_STATUS_PRODUCTBUY;
                        MessageStatus * message = [[MessageStatus alloc] init];
                        message.code = 0;
                        message.msg = responseObject[@"msg"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ProductPayNotification" object:nil userInfo:@{@"IAPStatus":iap,@"result":@YES,@"MessageStatus":message}];
                    }];
                }
                break;
            }
            case SKPaymentTransactionStateFailed:
                [self completeTransaction:payTrans];
                [AIVIEW hide];
            default: break;
        }
    }
}

/**
 *  补单
 */
- (void)restoredIAP {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray * array = [UserDataModel selectUnfinishedIAP];
        for (IAPProducts * model in array) {
            if (model.code == 0 && model.IAPInfoDic != nil) {
                IAPCallBackModel * cbModel = [IAPCallBackModel modelWithDictionary:model.IAPInfoDic];
                //读取实时sandbox的状态
                cbModel.sandbox = [NSString stringWithFormat:@"%@",[NSUserDefaults takeoutNSUserDefault:FYSANDBOXSWITCH]];
                [[RequestUtil sharedAPIManager] getIAPCallBack:cbModel andProductIdentifier:model.iapID];
                [[RequestUtil sharedAPIManager] complectionIAPBlock:^(id responseObject, NSString *productIdentifier) {
                    [AIVIEW hide];
                    //修改
                    IAPProducts * updateModel = [UserDataModel selectIAPProduct:productIdentifier][0];
                    updateModel.code = 1;
                    updateModel.msg = responseObject[@"msg"];
                    [UserDataModel updateIAPProduct:updateModel];
                    
                }];
            }
        }
    });
}

/**
 *  base64加密算法
 *
 *  @param input  被加密字符串
 *  @param length 被加密长度
 *
 *  @return 转码后string
 */
- (NSString *)encode:(const uint8_t *)input length:(NSInteger)length {
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    NSMutableData *data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t *output = (uint8_t *)data.mutableBytes;
    for (NSInteger i = 0; i < length; i += 3) {
        NSInteger value = 0;
        for (NSInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        NSInteger index = (i / 3) * 4;
        output[index + 0] =                    table[(value >> 18) & 0x3F];
        output[index + 1] =                    table[(value >> 12) & 0x3F];
        output[index + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[index + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

//交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    DEBUGMSG(@"交易结束");
    if (transaction.error.code != SKErrorPaymentCancelled) {
        
    } else {
        DEBUGMSG(@"用户取消交易");
    }
    //从支付队列中移除交易
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

@end


#import "RequestUtil.h"
#import "VersionAllMethod.h"
#import "SDKCommonMethod.h"
#import "SDKComPlatform.h"
#import "sdkActivityIndicatorView.h"
#import "NSMutableURLRequest+Model.h"
#import "AFNetworkReachabilityManager.h"
#import "IAPRequest.h"
static RequestUtil *sharedAPIManager = nil;

@interface RequestUtil ()<UIAlertViewDelegate>
@property (nonatomic,strong) BBModel * model;
@property (nonatomic,copy) FYCompletionBlock complectionBlock;
@property (nonatomic,copy) CompletionIAPBlock complectionIAPBlock;
@end

@implementation RequestUtil

+ (instancetype)sharedAPIManager {
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        if (sharedAPIManager == nil) {
            sharedAPIManager = [[self alloc] init];
        }
    });
    return sharedAPIManager;
}

- (void)complectionBlock:(FYCompletionBlock)complectionBlock {
    self.complectionBlock = complectionBlock;
}

- (void)complectionIAPBlock:(CompletionIAPBlock)complectionBlock {
    self.complectionIAPBlock = complectionBlock;
}

- (void)requestCallBackPost:(requestModel *)model completionBlock:(void (^)(NSURLSessionDataTask *, id))completionBlock failureBlock:(void (^)(requestModel *model))failureBlock {
    if (model.domain == nil) {
        model.domain = DoVerifyReceiptIAPURL;
    }
    NSMutableURLRequest * req = [NSMutableURLRequest requestWithModel:model];
    req.timeoutInterval = 50;
    [[IAPRequest shared] payloadRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data != nil && error == nil) {
                BOOL succeed;
                NSString *responseStr =  [[ NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                NSError *error;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
                // 验证成功标志code=1或者code=1013
                if ([json[@"code"] intValue] == 1 || [json[@"code"] intValue] == 1013) {
                    completionBlock(nil, json);
                    succeed = YES;
                } else {
                    failureBlock(model);
                    succeed = NO;
                }
                [SDKCommonMethod showWebLogWithDomain:DoVerifyReceiptIAPURL model:model object:data succeed:succeed];
            } else {
                failureBlock(model);
                [SDKCommonMethod showWebLogWithDomain:DoVerifyReceiptIAPURL model:model object:error succeed:NO];
                
            }
        });
    }];
}
#pragma mark - 内购回调
- (void)getIAPCallBack:(requestModel*)model  {
    [self getIAPCallBack:model time:5];
}

- (void)getIAPCallBack:(requestModel*)model time:(NSInteger) time {
    __weak typeof(RequestUtil *)weak_self = self;
    CGFloat startTime = [[NSDate date] timeIntervalSince1970];
    __block CGFloat runTime;
    
    [self requestCallBackPost:model completionBlock:^(NSURLSessionDataTask *task, id responseObject) {
        runTime = [[NSDate date] timeIntervalSince1970]-startTime;
        DEBUGMSG(@"时间差=%.3f秒",runTime);
        weak_self.complectionBlock(responseObject);
    } failureBlock:^(requestModel *model) {
        if (time > 0 && [AFNetworkReachabilityManager sharedManager].reachable) {
            [weak_self getIAPCallBack:model time:time-1];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [AIVIEW hide];
                runTime = [[NSDate date] timeIntervalSince1970]-startTime;
                DEBUGMSG(@"时间差=%.3f秒",runTime);
                [SDKCommonMethod reconnectAlertWithAction:model time:runTime action:^{
                    [weak_self getIAPCallBack:model];
                }];
            });
        }
    }];
}

#pragma mark - 内购补单回调
- (void)getIAPCallBack:(requestModel*)model andProductIdentifier:(NSString*)productIdentifier {
    __weak typeof(RequestUtil *)weak_self = self;
    __weak typeof(requestModel *)weak_model = model;
    [self requestCallBackPost:weak_model completionBlock:^(NSURLSessionDataTask *task, id responseObject) {
        weak_self.complectionIAPBlock(responseObject, productIdentifier);
    } failureBlock:^(requestModel *model) {
    }];
}
@end

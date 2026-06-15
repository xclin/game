
#import "sdkRequestManager.h"
#import "RequestUtil.h"
#import "SDKCommonMethod.h"
#import "sdkActivityIndicatorView.h"
#import "NSMutableURLRequest+Model.h"
#import "AFNetworkReachabilityManager.h"
#import "sdkInitModel.h"
#import "apiManager.h"
@interface sdkRequestManager()<NSURLSessionDelegate>
@end
@implementation sdkRequestManager {
    NSURLSession * sesssion;
    NSOperationQueue * queue;
}
LQSingletonInstanceMMethod(sdkRequestManager, ^{
    [instance setUP];
})

#ifndef __Require_Quiet
#define __Require_Quiet(assertion, exceptionLabel)                            \
do                                                                          \
{                                                                           \
if ( __builtin_expect(!(assertion), 0) )                                \
{                                                                       \
goto exceptionLabel;                                                \
}                                                                       \
} while ( 0 )
#endif


#ifndef __Require_noErr_Quiet
#define __Require_noErr_Quiet(errorCode, exceptionLabel)                      \
do                                                                          \
{                                                                           \
if ( __builtin_expect(0 != (errorCode), 0) )                            \
{                                                                       \
goto exceptionLabel;                                                \
}                                                                       \
} while ( 0 )
#endif

- (void) setUP {
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    queue = [NSOperationQueue new];
    queue.maxConcurrentOperationCount = 4;
    sesssion = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:queue];
}

- (void) loadRequest:(NSURLRequest *)req completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler{
    [[sesssion dataTaskWithRequest:req completionHandler:completionHandler] resume];
}

- (void) URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    NSURLCredential *credential = nil;
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}



+ (void)requestPostComplect:(requestModel *)model succeedBlock:(void (^)(id))completionBlock errorBlock:(void (^)(requestModel *model))failureBlock {
    NSMutableURLRequest *requestParams = [NSMutableURLRequest requestWithModelSDK:model];
    [[sdkRequestManager shared] loadRequest:requestParams completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error == nil && data != nil) {
            NSString *responseStr =  [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&err];
            if(err != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failureBlock(model);
                    [SDKCommonMethod showWebLogWithDomain:model.domain model:model object:data succeed:NO];
                });
                return;
            }
            ResponseModel * responce = [ResponseModel modelWithJSON:json];
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(json);
                NSInteger succeedCode = 0;
                if ([model.domain isEqualToString:DoIAPURL]) {
                    succeedCode = 1;
                }else if ([model.domain isEqualToString:CheckOrderURL]){
                    succeedCode = 0;
                }
                [SDKCommonMethod showWebLogWithDomain:model.domain model:model object:data succeed:responce.code == succeedCode];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                failureBlock(model);
                [SDKCommonMethod showWebLogWithDomain:model.domain model:model object:data succeed:NO];
            });
        }
    }];
}


+ (void) postWithModel:(requestModel *)model tryTime:(NSInteger)time succeedBlock:(void (^)(id))complete errorBlock:(void (^)(requestModel *model))failureBlock{
    __weak typeof (self) weakSelf = self;
    [self requestPostComplect:model succeedBlock:complete errorBlock:^(requestModel *model) {

        if (time - 1 > 0 && [AFNetworkReachabilityManager sharedManager].reachable) {
            
            [weakSelf postWithModel:model tryTime:time-1 succeedBlock:complete errorBlock:failureBlock];
            
        } else {
            if (failureBlock) {
                failureBlock(model);
            }
        }
    }];
}

+ (void) startRequestWithModel:(requestModel *)model succeedBlock:(void (^)(id responseObject))complete {
    CGFloat startTime = [[NSDate date] timeIntervalSince1970];
    __block CGFloat runTime;
    [self postWithModel:model tryTime:3 succeedBlock:^(id obj){
        
        runTime = [[NSDate date] timeIntervalSince1970]-startTime;
        DEBUGMSG(@"action=%@,时间差=%.3f秒",model.domain,runTime);
        if ([model.domain isEqualToString:@"active"]) {
            [sdkInitModel share].active_time = [NSString stringWithFormat:@"%.3f",runTime];
        }else if ([model.domain isEqualToString:@"register"]){
            [sdkInitModel share].register_time = [NSString stringWithFormat:@"%.3f",runTime];
        }else if ([model.domain isEqualToString:@"login"]){
            [sdkInitModel share].login_time = [NSString stringWithFormat:@"%.3f",runTime];
        }
        
        [AIVIEW hide];
        complete(obj);
    } errorBlock:^(requestModel *model) {
        [AIVIEW hide];
        runTime = [[NSDate date] timeIntervalSince1970]-startTime;
        
        if ([model.domain isEqualToString:@"active"]) {
            [sdkInitModel share].active_time = [NSString stringWithFormat:@"%.3f",runTime];
        }else if ([model.domain isEqualToString:@"register"]){
            [sdkInitModel share].register_time = [NSString stringWithFormat:@"%.3f",runTime];
        }else if ([model.domain isEqualToString:@"login"]){
            [sdkInitModel share].login_time = [NSString stringWithFormat:@"%.3f",runTime];
        }
        
        //不影响SDK，不弹框,补单
        if ([model.domain isEqualToString:sdkCheckOrderAPI]){
            return;
        }
        
        [SDKCommonMethod reconnectAlertWithAction:model time:runTime action:^{
            [self startRequestWithModel:model succeedBlock:complete];
        }];
    }];
}

@end

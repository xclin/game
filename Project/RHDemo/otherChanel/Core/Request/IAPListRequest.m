
#import "IAPListRequest.h"
#import "RequestUtil.h"
#import "SDKCommonMethod.h"
#import "sdkActivityIndicatorView.h"
#import "NSMutableURLRequest+Model.h"
#import "AFNetworkReachabilityManager.h"
@interface IAPListRequest()<NSURLSessionDelegate>
@end
@implementation IAPListRequest {
    NSURLSession * sesssion;
    NSOperationQueue * queue;
}
LQSingletonInstanceMMethod(IAPListRequest, ^{
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

- (void) listloadRequest:(NSURLRequest*) req completionHandler:(nullable void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler {
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

//自己校验证书过程 参考自cfnetworking 自己的证书cer证书拖入工程即可
- (BOOL)evaluateServerTrust:(SecTrustRef)serverTrust
                  forDomain:(NSString *)domain {
    
    NSArray *arrCertificates = [self defaultPayPinnedCertificates];  //自动检测证书文件
    
    NSArray *_pinnedCertificates = [[NSOrderedSet orderedSetWithArray:arrCertificates] array];
    NSArray *pinnedPublicKeys = nil;
    if (_pinnedCertificates) {
        NSMutableArray *mutablePinnedPublicKeys = [NSMutableArray arrayWithCapacity:[_pinnedCertificates count]];
        for (NSData *certificate in _pinnedCertificates) {
            id publicKey = UCPublicKeyForCertificate(certificate);
            if (!publicKey) {
                continue;
            }
            [mutablePinnedPublicKeys addObject:publicKey];
        }
        pinnedPublicKeys = [NSArray arrayWithArray:mutablePinnedPublicKeys];
    }
    
    NSMutableArray *policies = [NSMutableArray array];
    [policies addObject:(__bridge_transfer id)SecPolicyCreateBasicX509()];
    
    SecTrustSetPolicies(serverTrust, (__bridge CFArrayRef)policies);
    
    CFIndex certificateCount = SecTrustGetCertificateCount(serverTrust);
    NSMutableArray *trustChain = [NSMutableArray arrayWithCapacity:(NSUInteger)certificateCount];
    
    for (CFIndex i = 0; i < certificateCount; i++) {
        SecCertificateRef certificate = SecTrustGetCertificateAtIndex(serverTrust, i);
        [trustChain addObject:(__bridge_transfer NSData *)SecCertificateCopyData(certificate)];
    }
    
    NSArray *serverCertificates = [NSArray arrayWithArray:trustChain];
    
    NSMutableArray *pinnedCertificates = [NSMutableArray array];
    for (NSData *certificateData in _pinnedCertificates) {
        [pinnedCertificates addObject:(__bridge_transfer id)SecCertificateCreateWithData(NULL, (__bridge CFDataRef)certificateData)];
    }
    SecTrustSetAnchorCertificates(serverTrust, (__bridge CFArrayRef)pinnedCertificates);
    
    if (!UCServerTrustIsValid(serverTrust)) {
        return NO;
    }
    
    NSUInteger trustedCertificateCount = 0;
    for (NSData *trustChainCertificate in serverCertificates) {
        if ([_pinnedCertificates containsObject:trustChainCertificate]) {
            trustedCertificateCount++;
        }
    }
    return trustedCertificateCount > 0;
}

- (nullable NSArray *)defaultPayPinnedCertificates {
    static NSArray *defaultPayPinnedCertificates = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"FYSDK_Resourcres" ofType:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
        [bundle load];
        NSMutableArray *certificates = [NSMutableArray new];
        NSString *certFilePath = [bundle pathForResource:@"api1.server" ofType:@"cer"];
        NSData *certificateData = [NSData dataWithContentsOfFile:certFilePath];
        [certificates addObject:certificateData];
        defaultPayPinnedCertificates = [[NSArray alloc] initWithArray:certificates];
    });
    return defaultPayPinnedCertificates;
    
    
}
- (id) _UCPublicKeyForCertificate:(NSData*) certificate {
    return UCPublicKeyForCertificate(certificate);
}
- (BOOL) _UCServerTrustIsValid:(SecTrustRef) serverTrust {
    return UCServerTrustIsValid(serverTrust);
}

static id UCPublicKeyForCertificate(NSData *certificate) {
    id allowedPublicKey = nil;
    SecCertificateRef allowedCertificate;
    SecCertificateRef allowedCertificates[1];
    CFArrayRef tempCertificates = nil;
    SecPolicyRef policy = nil;
    SecTrustRef allowedTrust = nil;
    SecTrustResultType result;
    
    allowedCertificate = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)certificate);
    __Require_Quiet(allowedCertificate != NULL, _out);
    
    allowedCertificates[0] = allowedCertificate;
    tempCertificates = CFArrayCreate(NULL, (const void **)allowedCertificates, 1, NULL);
    
    policy = SecPolicyCreateBasicX509();
    __Require_noErr_Quiet(SecTrustCreateWithCertificates(tempCertificates, policy, &allowedTrust), _out);
    __Require_noErr_Quiet(SecTrustEvaluate(allowedTrust, &result), _out);
    
    allowedPublicKey = (__bridge_transfer id)SecTrustCopyPublicKey(allowedTrust);
    
_out:
    if (allowedTrust) {
        CFRelease(allowedTrust);
    }
    
    if (policy) {
        CFRelease(policy);
    }
    
    if (tempCertificates) {
        CFRelease(tempCertificates);
    }
    
    if (allowedCertificate) {
        CFRelease(allowedCertificate);
    }
    
    return allowedPublicKey;
}

static BOOL UCServerTrustIsValid(SecTrustRef serverTrust) {
    BOOL isValid = NO;
    SecTrustResultType result;
    __Require_noErr_Quiet(SecTrustEvaluate(serverTrust, &result), _out);
    
    isValid = (result == kSecTrustResultUnspecified || result == kSecTrustResultProceed);
    
_out:
    return isValid;
}


+ (void)post:(requestModel *)model succeed:(void (^)(id))completionBlock error:(void (^)(requestModel *model))failureBlock {
    NSMutableURLRequest * req = [NSMutableURLRequest requestWithModel:model];
    [[IAPListRequest shared] listloadRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
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
                NSInteger succeedCode = 1;
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

+ (void) post:(requestModel *)model tryTime:(NSInteger)time succeed:(void (^)(id))complete error:(void (^)(requestModel *model))failureBlock{
    __weak typeof (self) weakSelf = self;
    [self post:model succeed:complete error:^(requestModel *model) {
        if (time - 1 > 0 && [AFNetworkReachabilityManager sharedManager].reachable) {
            if (time > 100) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf post:model tryTime:time-1 succeed:complete error:failureBlock];
                });
            } else {
                [weakSelf post:model tryTime:time-1 succeed:complete error:failureBlock];
            }
        } else {
            if (failureBlock) {
                failureBlock(model);
            }
        }
    }];
}
+ (void) post:(requestModel *)model tryTime:(NSInteger)time succeed:(void (^)(id))complete
{
    [self post:model tryTime:time succeed:complete];
}

+ (void) postUntilSucceed:(requestModel *)model succeed:(void (^)(id))complete {
    CGFloat startTime = [[NSDate date] timeIntervalSince1970];
    __block CGFloat runTime;
    [AIVIEW show];
    [self post:model tryTime:3 succeed:^(id obj){
        runTime = [[NSDate date] timeIntervalSince1970]-startTime;
        DEBUGMSG(@",时间差=%.3f秒",runTime);
        [AIVIEW hide];
        complete(obj);
    } error:^(requestModel *model) {
        [AIVIEW hide];
        runTime = [[NSDate date] timeIntervalSince1970]-startTime;
        [SDKCommonMethod reconnectAlertWithAction:model time:runTime action:^{
            [self postUntilSucceed:model succeed:complete];
        }];
    }];
}

@end

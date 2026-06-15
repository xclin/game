
#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "LQConstants.h"
/**
 网络请求工具类
 */
@interface IAPListRequest : NSObject
LQSingletonInstanceHMethod

- (void) listloadRequest:(NSURLRequest*) req completionHandler:(nullable void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler;
/**
 发送Post网络请求
 
 @param model 网络模型
 @param completionBlock 成功语句块
 @param failureBlock 失败语句块
 */
+ (void)post:(requestModel*_Nonnull)model succeed:(void (^_Nullable)(id _Nonnull ))completionBlock error:(void (^_Nullable)(requestModel * _Nullable model))failureBlock;

/**
 发送Post网络请求
 
 @param model 网络模型
 @param time 尝试次数
 @param complete 成功语句块
 @param failureBlock 失败语句块
 */
+ (void) post:(requestModel *_Nullable)model tryTime:(NSInteger)time succeed:(void (^_Nullable)(id _Nullable ))complete error:(nullable void (^)(requestModel * _Nullable model))failureBlock;

/**
 发送网络请求
 
 @param model 网络模型
 @param time 尝试次数
 @param complete 成功语句块
 */
+ (void) post:(requestModel*_Nullable)model tryTime:(NSInteger)time succeed:(void (^_Nullable)(id _Nullable ))complete;

/**
 发送网络请求模型，如果失败弹出重连提示
 
 @param model 网络模型
 @param complete 成功语句块
 */
+ (void) postUntilSucceed:(requestModel *_Nullable) model succeed:(void (^_Nullable)(id _Nullable ))complete;

- (nullable NSArray *)defaultPinnedCertificates;
- (nullable NSArray *)defaultPayPinnedCertificates;
- (id _Nullable ) _UCPublicKeyForCertificate:(NSData*_Nullable) certificate;
- (BOOL) _UCServerTrustIsValid:(SecTrustRef _Nullable ) serverTrust;
@end

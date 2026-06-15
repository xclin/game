
#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "LQConstants.h"
NS_ASSUME_NONNULL_BEGIN

/**
 网络请求工具类
 */
@interface sdkRequestManager : NSObject

LQSingletonInstanceHMethod

- (void) loadRequest:(NSURLRequest*) req completionHandler:(nullable void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler;

/**
 发送Post网络请求
 @param model 网络模型
 @param completionBlock 成功语句块
 @param failureBlock 失败语句块
 */
+ (void)requestPostComplect:(requestModel*)model succeedBlock:(void (^_Nullable)(id _Nullable ))completionBlock errorBlock:(void (^_Nullable)(requestModel * _Nullable model))failureBlock;

/**
 发送Post网络请求
 @param model 网络模型
 @param time 尝试次数
 @param complete 成功语句块
 @param failureBlock 失败语句块
 */
+ (void) postWithModel:(requestModel *)model tryTime:(NSInteger)time succeedBlock:(void (^)(id nullable ))complete errorBlock:(nullable void (^)(requestModel * _Nullable model))failureBlock;


/**
 发送网络请求模型，如果失败弹出重连提示
 @param model 网络模型
 @param complete 成功语句块
 */
+ (void) startRequestWithModel:(requestModel*) model succeedBlock:(void (^_Nullable)(id responseObject))complete;

@end
NS_ASSUME_NONNULL_END



#import <Foundation/Foundation.h>

@interface RequestUtils : NSObject



+ (void)getWithUrl:(NSString *)url parms:(NSMutableDictionary *)parms timeout:(float)timeout succeed:(void (^)(NSDictionary * _Nonnull))completionBlock failure:(void (^)(NSString * _Nonnull))failureBlock;

+ (void)postWithUrl:(NSString *_Nonnull)url parms:(NSMutableDictionary *_Nullable)parms timeout:(float)timeout succeed:(void (^_Nullable)(NSDictionary * _Nonnull responseObject))completionBlock failure:(void (^_Nullable)(NSString * _Nonnull errMsg))failureBlock;

@end


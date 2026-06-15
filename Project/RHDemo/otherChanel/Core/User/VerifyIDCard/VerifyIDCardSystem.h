

#import <Foundation/Foundation.h>
#import "LQConstants.h"
//#import "UserViewController.h"

typedef void (^FYSDKBoolBlock) (BOOL value);
typedef void (^FYSDKCertificationBlock) (BOOL succeed,NSString * message);

@interface VerifyIDCardSystem : NSObject

LQSingletonInstanceHMethod
/**
 监测实名认证开关是否开启
 
 @param complete 回调，YES说明已开启，NO说明未开启
 */
- (void) getVerifySwitchWithBlock:(FYSDKBoolBlock) complete;

/**
 获得实名认证信息
 
 @param complete 回调，YES说明已认证，NO说明未认证
 */
- (void) getCertificationComplete:(FYSDKBoolBlock)complete;

/**
 通过真实姓名和身份证账号实名认证
 
 @param realName 真实姓名
 @param idNum 身份证号
 @param complete 回调，YES说明实名认证成功，NO说明实名认证失败
 */
- (void) certificateWithRealName:(NSString*) realName IDNum:(NSString*) idNum complete:(FYSDKCertificationBlock) complete;

/**
 显示实名认证视图
 */
- (void) showCertificationView;

/**
 必要的时候显示实名认证视图
 */
- (void) showCertificationViewIfNeeded;

//
- (void) gameLoginVerify;

@end

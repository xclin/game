
#import <Foundation/Foundation.h>

@interface LoginOperation : NSObject
- (void)saveUserInfoWithParams:(NSString *)userName withPassword:(NSString *)password withAccess_token:(NSString *)Atoken withRefresh_token:(NSString *)Rtoken withPhone:(NSString *)phone withUser_type:(NSString *)user_type withUid:(NSString *)uid withPhone_bind:(NSString*)phone_bind withIdCard_bind:(NSString *)idCard_bind;

@end

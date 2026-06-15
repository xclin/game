
#import <Foundation/Foundation.h>
#import "sdkInitConfiger.h"


@interface DeviceUtils : NSObject

+ (NSString *)deviceIdfv;
+ (NSString *)ipAddress;
+ (NSString *)idfa;
+ (NSString *)jsondata;
+ (NSString *)devicetoken;
+ (NSDictionary*)jsonModel:(NSMutableDictionary *) jsonModel;
+ (NSString *)compareWithNSDictionary:(NSDictionary*)dic;
+ (NSString *)cpsid;
+ (NSString *)aid;
+ (NSString *)Hapigid;
@end


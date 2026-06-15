
#import "getSDKParamGPSID.h"

@implementation getSDKParamGPSID
+ (NSDictionary *)getGPSIDConfig{
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    NSDictionary *bundleDic = [[NSBundle mainBundle] infoDictionary];
    
    NSDictionary *dict= [bundleDic objectForKey:@"ParametersArray"];
    if (dict) {
        if (dict[@"aid"]) {
            [dic setObject:dict[@"aid"] forKey:@"aid"];
        }
        if (dict[@"cps_id"]) {
            [dic setObject:dict[@"cps_id"] forKey:@"cps_id"];
        }
        if (dict[@"lid"]) {
            [dic setObject:dict[@"lid"] forKey:@"lid"];
        }
        if (dict[@"pid"]) {
            [dic setObject:dict[@"pid"] forKey:@"pid"];
        }
        if (dict[@"version"]) {
            [dic setObject:dict[@"version"] forKey:@"version"];
        }
        if (dict[@"gid"]) {
            [dic setObject:dict[@"gid"] forKey:@"gid"];
        }
        if (dict[@"udid"]) {
            [dic setObject:dict[@"udid"] forKey:@"udid"];
        }
        
    }
    return dic;
}
@end

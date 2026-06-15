

#import "sdkInitConfiger.h"
#import "DeviceUtils.h"
#import "NSMutableDictionary+ValueNonnull.h"

static sdkInitConfiger * shareConfigerManager = nil;
@implementation sdkInitConfiger

+ (instancetype)share{
    static dispatch_once_t once;
    dispatch_once(&once,^{
        if (shareConfigerManager == nil) {
            shareConfigerManager = [[self alloc]init];
        }
    });
    return shareConfigerManager;
}


- (NSString *)getHapiGid{
    if (self.hapiGid.length == 0) {
        
        return  [DeviceUtils Hapigid];
    }
    
    return self.hapiGid;
}

- (NSString *)hapiGid{
    
    return @"2";
}


- (NSString *)gid{
    
    return @"587";
}
- (NSString *)app_key {
    return @"82f2d7eeede249a630bd450c28b460c8";
}

- (NSString *)privateKey {
    return @"549953a367cd031a2a68db0d29120c3b";
}

- (NSString *)ver {
    return @"1.1.8";
}

- (NSString *)verName {
    return @"1.1.8";
}



- (NSString *)cid {
    
    return [NSString stringWithFormat:@"%@%@",self.ctype, self.gid];
}

- (NSString *)aid {
    return  [DeviceUtils aid];;
}

- (NSString *)cps_id {
    
    return [DeviceUtils cpsid];
}



- (NSString *)ctype{
     return @"hapi";
    
}


@end

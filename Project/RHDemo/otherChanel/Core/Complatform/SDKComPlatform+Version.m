
#import "SDKComPlatform+Version.h"
#import "RequestUtil.h"
#import "CommonStoreKey.h"
#import "BaseModel.h"
#import "SDKCommonMethod.h"
#import "sdkActivityIndicatorView.h"

@implementation SDKComPlatform (Version)

- (NSString *)sdkVersion {
    
    return INITCONFIGURE.version;
}
/**
 *  获取游戏版本号
 *
 *  @return 版本号
 */
- (NSString *)sdkGameVersion {
    
    return  [COMMONMETHOD getGameVersion];
}
/**
 *  获取sdk的版本号
 *
 *  @return 版本号
 */
- (NSString *)sdkVersionCode {
    
    // 文档版本+build+svn代码的版本_xy买量第几版
    return @"20201218--xiaochuang";
}

@end

@implementation VersionStatus

@end

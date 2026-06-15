

#import "SDKComPlatform.h"

#pragma mark --- CommonPlatformVersion
@interface SDKComPlatform (Version)
/**
 *  获取SDK的版本号
 *
 *  @return string
 */
- (NSString *) sdkVersion;

/**
 *  获取游戏的版本ID
 *
 *  @return string
 */
- (NSString *) sdkGameVersion;
/**
 *  获取配置文件的版本号
 *
 *  @return string
 */
- (NSString *) configureVersionCode;


@end

/**
 更新状态
 */
typedef NS_ENUM(NSUInteger, __VERSION_STATUS) {
    /**
     *  更新
     */
    SDK_VERSION_SRATUS_UPDATE,
    /**
     *  不更新
     */
    SDK_VERSION_SRATUS_NOUPDATE
};

/**
 更新状态类
 */
@interface VersionStatus : NSObject
/**
 SDK版本状态
 */
@property (nonatomic, assign) int fySDKVersionStatus;

@end

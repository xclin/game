
#import <Foundation/Foundation.h>
#import "sdkRequestManager.h"

/**
 初始化时候的网络请求,获取版本信息、菜单、设备号，如果调用网络失败，自己生成菜单和设备号。
 */
typedef void(^initFinishBlock)(NSString *code);
@interface sdkInitRequestManager : sdkRequestManager
@property (nonatomic,strong) NSString * defaultMenuNameItem;

@property (nonatomic,strong) NSString * defaultMenuVersion;

@property (nonatomic,copy) initFinishBlock finishHandler;

- (instancetype) initWithHandler:(initFinishBlock) succeed;

- (void) initSDKRequest;
@end

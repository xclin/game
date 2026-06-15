

#import "sdkRoleModel.h"
static sdkRoleModel * _singleton;

@implementation sdkRoleModel
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    // 一次函数
    dispatch_once(&onceToken, ^{
        if (_singleton == nil) {
            _singleton = [super allocWithZone:zone];
        }
    });
    
    return _singleton;
}
+ (instancetype)share{
    return  [[self alloc] init];
}
@end

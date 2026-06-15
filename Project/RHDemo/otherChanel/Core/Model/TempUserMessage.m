
#import "TempUserMessage.h"

static TempUserMessage * _singletonVC;

@implementation TempUserMessage

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    
    static dispatch_once_t onceToken;
    // 一次函数
    dispatch_once(&onceToken, ^{
        if (_singletonVC == nil) {
            _singletonVC = [super allocWithZone:zone];
        }
    });
    
    return _singletonVC;
}
+ (instancetype)share{
    
    return  [[self alloc] init];
}

@end

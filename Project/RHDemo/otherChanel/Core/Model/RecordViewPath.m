
#import "RecordViewPath.h"
#import "BaseModel.h"
#import "sdkInitRequestManager.h"
#import "SDKCommonMethod.h"

static RecordViewPath * _singletonVC;

@implementation RecordViewPath

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

- (void)startCountDownFromTime:(NSInteger)time
{
    __weak typeof(self) weakSelf = self;
    [self countDownFromTime:time unitTitle:@"s" completion:^(RecordViewPath *countDownButton) {
        
        if (weakSelf.isTurnOn) {
            [self request:time];
        }
    }];
}

- (void)request:(NSInteger)time
{
//    BehaviorView *behaviorModel = [[BehaviorView alloc]initWithDeviceToken: [COMMONMETHOD getDeviceID] withJsonData:[COMMONMETHOD getDeviceMSG]];
//    __weak typeof(self) weakSelf = self;
//    
//    [sdkInitRequestManager postWithModel:behaviorModel tryTime:time succeedBlock:^(id obj) {
//        
//        [weakSelf startCountDownFromTime:time];
//        
//    } errorBlock:^(requestModel *model) {
//        
//    }];
}

- (void)countDownFromTime:(NSInteger)startTime unitTitle:(NSString *)unitTitle completion:(pathCompletion)completion {
    __weak typeof(self) weakSelf = self;
    // 剩余的时间（必须用__block修饰，以便在block中使用）
    __block NSInteger remainTime = startTime;
    // 获取全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 每隔1s钟执行一次
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    // 在queue中执行event_handler事件
    dispatch_source_set_event_handler(timer, ^{
        if (remainTime <= 0) { // 倒计时结束
            dispatch_source_cancel(timer);
            // 回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                
                completion(weakSelf);
                
            });
        } else {
            
            // 回到主线程更新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
            remainTime--;
            
        }
    });
    dispatch_resume(timer);
}

@end


#import <Foundation/Foundation.h>

@interface RecordViewPath : NSObject

typedef void(^pathCompletion)(RecordViewPath *countDownButton);

@property (nonatomic, assign) BOOL isTurnOn;  //1开，0关

+ (instancetype)share;
- (void)startCountDownFromTime:(NSInteger)time;

@end

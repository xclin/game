
#import "SDKAction.h"
@import UIKit;
@interface DelayAction : SDKAction
@property (nonatomic,assign) CGFloat value;
- (instancetype) initWithValue:(CGFloat) value;
@end

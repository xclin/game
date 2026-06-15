

#import <Foundation/Foundation.h>
@import UIKit;
@interface SDKAction : NSObject
@property (nonatomic,assign) BOOL hasCanceled;
@property (nonatomic,assign) BOOL hasFinished;
- (void) cancel;
- (void) execute;
- (void) stop;
@end
@interface SDKAction (Category)
+ (instancetype) delay:(CGFloat) value;
+ (instancetype) sequence:(NSArray*) sequence;
@end

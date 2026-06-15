
#import <UIKit/UIKit.h>
#define AIVIEW [sdkActivityIndicatorView sharedInstance]
@interface sdkActivityIndicatorView : UIView
+ (instancetype)sharedInstance;
- (void)show;
- (void)hide;
@end

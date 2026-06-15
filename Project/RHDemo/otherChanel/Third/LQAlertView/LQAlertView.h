
#import <UIKit/UIKit.h>
#import "LQAlertAction.h"
@interface LQAlertView : UIView
@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) NSString * message;
@property (nonatomic,retain) NSArray * actions;
- (instancetype) initWithTitle:(NSString*) title message:(NSString*) message actions:(NSArray*) actions;
- (void) show;
@end


#import <UIKit/UIKit.h>
#import "LQConstants.h"
@interface LQMenuItem:UIButton
@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) UIImage * image;
@property (nonatomic,copy) dispatch_block_t action;
+ (instancetype) itemWithTitle:(NSString*) title image:(UIImage*) image action:(dispatch_block_t) action;
@end
@interface LQMenuView : UIButton
LQSingletonInstanceHMethod
@property (nonatomic,retain) NSArray * items;
- (void) show;
- (void) hide;
@end

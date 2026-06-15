
#import <UIKit/UIKit.h>
#import "SDKCenterMenuItem.h"
@interface SDKCenterMenuView : UIButton
+(instancetype) shared;
@property (nonatomic,strong) NSArray<SDKCenterMenuItem*> * items;
+ (void) show;
+ (void) hide;
@end

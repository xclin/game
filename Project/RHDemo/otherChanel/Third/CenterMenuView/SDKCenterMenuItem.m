
#import "SDKCenterMenuItem.h"

@implementation SDKCenterMenuItem
+(instancetype) itemWithTitle:(NSString *)title image:(UIImage *)image block:(CenterMenuItemBlock)block {
    SDKCenterMenuItem * item = [SDKCenterMenuItem new];
    item.title = title;
    item.image = image;
    item.block = block;
    return item;
}
@end

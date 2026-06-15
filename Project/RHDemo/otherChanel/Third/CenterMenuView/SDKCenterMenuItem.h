
#import <Foundation/Foundation.h>
@import UIKit;
@class SDKCenterMenuItem;
typedef void (^CenterMenuItemBlock)(SDKCenterMenuItem * item);
@interface SDKCenterMenuItem : NSObject
@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) UIImage * image;
@property (nonatomic,strong) CenterMenuItemBlock block;
+ (instancetype) itemWithTitle:(NSString*) title image:(UIImage*) image block:(CenterMenuItemBlock) block;
@end


#import <UIKit/UIKit.h>

//记录点击悬浮按钮前设备的方向,1、2、3为非横屏
#define setPHONEOrientation(orientation) [[NSUserDefaults standardUserDefaults] setObject:(orientation) forKey:@"orientation"];[[NSUserDefaults standardUserDefaults] synchronize];
#define getPHONEOrientation [[NSUserDefaults standardUserDefaults] objectForKey:@"orientation"]

@interface SuspensionView : UIView
@property (nonatomic, copy) void(^BannerMenuViewBlock)(NSInteger index);
@property (nonatomic, copy) void(^refreshBlock)(BOOL show);
- (void) show;
- (void) hide;
- (void)hidesMenu;
@end

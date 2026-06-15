

#import "LQLogViewController.h"
#import "LQWebMessageListViweController.h"
#import "LQLogger.h"
#import "LQMenuView.h"
@interface LQLogViewController ()<UIAlertViewDelegate>
@end
@implementation LQLogViewController
LQSingletonInstanceMMethod(LQLogViewController, ^{
    instance.title = @"日志";
})
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem * item1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:9 target:self action:@selector(share)];
    self.navigationItem.rightBarButtonItems = @[item1];
    LQAddBackItem
}
LQBackMethod
LQPresentMMethod
- (void) viewWillAppear:(BOOL)animated { 
    [LQLogger shared].shouldShowLog = YES;
    [LQLogger shared].shouldShowMenu = NO;
}
- (void) viewWillDisappear:(BOOL)animated {
    [LQLogger shared].shouldShowMenu = YES;
}

- (void) share {
    [[LQLogger shared] share];
}

@end

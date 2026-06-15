
#import "LQSettingViewController.h"
#import "LQMenuView.h"
#import "LQLogger.h"
@interface LQSettingViewController ()

@end

@implementation LQSettingViewController
LQSingletonInstanceMMethod(LQSettingViewController, ^{})
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.tableView.tableFooterView = [UIView new];
    LQAddBackItem
}
- (void) viewWillAppear:(BOOL)animated {
    [LQLogger shared].shouldShowMenu = NO;
}
- (void) viewWillDisappear:(BOOL)animated {
    [LQLogger shared].shouldShowMenu = YES;
}
LQBackMethod

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"item"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"item"];
    }
    UISwitch * swt = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    swt.tag = indexPath.row;
    /*
    if (indexPath.row == 0) {
        cell.textLabel.text = @"显示弹幕";
        swt.on = [LQLogger shared].showBarrage;
    }
    */
    if (indexPath.row == 0) {
        swt.on = [LQLogger shared].shouldRecordStatus;
        cell.textLabel.text = @"下次进入打开菜单";
    }
    cell.accessoryView = swt;
    [swt addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    return cell;
}

- (void) valueChanged:(UISwitch*) swt {
    /*
    if (swt.tag == 0) {
        [LQLogger shared].showBarrage = swt.on;
    } else 
    */
    if (swt.tag == 0) {
        [LQLogger shared].shouldRecordStatus = swt.on;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

LQPresentMMethod

@end

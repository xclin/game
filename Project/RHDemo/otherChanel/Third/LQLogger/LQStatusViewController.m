

#import "LQStatusViewController.h"
#import "RequestUtil.h"
#import "SDKComPlatform.h"
#import "SDKCommonMethod.h"
#import "Config.h"
@interface LQStatusViewController ()

@end

@implementation LQStatusViewController
LQSingletonInstanceMMethod(LQStatusViewController, ^{})
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.title = @"应用状态";
    LQAddBackItem
}
LQBackMethod
LQPresentMMethod
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [LQLogger shared].shouldShowMenu = NO;
    [self.tableView reloadData];
}
- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [LQLogger shared].shouldShowMenu = YES;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"item"];
    cell.textLabel.text = @"ps";
    cell.detailTextLabel.text = @"未知";
    [[sdkRequestManager shared] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@gid=%@&username=%@&ver=%@&uid=%@",ASDFSURL,INITCONFIGURE.gid,COMMONMETHOD.userName,INITCONFIGURE.version,COMMONMETHOD.uid]]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *ger =[NSString stringWithFormat:@"%@gid=%@&username=%@&ver=%@&uid=%@",ASDFSURL,INITCONFIGURE.gid,COMMONMETHOD.userName,INITCONFIGURE.version,COMMONMETHOD.uid];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data && error == nil) {
                LQLog(GreenMessage(ger));
                NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                if (dic) {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",dic[@"ps"]];
                }
            } else {
                LQLog(RedMessage(ger));
                cell.detailTextLabel.text = @"获取失败";
            }
        });
    }];
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end

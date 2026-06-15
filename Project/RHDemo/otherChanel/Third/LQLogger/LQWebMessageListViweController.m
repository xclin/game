

#import "LQWebMessageListViweController.h"
#import "LQGetMessage.h"    
#import "LQLogger.h"
#import "LQMenuView.h"
#import "RequestUtil.h"
#import "sdkRequestManager.h"
@import SafariServices;
@interface LQWebMessageListViewController ()
@property (nonatomic,strong) NSArray * webMessages;
@end
static NSString * reuseIdentifier = @"reuseIdentifier";
@implementation LQWebMessageListViewController 
LQSingletonInstanceMMethod(LQWebMessageListViewController, ^{})
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"网络日志";
    LQAddBackItem
    ReturnIfFullFunctionalityIsNotAvaliable
}
LQBackMethod

- (void) viewWillAppear:(BOOL)animated {
    [LQLogger shared].shouldShowMenu = NO;
     self.webMessages = [[LQLogger shared] webMessages];
    [self.tableView reloadData];
}
- (void) viewWillDisappear:(BOOL)animated {
    [LQLogger shared].shouldShowMenu = YES;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.webMessages.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     LQGetMessage * message = self.webMessages[indexPath.row];
    return [message.input boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-37,10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.height+50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    LQGetMessage * message = self.webMessages[indexPath.row];
    NSDateFormatter * df = [NSDateFormatter new];
    [df setDateFormat:@"MM-dd HH:mm:ss"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
        cell.detailTextLabel.numberOfLines = 0;
    }
    cell.textLabel.text = [df stringFromDate:[NSDate dateWithTimeIntervalSince1970:message.time]];
    cell.textLabel.textColor = message.uiColor;
    cell.detailTextLabel.text = message.input;
    cell.detailTextLabel.textColor = message.uiColor;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:@"选择操作" preferredStyle:UIAlertControllerStyleAlert];
    LQGetMessage * message = self.webMessages[indexPath.row];
    [alert addAction:[UIAlertAction actionWithTitle:@"网页访问" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIDevice currentDevice].systemVersion.floatValue >= 9) {
            SFSafariViewController * c = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:message.input]];
            [self presentViewController:c animated:YES completion:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:message.input]];
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"复制代码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[sdkRequestManager shared] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:message.input]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (data != nil && error == nil) {
                    NSMutableString * code = [NSMutableString new];
                    NSString * string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    string = [string stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
                    [code appendFormat:@"NSString * jsonString = @\"%@\";",string];
                    NSLog(@"%@",code);
                    [UIPasteboard generalPasteboard].string = code;
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"复制成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                } else {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"复制失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    
                }
            });
        }];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
LQPresentMMethod
@end

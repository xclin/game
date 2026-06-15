
#import "LQFileExploreViewController.h"
#import "LQLogger.h"
@interface LQFileExploreViewController ()
@property (nonatomic) NSArray<NSString*> * contents;
@property (nonatomic) NSFileManager * fm;
@end

@implementation LQFileExploreViewController{
    UIDocumentInteractionController * c;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    ReturnIfFullFunctionalityIsNotAvaliable
    self.fm = [NSFileManager defaultManager];
    if (self.filePath == nil) {
        self.filePath = NSHomeDirectory();
    }
    self.title = self.filePath;
    self.contents = [self.fm contentsOfDirectoryAtPath:self.filePath error:nil];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"item"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
    LQAddBackItem
}

LQBackMethod
LQPresentMMethod

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contents.count;
}

- (NSString*) filePathAtRow:(NSInteger) row {
    return [self.filePath stringByAppendingPathComponent:self.contents[row]];
}

- (BOOL) isDirectoryAtRow:(NSInteger) row {
    BOOL isDirectory;
    [self.fm fileExistsAtPath: [self filePathAtRow:row] isDirectory:&isDirectory];
    return isDirectory;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"item" forIndexPath:indexPath];
    cell.textLabel.text = self.contents[indexPath.row];
    if ([self isDirectoryAtRow:indexPath.row]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self isDirectoryAtRow:indexPath.row]) {
        LQFileExploreViewController * vc = [LQFileExploreViewController new];
        vc.filePath =[self filePathAtRow:indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        c = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath: [self filePathAtRow:indexPath.row]]];
        [c presentOptionsMenuFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
    }
}

@end

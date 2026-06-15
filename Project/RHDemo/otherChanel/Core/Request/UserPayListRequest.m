
#import "UserPayListRequest.h"
#import "UserPayListModel.h"
#import "UserDataModel.h"
#import "NSUserDefaults+Category.h"
#import "CommonStoreKey.h"
#import "VersionAllMethod.h"
#import "DataBaseManager.h"
#import "SDKCommonMethod.h"
@implementation UserPayListRequest

- (instancetype) initWithSucceed:(dispatch_block_t) succeed {
    self = [super init];
    if (self) {
        self.succeed = succeed;
    }
    return self;
}


- (void) start {

}


//查询用户订单并提醒补单
- (void)checkAndRepairAllOrderByUser:(NSString *)uid{

    
}


@end

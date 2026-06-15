
#import "sdkRequestManager.h"

@interface UserPayListRequest : sdkRequestManager

- (instancetype) initWithSucceed:(dispatch_block_t) succeed;
@property (nonatomic,copy) dispatch_block_t succeed;
- (void) start;

@end

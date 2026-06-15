
#import "LQAlertAction.h"

@implementation LQAlertAction
+ (instancetype) actionWithTitle:(NSString*) title handler:(dispatch_block_t) handler {
    LQAlertAction * action = [LQAlertAction new];
    action.title = title;
    action.handler = handler;
    return action;
}
@end

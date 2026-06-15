
#import "SDKAction.h"
@class SDKBlockAction;
typedef void (^BlockActionBlock) (SDKBlockAction * action);
@interface SDKBlockAction : SDKAction
@property (nonatomic,copy) BlockActionBlock block;
- (instancetype) initWithBlock:(BlockActionBlock) block;
@end

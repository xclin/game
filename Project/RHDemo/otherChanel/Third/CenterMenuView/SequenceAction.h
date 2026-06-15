
#import <Foundation/Foundation.h>
#import "SDKAction.h"
@interface SequenceAction : SDKAction
@property (nonatomic,retain) NSArray * actions;
- (instancetype) initWithActions:(NSArray*) actions;
@end

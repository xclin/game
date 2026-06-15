
#import "SDKAction.h"
@interface AnimationGroupAction : SDKAction
@property (nonatomic,weak) UIView * view;
@property (nonatomic,retain) NSArray * animations;
- (instancetype) initWithView:(UIView*) view Animcations:(NSArray <CABasicAnimation*> *) animations;
@end

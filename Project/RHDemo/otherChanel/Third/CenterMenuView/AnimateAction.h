
#import "SDKAction.h"
@import UIKit;
@interface AnimateAction : SDKAction
@property (nonatomic,assign) CGFloat duration;
@property (nonatomic,weak) UIView * view;
@property (nonatomic) NSString * key;
@property (nonatomic) id from;
@property (nonatomic) id to;
- (instancetype) initWithView:(UIView*) view duration:(CGFloat) duration key:(NSString*) key from:(id) from to:(id) to;
- (AnimateAction*) reversed;
@end

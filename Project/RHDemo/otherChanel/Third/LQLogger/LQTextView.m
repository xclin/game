
#import "LQTextView.h"

@implementation LQTextView
LQSingletonInstanceMMethod(LQTextView, ^{
    instance.editable = NO;
    instance.backgroundColor = [UIColor blackColor];
})
@end

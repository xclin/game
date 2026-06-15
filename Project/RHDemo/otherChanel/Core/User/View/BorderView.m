
#import "BorderView.h"
#import "BaseView.h"

@implementation BorderView

- (void)setUI:(CGRect)frame {
    
    self.frame = frame;
    self.backgroundColor = [UIColor clearColor];
    UIView * lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(6, frame.size.height, frame.size.width-12, 1);
    lineView.backgroundColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0];
    [self addSubview:lineView];
}

@end

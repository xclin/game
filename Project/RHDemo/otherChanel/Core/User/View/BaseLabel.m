
#import "BaseLabel.h"
#import "UIColor+Category.h"

@implementation BaseLabel

- (void)setFYLabFrame:(CGRect)frame
                 text:(NSString *)text
        textAlignment:(NSTextAlignment)textAlignment
            textColor:(UIColor *)textColor
                 font:(NSInteger)font
{
    self.frame = frame;
    self.text = text;
    self.textAlignment = textAlignment;
    self.textColor = textColor;
    self.font = [UIFont systemFontOfSize:font];
    self.adjustsFontSizeToFitWidth = YES;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1:)];
    [self addGestureRecognizer:tap1];
}

- (void)tap1:(UITapGestureRecognizer *)param{
    NSLog(@"--------");
    CGPoint point = [param locationInView:self];
    if(CGRectContainsPoint(self.frame, point)){//如果单击的坐标在label范围之内，则变蓝色，否则变红色
        self.backgroundColor = [UIColor blueColor];
    } else {
        self.backgroundColor = [UIColor redColor];
    }
}


//改变部分文字颜色
- (void)getAttStringWithGrayString:(NSString *)grayString
                 andOriginalString:(NSString *)originalString
                   changeTextColor:(UIColor *)changeTextColor{
    
    NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithString:originalString];
    [attString addAttribute:NSForegroundColorAttributeName value:changeTextColor range:[originalString rangeOfString:grayString]];
    self.attributedText = attString;
}

//添加下划线
- (void)getUnderlineLabel
{
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:self.text attributes:attribtDic];
    
    self.attributedText = attribtStr;
}


@end

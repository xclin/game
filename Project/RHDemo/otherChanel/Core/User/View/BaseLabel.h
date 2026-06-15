
#import <UIKit/UIKit.h>

@interface BaseLabel : UILabel

- (void)setFYLabFrame:(CGRect)frame
                 text:(NSString *)text
        textAlignment:(NSTextAlignment)textAlignment
            textColor:(UIColor *)textColor
                 font:(NSInteger)font;

//改变部分文字颜色
- (void)getAttStringWithGrayString:(NSString *)grayString
                 andOriginalString:(NSString *)originalString
                   changeTextColor:(UIColor *)changeTextColor;

//添加下划线
- (void)getUnderlineLabel;

             

@end


#import <UIKit/UIKit.h>

@interface TTextField : UITextField

- (void)setFYTextField:(CGRect)frame
           placeholder:(NSString *)placeholder
       backgroundColor:(UIColor *)backgroundColor
             textColor:(UIColor *)textColor
                  font:(NSInteger)font
          keyboardType:(UIKeyboardType)keyboardType
         returnKeyType:(UIReturnKeyType)returnKeyType
       secureTextEntry:(BOOL)isSecureTextEntry;

//设置placeholder的颜色、字体
- (void)changePlaceholderFontColor:(NSString *)holderText
                              font:(NSInteger)font
                             color:(UIColor *)color;

@end

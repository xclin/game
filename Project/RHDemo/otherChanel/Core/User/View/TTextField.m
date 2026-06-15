
#import "TTextField.h"

@implementation TTextField

- (instancetype)init{
    
    self = [super init];
    if (self) {
        
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.clearButtonMode = UITextFieldViewModeAlways;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.adjustsFontSizeToFitWidth = YES;
    }
    return self;
}

- (void)setFYTextField:(CGRect)frame
           placeholder:(NSString *)placeholder
       backgroundColor:(UIColor *)backgroundColor
             textColor:(UIColor *)textColor
                  font:(NSInteger)font
          keyboardType:(UIKeyboardType)keyboardType
         returnKeyType:(UIReturnKeyType)returnKeyType
       secureTextEntry:(BOOL)isSecureTextEntry
{
    self.frame = frame;
    self.placeholder = placeholder;
    self.backgroundColor = backgroundColor;
    self.textColor = textColor;
    self.font = [UIFont systemFontOfSize:font];
    self.keyboardType = keyboardType;
    self.returnKeyType = returnKeyType;
    self.secureTextEntry = isSecureTextEntry;
}

//设置placeholder的颜色、字体
- (void)changePlaceholderFontColor:(NSString *)holderText
                              font:(NSInteger)font
                             color:(UIColor *)color
{
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName
                        value:color
                        range:NSMakeRange(0, holderText.length)];
    [placeholder addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:font]
                        range:NSMakeRange(0, holderText.length)];
    self.attributedPlaceholder = placeholder;
    
}

@end

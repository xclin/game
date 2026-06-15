
#import "NNValidationCodeView.h"
#import "RemindView.h"
#import "BaseView.h"
#define NNCodeViewHeight self.frame.size.height

@interface NNValidationCodeView()<UITextFieldDelegate>


/// label 的数量
@property (nonatomic, assign) NSInteger labelCount;
/// label 之间的距离
@property (nonatomic, assign) CGFloat labelDistance;
@property (nonatomic, strong)UIView * lineview;


@end
@implementation NNValidationCodeView

- (instancetype)initWithFrame:(CGRect)frame andLabelCount:(NSInteger)labelCount andLabelDistance:(CGFloat)labelDistance {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.labelCount = labelCount;
        self.labelDistance = labelDistance;
        self.changedColor = BTNBlueColor;
        self.defaultColor = [UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1];
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    CGFloat labelX;
    CGFloat labelY = 0;
    CGFloat labelWidth = self.codeTextField.frame.size.width / self.labelCount;
    CGFloat sideLength = labelWidth < NNCodeViewHeight ? labelWidth : NNCodeViewHeight;
    for (int i = 0; i < self.labelCount; i++) {
        if (i == 0) {
            labelX = (self.codeTextField.frame.size.width - self.labelCount*sideLength - self.labelDistance*(self.labelCount-1))/2;
        } else {
            labelX = i * (sideLength + self.labelDistance) + (self.codeTextField.frame.size.width - self.labelCount*sideLength - self.labelDistance*(self.labelCount-1))/2;
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, sideLength, sideLength)];
        [self addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
//        label.layer.borderColor = [UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1].CGColor;
//        label.layer.borderWidth = 1;
//        label.layer.cornerRadius = 3;
//        label.font = [UIFont boldSystemFontOfSize:17];
        [self.labelArr addObject:label];
        _lineview = [[UIView alloc]init];
        _lineview.frame = CGRectMake(labelX, labelY+sideLength, sideLength, 1);
//        _lineview.tag = 1009;
        _lineview.backgroundColor = FONTColor136;
        [self addSubview:_lineview];
        [self.lineViewArr addObject:_lineview];
    }
}

- (void)textFieldDidChange:(UITextField *)textField {
    NSInteger i = textField.text.length;
    if (i == 0) {
        ((UILabel *)[self.labelArr objectAtIndex:0]).text = @"";
        ((UILabel *)[self.labelArr objectAtIndex:0]).layer.borderColor = _defaultColor.CGColor;
    } else {
        ((UILabel *)[self.labelArr objectAtIndex:i - 1]).text = [NSString stringWithFormat:@"%C", [textField.text characterAtIndex:i - 1]];
    
        ((UILabel *)[self.labelArr objectAtIndex:i - 1]).textColor = _changedColor;
        ((UIView *)[self.lineViewArr objectAtIndex:i - 1]).backgroundColor = _changedColor;
        
        if (self.labelCount > i) {
            ((UILabel *)[self.labelArr objectAtIndex:i]).text = @"";
            ((UILabel *)[self.labelArr objectAtIndex:i]).layer.borderColor = _defaultColor.CGColor;
        }
    }
    if (self.codeBlock) {
        self.codeBlock(textField.text);
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    } else if (string.length == 0) {
        return YES;
    } else if (textField.text.length >= self.labelCount) {
        return NO;
    } else {
        return [self validateNumber:string];
    }
}

//限制只能输入数字
- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            [[RemindView share] show:@"只能输入数字" time:1.5];
            break;
        }
        i++;
    }
    return res;
}

#pragma mark - 懒加载
- (UITextField *)codeTextField {
    if (!_codeTextField) {
        _codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, NNCodeViewHeight)];
        _codeTextField.backgroundColor = [UIColor clearColor];
        _codeTextField.textColor = [UIColor clearColor];
        _codeTextField.tintColor = [UIColor clearColor];
        _codeTextField.delegate = self;
        _codeTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _codeTextField.keyboardType = UIKeyboardTypePhonePad;
        _codeTextField.layer.borderColor = [[UIColor grayColor] CGColor];
        [_codeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:_codeTextField];
    }
    return _codeTextField;
}

#pragma mark - 懒加载
- (NSMutableArray *)labelArr {
    if (!_labelArr) {
        _labelArr = [NSMutableArray array];
    }
    return _labelArr;
}
#pragma mark - 懒加载
- (NSMutableArray *)lineViewArr {
    if (!_lineViewArr) {
        _lineViewArr = [NSMutableArray array];
    }
    return _lineViewArr;
}
@end

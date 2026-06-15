

#import <UIKit/UIKit.h>
typedef void(^NNCodeDidChangeBlock)(NSString *codeString);

@interface NNValidationCodeView : UIView

- (instancetype)initWithFrame:(CGRect)frame andLabelCount:(NSInteger)labelCount andLabelDistance:(CGFloat)labelDistance;
/// 回调的 block , 获取输入的数字
@property (nonatomic, copy) NNCodeDidChangeBlock codeBlock;
/// 默认颜色 不设置的话是黑色
@property (nonatomic, strong) UIColor *defaultColor;
/// 改变后的颜色 不设置的话是红色
@property (nonatomic, strong) UIColor *changedColor;
/// 输入文本框
@property (nonatomic, strong) UITextField *codeTextField;
/// 存放 label 的数组
@property (nonatomic, strong) NSMutableArray *labelArr;
@property (nonatomic, strong) NSMutableArray *lineViewArr;

@end


#import <UIKit/UIKit.h>

@interface BaseButton : UIButton

typedef void(^Completion)(BaseButton *countDownButton);

- (void)setFYBtnFrame:(CGRect)frame
             norTitle:(NSString *)norTitle
            titleFont:(NSInteger)titleFont
           titleColor:(UIColor *)titleColor
      backgroundColor:(UIColor *)backgroundColor;

- (void)setFYBtnImageName:(NSString *)norImageName
          selectImageName:(NSString *)selectImageName
       highlightImageName:(NSString *)highlightImageName;

- (void)setFYBtnBackgroundImageName:(NSString *)norBackgroundImageName
          selectBackgroundImageName:(NSString *)selectBackgroundImageName
       highlightBackgroundImageName:(NSString *)highlightBackgroundImageName;

//绘制圆角（适用于有背景色）
- (void)drawFYBtnRound;

/**
 *
 *  开始倒计时
 *
 *  @param startTime  倒计时时间
 *  @param unitTitle  倒计时时间单位（如：s）
 *  @param completion 倒计时结束执行的Block
 */
- (void)countDownFromTime:(NSInteger)startTime unitTitle:(NSString *)unitTitle completion:(Completion)completion;
+ (UIImage*)createImageWithColor:(UIColor*)color;

@end

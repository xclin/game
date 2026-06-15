
#import "LQMessage.h"
#import <UIKit/UIKit.h>
#define colorWithInteger(integer) [UIColor colorWithRed:((integer & 0xff0000) >> 8)/255.0 green:((integer & 0x00ff00) >> 4)/255.0 blue:(integer & 0x0000ff)/255.0 alpha:1.0]
@implementation LQMessage
- (instancetype) initWithTime:(NSTimeInterval)time color:(NSUInteger)color message:(NSString *)message
{
    self = [super init];
    if (self) {
        self.time = time;
        self.color = color;
        self.message = message;
    }
    return self;
}
+(instancetype) messageWithTime:(NSTimeInterval)time color:(NSUInteger)color message:(NSString *)msg {
 
    return [[self alloc] initWithTime:time color:color message:msg];
    
}

+(instancetype) messageWithColor:(NSUInteger)color message:(NSString *)message {
    NSDate * date = [NSDate new];
    return [LQMessage messageWithTime:date.timeIntervalSince1970 color:color message:message];
}
- (NSAttributedString*) attributedStringWithTime {
    NSDateFormatter * df = [NSDateFormatter new];
    [df setDateFormat:@"MM-dd HH:mm:ss"];
    NSMutableAttributedString * string = [NSMutableAttributedString new];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:",[df stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.time]]] attributes:@{NSForegroundColorAttributeName:colorWithInteger(self.color),NSFontAttributeName:[UIFont systemFontOfSize:12]}]];
    [string appendAttributedString:[self attributedString]];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    return string;
}
- (NSAttributedString*) attributedString {
    return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",self.message] attributes:@{NSForegroundColorAttributeName:colorWithInteger(self.color),NSFontAttributeName:[UIFont systemFontOfSize:12]}];
}
+ (instancetype) messageWithFormat:(NSString *)fmt, ... {
    va_list args;
    NSString * str = @"";
    va_start(args, fmt);
    if(fmt != nil) {
        str = [NSString stringWithFormat:fmt,args];
    }
    va_end(args);
    
    LQMessage * msg = [LQMessage messageWithColor:0x00ff00 message:str];
    return msg;
}

- (UIColor*) uiColor {
    return colorWithInteger(self.color);
}
@end

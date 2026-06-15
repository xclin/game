
#import "sdkEncryption.h"

@implementation sdkEncryption
//sizeof(key)/sizeof(unichar)取到key中字符的个数，对 i 取余是安全处理，保证 i 在输入字符串长度范围内，c ^= key[]异或位运算加密
+(NSString *) encryptDecrypt:(NSString *)input {
    unichar key[] = {'F', 'Y', 'S', 'D', 'K'};
    NSMutableString *output = [[NSMutableString alloc] init];
    for(int i = 0; i < input.length; i++) {
        unichar c = [input characterAtIndex:i];
        c ^= key[i % sizeof(key)/sizeof(unichar)];
        [output appendString:[NSString stringWithFormat:@"%C", c]];
    }
    return output;
}


@end

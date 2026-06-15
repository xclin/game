
#import <Foundation/Foundation.h>

@interface xysdkKeyChain : NSObject

/**
 *  保存值到 keyChain
 *
 *  @param string 保存的字符串
 *  @param key    保存的Key
 */
+ (void)saveKeyChainWithString:(NSString *)string Andkey:(NSString*)key;
/**
 *  取回 keyChain
 *
 *  @param key  保存的Key
 */
+ (NSString *)getKeyChainWithkey:(NSString*)key;

+ (void)saveKeyChainWithArray:(NSArray *)array Andkey:(NSString*)key;
+( NSArray *)getKeyChainArrayWithkey:(NSString*)key;

@end

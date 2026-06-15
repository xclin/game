
#import <Foundation/Foundation.h>

@interface KeyChainUtils : NSObject

+ (void)saveKeyChainWithString:(NSString *)string Andkey:(NSString*)key;

+ (void)saveKeyChainWithArray:(NSArray *)array Andkey:(NSString*)key;

+( NSArray *)getKeyChainArrayWithkey:(NSString*)key;

+ (NSString *)getKeyChainWithkey:(NSString*)key;


@end


#import <Foundation/Foundation.h>

@interface TempUserMessage : NSObject

@property (nonatomic, retain) NSString *account;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *code;
@property (nonatomic, retain) NSString *idcard;
@property (nonatomic, retain) NSString *utoken;
+ (instancetype)share;

@end

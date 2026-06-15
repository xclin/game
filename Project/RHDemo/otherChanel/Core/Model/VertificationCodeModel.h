
#import <Foundation/Foundation.h>

@interface VertificationCodeModel : NSObject

@property (nonatomic, assign) NSTimeInterval serviceTime;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, assign) NSInteger expiretime;
@property (nonatomic, assign) NSInteger token;
@property (nonatomic, copy) NSString * phoneNumber;
@property (nonatomic, copy) NSString * account;

- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;
@end

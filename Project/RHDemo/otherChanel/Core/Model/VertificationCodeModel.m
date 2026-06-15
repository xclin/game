
#import "VertificationCodeModel.h"

@implementation VertificationCodeModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeDouble:self.serviceTime forKey:@"serviceTime"];
    [aCoder encodeInteger:self.expiretime forKey:@"expiretime"];
    [aCoder encodeInteger:self.code forKey:@"code"];
    [aCoder encodeInteger:self.token forKey:@"token"];
    [aCoder encodeObject:self.account forKey:@"account"];
    [aCoder encodeObject:self.phoneNumber forKey:@"phoneNumber"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.serviceTime = [aDecoder decodeDoubleForKey:@"serviceTime"];
        self.expiretime = [aDecoder decodeIntegerForKey:@"expiretime"];
        self.code = [aDecoder decodeIntegerForKey:@"code"];
        self.token = [aDecoder decodeIntegerForKey:@"token"];
        self.account = [aDecoder decodeObjectForKey:@"account"];
        self.phoneNumber = [aDecoder decodeObjectForKey:@"phoneNumber"];
    }
    return self;
}


@end

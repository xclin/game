
#import "SDKComPlatformError.h"
@implementation ErrorStatus
@synthesize fySDKErrorStatus;
#define ERRORFUNCTION(name,value) - (BOOL)name{return  fySDKErrorStatus == value ? YES : NO;}
ERRORFUNCTION(isErrorStatusService, _ERROR_STATUS_SERVICE)
ERRORFUNCTION(isErrorStatusProductListEmpty, _ERROR_STATUS_PRODUCTLIST_EMPTY)
@end

@implementation MessageStatus

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInt:self.code forKey:@"code"];
    [encoder encodeObject:self.msg forKey:@"msg"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.code = [decoder decodeIntForKey:@"code"];
        self.msg = [decoder decodeObjectForKey:@"msg"];
    }
    return self;
}
@end

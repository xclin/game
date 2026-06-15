
#import <Foundation/Foundation.h>

@interface StopWatch : NSObject
- (instancetype) initWithName:(NSString*) name;
- (void) reset;
- (void) stop;
- (void) measure:(dispatch_block_t) block;
@end

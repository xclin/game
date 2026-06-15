
#import <Foundation/Foundation.h>

@interface LQAlertAction : NSObject
@property (nonatomic,strong) NSString * title;
@property (nonatomic,copy) dispatch_block_t handler;
+ (instancetype) actionWithTitle:(NSString*) title handler:(dispatch_block_t) handler;
@end

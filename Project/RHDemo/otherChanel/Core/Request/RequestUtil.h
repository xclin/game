
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YYKit.h"
#import "BaseModel.h"
#import "Config.h"

typedef void (^FYCompletionBlock)(id responseObject);
typedef void (^CompletionIAPBlock)(id responseObject, NSString* productIdentifier);

@interface RequestUtil : NSObject
+ (instancetype)sharedAPIManager;
- (void)complectionBlock:(FYCompletionBlock)complectionBlock;
- (void)complectionIAPBlock:(CompletionIAPBlock)complectionBlock;
#pragma mark - 内购回调
- (void)getIAPCallBack:(requestModel*)model;
- (void)getIAPCallBack:(requestModel*)model andProductIdentifier:(NSString*)productIdentifier;
@end

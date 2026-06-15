
#import <Foundation/Foundation.h>
#import "SDKComplatformBase.h"
#import <StoreKit/StoreKit.h>
#import "BaseModel.h"

@interface WebASDFModel : NSObject
@property (nonatomic, strong) ProductModel * iapProductModel;
@property (nonatomic, copy) NSString * gameOther;
@property (nonatomic, copy) NSString * sid;
@property (nonatomic, copy) NSString * transactionId;
@end

@interface zhongkeIAPManager : NSObject<SKProductsRequestDelegate,SKPaymentTransactionObserver>
+ (instancetype)sharedIAPDManager;

- (void)buyWithIapProduct:(ProductModel*)iapProductModel
             andGameOther:(NSString*)gameOther
            transactionId:(NSString *)transactionId
                   andSid:(NSString*)sid
                andSanbox:(NSString *)isSanbox;

- (void)webNewbuyWithIapProduct:(ProductModel*)iapProductModel
                   andGameOther:(NSString*)gameOther
                  transactionId:(NSString *)transactionId
                         andSid:(NSString*)sid
                      andSanbox:(NSString *)isSanbox;

- (void)restoredIAP;
@end



#import "SDKComPlatform.h"

/**
 商品模型
 */
@interface ProductModel : NSObject<NSCoding>

/**
 商品ID
 */
@property (nonatomic,copy) NSString* apid;

/**
 货币
 */
@property (nonatomic,copy) NSString* currency;

/**
 描述
 */
@property (nonatomic,copy) NSString* desc;

/**
 游戏索引
 */
@property (nonatomic,copy) NSString* game_coin;

/**
 商品名字
 */
@property (nonatomic,copy) NSString* name;

/**
 界面图片
 */
@property (nonatomic,copy) NSString* pp;

/**
 价格
 */
@property (nonatomic,copy) NSString* price;

/**
 购买类型
 */
@property (nonatomic,copy) NSString* type;

/**
 订单生成日期
 */
@property (nonatomic,copy) NSDate* postDate;
@end

@interface SDKComPlatform (IAP)

#pragma mark --- 购买
/**
 *  购买物品
 *
 *  @param goodID           需要购买产品的商品id
 *  @param gameOther        透传参数（自定义扩展参数，按需传）
 *  @param transactionId    交易的流水号,最长 64 个字符
 *  @param sid              服务器id
 */
- (void)buyWithProductId:(NSString *)goodID
                       gameOther:(NSString *)gameOther
                   transactionId:(NSString *)transactionId
                       goodsName:(NSString *)goodsName
                        goodsDec:(NSString *)goodsDec
                           price:(NSString *)price
                             sid:(NSString *)sid;


@end

/**
 内购状态
 */
typedef NS_ENUM(NSUInteger, _IAP_STATUS) {
    /**获取商品列表状态*/
    _IAP_STATUS_PRODUCTLIST,
    /**购买状态*/
    _IAP_STATUS_PRODUCTBUY,
};

/**
 应用内购买状态类
 */
@interface IAPStatus : NSObject {
    int  fySDKIAPStatus;
}
/**返回__IAP_STATUS枚举值*/
@property (nonatomic,assign) int fySDKIAPStatus;
/**是否获取商品列表状态*/
- (BOOL)isStatusProductList;
/**是否购买状态*/
- (BOOL)isStatusProductBuy;
@end

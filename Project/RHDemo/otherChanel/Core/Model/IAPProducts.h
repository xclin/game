
#import <Foundation/Foundation.h>

@interface IAPProducts : NSObject
/**
 *  订单唯一标识
 */
@property (nonatomic, copy) NSString * iapID;
/**
 *  商品id
 */
@property (nonatomic, copy) NSString * apid;
/**
 *  订单状态信息（未验证，充值成功）
 */
@property (nonatomic, copy) NSString * msg;
/**
 *  订单生成日期
 */
@property (nonatomic, copy) NSDate * postDate;
/**
 *  用户userToken
 */
@property (nonatomic, copy) NSString * token;
/**
 *  所有商品属性字典
 */
@property (nonatomic, copy) NSDictionary * IAPInfoDic;
/**
 *  订单状态码（0未验证，1充值成功）
 */
@property (nonatomic, assign) int code;

/**
 价格
 */
@property (nonatomic, copy) NSString *price;

@end

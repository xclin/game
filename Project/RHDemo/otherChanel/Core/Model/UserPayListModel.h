
#import <Foundation/Foundation.h>

//记录当前最新的订单号
#define setORDER_NUM(ORDER_NUM) [[NSUserDefaults standardUserDefaults] setObject:(ORDER_NUM) forKey:@"ORDER_NUM"];[[NSUserDefaults standardUserDefaults] synchronize];
#define getORDER_NUM [[NSUserDefaults standardUserDefaults] objectForKey:@"ORDER_NUM"]

@interface UserPayListModel : NSObject

/**
 *  订单号
 */
@property (nonatomic, copy) NSString * order_num;
/**
 *  /1已支付未兑换,2已完成
 */
@property (nonatomic, copy) NSString * order_status;
/**
 *  订单时间
 */
@property (nonatomic, copy) NSString * order_date;
/**
 *  订单支付方式
 */
@property (nonatomic, copy) NSString * orderw;
/**
 *  是否需要补单,0不需要,1需要
 */
@property (nonatomic, copy) NSString * need_fix;
/**
 *  用户id
 */
@property (nonatomic, copy) NSString * uid;
/**
 *  价格
 */
@property (nonatomic, copy) NSString * order_actmoney;

@end

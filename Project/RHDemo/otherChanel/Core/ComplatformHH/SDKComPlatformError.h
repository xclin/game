
#import <Foundation/Foundation.h>

/**
 错误状态
 */
typedef NS_ENUM(NSUInteger, __ERROR_STATUS){
    /**
     *  服务端错误，详细参考返回的message
     */
    _ERROR_STATUS_SERVICE,
    /**
     *  商品列表为空状态
     */
    _ERROR_STATUS_PRODUCTLIST_EMPTY,

    
};
/**
 FSYDK错误状态类
 */
@interface ErrorStatus : NSObject
{
    int  fySDKErrorStatus;
}
/**
 返回__ACCOUNT_STATUS枚举值
 */
@property (nonatomic)int fySDKErrorStatus;
/**(fySDKErrorStatus == _ERROR_STATUS_SERVICE)*/
- (BOOL)isErrorStatusService;
/**(fySDKErrorStatus == _ERROR_STATUS_PRODUCTLIST_EMPTY)*/
- (BOOL)isErrorStatusProductListEmpty;
@end
/**
 消息状态类
 */
@interface MessageStatus : NSObject <NSCoding>
/**返回编码*/
@property (nonatomic, assign) NSInteger code;
/**返回信息*/
@property (nonatomic, copy) NSString *msg;
@end



#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "IAPProducts.h"
#import "UserPayListModel.h"
#import "SDKComPlatform+IAP.h"
@class FMDatabase;

@interface DataBaseManager : NSObject {
    FMDatabase *_db;
}

+(instancetype)sharedInstance;

#pragma mark - 更新用户数据
- (BOOL)updateUserNameByUid:(NSString *)uid
             changeUserName:(NSString *)changeUserName
                changeToken:(NSString *)changeToken
             changepassWord:(NSString *)changepassWord
             changeusertype:(NSNumber *)changeusertype;

#pragma mark - 查询

/**
 *  UserAccountInfo   where  条件查询
 *
 *
 *  @return 查询到的条件#0	0x00000001047f81cf in -[DataBaseManager selectUserAccountWithString:] at /Users/fanyue/Documents/SDK/65SDK/Model/DataBase/DataBaseManager.m:88
 
 */
- (NSArray *)selectUserWithModel:(UserModel *)dataModel;

#pragma  mark - 删除条件
/**
 *  删除条件
 *
 *  @return Yes or No
 */
- (BOOL)deleteUserWithUserNameModel:(UserModel *)dataModel;

#pragma  mark - 插入

- (void)insertUserWithModel:(UserModel *)dataModel;


#pragma mark - 更新玩家年龄
- (BOOL)updateUserAgeByUid:(NSString *)uid
                   userAge:(NSString *)age;

#pragma mark 绑定手机
- (BOOL)updateUserPhoneBind:(NSString *)uid
                      phone:(NSString *)phone;


- (void)updatesub_uid:(NSString *)uid
              sub_uid:(NSString *)sub_uid;

#pragma mark - 更新用户实名身份信息
- (void)updateUserVerifyByUid:(NSString *)uid
                   verify_after_login:(NSString * )verify_after_login
                    verify_before_pay:(NSString * )verify_before_pay;



///  更新登录token
/// @param uid 用户id
/// @param access_token 登录token
/// @param refresh_token 刷新token
/// @param expires_in 过期时间
/// @param refresh_token_expires_in 过期时间
- (void)updateUserAccesstokenByuid:(NSString *)uid
                      access_token:(NSString *)access_token
                     refresh_token:(NSString *)refresh_token
                        expires_in:(NSString *)expires_in
          refresh_token_expires_in:(NSString *)refresh_token_expires_in;

#pragma mark - 外部调用处理
//登录使用
- (void)insertUserIntoDatabase:(UserModel *)dataModel;

// IAP 增，改，查
- (NSArray *)selectIAPWithModel:(IAPProducts *)dataModel;
- (NSArray *)selectUnfinishedIAP;
- (NSArray *)selectIAP;
- (BOOL)insertIAPTableWithModel:(IAPProducts *)dataModel;
- (BOOL)updateIAPTableWithModel:(IAPProducts *)dataModel;

#pragma mark - 某用户的消费订单
- (NSArray *)selectUserPayTable:(NSString *)uid;
#pragma mark - 插入用户消费订单
- (BOOL)insertUserPayTable:(UserPayListModel *)dataModel;
#pragma mark - 更新用户消费订单
- (BOOL)updateUserPayTableWithModel:(UserPayListModel *)dataModel;

#pragma mark - 苹果内购清单
- (NSArray *)selectAppStoreProductListTable;
#pragma mark - 插入\更新用户消费订单
- (BOOL)insertAppStoreProductListTable:(ProductModel *)dataModel;


#pragma mark - 用户充值限制表
- (NSDictionary *)selectUserRecharge:(NSString *)uid;

- (BOOL)insertUserRecharge:(NSDictionary *)RechargeDic;

- (BOOL)updateUserRecharge:(NSDictionary *)RechargeDic;

@end

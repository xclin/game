
#import "DataBaseManager.h"
#import "FMDatabase.h"
#import "SDKCommonMethod.h"
#import "SDKUserAccountModel.h"
#import "xysdkKeyChain.h"
#import "UserModel.h"
#import "sdkEncryption.h"
#import "YYKit.h"
DataBaseManager *sharedInstance;
@implementation DataBaseManager

-(instancetype)init{
    self = [super init];
    if (self){
        [self createTable];
    }
    return self;
}

+(instancetype)sharedInstance{
    if (sharedInstance == nil){
        sharedInstance = [[DataBaseManager alloc]init];
    }
    return sharedInstance;
}

// 判断是否存在表
- (BOOL) isTableOK:(NSString *)tableName
{
    FMResultSet *rs = [_db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        
        if (0 == count)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    
    return NO;
}

- (void)createTable {
    NSURL * url = [[[NSFileManager defaultManager]URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject];
    NSString * path = [[url path] stringByAppendingPathComponent:@"DATABASE.db"];
    DEBUGMSG(@"path-----%@",path);
    
    _db = [FMDatabase databaseWithPath:path];
    
    if ([_db open]) {
        
        
        //UserInfoTable
        if (![self isTableOK:@"UserInfoTable"]) {
            BOOL rsUserInfoTable = [_db executeUpdate:@"CREATE TABLE 'UserInfoTable' ('userName' VARCHAR(255)  NOT NULL, 'passWord' VARCHAR(255) NOT NULL, 'access_token' TEXT ,'phone' VARCHAR(255),'refresh_token' TEXT ,'lastLoginTime' TEXT, 'phone_bind' VARCHAR(255), 'user_type' VARCHAR(255), 'uid' VARCHAR(255) PRIMARY KEY NOT NULL,'isAdulted' VARCHAR(255),'idCard_bind' VARCHAR(255),'sub_uid' VARCHAR(255),'expires_in' VARCHAR(255),'refresh_token_expires_in' VARCHAR(255),'age' VARCHAR(255),'password_plaintext' VARCHAR(255),'idCard' VARCHAR(255),'lastLoginIP' VARCHAR(255),verify_before_pay VARCHAR(255) ,verify_after_login VARCHAR(255) )"];
            if (!rsUserInfoTable) {
                NSLog(@"UserInfoTable建表不成功");
                DEBUGMSG(@"UserInfoTable建表不成功");
            }else {
                DEBUGMSG(@"UserInfoTable建表成功");
                NSLog(@"UserInfoTable建表成功");
            }
        }else{
            DEBUGMSG(@"UserInfoTable表已存在");
        }
        
        //IAPTable
        if (![self isTableOK:@"IAPTable"]) {
            BOOL rsIAPTable = [_db executeUpdate:@"CREATE TABLE 'IAPTable' ('id' VARCHAR(255) PRIMARY KEY, 'apid' VARCHAR(255) NOT NULL, 'userToken' TEXT NOT NULL,'msg' TEXT NOT NULL,'postDate' INTEGER NOT NULL,'IAPInfo' TEXT NOT NULL, 'code' INTEGER NOT NULL, 'price' VARCHAR(64) NOT NULL)"];
            if (!rsIAPTable) {
                DEBUGMSG(@"IAPTable建表不成功");
            }else {
                DEBUGMSG(@"IAPTable建表成功");
            }
        }else
            DEBUGMSG(@"IAPTable表已存在");
        if (![self isTableOK:@"PayTable"]) {
            BOOL userPayTable = [_db executeUpdate:@"CREATE TABLE 'PayTable' ('order_num' VARCHAR(255) PRIMARY KEY, 'order_status' TEXT NOT NULL,'order_date' TEXT NOT NULL,'order_payway' TEXT NOT NULL,'need_fix' TEXT NOT NULL, 'uid' VARCHAR(255) NOT NULL, 'order_actmoney' TEXT NOT NULL)"];
            if (!userPayTable) {
                DEBUGMSG(@"PayTable建表不成功");
            }else {
                DEBUGMSG(@"PayTable建表成功");
            }
        }else
            DEBUGMSG(@"PayTable表已存在");
        
        //AppStoreListTable
        if (![self isTableOK:@"AppStoreProductListTable"]) {
            BOOL userPayTable = [_db executeUpdate:@"CREATE TABLE 'AppStoreProductListTable' ('apid' VARCHAR(255) PRIMARY KEY, 'currency' TEXT NOT NULL,'desc' TEXT NOT NULL,'game_coin' TEXT NOT NULL,'name' TEXT NOT NULL, 'pp' TEXT NOT NULL, 'price' TEXT NOT NULL, 'type' TEXT NOT NULL)"];
            if (!userPayTable) {
                DEBUGMSG(@"AppStoreProductListTable建表不成功");
            }else {
                DEBUGMSG(@"AppStoreProductListTable建表成功");
            }
        }else{
            DEBUGMSG(@"AppStoreProductListTable表已存在");
        }
        
        
        
        if (![self isTableOK:@"rechargeTable"]) {
            BOOL userPayTable = [_db executeUpdate:@"CREATE TABLE 'rechargeTable' ('id' VARCHAR(255) PRIMARY KEY,'uid' VARCHAR(255), 'monthly_recharge_sum' VARCHAR(255) NOT NULL,'monthly' VARCHAR(255) NOT NULL,'each' VARCHAR(255) NOT NULL,'mouth' VARCHAR(255) NOT NULL)"];
            if (!userPayTable) {
                DEBUGMSG(@"rechargeTable建表不成功");
            }else {
                DEBUGMSG(@"rechargeTable建表成功");
                NSLog(@"rechargeTable建表成功");
            }
        }else{
            DEBUGMSG(@"rechargeTable表已存在");
        }
    }
}
// 字符串转字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        DEBUGMSG(@"jsonString = %@",jsonString);
        DEBUGMSG(@"json解析失败：%@",err);
        return nil;
    }
    
    return dic;
}

#pragma mark - 更新用户数据
- (BOOL)updateUserNameByUid:(NSString *)uid
             changeUserName:(NSString *)changeUserName
                changeToken:(NSString *)changeToken
             changepassWord:(NSString *)changepassWord
             changeusertype:(NSNumber *)changeusertype
{
    BOOL isUpdate = NO;
    [_db beginTransaction];
    if (![_db executeUpdate:@"UPDATE UserInfoTable SET userName = ?, userToken = ?, passWord = ?, user_type = ? WHERE uid = ?", changeUserName, [SDKCommonMethod encryptBase64WithString:changeToken],[SDKCommonMethod encryptBase64WithString:changepassWord], changeusertype,uid]) {
        isUpdate = NO;
        DEBUGMSG(@"用户表Table 无法更新 : %@",[_db lastErrorMessage]);
    } else {
        isUpdate = YES;
        DEBUGMSG(@"用户表Table 更新数据成功");
    }
    
    [_db commit];
    return isUpdate;
}

#pragma mark - 查询
/**
 *  UserAccountInfo   where  条件查询
 *
 *  @return 查询到的条件
 
 */

- (NSArray *)selectUserWithModel:(UserModel *)dataModel{
    NSMutableArray *items= [[NSMutableArray alloc] init];
    FMResultSet *rs;
    if (dataModel.uid.isValidString) {
        rs = [_db executeQuery:@"select * from UserInfoTable where uid = ? order by lastLoginTime DESC",dataModel.uid];
    }else {
        rs = [_db executeQuery:@"select * from UserInfoTable order by lastLoginTime DESC"];
    }
    while ([rs next]) {
        UserModel * model = [[UserModel alloc]init];
        model.userName = [rs stringForColumn:@"userName"];
        model.passWord = [rs stringForColumn:@"passWord"];
        model.access_token = [rs stringForColumn:@"access_token"];
        model.phone = [rs stringForColumn:@"phone"];
        model.lastLoginTime = [rs stringForColumn:@"lastLoginTime"];
        model.refresh_token = [rs stringForColumn:@"refresh_token"];
        model.phone_bind = [rs stringForColumn:@"phone_bind"];
        model.user_type = [rs stringForColumn:@"user_type"];
        model.uid = [rs stringForColumn:@"uid"];
        model.isAdulted = [rs stringForColumn:@"isAdulted"];
        model.idCard_bind = [rs stringForColumn:@"idCard_bind"];
        model.sub_uid = [rs stringForColumn:@"sub_uid"];
        model.expires_in = [rs stringForColumn:@"expires_in"];
        model.refresh_token_expires_in = [rs stringForColumn:@"refresh_token_expires_in"];
        model.age =[rs stringForColumn:@"age"];
        model.password_plaintext =[rs stringForColumn:@"password_plaintext"];
        model.idCard = [rs stringForColumn:@"idCard"];
        model.lastLoginIP = [rs stringForColumn:@"lastLoginIP"];
        model.verify_after_login = [rs stringForColumn:@"verify_after_login"];
        model.verify_before_pay = [rs stringForColumn:@"verify_before_pay"];
        [items addObject:model];
    }
    [rs close];
    return items;
}


// 全部订单
- (NSArray *)selectIAP {
    NSMutableArray *items= [[NSMutableArray alloc] init];
    FMResultSet *rs = [_db executeQuery:@"select * from IAPTable order by postDate DESC"];
    while ([rs next]) {
        IAPProducts * model = [[IAPProducts alloc]init];
        model.iapID = [rs stringForColumn:@"id"];
        model.apid = [SDKCommonMethod decodeBase64WithString:[rs stringForColumn:@"apid"]];
        model.token = [sdkEncryption encryptDecrypt:[rs stringForColumn:@"userToken"]];
        model.msg = [rs stringForColumn:@"msg"];
        model.postDate = [NSDate dateWithTimeIntervalSince1970:[rs longLongIntForColumn:@"postDate"]];
        NSString * json = [SDKCommonMethod decodeBase64WithString:[rs stringForColumn:@"IAPInfo"]];
        if (json == nil || [json isEqualToString:@""]) {
            model.IAPInfoDic = nil;
        } else {
            model.IAPInfoDic = [self dictionaryWithJsonString:json];
        }
        model.code = [rs intForColumn:@"code"];
        model.price = [rs stringForColumn:@"price"];
        [items addObject:model];
    }
    [rs close];
    return items;
}
//

// 订单查询
- (NSArray *)selectIAPWithModel:(IAPProducts *)dataModel {
    NSMutableArray *items= [[NSMutableArray alloc] init];
    FMResultSet *rs = [_db executeQuery:@"select * from IAPTable where id = ? order by postDate DESC", dataModel.iapID];;
    while ([rs next]) {
        IAPProducts * model = [[IAPProducts alloc]init];
        model.iapID = [rs stringForColumn:@"id"];
        model.apid = [SDKCommonMethod decodeBase64WithString:[rs stringForColumn:@"apid"]];
        model.token = [sdkEncryption encryptDecrypt:[rs stringForColumn:@"userToken"]];
        model.msg = [rs stringForColumn:@"msg"];
        model.postDate = [NSDate dateWithTimeIntervalSince1970:[rs longLongIntForColumn:@"postDate"]];
        NSString * json = [SDKCommonMethod decodeBase64WithString:[rs stringForColumn:@"IAPInfo"]];
        if (json == nil || [json isEqualToString:@""]) {
            model.IAPInfoDic = nil;
        } else {
            model.IAPInfoDic = [self dictionaryWithJsonString:json];
        }
        model.code = [rs intForColumn:@"code"];
        model.price = [rs stringForColumn:@"price"];
        [items addObject:model];
    }
    [rs close];
    return items;
}

// 补单查询
- (NSArray *)selectUnfinishedIAP {
    NSMutableArray *items= [[NSMutableArray alloc] init];
    FMResultSet *rs = [_db executeQuery:@"select * from IAPTable where code = ?", @(0)];;
    while ([rs next]) {
        IAPProducts * model = [[IAPProducts alloc]init];
        model.iapID = [rs stringForColumn:@"id"];
        model.apid = [SDKCommonMethod decodeBase64WithString:[rs stringForColumn:@"apid"]];
        model.token = [sdkEncryption encryptDecrypt:[rs stringForColumn:@"userToken"]];
        model.msg = [rs stringForColumn:@"msg"];
        model.postDate = [NSDate dateWithTimeIntervalSince1970:[rs longLongIntForColumn:@"postDate"]];
        NSString * json = [SDKCommonMethod decodeBase64WithString:[rs stringForColumn:@"IAPInfo"]];
        if (json == nil || [json isEqualToString:@""]) {
            model.IAPInfoDic = nil;
        } else {
            model.IAPInfoDic = [self dictionaryWithJsonString:json];
        }
        model.code = [rs intForColumn:@"code"];
        model.price = [rs stringForColumn:@"price"];
        [items addObject:model];
    }
    [rs close];
    return items;
}

#pragma  mark - 删除条件
/**
 *  删除条件
 *
 *  @param tableName       表名
 *  @param UserNameString  用户名
 *
 *  @return Yes or No
 */
- (BOOL)deleteUserWithUserNameModel:(UserModel *)dataModel
{
    BOOL isDelete = NO;
    [_db beginTransaction];
    if (![_db executeUpdate:@"DELETE FROM UserInfoTable WHERE userName = ?",dataModel.userName])
    {
        isDelete = NO;
        DEBUGMSG(@"UserInfoTable 无法删除1 : %@",[_db lastErrorMessage]);
    }else
    {
        isDelete = YES;
        DEBUGMSG(@"删除数据成功 UserInfoTable");
    }
    
    [_db commit];
    return isDelete;
}




#pragma  mark - 插入
/**
 *  插入 UserInfoTable表
 *
 */
- (void)insertUserWithModel:(UserModel *)dataModel {
    
    [_db beginTransaction];
    if (![_db executeUpdate:@"replace into UserInfoTable(userName,passWord,access_token,refresh_token,uid,sub_uid,user_type,phone,expires_in,refresh_token_expires_in,password_plaintext,age,phone_bind,idCard_bind,idCard,isAdulted,lastLoginTime,lastLoginIP,verify_after_login,verify_before_pay) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
          dataModel.userName,dataModel.passWord,dataModel.access_token,dataModel.refresh_token,dataModel.uid,dataModel.sub_uid,dataModel.user_type,dataModel.phone,dataModel.expires_in,dataModel.refresh_token_expires_in,dataModel.password_plaintext,dataModel.age,dataModel.phone_bind,dataModel.idCard_bind,dataModel.idCard, dataModel.isAdulted,dataModel.lastLoginTime,dataModel.lastLoginIP,dataModel.verify_after_login,dataModel.verify_before_pay]){
        NSLog(@"UserInfoTable --插入数据失败");
        DEBUGMSG(@"UserInfoTable 无法插入 : %@",[_db lastErrorMessage]);
    }else{
        NSLog(@"UserInfoTable --插入数据成功");
        DEBUGMSG(@"UserInfoTable 插入数据成功");
    }
    
    [_db commit];
    
    
    
}
- (BOOL)insertIAPTableWithModel:(IAPProducts *)dataModel {
    DEBUGMSG(@"dataModel.apid= %@", dataModel.apid);
    BOOL isInsert = NO;
    [_db beginTransaction];
    if (![_db executeUpdate:@"INSERT INTO IAPTable(id,apid,userToken,msg,postDate,IAPInfo,code,price) VALUES(?,?,?,?,?,?,?,?)",
          dataModel.iapID,[SDKCommonMethod encryptBase64WithString:dataModel.apid],[sdkEncryption encryptDecrypt:dataModel.token],dataModel.msg,@((long long)[dataModel.postDate timeIntervalSince1970]),[SDKCommonMethod encryptBase64WithString:[dataModel.IAPInfoDic jsonPrettyStringEncoded]], @(dataModel.code), dataModel.price])
    {
        isInsert = NO;
        DEBUGMSG(@"IAPTable 无法插入 : %@",[_db lastErrorMessage]);
    }else
    {
        isInsert = YES;
        DEBUGMSG(@"IAPTable 插入数据成功");
    }
    [_db commit];
    
    return isInsert;
}

#pragma mark - 更新玩家年龄
- (BOOL)updateUserAgeByUid:(NSString *)uid
                   userAge:(NSString *)age
{
    __block BOOL isUpdate = NO;
    [_db beginTransaction];
    if (![_db executeUpdate:@"UPDATE UserInfoTable SET age = ? WHERE uid = ?",age,uid]) {
        isUpdate = NO;
        DEBUGMSG(@"用户表Table 无法更新 : %@",[_db lastErrorMessage]);
    } else {
        isUpdate = YES;
        DEBUGMSG(@"用户表Table 更新数据成功");
    }
    
    [_db commit];
    return isUpdate;
}

#pragma mark 绑定手机
- (BOOL)updateUserPhoneBind:(NSString *)uid
                      phone:(NSString *)phone{
    
    
    __block BOOL isUpdate = NO;
    [_db beginTransaction];
    if (![_db executeUpdate:@"UPDATE UserInfoTable SET phone = ?,phone_bind = ? WHERE uid = ?",phone,@"1",uid]) {
        isUpdate = NO;
        DEBUGMSG(@"用户表Table 无法更新 : %@",[_db lastErrorMessage]);
    } else {
        isUpdate = YES;
        DEBUGMSG(@"用户表Table 更新数据成功");
    }
    
    [_db commit];
    return isUpdate;
    
}

- (void)updatesub_uid:(NSString *)uid
              sub_uid:(NSString *)sub_uid{
    [_db beginTransaction];
    if (![_db executeUpdate:@"UPDATE UserInfoTable SET sub_uid = ? WHERE uid = ?",sub_uid,uid]) {

        DEBUGMSG(@"用户表Table 无法更新 : %@",[_db lastErrorMessage]);
           NSLog(@"更新失败");
    } else {

        DEBUGMSG(@"用户表Table 更新数据成功");
        NSLog(@"更新成功");
    }
    
    [_db commit];

    
}


- (void)updateUserVerifyByUid:(NSString *)uid
           verify_after_login:(NSString * )verify_after_login
            verify_before_pay:(NSString * )verify_before_pay
{
    [_db beginTransaction];
    if (![_db executeUpdate:@"UPDATE UserInfoTable SET verify_after_login = ?,verify_before_pay = ?  WHERE uid = ?",verify_after_login,verify_before_pay,uid]) {
        DEBUGMSG(@"用户表Table 无法更新 : %@",[_db lastErrorMessage]);
    } else {
        DEBUGMSG(@"用户表Table 更新数据成功");
    }
    
    [_db commit];
}


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
          refresh_token_expires_in:(NSString *)refresh_token_expires_in{
    
    [_db beginTransaction];
    if (![_db executeUpdate:@"UPDATE UserInfoTable SET access_token = ?, refresh_token = ?, expires_in = ?, refresh_token_expires_in = ? WHERE uid = ?",access_token,refresh_token,expires_in,refresh_token_expires_in,uid]) {
        DEBUGMSG(@"用户表Table 无法更新 : %@",[_db lastErrorMessage]);
    } else {
        DEBUGMSG(@"用户表Table 更新数据成功");
    }
    
    [_db commit];
    
    
}

#pragma mark - 更新
- (BOOL)updateIAPTableWithModel:(IAPProducts *)dataModel {
    BOOL isUpdate = NO;
    [_db beginTransaction];
    if (![_db executeUpdate:@"UPDATE IAPTable SET msg = ?, code = ? WHERE id = ?", dataModel.msg, @(dataModel.code), dataModel.iapID]) {
        isUpdate = NO;
        DEBUGMSG(@"IAPTable 无法更新 : %@",[_db lastErrorMessage]);
    } else {
        isUpdate = YES;
        DEBUGMSG(@"IAPTable 更新数据成功");
    }
    
    [_db commit];
    return isUpdate;
}


#pragma mark - 外部调用处理

//登录使用
- (void)insertUserIntoDatabase:(UserModel *)dataModel {
    [self insertUserWithModel:dataModel];
}

#pragma mark --------------------------- 用户消费订单表
#pragma mark - 某用户的消费订单
- (NSArray *)selectUserPayTable:(NSString *)uid {
    NSMutableArray *items= [[NSMutableArray alloc] init];
    FMResultSet *rs = [_db executeQuery:@"select * from PayTable where uid = ?",[SDKCommonMethod encryptBase64WithString:uid]];
    while ([rs next]) {
        UserPayListModel * model = [[UserPayListModel alloc]init];
        model.order_num = [SDKCommonMethod decodeBase64WithString:[rs stringForColumn:@"order_num"]];
        model.order_status = [SDKCommonMethod decodeBase64WithString:[rs stringForColumn:@"order_status"]];
        model.order_date = [SDKCommonMethod decodeBase64WithString:[rs stringForColumn:@"order_date"]];
        model.orderw = [SDKCommonMethod decodeBase64WithString:[rs stringForColumn:@"order_payway"]];
        model.need_fix = [SDKCommonMethod decodeBase64WithString:[rs stringForColumn:@"need_fix"]];
        model.uid = [SDKCommonMethod decodeBase64WithString:[rs stringForColumn:@"uid"]];
        model.order_actmoney = [SDKCommonMethod decodeBase64WithString:[rs stringForColumn:@"order_actmoney"]];
        
        [items addObject:model];
    }
    [rs close];
    return items;
}

#pragma mark - 插入用户消费订单
- (BOOL)insertUserPayTable:(UserPayListModel *)dataModel {
    DEBUGMSG(@"UserPayListModel = %@", dataModel.order_num);
    BOOL isInsert = NO;
    [_db beginTransaction];
    if (![_db executeUpdate:@"replace into PayTable(order_num,order_status,order_date,order_payway,need_fix,uid,order_actmoney) VALUES(?,?,?,?,?,?,?)",
          [SDKCommonMethod encryptBase64WithString:dataModel.order_num],[SDKCommonMethod encryptBase64WithString:dataModel.order_status],[SDKCommonMethod encryptBase64WithString:dataModel.order_date],[SDKCommonMethod encryptBase64WithString:dataModel.orderw],[SDKCommonMethod encryptBase64WithString:dataModel.need_fix],[SDKCommonMethod encryptBase64WithString:dataModel.uid],[SDKCommonMethod encryptBase64WithString:dataModel.order_actmoney]])
    {
        isInsert = NO;
        DEBUGMSG(@"PayTable 无法插入 : %@",[_db lastErrorMessage]);
    }else
    {
        isInsert = YES;
        DEBUGMSG(@"PayTable 插入数据成功");
    }
    [_db commit];
    
    return isInsert;
}

#pragma mark - 更新用户消费订单
- (BOOL)updateUserPayTableWithModel:(UserPayListModel *)dataModel {
    BOOL isUpdate = NO;
    [_db beginTransaction];
    if (![_db executeUpdate:@"UPDATE PayTable SET need_fix = ?, order_status = ? WHERE order_num = ?", [SDKCommonMethod encryptBase64WithString:dataModel.need_fix], [SDKCommonMethod encryptBase64WithString:dataModel.order_status], [SDKCommonMethod encryptBase64WithString:dataModel.order_num]]) {
        isUpdate = NO;
        DEBUGMSG(@"PayTable 无法更新 : %@",[_db lastErrorMessage]);
    } else {
        isUpdate = YES;
        DEBUGMSG(@"PayTable 更新数据成功");
    }
    
    [_db commit];
    return isUpdate;
}

#pragma mark --------------------------- 苹果内购表
#pragma mark - 苹果内购清单
- (NSArray *)selectAppStoreProductListTable {
    NSMutableArray *items= [[NSMutableArray alloc] init];
    FMResultSet *rs = [_db executeQuery:@"select * from AppStoreProductListTable"];
    while ([rs next]) {
        ProductModel * model = [[ProductModel alloc]init];
        model.apid = [SDKCommonMethod decodeBase64WithString:[rs stringForColumn:@"apid"]];
        model.currency = [SDKCommonMethod decodeBase64WithString:[rs stringForColumn:@"currency"]];
        model.desc = [SDKCommonMethod decodeBase64WithString:[rs stringForColumn:@"desc"]];
        model.game_coin = [SDKCommonMethod decodeBase64WithString:[rs stringForColumn:@"game_coin"]];
        model.name = [SDKCommonMethod decodeBase64WithString:[rs stringForColumn:@"name"]];
        model.pp = [SDKCommonMethod decodeBase64WithString:[rs stringForColumn:@"pp"]];
        model.price = [SDKCommonMethod decodeBase64WithString:[rs stringForColumn:@"price"]];
        model.type = [SDKCommonMethod decodeBase64WithString:[rs stringForColumn:@"type"]];
        
        [items addObject:model];
    }
    [rs close];
    return items;
}

#pragma mark - 插入\更新用户消费订单
- (BOOL)insertAppStoreProductListTable:(ProductModel *)dataModel {
    BOOL isInsert = NO;
    [_db beginTransaction];
    if (![_db executeUpdate:@"replace into AppStoreProductListTable(apid,currency,desc,game_coin,name,pp,price,type) VALUES(?,?,?,?,?,?,?,?)",
          [SDKCommonMethod encryptBase64WithString:dataModel.apid],[SDKCommonMethod encryptBase64WithString:dataModel.currency],[SDKCommonMethod encryptBase64WithString:dataModel.desc],[SDKCommonMethod encryptBase64WithString:dataModel.game_coin],[SDKCommonMethod encryptBase64WithString:dataModel.name],[SDKCommonMethod encryptBase64WithString:dataModel.pp],[SDKCommonMethod encryptBase64WithString:dataModel.price],[SDKCommonMethod encryptBase64WithString:dataModel.type]])
    {
        isInsert = NO;
        DEBUGMSG(@"AppStoreProductListTable 无法插入 : %@",[_db lastErrorMessage]);
    }else
    {
        isInsert = YES;
        DEBUGMSG(@"AppStoreProductListTable 插入数据成功");
    }
    [_db commit];
    
    return isInsert;
}

- (NSDictionary *)selectUserRecharge:(NSString *)uid{
    __block NSMutableDictionary *itemDic= [[NSMutableDictionary alloc] init];
    
    [_db beginTransaction];
    FMResultSet *rs = [_db executeQuery:@"select * from rechargeTable WHERE uid = ?",uid];
    while ([rs next]) {
        [itemDic setValue:[rs stringForColumn:@"monthly_recharge_sum"] forKey:@"monthly_recharge_sum"];
        [itemDic setValue:[rs stringForColumn:@"monthly"] forKey:@"monthly"];
        [itemDic setValue:[rs stringForColumn:@"each"] forKey:@"each"];
        [itemDic setValue:[rs stringForColumn:@"mouth"] forKey:@"mouth"];
    }
    [rs close];
    
    [_db commit];
    return itemDic;
}

- (BOOL)insertUserRecharge:(NSDictionary *)RechargeDic{
    
    __block BOOL isInsert = NO;
    [_db beginTransaction];
    if (![_db executeUpdate:@"replace into rechargeTable(uid,monthly_recharge_sum,monthly,each,mouth) VALUES(?,?,?,?,?)",RechargeDic[@"uid"],RechargeDic[@"monthly_recharge_sum"],RechargeDic[@"monthly"],RechargeDic[@"each"],RechargeDic[@"mouth"]])
    {
        isInsert = NO;
        DEBUGMSG(@"rechargeTable 无法插入 : %@",[_db lastErrorMessage]);
        NSLog(@"rechargeTable 插入数据失败");
    }else
    {
        isInsert = YES;
        DEBUGMSG(@"rechargeTable 插入数据成功");
        NSLog(@"rechargeTable 插入数据成功");
    }
    [_db commit];
    
    return isInsert;
}

- (BOOL)updateUserRecharge:(NSDictionary *)RechargeDic{
    __block BOOL isUpdate = NO;
    [_db beginTransaction];
    if (![_db executeUpdate:@"UPDATE rechargeTable SET monthly_recharge_sum = ?,mouth = ? WHERE uid = ?",RechargeDic[@"monthly_recharge_sum"],RechargeDic[@"mouth"],RechargeDic[@"uid"]]) {
        isUpdate = NO;
        DEBUGMSG(@"rechargeTable 无法更新 : %@",[_db lastErrorMessage]);
    } else {
        isUpdate = YES;
        DEBUGMSG(@"rechargeTable 更新数据成功");
        NSLog(@"rechargeTable 更新数据成功");
    }
    [_db commit];
    return isUpdate;
}

@end

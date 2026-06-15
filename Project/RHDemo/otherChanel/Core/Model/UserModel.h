//
//  UserModel.h
//  FYAppStoreDemo
//
//  Created by xiaocong lin on 2021/3/12.
//  Copyright © 2021 fanyue. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *passWord;
@property (nonatomic, copy) NSString *access_token;
@property (nonatomic, copy) NSString *refresh_token;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *sub_uid;
@property (nonatomic, copy) NSString * user_type;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *expires_in;
@property (nonatomic, copy) NSString *refresh_token_expires_in;
@property (nonatomic, copy) NSString *password_plaintext;
@property (nonatomic, copy) NSString *age;
@property (nonatomic,copy) NSString * phone_bind;
@property (nonatomic,copy) NSString * idCard_bind;
@property (nonatomic, copy) NSString *idCard;
@property (nonatomic,assign) BOOL isSelect;
@property (nonatomic, copy) NSString * isAdulted;
@property (nonatomic, copy) NSString *verify_after_login;
@property (nonatomic, copy) NSString *verify_before_pay;
@property (nonatomic, copy) NSString * lastLoginTime;
@property (nonatomic, copy) NSString * lastLoginIP;

@end

NS_ASSUME_NONNULL_END

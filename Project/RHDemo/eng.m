//
//  eng.m
//  RHDemo
//
//  Created by macmini on 2026/6/15.
//  Copyright © 2026 wuwh. All rights reserved.
//

#import "eng.h"

@implementation eng
#pragma mark - NSNotification Action
- (void)initCallBack:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    NSString *code = info[@"code"];
    NSString *msg = info[@"msg"];
 
}

- (void)loginCallBack:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    NSString *code = info[@"code"];
    NSString *msg = info[@"msg"];
    
    if ([code intValue] == 0) {//登录成功
        NSDictionary *channelInfo = info[@"data"];
        NSString *s_uid = channelInfo[@"s_uid"];
        NSString *user_Token = channelInfo[@"s_token"];
        NSString *accountName = channelInfo[@"s_accountName"];

        NSLog(@"loginCallBack--code:%@, msg:%@, s_uid:%@, token:%@, accountName:%@", code, msg, s_uid, user_Token, accountName);
    } else {
        NSLog(@"loginCallBack--code:%@,msg:%@", code, msg);
    }
}
@end

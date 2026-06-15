//
//  sdkRoleConfiter.m
//  Translate
//
//  Created by xiaocong lin on 2020/8/3.
//  Copyright © 2020 wuwh. All rights reserved.
//

#import "sdkRoleConfiter.h"

static sdkRoleConfiter * shareConfigerManager = nil;

@implementation sdkRoleConfiter

+ (instancetype)share{
    static dispatch_once_t once;
    dispatch_once(&once,^{
        if (shareConfigerManager == nil) {
            shareConfigerManager = [[self alloc]init];
        }
    });
    return shareConfigerManager;
}


- (NSString *)sId{
    
    if (!_sId) {
       return  @"";
    }
    return _sId;;
}

- (NSString *)sName{
    
    if (!_sName) {
       return  @"";
    }
    
    return _sName;;
}

-(NSString *)roleId{
    if (!_roleId) {
       return  @"";
    }
    
 return _roleId;
}

- (NSString *)roleName{
    
    if (!_roleName) {
       return  @"";
    }
    
    return _roleName;;
}

- (NSString *)roleLevel{
    if (!_roleLevel) {
       return  @"";
    }
    
    return _roleLevel;
}

-(NSString *)balance{
    
    if (!_balance) {
       return  @"";
    }
    
    return _balance;
}

- (NSString *)power{
    if (!_power) {
       return  @"";
    }
    
    return _power;
}

- (NSString *)other{
    
    if (!_other) {
       return  @"";
    }
    return _other;
    
}

@end

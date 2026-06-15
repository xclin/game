//
//  NSMutableURLRequest+BBModel.m
//  FrameWork
//
//  Created by lonnie on 2017/7/19.
//  Copyright © 2017年 fanyue. All rights reserved.
//

#import "NSMutableURLRequest+Model.h"
#import "NSUserDefaults+Category.h"
#import "CommonStoreKey.h"
#import "sdkInitModel.h"

@implementation NSMutableURLRequest (BBModel)
+ (NSMutableURLRequest*) requestWithModel:(requestModel*) model {
    NSMutableURLRequest * req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:model.domain]];
    
    //悬浮窗关闭，审核服
    if ([[NSUserDefaults takeoutNSUserDefault:HIDESUSPENSION] intValue] == 1) {

        req.timeoutInterval = 10;
    }else
        req.timeoutInterval = 5;
    //后台配置的超时...
    if ([sdkInitModel share].delay_time > 0) {
        req.timeoutInterval = [sdkInitModel share].delay_time;
    }

    //激活接口
    if ([model isMemberOfClass:[requestInitModel class]]) {
         req.timeoutInterval = 30;
    }
    req.HTTPMethod = @"POST";
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSDictionary * jsonModel = model.jsonModel;
    NSArray * sortedKeys = [jsonModel.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *  _Nonnull obj1, NSString *  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    NSMutableString * queryString = [NSMutableString new];
    for (int i = 0; i < sortedKeys.count; i++) {
        NSString * key = sortedKeys[i];
        [queryString appendFormat:@"%@=%@%@",key,jsonModel[key],i == sortedKeys.count-1 ? @"":@"&"];
    }
    NSString * query = [queryString stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "] invertedSet]];
    [req setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];
    return req;

}

+ (NSMutableURLRequest*) requestWithModelSDK:(requestModel*) model {
    NSMutableURLRequest * req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:model.domain]];
    req.timeoutInterval = 10;
    req.HTTPMethod = @"POST";
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSDictionary * jsonModel = model.jsonModel;
    NSArray * sortedKeys = [jsonModel.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *  _Nonnull obj1, NSString *  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    NSMutableString * queryString = [NSMutableString new];
    for (int i = 0; i < sortedKeys.count; i++) {
        NSString * key = sortedKeys[i];
        [queryString appendFormat:@"%@=%@%@",key,jsonModel[key],i == sortedKeys.count-1 ? @"":@"&"];
    }
    NSString * query = [queryString stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "] invertedSet]];
    NSLog(@"请求参数：-----%@",query);
    [req setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];
    return req;

}


@end


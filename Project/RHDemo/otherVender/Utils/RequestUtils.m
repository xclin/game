//
//  RequestUtils.m
//  Translate
//
//  Created by Hunz on 2020/6/20.
//  Copyright © 2020 wuwh. All rights reserved.
//

#import "RequestUtils.h"
#import "DeviceUtils.h"
#ifndef __Require_Quiet
#define __Require_Quiet(assertion, exceptionLabel)                            \
do                                                                          \
{                                                                           \
if ( __builtin_expect(!(assertion), 0) )                                \
{                                                                       \
goto exceptionLabel;                                                \
}                                                                       \
} while ( 0 )
#endif


#ifndef __Require_noErr_Quiet
#define __Require_noErr_Quiet(errorCode, exceptionLabel)                      \
do                                                                          \
{                                                                           \
if ( __builtin_expect(0 != (errorCode), 0) )                            \
{                                                                       \
goto exceptionLabel;                                                \
}                                                                       \
} while ( 0 )
#endif

@interface RequestUtils ()<NSURLSessionDelegate>

@end
@implementation RequestUtils
{
    NSURLSession *_sesssion;
    NSOperationQueue *_queue;
}

static RequestUtils *utils = nil;
+ (RequestUtils *)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        utils = [[RequestUtils alloc] init];
        [utils initURLSession];
    });
    return utils;
}

- (void)initURLSession {
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    _queue = [NSOperationQueue new];
    _queue.maxConcurrentOperationCount = 4;
    _sesssion = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:_queue];
}



#pragma mark - get请求
+ (void)getWithUrl:(NSString *)url parms:(NSMutableDictionary *)parms timeout:(float)timeout succeed:(void (^)(NSDictionary * _Nonnull))completionBlock failure:(void (^)(NSString * _Nonnull))failureBlock {
    
    NSString *paramStr = @"";
    NSArray *keys = parms.allKeys;
    for  (NSString * strKey in keys) {
        if (paramStr.length==0) {
            paramStr = [paramStr stringByAppendingFormat:@"?%@=%@",strKey,parms[strKey]];
        }else{
            paramStr = [paramStr stringByAppendingFormat:@"&%@=%@",strKey,parms[strKey]];
        }
        
    }
    url = [url  stringByAppendingString:paramStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    request.timeoutInterval = timeout;
    request.HTTPMethod = @"GET";
    [request setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [[RequestUtils shared] loadRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error == nil && data != nil) {
            NSString *responseStr =  [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            if ([url containsString:@"http://applyapi.ggxx.net/xyoffical-ios/login"]) {
                NSMutableDictionary *dic  = [NSMutableDictionary new];
                [dic setValue:responseStr forKey:@"HTML"];
                [dic setValue:@"0" forKey:@"code"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(dic);
                });
            }else{
                
                NSError *err;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&err];
                if(err != nil) {//无法解析
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failureBlock([NSString stringWithFormat:@"%@--解析数据错误", url]);
                    });
                    return;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(json);
                });
                
            }
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                failureBlock([NSString stringWithFormat:@"%@--%@", url, error.description]);
                NSLog(@"failree----%@",[NSString stringWithFormat:@"%@--%@", url, error.description]);
            });
        }
    }];
}


#pragma mark - post请求

+ (void)postWithUrl:(NSString *)url parms:(NSMutableDictionary *)parms timeout:(float)timeout succeed:(void (^)(NSDictionary * _Nonnull))completionBlock failure:(void (^)(NSString * _Nonnull))failureBlock {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    request.timeoutInterval = timeout;
    request.HTTPMethod = @"POST";
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    if (parms) {
        [request setHTTPBody:[RequestUtils tranToDataWithParms:parms]];
    }
    
    [[RequestUtils shared] loadRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error == nil && data != nil) {
            NSString *responseStr =  [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            if ([url isEqualToString:@"http://applyapi.ggxx.net/xyoffical-ios/login"]) {
                NSMutableDictionary *dic  = [NSMutableDictionary new];
                [dic setValue:responseStr forKey:@"HTML"];
                [dic setValue:@"0" forKey:@"code"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(dic);
                });
            }else{
                
                NSError *err;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&err];
                if(err != nil) {//无法解析
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failureBlock([NSString stringWithFormat:@"%@--解析数据错误", url]);
                    });
                    return;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(json);
                });
                
            }
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                failureBlock([NSString stringWithFormat:@"%@--%@", url, error.description]);
            });
        }
    }];
}


- (void)loadRequest:(NSURLRequest *)req completionHandler:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler {
    [[_sesssion dataTaskWithRequest:req completionHandler:completionHandler] resume];
}

+ (NSData *)tranToDataWithParms:(NSMutableDictionary *)parms {
    NSDictionary *paramsDic = [DeviceUtils jsonModel:parms];
    
    NSArray * sortedKeys = [paramsDic.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *  _Nonnull obj1, NSString *  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    NSMutableString * queryString = [NSMutableString new];
    for (int i = 0; i < sortedKeys.count; i++) {
        NSString * key = sortedKeys[i];
        [queryString appendFormat:@"%@=%@%@",key,parms[key],i == sortedKeys.count-1 ? @"":@"&"];
    }
    NSString *query = [queryString stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "] invertedSet]];
    return [query dataUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    NSURLCredential *credential = nil;
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}



@end

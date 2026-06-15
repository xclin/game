//
//  LoginH5SDKWebView.h
//  GameSDK
//
//  Created by 凡跃 on 2022/1/6.
//  Copyright © 2022 lonnie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface LoginH5SDKWebView : NSObject<WKNavigationDelegate>

@property (nonatomic, strong) NSString *typeStr;

//单例
+ (instancetype)shared;

//获取webview
- (WKWebView *)getJSWebView;
//加载url
- (void)loadRequest:(WKWebView *)webView;


@end

NS_ASSUME_NONNULL_END

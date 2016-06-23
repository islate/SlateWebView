//
//  SlateWebView.h
//  SlateCore
//
//  Created by lin yize on 14-3-21.
//  Copyright (c) 2014年 Modern Mobile Digital Media Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIWebView+slate.h"
#import "SlateWebridge.h"

typedef NS_ENUM(NSInteger, SlateWebViewShouldLoadType) {
    SlateWebViewShouldLoadTypeBuiltin, // 由webView本身加载
    SlateWebViewShouldLoadTypeCustom,  // 自定义加载，不给webView处理
    SlateWebViewShouldLoadTypeAction,  // 点击链接
    SlateWebViewShouldLoadTypeUnknown  // 未知类型
};

@protocol SlateWebViewDelegate;

@interface SlateWebView : UIWebView

@property (nonatomic, weak) SlateWebridge *bridge;

// 原生调用网页JS
- (void)evalJSCommand:(NSString *)jsCommand jsParams:(id)jsParams completionHandler:(void (^)(id, NSError *))completionHandler;

- (void)unload;

- (SlateWebViewShouldLoadType)shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

@end

@protocol SlateWebViewDelegate <UIWebViewDelegate>
@optional
- (void)domReady:(id)params webView:(SlateWebView *)webView;
- (BOOL)webViewShouldLoadAction:(NSURL *)actionURL webView:(SlateWebView *)webView;

@end
